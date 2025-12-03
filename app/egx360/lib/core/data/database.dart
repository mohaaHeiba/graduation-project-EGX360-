import 'dart:async';
import 'package:egx/core/data/daos/posts_dao.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

// Imports
import 'package:egx/core/data/converters/datetime_converter.dart';
import 'package:egx/features/auth/domain/entity/auth_entity.dart';
import 'package:egx/core/data/entities/post_local_model.dart';

// DAOs
import 'package:egx/features/auth/data/datasources/auth_dao.dart';

part 'database.g.dart';

@TypeConverters([DateTimeConverter])
@Database(version: 1, entities: [AuthEntity, PostLocalModel])
abstract class LocalData extends FloorDatabase {
  AuthDao get authdao;
  PostsDao get postsDao;
}
