import 'dart:async';

import 'package:aliens/models/chatroom_model.dart';
import 'package:aliens/models/screen_argument.dart';
import 'package:aliens/views/pages/chatting/chatting_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:aliens/services/chat_service.dart';
import 'package:aliens/services/auth_service.dart';

class MatchingChattingWidget extends StatefulWidget {
  const MatchingChattingWidget({super.key, required this.screenArguments});

  final ScreenArguments screenArguments;

  @override
  State<StatefulWidget> createState() => _MatchingChattingWidgetState();
}

class _MatchingChattingWidgetState extends State<MatchingChattingWidget> {
  StreamSubscription<RemoteMessage>? _messageStreamSubscription;
  Future<List<ChatRoom>>? futureChatRoomList;
  late List<ChatRoom> _chatRoomList;
  bool flag = true;

  @override
  void initState() {
    //채팅 정보 받아오기
    futureChatRoomList = _getChatRoomList();
    _messageStreamSubscription =
        FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('채팅리스트에서 Received FCM with: ${message.data} at ${DateTime.now()}');
      _updateList();
    });
  }

  @override
  void dispose() {
    _messageStreamSubscription?.cancel();
  }

  Future<List<ChatRoom>> _getChatRoomList() async {
    List<ChatRoom> chatRoomList = List<ChatRoom>.generate(
        widget.screenArguments.partners!.length,
        (index) => ChatRoom(partner: widget.screenArguments.partners![index]));
    Map<String, dynamic> chatSummary;

    try {
      chatSummary = await ChatService.getChatSummary(context);
    } catch (e) {
      await AuthService.getAccessToken();
      chatSummary = await ChatService.getChatSummary(context);
    }

    for (int i = 0; i < chatRoomList.length; i++) {
      if (chatRoomList[i].partner!.roomState == 'CLOSE') {
        chatRoomList[i].lastChatContent = 'chatting1'.tr();
        chatRoomList[i].lastChatTime = '기록 없음';
        chatRoomList[i].numberOfUnreadChat = 0;
      } else {
        for (int j = 0; j < chatRoomList.length; j++) {
          if (chatRoomList[i].partner!.roomId ==
              chatSummary['chatSummaries'][j]['roomId']) {
            chatRoomList[i].lastChatContent =
                chatSummary['chatSummaries'][j]['lastChatContent'];
            chatRoomList[i].lastChatTime =
                chatSummary['chatSummaries'][j]['lastChatTime'];
            chatRoomList[i].numberOfUnreadChat =
                chatSummary['chatSummaries'][j]['numberOfUnreadChat'];
            break;
          }
        }
      }
    }
    chatRoomList.sort((a, b) {
      if (a.lastChatTime == null && b.lastChatTime == null) {
        return 0;
      } else if (a.lastChatTime == '기록 없음') {
        return 1; // a의 lastChatTime이 null이면 b가 더 앞으로 감
      } else if (b.lastChatTime == '기록 없음') {
        return -1; // b의 lastChatTime이 null이면 a가 더 앞으로 감
      } else {
        return b.lastChatTime!.compareTo(a.lastChatTime!); // 일반적인 비교
      }
    });
    return chatRoomList;
  }

  _updateList() async {
    late Map<String, dynamic> chatSummary;
    try {
      chatSummary = await ChatService.getChatSummary(context);
    } catch (e) {
      if (e == "AT-C-002") {
        await AuthService.getAccessToken();
        chatSummary = await ChatService.getChatSummary(context);
      }
    }

    setState(() {
      for (int i = 0; i < _chatRoomList.length; i++) {
        if (_chatRoomList[i].partner!.roomState == 'CLOSE') {
          _chatRoomList[i].lastChatContent = 'chatting1'.tr();
          _chatRoomList[i].lastChatTime = '기록 없음';
          _chatRoomList[i].numberOfUnreadChat = 0;
        } else {
          for (int j = 0; j < _chatRoomList.length; j++) {
            if (_chatRoomList[i].partner!.roomId ==
                chatSummary['chatSummaries'][j]['roomId']) {
              _chatRoomList[i].lastChatContent =
                  chatSummary['chatSummaries'][j]['lastChatContent'];
              _chatRoomList[i].lastChatTime =
                  chatSummary['chatSummaries'][j]['lastChatTime'];
              _chatRoomList[i].numberOfUnreadChat =
                  chatSummary['chatSummaries'][j]['numberOfUnreadChat'];
              break;
            }
          }
        }
      }
      _chatRoomList.sort((a, b) {
        if (a.lastChatTime == null && b.lastChatTime == null) {
          return 0;
        } else if (a.lastChatTime == '기록 없음') {
          return 1; // a의 lastChatTime이 null이면 b가 더 앞으로 감
        } else if (b.lastChatTime == '기록 없음') {
          return -1; // b의 lastChatTime이 null이면 a가 더 앞으로 감
        } else {
          return b.lastChatTime!.compareTo(a.lastChatTime!); // 일반적인 비교
        }
      });
    });
    //return chatRoomList;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xffF5F7FF),
      ),
      child: FutureBuilder<List<ChatRoom>>(
          future: futureChatRoomList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                  alignment: Alignment.center,
                  child: const Image(
                      image: AssetImage("assets/illustration/loading_01.gif")));
            } else if (snapshot.data == null) {
              return const Center(
                child: Text(
                  '',
                  style: TextStyle(fontSize: 16, color: Color(0xff616161)),
                  textAlign: TextAlign.center,
                ),
              );
            } else {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    _chatRoomList = snapshot.data!;
                    return Column(
                      children: [
/*
                        if(index==0) TextButton(onPressed: (){
                          SqlMessageDataBase.instance.deleteDB();
                        }, child: Text('dB 삭제')),

 */
                        chatList(context, index, _chatRoomList[index]),
                      ],
                    );
                  });
            }
          }),
    );
  }

  Widget chatList(context, index, ChatRoom chatRoom) {
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
                      applicant: widget.screenArguments.applicant,
                      partner: chatRoom.partner!,
                      memberDetails: widget.screenArguments.memberDetails!,
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
            widget.screenArguments.partners![index].profileImage == null
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
                                .partners![index].profileImage!))),
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
                        '${chatRoom.partner!.name}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        (chatRoom.lastChatTime == '기록 없음' ||
                                chatRoom.lastChatTime == null)
                            ? ''
                            : DateFormat('hh:mm aaa').format(
                                DateTime.parse('${chatRoom.lastChatTime}')),
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
                            '${chatRoom.lastChatContent}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xffA4A4A4),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      chatRoom.numberOfUnreadChat == 0 ||
                              chatRoom.numberOfUnreadChat == null
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
                                '${chatRoom.numberOfUnreadChat}',
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
