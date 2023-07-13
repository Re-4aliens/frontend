import 'package:uuid/uuid.dart';

class MessageFields {
  static final String requestId = 'requestId';
  static final String chatId = 'chatId';
  static final String chatType = 'chatType';
  static final String chatContent = 'chatContent';
  static final String roomId = 'roomId';
  static final String senderId = 'senderId';
  static final String senderName = 'senderName';
  static final String receiverId = 'receiverId';
  static final String sendTime = 'sendTime';
  static final String unReadCount = 'unReadCount';
}

class MessageModel {
  String? requestId;
  int? chatId;
  int? chatType;
  String? chatContent;
  int? roomId;
  int? senderId;
  String? senderName;
  int? receiverId;
  String? sendTime;
  int? unReadCount;

  MessageModel(
      {this.requestId,
        this.chatId,
      this.chatType,
      this.chatContent,
      this.roomId,
      this.senderId,
      this.senderName,
      this.receiverId,
      this.sendTime,
      this.unReadCount});

  MessageModel.fromJson(Map<String, dynamic> json) {
    requestId = json['requestId'];
    chatId = json['chatId'];
    chatType = json['chatType'];
    chatContent = json['chatContent'];
    roomId = json['roomId'];
    senderId = json['senderId'];
    senderName = json['senderName'];
    receiverId = json['receiverId'];
    sendTime = json['sendTime'];
    unReadCount = json['unReadCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['requestId'] = this.requestId;
    data['chatId'] = this.chatId;
    data['chatType'] = this.chatType;
    data['chatContent'] = this.chatContent;
    data['roomId'] = this.roomId;
    data['senderId'] = this.senderId;
    data['senderName'] = this.senderName;
    data['receiverId'] = this.receiverId;
    data['sendTime'] = this.sendTime;
    data['unReadCount'] = this.unReadCount;
    return data;
  }
}

class DataUtils {
  static String makeUUID(){
    return const Uuid().v1();
  }
}
