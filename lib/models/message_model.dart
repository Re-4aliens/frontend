class MessageModel {
  int? roomId;
  String? senderId;
  String? receiverId;
  String? message;
  String? messageCategory;

  MessageModel(
      {this.roomId,
        this.senderId,
        this.receiverId,
        this.message,
        this.messageCategory});

  MessageModel.fromJson(Map<String, dynamic> json) {
    roomId = json['roomId'];
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    message = json['message'];
    messageCategory = json['messageCategory'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['roomId'] = this.roomId;
    data['senderId'] = this.senderId;
    data['receiverId'] = this.receiverId;
    data['message'] = this.message;
    data['messageCategory'] = this.messageCategory;
    return data;
  }
}