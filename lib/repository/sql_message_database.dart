import 'package:aliens/models/message_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlMessageDataBase{

  static String tableName = 'chat';
  static final SqlMessageDataBase instance = SqlMessageDataBase._instance();

  Database? _database;

  SqlMessageDataBase._instance(){
    _initDB();
  }

  factory SqlMessageDataBase(){
    return instance;
  }

  Future<Database> get database async {
    if(_database != null) return _database!;
    await _initDB();  //데이터 베이스 생성
    return _database!;
  }

  Future<void> _initDB() async{
     String _path = join(await getDatabasesPath(), 'chat.db');
    _database = await openDatabase(_path, version: 1, onCreate: _createDB);
  }

  void _createDB(Database db, int version) async{
    await db.execute('''
      CREATE TABLE ${tableName}(
              ${MessageFields.chatId} INTEGER PRIMARY KEY,
              ${MessageFields.chatType} INTEGER, 
              ${MessageFields.chatContent} TEXT,
              ${MessageFields.roomId} INTEGER,
              ${MessageFields.senderId} INTEGER,
              ${MessageFields.senderName} TEXT,
              ${MessageFields.receiverId} INTEGER, 
              ${MessageFields.sendTime} TEXT,
              ${MessageFields.unReadCount} INTEGER
            )
    ''');
  }

  void _closeDataBase() async {
    if (_database != null) await _database!.close();
  }

  Future<void> deleteDB() async {
    String _path = join(await getDatabasesPath(), 'chat.db');
    await deleteDatabase(_path);
  }

}