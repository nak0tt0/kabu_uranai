import sys
import json
import yfinance as yf

def get_stock_data(symbol):
    try:
        stock = yf.Ticker(symbol)
        info = stock.info
        hist = stock.history(period='2d')

        # リアルタイム価格または最新価格の取得
        current_price = info.get('currentPrice') or info.get('regularMarketPrice')

        if len(hist) >= 1:
            latest_close = hist['Close'].iloc[-1]
            prev_close = hist['Close'].iloc[-2] if len(hist) >= 2 else latest_close
            price = current_price if current_price is not None else latest_close
            change_ratio = ((price - prev_close) / prev_close) * 100
        else:
            price = current_price if current_price is not None else 0.0
            change_ratio = 0.0

        name = info.get('shortName') or info.get('longName') or symbol

        return {
            "symbol": symbol,
            "name": name,
            "current_price": float(price),
            "change_ratio": float(change_ratio)
        }
    except Exception as e:
        return {"error": str(e)}

if __name__ == "__main__":
    if len(sys.argv) > 1:
        data = get_stock_data(sys.argv[1])
        print(json.dumps(data))
    else:
        print(json.dumps({"error": "No ticker symbol provided"}))
