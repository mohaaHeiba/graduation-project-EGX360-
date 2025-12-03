// lib/features/stock_chat/domain/repositories/stock_chat_repository.dart
import '../entities/chat_message.dart';

abstract class StockChatRepository {
  Stream<List<ChatMessage>> getChatStream(int stockId);
  Future<void> sendMessage({required int stockId, required String message});
}
