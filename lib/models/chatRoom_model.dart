class ChatRoom {
  int? roomId;
  String? status;
  List<dynamic>? chatMessages;
  int? partnerId;

  ChatRoom({this.roomId, this.status, this.chatMessages, this.partnerId});

  ChatRoom.fromJson(Map<String, dynamic> json) {
    roomId = json['roomId'];
    status = json['status'];
    chatMessages = json['chatMessages'];
    partnerId = json['partnerId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['roomId'] = this.roomId;
    data['status'] = this.status;
    data['chatMessages'] = this.chatMessages;
    data['partnerId'] = this.partnerId;
    return data;
  }
}