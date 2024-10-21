import 'package:aliens/models/chat_room_model.dart';

ChatRoom chatRoom1 = ChatRoom(
  id: 143,
  status: "OPEND",
);

ChatRoom chatRoom2 = ChatRoom(
  id: 144,
  status: "OPEND",
);

ChatRoom chatRoom3 = ChatRoom(
  id: 136,
  status: "CLOSED",
);

ChatRoom chatRoom4 = ChatRoom(
  id: 139,
  status: "OPNED",
);

ChatMessageSummary chatMessageSummary1 = ChatMessageSummary(
  roomId: 143,
  lastMessageContent: "ㅈㅎㅈㅎ",
  numberOfUnreadMessages: 24,
  lastMessageTime: "2024-08-22T13:21:18.537+00:00",
);

ChatMessageSummary chatMessageSummary2 = ChatMessageSummary(
  roomId: 144,
  lastMessageContent: "efefge",
  numberOfUnreadMessages: 1,
  lastMessageTime: "2024-08-22T13:21:18.537+00:00",
);

ChatData chatDataMock = ChatData(
  chatRooms: [chatRoom1, chatRoom2, chatRoom3, chatRoom4],
  chatMessageSummaries: [chatMessageSummary1, chatMessageSummary2],
);






