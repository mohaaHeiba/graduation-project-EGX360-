import 'package:egx/app.dart';
import 'package:egx/core/data/init_local_data.dart';
import 'package:egx/features/settings/presentaion/controller/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  WebViewPlatform.instance = AndroidWebViewPlatform();
  // load apis from enviroment
  await dotenv.load(fileName: ".env");

  //init supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_APIKEY']!,
  );

  //load theme adn state
  await GetStorage.init();

  //load local storage
  final initData = Get.put(InitLocalData(), permanent: true);
  await initData.initDatabase();

  //for theme
  await Get.putAsync(() async => ThemeController(), permanent: true);

  // GetStorage().erase();
  runApp(const MyApp());
}
