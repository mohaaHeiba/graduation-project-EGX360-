import 'package:egx/features/stock_chat/data/model/chat_message_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class StockChatRemoteDataSource {
  Stream<List<ChatMessageModel>> getChatStream(int stockId);
  Future<void> sendMessage({required int stockId, required String message});
}

class StockChatRemoteDataSourceImpl implements StockChatRemoteDataSource {
  final SupabaseClient supabaseClient;

  StockChatRemoteDataSourceImpl(this.supabaseClient);

  @override
  Stream<List<ChatMessageModel>> getChatStream(int stockId) {
    // ميزة Supabase القوية: Stream
    // بترجع داتا كل ما يحصل تغيير في الجدول
    return supabaseClient
        .from('stock_messages')
        .stream(primaryKey: ['id'])
        .eq('stock_id', stockId) // فلتر بالسهم المحدد
        .order('created_at', ascending: true) // رتب من القديم للجديد
        .map(
          (data) =>
              data.map((json) => ChatMessageModel.fromJson(json)).toList(),
        );
  }

  @override
  Future<void> sendMessage({
    required int stockId,
    required String message,
  }) async {
    final user = supabaseClient.auth.currentUser;
    if (user == null) throw Exception("User not logged in");

    await supabaseClient.from('stock_messages').insert({
      'stock_id': stockId,
      'user_id': user.id,
      'message': message,
    });
  }
}
