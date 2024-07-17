class ChatRoom {
  final int id;
  final String status;

  ChatRoom({required this.id, required this.status});

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      id: json['id'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
    };
  }
}

class ChatMessageSummary {
  int roomId;
  String lastMessageContent;
  int numberOfUnreadMessages;

  ChatMessageSummary({
    required this.roomId,
    required this.lastMessageContent,
    required this.numberOfUnreadMessages,
  });

  factory ChatMessageSummary.fromJson(Map<String, dynamic> json) {
    return ChatMessageSummary(
      roomId: json['roomId'],
      lastMessageContent: json['lastMessageContent'],
      numberOfUnreadMessages: json['numberOfUnreadMessages'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomId': roomId,
      'lastMessageContent': lastMessageContent,
      'numberOfUnreadMessages': numberOfUnreadMessages,
    };
  }
}

class ChatData {
  final List<ChatRoom> chatRooms;
  final List<ChatMessageSummary> chatMessageSummaries;

  ChatData({
    required this.chatRooms,
    required this.chatMessageSummaries,
  });

  factory ChatData.fromJson(Map<String, dynamic> json) {
    var chatRoomsJson = json['chatRooms'] as List;
    var chatMessageSummariesJson = json['chatMessageSummaries'] as List;

    List<ChatRoom> chatRoomsList =
        chatRoomsJson.map((room) => ChatRoom.fromJson(room)).toList();
    List<ChatMessageSummary> chatMessageSummariesList = chatMessageSummariesJson
        .map((summary) => ChatMessageSummary.fromJson(summary))
        .toList();

    return ChatData(
      chatRooms: chatRoomsList,
      chatMessageSummaries: chatMessageSummariesList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatRooms': chatRooms.map((room) => room.toJson()).toList(),
      'chatMessageSummaries':
          chatMessageSummaries.map((summary) => summary.toJson()).toList(),
    };
  }
}
