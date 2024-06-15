import 'package:aliens/models/message_model.dart';
import 'package:aliens/repository/sql_message_database.dart';
import 'package:aliens/models/partner_model.dart';

import 'package:sqflite/sqflite.dart';

class SqlMessageRepository{
  static Future<void> create(MessageModel messageModel) async {
    print('챗 생성 ${messageModel.unreadCount}  ${DateTime.now()}');
    var _db = await SqlMessageDataBase().database;

    final id = messageModel.chatId;
    if ((await _db.rawQuery('SELECT * FROM chat WHERE chatId = ?', [id])).isEmpty) {
      // 중복이 없으면 데이터 삽입
      await _db.insert('chat',
        messageModel.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace
      );
    }

  }

  static Future<List<MessageModel>> getList(int roomId, int senderId) async{
    var _db = await SqlMessageDataBase().database;
    var result = await _db.query("chat", columns: [
      MessageFields.chatId,
      MessageFields.chatType,
      MessageFields.chatContent,
      MessageFields.roomId,
      MessageFields.senderId,
      MessageFields.senderName,
      MessageFields.receiverId,
      MessageFields.sendTime,
      MessageFields.unreadCount,
    ]);
    List<MessageModel> _list = [];


    for(final message in result){

      if(MessageModel.fromJson(message).roomId != roomId)
        continue;
      _list.add(MessageModel.fromJson(message));
    }
    return _list;
  }

  static Future<String> getCreatedTime(int roomId) async {

    var _db = await SqlMessageDataBase().database;
    var result = await _db.query("chat", columns: [
      MessageFields.chatId,
      MessageFields.chatType,
      MessageFields.chatContent,
      MessageFields.roomId,
      MessageFields.senderId,
      MessageFields.senderName,
      MessageFields.receiverId,
      MessageFields.sendTime,
      MessageFields.unreadCount,
    ]);
    return MessageModel.fromJson(result[0]).sendTime!;
  }


  static Future<void> update(Partner partner, int chatId) async {
    var _db = await SqlMessageDataBase().database;

    final _roomId = partner.roomId; // 룸 아이디 (어떤 룸의 데이터를 업데이트할지 선택)
    final _receiverId = partner.memberId; // 리시버 (어떤 리시버의 데이터를 업데이트할지 선택)
    final _chatId = chatId;

    await _db.rawUpdate('''
      UPDATE chat 
      SET unreadCount = 0 
      WHERE roomId = ? AND receiverId = ? AND chatId = ?
    ''', [_roomId, _receiverId, _chatId]);
  }

  static Future<void> bulkUpdate(Partner partner) async {
    var _db = await SqlMessageDataBase().database;

    //모두 읽음으로 바꾸되,
    final _roomId = partner.roomId; // 룸 아이디 (어떤 룸의 데이터를 업데이트할지 선택)
    //final _receiverId = partner.memberId; // 리시버 (어떤 리시버의 데이터를 업데이트할지 선택)

    await _db.rawUpdate('''
      UPDATE chat 
      SET unreadCount = 0 
      WHERE roomId = ?
    ''', [_roomId]);
  }

}

