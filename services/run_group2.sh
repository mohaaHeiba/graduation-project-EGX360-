#!/bin/bash

source venv/bin/activate 2>/dev/null || echo "No virtualenv found, continuing..."

python -m egx_candles.abuk_candle &
python -m egx_candles.comi_candle &
python -m egx_candles.east_candle &
python -m egx_candles.efih_candle &
python -m egx_candles.emfd_candle &
python -m egx_candles.hrho_candle &


echo "Group 1 candles running..."
wait
