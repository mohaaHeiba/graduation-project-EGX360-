// lib/features/stock_chat/presentation/pages/stock_chat_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/stock_chat_controller.dart';

class StockChatPage extends GetView<StockChatController> {
  const StockChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chat")),
      body: Column(
        children: [
          // منطقة الرسائل
          Expanded(
            child: Obx(() {
              // Obx بيسمع للتغييرات في messages
              if (controller.messages.isEmpty) {
                return const Center(child: Text("كن أول من يبدأ النقاش!"));
              }

              return ListView.builder(
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final msg = controller.messages[index];
                  return ListTile(
                    title: Text(msg.message),
                    subtitle: Text(msg.userId.substring(0, 5)), // مجرد مثال
                  );
                },
              );
            }),
          ),

          // منطقة الكتابة
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.messageController,
                    decoration: const InputDecoration(
                      hintText: "اكتب رسالة...",
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: controller.sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
