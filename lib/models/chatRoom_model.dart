import 'package:aliens/models/partner_model.dart';

class ChatRoom {
  Partner? partner;
  String? lastChatContent;
  String? lastChatTime;
  int? numberOfUnreadChat;

  ChatRoom(
      {this.partner,
      this.lastChatContent,
      this.lastChatTime,
      this.numberOfUnreadChat});

  ChatRoom.fromJson(Map<String, dynamic> json) {
    partner = json['partner'];
    lastChatContent = json['lastChatContent'];
    lastChatTime = json['lastChatTime'];
    numberOfUnreadChat = json['numberOfUnreadChat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['partner'] = partner;
    data['lastChatContent'] = lastChatContent;
    data['lastChatTime'] = lastChatTime;
    data['numberOfUnreadChat'] = numberOfUnreadChat;
    return data;
  }
}
