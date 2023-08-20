import 'package:easy_localization/easy_localization.dart';
import 'package:uuid/uuid.dart';

class MessageFields {
  static final String chatId = 'chatId';
  static final String chatType = 'chatType';
  static final String chatContent = 'chatContent';
  static final String roomId = 'roomId';
  static final String senderId = 'senderId';
  static final String senderName = 'senderName';
  static final String receiverId = 'receiverId';
  static final String sendTime = 'sendTime';
  static final String unreadCount = 'unreadCount';
}

class MessageModel {
  int? chatId;
  int? chatType;
  String? chatContent;
  int? roomId;
  int? senderId;
  String? senderName;
  int? receiverId;
  String? sendTime;
  int? unreadCount;

  MessageModel(
      {
        this.chatId,
      this.chatType,
      this.chatContent,
      this.roomId,
      this.senderId,
      this.senderName,
      this.receiverId,
      this.sendTime,
      this.unreadCount});

  MessageModel.fromJson(Map<String, dynamic> json) {
    chatId = json['chatId'];
    chatType = json['chatType'];
    chatContent = json['chatContent'];
    roomId = json['roomId'];
    senderId = json['senderId'];
    senderName = json['senderName'];
    receiverId = json['receiverId'];
    sendTime = json['sendTime'];
    unreadCount = json['unreadCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chatId'] = this.chatId;
    data['chatType'] = this.chatType;
    data['chatContent'] = this.chatContent;
    data['roomId'] = this.roomId;
    data['senderId'] = this.senderId;
    data['senderName'] = this.senderName;
    data['receiverId'] = this.receiverId;
    data['sendTime'] = this.sendTime;
    data['unreadCount'] = this.unreadCount;
    return data;
  }
}

class DataUtils {
  static String makeUUID(){
    return const Uuid().v1();
  }
  static String getTime(createdAt) {
    Duration diff = DateTime.now().difference(DateTime.parse('${createdAt}'));
    //1분 이하
    if(diff.inSeconds < 60){
      return "time1".tr();
    }
    //1분 이상 1시간 이하
    else if(diff.inSeconds >= 60 && diff.inMinutes < 60){
      return "${diff.inMinutes}${"time2".tr()}";
    }
    else if(diff.inMinutes >= 60 && diff.inHours < 24){
      return "${diff.inHours}${"time3".tr()}";
    }
    else{
      return DateFormat('yy.MM.dd').format(DateTime.parse('${createdAt}'));
    }
  }
}
