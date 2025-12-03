import 'dart:math' as math;

import 'package:egx/features/candle_stick/domain/entity/candlestick_data.dart';
import 'package:flutter/material.dart';

class CandlestickPainter extends CustomPainter {
  final List<CandlestickData> candlesticks;
  final double animationValue;

  CandlestickPainter({
    required this.candlesticks,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (candlesticks.isEmpty) return;

    final candleWidth = 8.0;
    final spacing = 4.0;
    final totalWidth = (candleWidth + spacing) * candlesticks.length;

    // Find min and max for scaling
    double minPrice = double.infinity;
    double maxPrice = double.negativeInfinity;

    for (var candle in candlesticks) {
      minPrice = math.min(minPrice, candle.low);
      maxPrice = math.max(maxPrice, candle.high);
    }

    final priceRange = maxPrice - minPrice;
    final chartHeight = size.height * 0.6;
    final chartTop = size.height * 0.2;

    final visibleCandles = (animationValue * candlesticks.length).floor();

    for (int i = 0; i < visibleCandles; i++) {
      final candle = candlesticks[i];
      final x =
          (size.width / 2) - (totalWidth / 2) + (i * (candleWidth + spacing));

      // Scale prices to canvas coordinates
      final openY =
          chartTop + ((maxPrice - candle.open) / priceRange) * chartHeight;
      final closeY =
          chartTop + ((maxPrice - candle.close) / priceRange) * chartHeight;
      final highY =
          chartTop + ((maxPrice - candle.high) / priceRange) * chartHeight;
      final lowY =
          chartTop + ((maxPrice - candle.low) / priceRange) * chartHeight;

      final bodyTop = math.min(openY, closeY);
      final bodyBottom = math.max(openY, closeY);

      // Draw wick (line)
      final wickPaint = Paint()
        ..color = candle.isGreen
            ? Color(0xFF26a69a).withOpacity(0.6)
            : Color(0xFFef5350).withOpacity(0.6)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke;

      canvas.drawLine(
        Offset(x + candleWidth / 2, highY),
        Offset(x + candleWidth / 2, lowY),
        wickPaint,
      );

      // Draw body (rectangle)
      final bodyPaint = Paint()
        ..color = candle.isGreen ? Color(0xFF26a69a) : Color(0xFFef5350)
        ..style = PaintingStyle.fill;

      final bodyRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, bodyTop, candleWidth, bodyBottom - bodyTop),
        Radius.circular(1),
      );

      canvas.drawRRect(bodyRect, bodyPaint);

      // Add subtle glow for effect
      final glowPaint = Paint()
        ..color = (candle.isGreen ? Color(0xFF26a69a) : Color(0xFFef5350))
            .withOpacity(0.2)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 3);

      canvas.drawRRect(bodyRect, glowPaint);
    }

    // Draw grid lines
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..strokeWidth = 1;

    for (int i = 0; i < 5; i++) {
      final y = chartTop + (i * chartHeight / 4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  @override
  bool shouldRepaint(CandlestickPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}
