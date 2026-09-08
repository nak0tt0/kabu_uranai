require 'net/http'
require 'json'
require 'uri'

class FomoCheckerService
  def initialize(purchase_motivation, exit_scenario)
    @purchase_motivation = purchase_motivation
    @exit_scenario = exit_scenario
    @api_key = ENV['GEMINI_API_KEY'].to_s.strip
  end

  def call
    return default_response if @api_key.blank?

    prompt = <<~TEXT
      あなたは冷静で客観的なプロの投資アドバイザーです。
      以下の「購入動機」と「売却シナリオ」を評価し、衝動買い(FOMO買い)リスクを0〜100の数値でスコアリングし、アドバイスを提供してください。

      購入動機: #{@purchase_motivation}
      売却シナリオ: #{@exit_scenario}

      【出力形式】
      必ず以下のJSON形式のみで出力してください。余計な解説やマークダウン（```jsonなど）は一切含めないでください。
      {"score": 数値(0-100), "advice": "アドバイス文章"}
    TEXT

    response_text = call_gemini_api(prompt)
    parse_response(response_text)
  rescue => e
    Rails.logger.error("FomoCheckerService エラー: #{e.message}")
    default_response
  end

  private

  def call_gemini_api(prompt)
    uri = URI.parse("https://generativelanguage.googleapis.com/v1beta/models/gemini-3.6-flash:generateContent?key=#{@api_key}")

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

  def parse_response(text)
    return default_response if text.blank?

    cleaned_text = text.gsub(/```json|```/, '').strip
    data = JSON.parse(cleaned_text, symbolize_names: true)

    {
      score: data[:score] || 50,
      advice: data[:advice] || "分析結果を取得できませんでした。"
    }
  rescue JSON::ParserError
    default_response
  end

  def default_response
    { score: 50, advice: "AIによる分析を行えませんでした。APIキーまたは入力内容をご確認ください。" }
  end
end
