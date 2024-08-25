import 'dart:async';

import 'package:aliens/models/screen_argument.dart';
import 'package:aliens/models/partner_model.dart';
import 'package:aliens/views/pages/chatting/chatting_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:aliens/services/chat_service.dart';
import 'package:aliens/services/auth_service.dart';
import 'package:aliens/models/chat_room_model.dart';

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
  Future<List<ChatMessageSummary>>? futureChatMessageSummaries;
  late List<ChatMessageSummary> _chatMessageSummaries;
  late Map<int, Partner> _partnerMap;

  @override
  void initState() {
    super.initState();

    _partnerMap = {
      for (var partner in widget.screenArguments.partners!)
        partner.chatRoomId ?? -1: partner
    };

    // 채팅 정보 받아오기
    futureChatMessageSummaries = _getChatMessageSummaries();
    _messageStreamSubscription =
        FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      _updateList();
    });
  }

  @override
  void dispose() {
    _messageStreamSubscription?.cancel();
    super.dispose();
  }

  Future<List<ChatMessageSummary>> _getChatMessageSummaries() async {
    ChatData chatData;
    try {
      chatData = await ChatService.getChatSummary();
    } catch (e) {
      await AuthService.getAccessToken();
      chatData = await ChatService.getChatSummary();
    }

    _chatMessageSummaries = chatData.chatMessageSummaries;

    // 채팅 요약 목록 업데이트 및 정렬
    for (var summary in _chatMessageSummaries) {
      if (summary.lastMessageTime == '기록 없음') {
        summary.lastMessageContent = 'chatting1'.tr();
        summary.lastMessageTime = '기록 없음';
        summary.numberOfUnreadMessages = 0;
      }
    }

    //_chatMessageSummaries = chatDataMock.chatMessageSummaries;

    // 목록을 정렬
    _chatMessageSummaries.sort((a, b) {
      if (a.lastMessageTime == '기록 없음') {
        return 1;
      } else if (b.lastMessageTime == '기록 없음') {
        return -1;
      } else {
        return b.lastMessageTime.compareTo(a.lastMessageTime);
      }
    });

    return _chatMessageSummaries;
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
        var summary = _chatMessageSummaries.firstWhere(
          (s) => s.roomId == item.roomId,
          orElse: () => ChatMessageSummary(
            roomId: -1,
            lastMessageContent: 'No content',
            numberOfUnreadMessages: 0,
            lastMessageTime: 'No time',
          ), // 기본값 반환
        );

        if (summary.roomId == -1) continue;

        summary.lastMessageContent = item.lastMessageContent;
        summary.lastMessageTime = item.lastMessageTime;
        summary.numberOfUnreadMessages = item.numberOfUnreadMessages;
      }

      // 목록을 정렬
      _chatMessageSummaries.sort((a, b) {
        if (a.lastMessageTime == '기록 없음') {
          return 1;
        } else if (b.lastMessageTime == '기록 없음') {
          return -1;
        } else {
          return b.lastMessageTime.compareTo(a.lastMessageTime);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xffF5F7FF),
      ),
      child: FutureBuilder<List<ChatMessageSummary>>(
          future: futureChatMessageSummaries,
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
              var summaries = snapshot.data!;
              return ListView.builder(
                  itemCount: summaries.length,
                  itemBuilder: (context, index) {
                    var chatMessageSummary = summaries[index];
                    return Column(
                      children: [
                        chatList(context, index, chatMessageSummary),
                      ],
                    );
                  });
            }
          }),
    );
  }

  Widget chatList(context, index, ChatMessageSummary chatMessageSummary) {
    Partner partner = _partnerMap[chatMessageSummary.roomId] ?? Partner();

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
                partner: partner,
                memberId: widget.screenArguments.applicant!.memberId ?? 0,
              ),
            ),
          ).then((value) async {
            _updateList();
            _messageStreamSubscription = FirebaseMessaging.onMessage
                .listen((RemoteMessage message) async {
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
            partner.profileImageUrl == null
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
                        image: NetworkImage(partner.profileImageUrl!),
                      ),
                    ),
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
                          '${partner.name}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          (chatMessageSummary.lastMessageTime == '기록 없음')
                              ? ''
                              : DateFormat('hh:mm aaa').format(DateTime.parse(
                                  chatMessageSummary.lastMessageTime)),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xff888888),
                          ),
                        ),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
