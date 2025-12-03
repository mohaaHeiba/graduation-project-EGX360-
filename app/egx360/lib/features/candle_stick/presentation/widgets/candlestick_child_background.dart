import 'package:egx/features/welcome/presentaion/controller/welcome_controller.dart';
import 'package:egx/features/candle_stick/presentation/painter/candlestick_painter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CandlestickChartBackground extends GetView<WelcomeController> {
  const CandlestickChartBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller.controllerAnimation,
      builder: (context, child) {
        return SizedBox.expand(
          child: CustomPaint(
            painter: CandlestickPainter(
              candlesticks: controller.candlesticks,
              animationValue: controller.controllerAnimation.value,
            ),
          ),
        );
      },
    );
  }
}
