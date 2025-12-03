import 'package:egx/features/stock_chat/data/datasources/stock_chat_remote_datasource.dart';
import 'package:egx/features/stock_chat/data/repositories/stock_chat_repository_impl.dart';
import 'package:egx/features/stock_chat/domian/repositories/stock_chat_repository.dart';
import 'package:egx/features/stock_chat/domian/usecases/get_chat_stream_usecase.dart';
import 'package:egx/features/stock_chat/presentation/controllers/stock_chat_controller.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StockChatBinding extends Bindings {
  @override
  void dependencies() {
    final int stockId = Get.arguments['stock_id'];

    // 2. Data Source
    Get.lazyPut<StockChatRemoteDataSource>(
      () => StockChatRemoteDataSourceImpl(Supabase.instance.client),
    );

    // 3. Repository
    Get.lazyPut<StockChatRepository>(() => StockChatRepositoryImpl(Get.find()));

    // 4. UseCases
    Get.lazyPut(() => GetChatStreamUseCase(Get.find()));
    Get.lazyPut(() => SendMessageUseCase(Get.find()));

    // 5. Controller
    Get.put(
      StockChatController(
        getChatStreamUseCase: Get.find(),
        sendMessageUseCase: Get.find(),
        stockId: stockId,
      ),
    );
  }
}
