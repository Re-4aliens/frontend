import 'package:aliens/models/message_model.dart';
import 'package:aliens/repository/sql_message_database.dart';
import 'package:aliens/models/partner_model.dart';

import 'package:sqflite/sqflite.dart';

class SqlMessageRepository {
  static Future<void> create(MessageModel messageModel) async {
    print('챗 생성 ${messageModel.isRead}  ${DateTime.now()}');
    var db = await SqlMessageDataBase().database;

    final id = messageModel.id;
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
      MessageFields.id,
      MessageFields.type,
      MessageFields.content,
      MessageFields.roomId,
      MessageFields.senderId,
      MessageFields.receiverId,
      MessageFields.sendTime,
      MessageFields.isRead,
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
      MessageFields.id,
      MessageFields.type,
      MessageFields.content,
      MessageFields.roomId,
      MessageFields.senderId,
      MessageFields.receiverId,
      MessageFields.sendTime,
      MessageFields.isRead,
    ]);
    return MessageModel.fromJson(result[0]).sendTime!;
  }

  static Future<void> update(Partner partner, int chatId) async {
    var db = await SqlMessageDataBase().database;

    final roomId = partner.chatRoomId;
    final receiverId = partner.partnerMemberId;
    final chatId0 = chatId;

    await db.rawUpdate('''
      UPDATE chat 
      SET unreadCount = 0 
      WHERE roomId = ? AND receiverId = ? AND chatId = ?
    ''', [roomId, receiverId, chatId0]);
  }

  static Future<void> bulkUpdate(Partner partner) async {
    var db = await SqlMessageDataBase().database;

    final roomId = partner.chatRoomId;

    await db.rawUpdate('''
      UPDATE chat 
      SET unreadCount = 0 
      WHERE roomId = ?
    ''', [roomId]);
  }

  static Future<void> addSubscription(int chatRoomId) async {
    // 수정된 부분
    var db = await SqlMessageDataBase().database;
    await db.insert(
      'subscriptions',
      {'chatRoomId': chatRoomId},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  static Future<List<int>> getSubscriptions() async {
    // 수정된 부분
    var db = await SqlMessageDataBase().database;
    final List<Map<String, dynamic>> maps = await db.query('subscriptions');
    return List.generate(maps.length, (i) {
      return maps[i]['chatRoomId'] as int;
    });
  }

  static Future<void> deleteSubscription(int chatRoomId) async {
    // 수정된 부분
    var db = await SqlMessageDataBase().database;
    await db.delete(
      'subscriptions',
      where: 'chatRoomId = ?',
      whereArgs: [chatRoomId],
    );
  }
}
