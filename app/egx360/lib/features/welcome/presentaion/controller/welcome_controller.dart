import 'dart:math' as math;

import 'package:egx/core/routes/app_pages.dart';
import 'package:egx/core/services/permission_service.dart';
import 'package:egx/features/candle_stick/domain/entity/candlestick_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class WelcomeController extends GetxController
    with GetTickerProviderStateMixin {
  //for Welcome page
  late AnimationController controller;
  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;

  //For CandleStick
  late AnimationController controllerAnimation;
  final List<CandlestickData> candlesticks = [];
  final int totalCandles = 40;

  void _generateCandlestickData() {
    final random = math.Random(42);
    double currentPrice = 100.0;

    for (int i = 0; i < totalCandles; i++) {
      final change = (random.nextDouble() - 0.45) * 8;
      currentPrice += change;

      final isGreen = random.nextBool();
      final bodySize = 3 + random.nextDouble() * 12;
      final wickTop = 2 + random.nextDouble() * 8;
      final wickBottom = 2 + random.nextDouble() * 8;

      double open, close, high, low;

      if (isGreen) {
        open = currentPrice;
        close = currentPrice + bodySize;
        high = close + wickTop;
        low = open - wickBottom;
      } else {
        open = currentPrice + bodySize;
        close = currentPrice;
        high = open + wickTop;
        low = close - wickBottom;
      }

      candlesticks.add(
        CandlestickData(open: open, close: close, high: high, low: low),
      );

      currentPrice = close;
    }
  }

  // initState

  @override
  void onInit() {
    super.onInit();
    controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

    controller.forward();

    _generateCandlestickData();

    controllerAnimation = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

    controllerAnimation.forward();
  }

  @override
  void onClose() {
    controllerAnimation.dispose();
    super.dispose();
    controller.dispose();
  }

  Future<void> goAuth() async {
    PermissionService p = PermissionService();
    await GetStorage().write('seenWelcome', true);

    await p.requestAll();

    await Get.toNamed(AppPages.authPage);
  }
}
