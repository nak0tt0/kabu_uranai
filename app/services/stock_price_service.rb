require 'open3'

class StockPriceService
  def initialize(ticker_symbol)
    @raw_symbol = ticker_symbol.to_s.strip
    @formatted_symbol = format_ticker(@raw_symbol)
  end

  # 株価データの取得（現在値・前日比・銘柄名）
  def fetch_data
    return nil if @formatted_symbol.blank?

    script_path = Rails.root.join('lib', 'scripts', 'fetch_price.py')
    # 作成した仮想環境(.venv)内の python を使用する
    python_path = Rails.root.join('.venv', 'bin', 'python')

    stdout, stderr, status = Open3.capture3("#{python_path} #{script_path} #{@formatted_symbol}")

    unless status.success?
      Rails.logger.error("yfinance取得エラー stderr: #{stderr}")
      return nil
    end

    result = JSON.parse(stdout, symbolize_names: true)
    return nil if result[:error]

    result
  rescue => e
    Rails.logger.error("StockPriceService 例外エラー: #{e.message}")
    nil
  end

  # 評価額および評価損益の算定処理
  def calculate_performance(shares, acquisition_price)
    data = fetch_data
    current_price = data&.fetch(:current_price, nil) || acquisition_price.to_f

    shares = shares.to_f
    acq_price = acquisition_price.to_f

    eval_amount = current_price * shares
    cost_amount = acq_price * shares
    profit_loss = eval_amount - cost_amount

    {
      current_price: current_price,
      change_ratio: data&.fetch(:change_ratio, 0.0),
      eval_amount: eval_amount,
      profit_loss: profit_loss,
      formatted_symbol: @formatted_symbol
    }
  end

  private

  # 4桁数字の日本株コードの場合は自動で末尾に '.T' を補完
  def format_ticker(symbol)
    symbol.match?(/^\d{4}$/) ? "#{symbol}.T" : symbol
  end
end
