import 'package:aliens/models/message_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlMessageDataBase {
  static String messageTable = 'chat';
  static String subscriptionTable = 'subscriptions';
  static final SqlMessageDataBase instance = SqlMessageDataBase._instance();

  Database? _database;

  SqlMessageDataBase._instance() {
    _initDB();
  }

  factory SqlMessageDataBase() {
    return instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    await _initDB(); // 데이터베이스 생성
    return _database!;
  }

  Future<void> _initDB() async {
    String path = join(await getDatabasesPath(), 'chat.db');
    _database = await openDatabase(path,
        version: 2, onCreate: _createDB, onUpgrade: _upgradeDB);
  }

  void _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $messageTable(
              ${MessageFields.id} INTEGER PRIMARY KEY,
              ${MessageFields.type} INTEGER, 
              ${MessageFields.content} TEXT,
              ${MessageFields.roomId} INTEGER,
              ${MessageFields.senderId} INTEGER,
              ${MessageFields.receiverId} INTEGER, 
              ${MessageFields.sendTime} TEXT,
              ${MessageFields.isRead} INTEGER,
              UNIQUE (${MessageFields.id}) ON CONFLICT IGNORE
            )
    ''');

    await db.execute('''
      CREATE TABLE $subscriptionTable(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              chatRoomId INTEGER UNIQUE
            )
    ''');
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE $subscriptionTable(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                chatRoomId INTEGER UNIQUE
              )
      ''');
    }
  }

  void _closeDataBase() async {
    if (_database != null) await _database!.close();
  }

  Future<void> deleteDB() async {
    String path = join(await getDatabasesPath(), 'chat.db');
    await deleteDatabase(path);
  }
}
