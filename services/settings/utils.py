from datetime import datetime, timezone, timedelta, time as dtime

def is_market_open():
    now_cairo = datetime.now(timezone.utc) + timedelta(hours=3)
    weekday = now_cairo.weekday()
    current_time = now_cairo.time()
    market_open = dtime(10, 0)
    market_close = dtime(14, 30)
    return weekday not in [4, 5] and market_open <= current_time <= market_close

def cairo_now():
    return datetime.now(timezone.utc) + timedelta(hours=3)


