import 'package:easy_localization/easy_localization.dart';
import 'package:uuid/uuid.dart';

class MessageFields {
  static const String id = 'id';
  static const String type = 'type';
  static const String content = 'content';
  static const String roomId = 'roomId';
  static const String senderId = 'senderId';
  static const String receiverId = 'receiverId';
  static const String sendTime = 'sendTime';
  static const String isRead = 'isRead';
}

class MessageModel {
  int? id;
  String? type;
  String? content;
  int? roomId;
  int? senderId;
  int? receiverId;
  String? sendTime;
  bool? isRead;

  MessageModel(
      {this.id,
      this.type,
      this.content,
      this.roomId,
      this.senderId,
      this.receiverId,
      this.sendTime,
      this.isRead});

  MessageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    content = json['content'];
    roomId = json['roomId'];
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    sendTime = json['sendTime'];
    isRead = json['isRead'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['content'] = content;
    data['roomId'] = roomId;
    data['senderId'] = senderId;
    data['receiverId'] = receiverId;
    data['sendTime'] = sendTime;
    data['isRead'] = isRead;
    return data;
  }
}

class DataUtils {
  static String makeUUID() {
    return const Uuid().v1();
  }

  static String getTime(createdAt) {
    Duration diff = DateTime.now().difference(DateTime.parse('$createdAt'));
    //1분 이하
    if (diff.inSeconds < 60) {
      return "time1".tr();
    }
    //1분 이상 1시간 이하
    else if (diff.inSeconds >= 60 && diff.inMinutes < 60) {
      return "${diff.inMinutes}${"time2".tr()}";
    } else if (diff.inMinutes >= 60 && diff.inHours < 24) {
      return "${diff.inHours}${"time3".tr()}";
    } else {
      return DateFormat('yy.MM.dd').format(DateTime.parse('$createdAt'));
    }
  }
}
