import 'dart:io';
import 'package:egx/core/data/database.dart';
import 'package:egx/features/auth/domain/entity/auth_entity.dart';
import 'package:egx/features/profile/domain/entity/post_entity.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class InitLocalData extends GetxService {
  late final LocalData database;

  final Rx<AuthEntity?> currentUser = Rx<AuthEntity?>(null);
  final RxList<PostEntity> userPosts = <PostEntity>[].obs;

  Future<InitLocalData> initDatabase() async {
    await _copyDatabase();
    final dir = await getApplicationDocumentsDirectory();
    final dbPath = join(dir.path, 'data.db');

    database = await $FloorLocalData.databaseBuilder(dbPath).build();

    Get.put<LocalData>(database, permanent: true);

    currentUser.value = await database.authdao.getAuthData();

    if (currentUser.value != null) {
      print("User found: ${currentUser.value!.name}");

      final localPosts = await database.postsDao.getUserPosts(
        currentUser.value!.id,
      );

      if (localPosts.isNotEmpty) {
        userPosts.assignAll(localPosts.map((e) => e.toEntity()).toList());
        print("Loaded ${userPosts.length} cached posts.");
      }
    } else {
      print("No user found in local database.");
    }

    return this;
  }

  Future<void> _copyDatabase() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, 'data.db');

    if (File(path).existsSync()) return;

    try {
      ByteData data = await rootBundle.load('assets/data/data.db');
      List<int> bytes = data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes,
      );
      await File(path).writeAsBytes(bytes);
      print("Database copied from assets.");
    } catch (e) {
      print("No assets database found, creating clean one.");
    }
  }
}
