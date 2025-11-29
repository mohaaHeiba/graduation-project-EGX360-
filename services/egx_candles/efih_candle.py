from tvDatafeed import TvDatafeed, Interval
from datetime import datetime, timezone, timedelta
from settings.config import supabase, TV_USERNAME, TV_PASSWORD, UPDATE_INTERVAL
from settings.utils import is_market_open, cairo_now
import time

symbol = "efih"
exchange = "EGX"
table_name = "efih_candles"

tv = TvDatafeed(TV_USERNAME, TV_PASSWORD)
current_candle = None

while True:
    if not is_market_open():
        print(f"{symbol}: Market Closed")
        time.sleep(3600)
        continue

    try:
        data = tv.get_hist(symbol=symbol, exchange=exchange, interval=Interval.in_1_minute, n_bars=1)
        if data is None or data.empty:
            print(f"{symbol}: There is no available data now")
            time.sleep(UPDATE_INTERVAL)
            continue

        price = float(data['close'].iloc[-1])
        candle_time = cairo_now().replace(second=0, microsecond=0)

        if current_candle is None:
            current_candle = {"timestamp": candle_time, "open": price, "high": price, "low": price, "close": price}
        # elif current_candle["timestamp"] == candle_time:
        #     current_candle["high"] = max(current_candle["high"], price)
        #     current_candle["low"] = min(current_candle["low"], price)
        #     current_candle["close"] = price
        else:
            try:
                supabase.table(table_name).insert({
                    "timestamp": current_candle["timestamp"].isoformat(),
                    "open": current_candle["open"],
                    "high": current_candle["high"],
                    "low": current_candle["low"],
                    "close": current_candle["close"]
                }).execute()
                print(f" [{symbol}] Candle Saved: {current_candle}")
            except Exception as e:
                print(f" [{symbol}] Supabase Error:", e)

            current_candle = {"timestamp": candle_time, "open": price, "high": price, "low": price, "close": price}

        print(f"{symbol} | {price:.2f} EGP | Candle: {current_candle}")
    except Exception as e:
        print(f" [{symbol}] Error:", e)

    time.sleep(UPDATE_INTERVAL)
