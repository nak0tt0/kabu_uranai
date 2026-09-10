require 'net/http'
require 'json'
require 'uri'

class GripRestorationService
  def initialize(stock, price_data)
    @stock = stock
    @price_data = price_data
    @api_key = ENV['GEMINI_API_KEY'].to_s.strip
  end

  def call
    return "APIキーが設定されていないため、メッセージを生成できません。" if @api_key.blank?

    current_price = @price_data[:current_price] || @stock.acquisition_price
    change_ratio = @price_data[:change_ratio] || 0.0

    prompt = <<~TEXT
      あなたはユーザーの「投資の軸」を再確認させる熱く温かい投資メンターです。
      株価変動による不安でブレそうになっている投資家に対して、原点（購入時の初心）を思い出させ、冷静さを取り戻すための励ましメッセージを生成してください。

      【銘柄情報】
      銘柄名: #{@stock.name} (#{@stock.ticker_symbol})
      取得単価: #{@stock.acquisition_price}円
      現在値: #{current_price}円 (前日比: #{change_ratio}%)
      購入時の初心・理由: #{@stock.purchase_motivation}
      設定した売却基準: #{@stock.exit_scenario}

      【出力ルール】
      ・購入時の原点（理由）に触れ、なぜこの銘柄を買ったのかを再認識させてください。
      ・感情的な狼狽売りを留まらせるような、温かくも論理的なアドバイス（200文字程度）を出力してください。
    TEXT

    call_gemini_api(prompt) || "メンターからのメッセージ取得に失敗しました。"
  rescue => e
    Rails.logger.error("GripRestorationService エラー: #{e.message}")
    "一時的なエラーが発生しました。"
  end

  private

  def call_gemini_api(prompt)
    uri = URI.parse("[https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent](https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent)")
    uri.query = URI.encode_www_form({ key: @api_key })

    headers = { 'Content-Type' => 'application/json' }
    body = {
      contents: [
        { parts: [{ text: prompt }] }
      ]
    }.to_json

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.request_uri, headers)
    request.body = body

    response = http.request(request)
    return nil unless response.is_a?(Net::HTTPSuccess)

    result = JSON.parse(response.body)
    result.dig('candidates', 0, 'content', 'parts', 0, 'text')
  end
end
