import sys
import json
import yfinance as yf

def get_price(symbol):
    try:
        ticker = yf.Ticker(symbol)
        info = ticker.info
        
        # currentPrice または regularMarketPrice を取得
        price = info.get('currentPrice') or info.get('regularMarketPrice')
        
        if price is None:
            # バックアップ：直近1日の終値を取得
            hist = ticker.history(period="1d")
            if not hist.empty:
                price = float(hist['Close'].iloc[-1])

        if price is None:
            print(json.dumps({"error": "Price not found"}))
            return

        print(json.dumps({
            "current_price": round(float(price), 2),
            "symbol": symbol
        }))
    except Exception as e:
        print(json.dumps({"error": str(e)}))

if __name__ == "__main__":
    if len(sys.argv) > 1:
        get_price(sys.argv[1])
    else:
        print(json.dumps({"error": "No symbol provided"}))
