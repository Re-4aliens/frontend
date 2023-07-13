import 'package:aliens/models/message_model.dart';
import 'package:aliens/repository/sql_message_database.dart';

class SqlMessageRepository{
  static Future<void> create(MessageModel messageModel) async {
    var _db = await SqlMessageDataBase().database;
    await _db.insert("chat", messageModel.toJson());
  }

  static Future<List<MessageModel>> getList(int roomId) async{
    var _db = await SqlMessageDataBase().database;
    var result = await _db.query("chat", columns: [
      MessageFields.receiverId,
      MessageFields.chatId,
      MessageFields.chatType,
      MessageFields.chatContent,
      MessageFields.roomId,
      MessageFields.senderId,
      MessageFields.senderName,
      MessageFields.receiverId,
      MessageFields.sendTime,
      MessageFields.unReadCount,
    ]);
    List<MessageModel> _valueList = [];

    for(int i =0; i < result.length; i++){
      if(MessageModel.fromJson(result[i]).roomId != roomId)
        continue;
        _valueList.add(MessageModel.fromJson(result[i]));

    }
    return _valueList;

  }
}

