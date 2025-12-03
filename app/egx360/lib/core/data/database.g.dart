// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $LocalDataBuilderContract {
  /// Adds migrations to the builder.
  $LocalDataBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $LocalDataBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<LocalData> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorLocalData {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $LocalDataBuilderContract databaseBuilder(String name) =>
      _$LocalDataBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $LocalDataBuilderContract inMemoryDatabaseBuilder() =>
      _$LocalDataBuilder(null);
}

class _$LocalDataBuilder implements $LocalDataBuilderContract {
  _$LocalDataBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $LocalDataBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $LocalDataBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<LocalData> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$LocalData();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$LocalData extends LocalData {
  _$LocalData([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  AuthDao? _authdaoInstance;

  PostsDao? _postsDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `profiles` (`id` TEXT NOT NULL, `name` TEXT NOT NULL, `email` TEXT NOT NULL, `avatarUrl` TEXT, `bio` TEXT, `lastActiveAt` TEXT, `createdAt` TEXT, `updatedAt` TEXT, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `cached_posts` (`id` INTEGER NOT NULL, `userId` TEXT NOT NULL, `content` TEXT, `imageUrl` TEXT, `createdAt` INTEGER NOT NULL, `userName` TEXT, `userAvatar` TEXT, `sentiment` TEXT, `cashtags` TEXT, `likesCount` INTEGER NOT NULL, `dislikesCount` INTEGER NOT NULL, `commentsCount` INTEGER NOT NULL, `isLiked` INTEGER NOT NULL, `isBookmarked` INTEGER NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  AuthDao get authdao {
    return _authdaoInstance ??= _$AuthDao(database, changeListener);
  }

  @override
  PostsDao get postsDao {
    return _postsDaoInstance ??= _$PostsDao(database, changeListener);
  }
}

class _$AuthDao extends AuthDao {
  _$AuthDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _authEntityInsertionAdapter = InsertionAdapter(
            database,
            'profiles',
            (AuthEntity item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'email': item.email,
                  'avatarUrl': item.avatarUrl,
                  'bio': item.bio,
                  'lastActiveAt': item.lastActiveAt,
                  'createdAt': item.createdAt,
                  'updatedAt': item.updatedAt
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<AuthEntity> _authEntityInsertionAdapter;

  @override
  Future<AuthEntity?> getAuthData() async {
    return _queryAdapter.query('SELECT * FROM profiles LIMIT 1',
        mapper: (Map<String, Object?> row) => AuthEntity(
            id: row['id'] as String,
            name: row['name'] as String,
            email: row['email'] as String,
            avatarUrl: row['avatarUrl'] as String?,
            bio: row['bio'] as String?,
            lastActiveAt: row['lastActiveAt'] as String?,
            createdAt: row['createdAt'] as String?,
            updatedAt: row['updatedAt'] as String?));
  }

  @override
  Future<void> deleteAuthData() async {
    await _queryAdapter.queryNoReturn('DELETE FROM profiles');
  }

  @override
  Future<void> inserAuthData(AuthEntity authentity) async {
    await _authEntityInsertionAdapter.insert(
        authentity, OnConflictStrategy.replace);
  }
}

class _$PostsDao extends PostsDao {
  _$PostsDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _postLocalModelInsertionAdapter = InsertionAdapter(
            database,
            'cached_posts',
            (PostLocalModel item) => <String, Object?>{
                  'id': item.id,
                  'userId': item.userId,
                  'content': item.content,
                  'imageUrl': item.imageUrl,
                  'createdAt': _dateTimeConverter.encode(item.createdAt),
                  'userName': item.userName,
                  'userAvatar': item.userAvatar,
                  'sentiment': item.sentiment,
                  'cashtags': item.cashtags,
                  'likesCount': item.likesCount,
                  'dislikesCount': item.dislikesCount,
                  'commentsCount': item.commentsCount,
                  'isLiked': item.isLiked ? 1 : 0,
                  'isBookmarked': item.isBookmarked ? 1 : 0
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<PostLocalModel> _postLocalModelInsertionAdapter;

  @override
  Future<List<PostLocalModel>> getUserPosts(String userId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM cached_posts WHERE userId = ?1 ORDER BY createdAt DESC',
        mapper: (Map<String, Object?> row) => PostLocalModel(
            id: row['id'] as int,
            userId: row['userId'] as String,
            content: row['content'] as String?,
            imageUrl: row['imageUrl'] as String?,
            createdAt: _dateTimeConverter.decode(row['createdAt'] as int),
            userName: row['userName'] as String?,
            userAvatar: row['userAvatar'] as String?,
            likesCount: row['likesCount'] as int,
            dislikesCount: row['dislikesCount'] as int,
            commentsCount: row['commentsCount'] as int,
            sentiment: row['sentiment'] as String?,
            cashtags: row['cashtags'] as String?,
            isLiked: (row['isLiked'] as int) != 0,
            isBookmarked: (row['isBookmarked'] as int) != 0),
        arguments: [userId]);
  }

  @override
  Future<void> clearUserPosts(String userId) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM cached_posts WHERE userId = ?1',
        arguments: [userId]);
  }

  @override
  Future<void> insertPosts(List<PostLocalModel> posts) async {
    await _postLocalModelInsertionAdapter.insertList(
        posts, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateUserPostsCache(
    String userId,
    List<PostLocalModel> posts,
  ) async {
    if (database is sqflite.Transaction) {
      await super.updateUserPostsCache(userId, posts);
    } else {
      await (database as sqflite.Database)
          .transaction<void>((transaction) async {
        final transactionDatabase = _$LocalData(changeListener)
          ..database = transaction;
        await transactionDatabase.postsDao.updateUserPostsCache(userId, posts);
      });
    }
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
