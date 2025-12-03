// lib/features/stock_chat/presentation/controllers/stock_chat_controller.dart
import 'package:egx/features/stock_chat/domian/entities/chat_message.dart';
import 'package:egx/features/stock_chat/domian/usecases/get_chat_stream_usecase.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StockChatController extends GetxController {
  // UseCases
  final GetChatStreamUseCase getChatStreamUseCase;
  final SendMessageUseCase sendMessageUseCase;

  // المتغيرات اللي جاية من بره (زي الـ arguments)
  final int stockId;

  StockChatController({
    required this.getChatStreamUseCase,
    required this.sendMessageUseCase,
    required this.stockId,
  });

  // قائمة الرسائل (Reactive)
  RxList<ChatMessage> messages = <ChatMessage>[].obs;

  // للتحكم في حقل النص
  TextEditingController messageController = TextEditingController();
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // السحر بتاع GetX: اربط المتغير بالستريم مباشرة
    messages.bindStream(getChatStreamUseCase(stockId));
  }

  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    messageController.clear();
    try {
      await sendMessageUseCase(stockId, text);
      // مش محتاج تعمل تحديث للـ UI، لأن الـ Stream هيجيب الرسالة الجديدة لوحده
    } catch (e) {
      Get.snackbar("Error", "Failed to send message: $e");
    }
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }
}
