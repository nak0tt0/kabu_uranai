require 'open3'

class StockPriceService
  def initialize(ticker_symbol)
    @raw_symbol = ticker_symbol.to_s.strip
    @formatted_symbol = format_ticker(@raw_symbol)
  end

  # 米国株かどうかの判定（.T で終わらなければ米国株と判定）
  def us_stock?
    !@formatted_symbol.end_with?('.T')
  end

  # 通貨単位
  def currency_unit
    us_stock? ? "$" : "円"
  end

  # 株価データの取得
  def fetch_data
    return nil if @formatted_symbol.blank?

    script_path = Rails.root.join('lib', 'scripts', 'fetch_price.py').to_s
    python_path = Rails.root.join('.venv', 'bin', 'python').to_s

    stdout, stderr, status = Open3.capture3(python_path, script_path, @formatted_symbol)

    unless status.success?
      Rails.logger.error("yfinance取得エラー stderr: #{stderr}")
      return nil
    end

    result = JSON.parse(stdout, symbolize_names: true)
    return nil if result[:error]

    result[:unit] = currency_unit
    result
  rescue => e
    Rails.logger.error("StockPriceService 例外エラー: #{e.message}")
    nil
  end

  private

  # 日本株コード（4桁の数字、または141Aなどの英数字混在4桁）に '.T' を補完
  def format_ticker(symbol)
    symbol.match?(/^\d{3}[0-9A-Za-z]$/) ? "#{symbol}.T" : symbol
  end
end
