import 'dart:async';

import 'package:aliens/models/chat_room_model.dart';
import 'package:aliens/models/screen_argument.dart';
import 'package:aliens/models/partner_model.dart';
import 'package:aliens/views/pages/chatting/chatting_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:aliens/services/chat_service.dart';
import 'package:aliens/services/auth_service.dart';

class MatchingChattingWidget extends StatefulWidget {
  const MatchingChattingWidget({
    super.key,
    required this.screenArguments,
  });

  final ScreenArguments screenArguments;
  @override
  State<StatefulWidget> createState() => _MatchingChattingWidgetState();
}

class _MatchingChattingWidgetState extends State<MatchingChattingWidget> {
  StreamSubscription<RemoteMessage>? _messageStreamSubscription;
  Future<List<Map<String, dynamic>>>? futureCombinedList;
  late List<ChatRoom> _chatRoomList;
  late List<ChatMessageSummary> _chatMessageSummaries;
  late Map<int, Partner> _partnerMap;

  @override
  void initState() {
    super.initState();

    _partnerMap = {
      for (var partner in widget.screenArguments.partners!)
        partner.chatRoomId ?? -1: partner
    };

    //채팅 정보 받아오기
    futureCombinedList = _getCombinedChatData();
    _messageStreamSubscription =
        FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('채팅리스트에서 Received FCM with: ${message.data} at ${DateTime.now()}');
      _updateList();
    });

    _printFutureList();
  }

  Future<void> _printFutureList() async {
    List<Map<String, dynamic>> dataList = await futureCombinedList!;
    for (var data in dataList) {
      ChatRoom chatRoom = data['chatRoom'];
      ChatMessageSummary chatMessageSummary = data['chatMessageSummary'];

      print('ChatRoom: { id: ${chatRoom.id}, status: ${chatRoom.status} }');
      print('ChatMessageSummary: { roomId: ${chatMessageSummary.roomId}, '
          'lastMessageContent: ${chatMessageSummary.lastMessageContent}, '
          'numberOfUnreadMessages: ${chatMessageSummary.numberOfUnreadMessages}, '
          'lastChatTime: ${chatMessageSummary.lastChatTime} }');
    }
  }

  @override
  void dispose() {
    _messageStreamSubscription?.cancel();
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> _getCombinedChatData() async {
    ChatData chatData;
    try {
      chatData = await ChatService.getChatSummary();
    } catch (e) {
      await AuthService.getAccessToken();
      chatData = await ChatService.getChatSummary();
    }

    _chatRoomList = chatData.chatRooms;
    _chatMessageSummaries = chatData.chatMessageSummaries;

    int minLength = 0;
    if (_chatRoomList.isNotEmpty && _chatMessageSummaries.isNotEmpty) {
      minLength = _chatRoomList.length < _chatMessageSummaries.length
          ? _chatRoomList.length
          : _chatMessageSummaries.length;
    }

    var combinedList = List.generate(minLength, (index) {
      return {
        'chatRoom': _chatRoomList[index],
        'chatMessageSummary': _chatMessageSummaries[index]
      };
    });

    // 채팅방 목록 업데이트 및 정렬
    for (var item in combinedList) {
      var chatRoom = item['chatRoom'] as ChatRoom;
      var chatMessageSummary = item['chatMessageSummary'] as ChatMessageSummary;

      if (chatRoom.status == 'CLOSE') {
        chatMessageSummary.lastMessageContent = 'chatting1'.tr();
        chatMessageSummary.lastChatTime = '기록 없음';
        chatMessageSummary.numberOfUnreadMessages = 0;
      } else {
        for (var summary in _chatMessageSummaries) {
          if (chatRoom.id == summary.roomId) {
            chatMessageSummary.lastMessageContent = summary.lastMessageContent;
            chatMessageSummary.lastChatTime = summary.lastChatTime;
            chatMessageSummary.numberOfUnreadMessages =
                summary.numberOfUnreadMessages;
            break;
          }
        }
      }
    }

    // combinedList를 정렬
    combinedList.sort((a, b) {
      var chatMessageSummaryA = a['chatMessageSummary'] as ChatMessageSummary;
      var chatMessageSummaryB = b['chatMessageSummary'] as ChatMessageSummary;
      if (chatMessageSummaryA.lastChatTime == '기록 없음') {
        return 1;
      } else if (chatMessageSummaryB.lastChatTime == '기록 없음') {
        return -1;
      } else {
        return chatMessageSummaryB.lastChatTime
            .compareTo(chatMessageSummaryA.lastChatTime);
      }
    });

    return combinedList;
  }

  _updateList() async {
    late ChatData chatData;
    try {
      chatData = await ChatService.getChatSummary();
    } catch (e) {
      await AuthService.getAccessToken();
      chatData = await ChatService.getChatSummary();
    }

    setState(() {
      for (var item in chatData.chatMessageSummaries) {
        var roomId = item.roomId;
        var chatRoom = _chatRoomList.firstWhere((room) => room.id == roomId);
        var chatMessageSummary = _chatMessageSummaries
            .firstWhere((summary) => summary.roomId == roomId);

        if (chatRoom.status == 'CLOSE') {
          chatMessageSummary.lastMessageContent = 'chatting1'.tr();
          chatMessageSummary.lastChatTime = '기록 없음';
          chatMessageSummary.numberOfUnreadMessages = 0;
        } else {
          chatMessageSummary.lastMessageContent = item.lastChatTime;
          chatMessageSummary.lastChatTime = item.lastChatTime;
          chatMessageSummary.numberOfUnreadMessages =
              item.numberOfUnreadMessages;
        }
      }

      // combinedList를 정렬
      var combinedList = List.generate(_chatRoomList.length, (index) {
        return {
          'chatRoom': _chatRoomList[index],
          'chatMessageSummary': _chatMessageSummaries[index]
        };
      });

      combinedList.sort((a, b) {
        var chatMessageSummaryA = a['chatMessageSummary'] as ChatMessageSummary;
        var chatMessageSummaryB = b['chatMessageSummary'] as ChatMessageSummary;
        if (chatMessageSummaryA.lastChatTime == '기록 없음') {
          return 1;
        } else if (chatMessageSummaryB.lastChatTime == '기록 없음') {
          return -1;
        } else {
          return chatMessageSummaryB.lastChatTime
              .compareTo(chatMessageSummaryA.lastChatTime);
        }
      });

      _chatRoomList =
          combinedList.map((item) => item['chatRoom'] as ChatRoom).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xffF5F7FF),
      ),
      child: FutureBuilder<List<Map<String, dynamic>>>(
          future: futureCombinedList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                  alignment: Alignment.center,
                  child: const Image(
                      image: AssetImage("assets/illustration/loading_01.gif")));
            } else if (snapshot.data == null) {
              print("data null");
              return const Center(
                child: Text(
                  '',
                  style: TextStyle(fontSize: 16, color: Color(0xff616161)),
                  textAlign: TextAlign.center,
                ),
              );
            } else {
              var combinedList = snapshot.data!;
              return ListView.builder(
                  itemCount: combinedList.length,
                  itemBuilder: (context, index) {
                    var chatRoom = combinedList[index]['chatRoom'] as ChatRoom;
                    var chatMessageSummary = combinedList[index]
                        ['chatMessageSummary'] as ChatMessageSummary;
                    return Column(
                      children: [
                        chatList(context, index, chatRoom, chatMessageSummary),
                      ],
                    );
                  });
            }
          }),
    );
  }

  Widget chatList(context, index, ChatRoom chatRoom,
      ChatMessageSummary chatMessageSummary) {
    return Padding(
      padding: const EdgeInsets.only(right: 25, left: 25, top: 30),
      child: MaterialButton(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        height: 77,
        elevation: 0.0,
        onPressed: () {
          _messageStreamSubscription?.cancel();

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChattingPage(
                      partner: _partnerMap[chatRoom.id]!,
                    )),
          ).then((value) async {
            _updateList();
            _messageStreamSubscription = FirebaseMessaging.onMessage
                .listen((RemoteMessage message) async {
              print(
                  '채팅리스트에서 Received FCM with: ${message.data} at ${DateTime.now()}');
              _updateList();
            });
          });
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            widget.screenArguments.partners![index].profileImageUrl == null
                ? Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: SvgPicture.asset(
                      'assets/icon/icon_profile.svg',
                      height: 50,
                      color: const Color(0xff7898ff),
                    ),
                  )
                : Container(
                    height: 50,
                    width: 50,
                    margin: const EdgeInsets.only(right: 15),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(widget.screenArguments
                                .partners![index].profileImageUrl!))),
                  ),
            Expanded(
                child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_partnerMap[chatRoom.id]}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        (chatMessageSummary.lastChatTime == '기록 없음')
                            ? ''
                            : DateFormat('hh:mm aaa').format(DateTime.parse(
                                chatMessageSummary.lastChatTime)),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xff888888),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: SizedBox(
                          width: 200,
                          child: Text(
                            chatMessageSummary.lastMessageContent,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xffA4A4A4),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      chatMessageSummary.numberOfUnreadMessages == 0
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                            )
                          : Container(
                              height: 24,
                              width: 24,
                              decoration: const BoxDecoration(
                                color: Color(0xff7898ff),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '${chatMessageSummary.numberOfUnreadMessages}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                    ],
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
