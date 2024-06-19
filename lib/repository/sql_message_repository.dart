import 'package:aliens/models/message_model.dart';
import 'package:aliens/repository/sql_message_database.dart';
import 'package:aliens/models/partner_model.dart';

import 'package:sqflite/sqflite.dart';

class SqlMessageRepository {
  static Future<void> create(MessageModel messageModel) async {
    print('챗 생성 ${messageModel.unreadCount}  ${DateTime.now()}');
    var db = await SqlMessageDataBase().database;

    final id = messageModel.chatId;
    if ((await db.rawQuery('SELECT * FROM chat WHERE chatId = ?', [id]))
        .isEmpty) {
      // 중복이 없으면 데이터 삽입
      await db.insert('chat', messageModel.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  static Future<List<MessageModel>> getList(int roomId, int senderId) async {
    var db = await SqlMessageDataBase().database;
    var result = await db.query("chat", columns: [
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
    List<MessageModel> list = [];

    for (final message in result) {
      if (MessageModel.fromJson(message).roomId != roomId) {
        continue;
      }
      list.add(MessageModel.fromJson(message));
    }
    return list;
  }

  static Future<String> getCreatedTime(int roomId) async {
    var db = await SqlMessageDataBase().database;
    var result = await db.query("chat", columns: [
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
    var db = await SqlMessageDataBase().database;

    final roomId = partner.roomId; // 룸 아이디 (어떤 룸의 데이터를 업데이트할지 선택)
    final receiverId = partner.memberId; // 리시버 (어떤 리시버의 데이터를 업데이트할지 선택)
    final chatId0 = chatId;

    await db.rawUpdate('''
      UPDATE chat 
      SET unreadCount = 0 
      WHERE roomId = ? AND receiverId = ? AND chatId = ?
    ''', [roomId, receiverId, chatId0]);
  }

  static Future<void> bulkUpdate(Partner partner) async {
    var db = await SqlMessageDataBase().database;

    //모두 읽음으로 바꾸되,
    final roomId = partner.roomId; // 룸 아이디 (어떤 룸의 데이터를 업데이트할지 선택)
    //final _receiverId = partner.memberId; // 리시버 (어떤 리시버의 데이터를 업데이트할지 선택)

    await db.rawUpdate('''
      UPDATE chat 
      SET unreadCount = 0 
      WHERE roomId = ?
    ''', [roomId]);
  }
}
