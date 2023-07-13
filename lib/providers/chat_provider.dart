import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:aliens/models/message_model.dart';


final String TableName = 'message';

class MessageDB {
  static late Database _database;
  static late MessageDB _messageDB;

  MessageDB._createInstance();

  factory MessageDB(){
    _messageDB = MessageDB._createInstance();
    return _messageDB;
  }

  Future<Database> get database async {
    if(!_database.isOpen)
      _database = await initDB();
    return _database;
  }

  //생성함수
  Future<Database> initDB() async {
    //데이터 베이스의 경로
    //어느 경로에 어떤 데이터베이스를 만드는지
    String path = join(await getDatabasesPath(), 'message.db');

    return await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE message(
              requestId TEXT,
              chatId INTEGER,
              chatType INTEGER, 
              chatContent TEXT,
              roomId INTEGER,
              senderId INTEGER,
              senderName TEXT,
              receiverId INTEGER, 
              sendTime TEXT,
              unReadCount INTEGER
            )
          ''');
        },
    );
  }

  Future<void> createTable() async{
    try{
      final Database db = await this.database;
      await db.execute("CREATE TABLE message(requestId TEXT PRIMARY KEY,chatId INTEGER,chatType INTEGER,chatContent TEXT,roomId INTEGER,senderId INTEGER,senderName TEXT,receiverId INTEGER,sendTime TEXT,unReadCount INTEGER)");
    }catch(e){
      print(e);
    }
  }


  //추가 함수
  Future<void> insertDB(MessageModel message) async {
    try{
      final Database _db = await this.database;
      await _db.insert(TableName, message.toJson());
    }catch(e){
      print(e);
    }
/*
    //print(message.toJson()['chatId']);
    await _database?.insert(
      TableName,
      message.toJson(),
      //논의
      conflictAlgorithm: ConflictAlgorithm.fail
    );

 */
  }

  //보기
  Future<List<MessageModel>> messages() async {
    final _database = await database;

    final List<Map<String, dynamic>> maps = await _database!.query('message');
    print(maps.length);
    var _list =  List.generate(maps.length, (index) {
      print('${index}: ${maps[index]['chatId']}');
      return MessageModel(
        requestId: maps[index]['requestId'],
        chatId: maps[index]['chatID'],        //null
        chatType: maps[index]['chatType'],
        chatContent: maps[index]['chatContent'],
        roomId: maps[index]['roomId'],
        senderId: maps[index]['senderId'],    //null
        senderName: maps[index]['senderName'],
        receiverId: maps[index]['receiverId'],
        sendTime: maps[index]['sendTime'],
        unReadCount: maps[index]['unReadCount'] //null
      );
    });
    return List.from(_list.reversed);
  }

  //삭제함수
  Future<void> deleteDB() async {
    //데이터 베이스의 경로
    String path = join(await getDatabasesPath(), 'message.db');

    await deleteDatabase(path);
  }
}