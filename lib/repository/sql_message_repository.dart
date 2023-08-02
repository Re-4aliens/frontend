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

  static Future<String> getCurrentMessage(int roomId) async {
    String currentMessage = '';
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
    for(int i =0; i < result.length; i++){
      if(MessageModel.fromJson(result[i]).roomId != roomId)
        continue;
      currentMessage = MessageModel.fromJson(result[i]).chatContent!;
    }
    return currentMessage;
  }

  static Future<String> getCurrentTime(int roomId) async {
    String currentTime = '';
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
    for(int i =0; i < result.length; i++){
      if(MessageModel.fromJson(result[i]).roomId != roomId)
        continue;
      currentTime = MessageModel.fromJson(result[i]).sendTime!;
    }
    return currentTime;
  }

  static Future<int> getUnreadChat(int roomId) async {
    int unreadChatCount = 0;
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
    for(int i =0; i < result.length; i++){
      if(MessageModel.fromJson(result[i]).roomId != roomId)
        continue;
      if(MessageModel.fromJson(result[i]).unreadCount != 0)
        unreadChatCount++;
    }
    return unreadChatCount;
  }

  static Future<void> update(Partner partner) async {
    var _db = await SqlMessageDataBase().database;

    final roomId = partner.roomId; // 룸 아이디 (어떤 룸의 데이터를 업데이트할지 선택)
    final receiverId = partner.memberId; // 리시버 (어떤 리시버의 데이터를 업데이트할지 선택)

    await _db.rawUpdate('''
      UPDATE chat 
      SET unreadCount = 0 
      WHERE roomId = ? AND receiverId = ?
    ''', [roomId, receiverId]);

  }

}

