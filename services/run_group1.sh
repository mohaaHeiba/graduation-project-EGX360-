#!/bin/bash

source venv/bin/activate 2>/dev/null || echo "No virtualenv found, continuing..."

python -m egx_candles.etel_candle &
python -m egx_candles.expa_candle &
python -m egx_candles.fwry_candle &
python -m egx_candles.iron_candle &
python -m egx_candles.oras_candle &
python -m egx_candles.swdy_candle &
# python -m egx_candles.tmg_candle &

echo "Group 2 candles running..."
wait
