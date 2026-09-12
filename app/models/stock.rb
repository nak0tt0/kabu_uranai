require 'csv'

class Stock < ApplicationRecord
  belongs_to :user
  belongs_to :group, optional: true
  has_many :post_mortems, dependent: :destroy

  enum(:status, { holding: 0, pending: 1, sold: 2 }, default: :holding)

  validates :name, presence: true
  validates :purchase_motivation, presence: true

  # 楽天証券CSVの取り込み処理
  def self.import_csv(file, user)
    imported_count = 0

    # ファイル内容の読み込みとエンコード変換
    file_content = file.read.force_encoding("UTF-8")
    unless file_content.valid_encoding?
      file_content = file_content.force_encoding("Windows-31J").encode("UTF-8", invalid: :replace, undef: :replace, replace: "")
    end

    # ヘッダー行まで読み飛ばす処理
    lines = file_content.lines
    header_index = lines.find_index { |l| l.include?("銘柄") || l.include?("コード") } || 0
    clean_csv_content = lines[header_index..-1].join

    # タブ区切り（TSV）とカンマ区切り（CSV）の両方に対応
    col_sep = clean_csv_content.lines.first.include?("\t") ? "\t" : ","

    CSV.parse(clean_csv_content, headers: true, col_sep: col_sep) do |row|
      type = row['種別'] || row['口座'] || row['商品']
      
      ticker_symbol = (row['銘柄コード・ティッカー'] || row['銘柄コード'] || row['コード'] || row['シンボル'])&.strip
      name = (row['銘柄'] || row['銘柄名'])&.strip
      shares_str = row['保有数量'] || row['数量'] || row['保有株数']
      price_str = row['平均取得価額'] || row['取得単価'] || row['取得価額']

      if type.present?
        next if type.include?("投資信託") || type.include?("債券") || type.include?("先物")
      end

      shares = shares_str&.to_s&.gsub(',', '')&.to_f || 0
      acquisition_price = price_str&.to_s&.gsub(',', '')&.to_f || 0

      next if ticker_symbol.blank? || name.blank?

      # 重複登録を防ぐため、同一ユーザー・同一銘柄コードがあれば更新、無ければ新規作成
      stock = user.stocks.find_or_initialize_by(ticker_symbol: ticker_symbol)
      stock.assign_attributes(
        name: name,
        shares: shares,
        acquisition_price: acquisition_price,
        status: :holding,
        purchase_motivation: stock.purchase_motivation.presence || "楽天証券CSV一括インポート",
        exit_scenario: stock.exit_scenario.presence || "未設定（CSVインポート）"
      )
      
      if stock.save
        imported_count += 1
      end
    end

    imported_count
  end
end
