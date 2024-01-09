import 'package:aliens/models/partner_model.dart';

class ChatRoom {
  Partner? partner;
  String? lastChatContent;
  String? lastChatTime;
  int? numberOfUnreadChat;

  ChatRoom({this.partner, this.lastChatContent, this.lastChatTime, this.numberOfUnreadChat});

  ChatRoom.fromJson(Map<String, dynamic> json) {
    partner = json['partner'];
    lastChatContent = json['lastChatContent'];
    lastChatTime = json['lastChatTime'];
    numberOfUnreadChat = json['numberOfUnreadChat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['partner'] = this.partner;
    data['lastChatContent'] = this.lastChatContent;
    data['lastChatTime'] = this.lastChatTime;
    data['numberOfUnreadChat'] = this.numberOfUnreadChat;
    return data;
  }
}