import 'dart:async';

import 'package:aliens/models/chatRoom_model.dart';
import 'package:aliens/models/screenArgument.dart';
import 'package:aliens/repository/sql_message_database.dart';
import 'package:aliens/views/pages/chatting/chatting_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../apis/apis.dart';
import '../../repository/sql_message_repository.dart';

class matchingChattingWidget extends StatefulWidget {
  const matchingChattingWidget({super.key, required this.screenArguments});

  final ScreenArguments screenArguments;

  @override
  State<StatefulWidget> createState() => _matchingChattingWidgetState();
}

class _matchingChattingWidgetState extends State<matchingChattingWidget> {


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
        }
        );
  }
  @override
  void dispose() {
    _messageStreamSubscription?.cancel();
  }

  Future<List<ChatRoom>> _getChatRoomList() async {
    List<ChatRoom> _chatRoomList = List<ChatRoom>.generate(widget.screenArguments.partners!.length, (index) => ChatRoom(partner: widget.screenArguments.partners![index]));
    Map<String, dynamic> chatSummary;

    try{
      chatSummary = await APIs.getChatSummary();
    } catch(e){
      await APIs.getAccessToken();
      chatSummary = await APIs.getChatSummary();
    }

    for (int i = 0; i < _chatRoomList.length; i++) {
      for(int j = 0; j < _chatRoomList.length; j++){
        if (_chatRoomList[i].partner!.roomId == chatSummary['chatSummaries'][j]['roomId']) {
          _chatRoomList[i].lastChatContent = chatSummary['chatSummaries'][j]['lastChatContent'];
          _chatRoomList[i].lastChatTime = chatSummary['chatSummaries'][j]['lastChatTime'];
          _chatRoomList[i].numberOfUnreadChat = chatSummary['chatSummaries'][j]['numberOfUnreadChat'];
          break;
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
    return _chatRoomList;
  }

  _updateList() async {
    late Map<String, dynamic> chatSummary;
    try {
      chatSummary = await APIs.getChatSummary();
    } catch (e) {
      if(e == "AT-C-002"){
        await APIs.getAccessToken();
        chatSummary = await APIs.getChatSummary();
      }
    }

      setState(() {
        for (int i = 0; i < _chatRoomList.length; i++) {
          for(int j = 0; j < _chatRoomList.length; j++){
            if (_chatRoomList[i].partner!.roomId == chatSummary['chatSummaries'][j]['roomId']) {
              _chatRoomList[i].lastChatContent = chatSummary['chatSummaries'][j]['lastChatContent'];
              _chatRoomList[i].lastChatTime = chatSummary['chatSummaries'][j]['lastChatTime'];
              _chatRoomList[i].numberOfUnreadChat = chatSummary['chatSummaries'][j]['numberOfUnreadChat'];
              break;
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
      decoration: BoxDecoration(
        color: Color(0xffF5F7FF),
      ),
      child: FutureBuilder<List<ChatRoom>>(
          future: futureChatRoomList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Container(
                  margin: EdgeInsets.only(left: 75),
                  alignment: Alignment.center,
                  child: Image(
                      image: AssetImage(
                          "assets/illustration/loading_01.gif")));
            else if(snapshot.data == null){
              return Center(
                child: Text('불러올 매칭 상대가 없습니다.',
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff616161)
                  ),textAlign: TextAlign.center,
                ),
              );
            }
            else {
              return ListView.builder(
                  itemCount:snapshot.data!.length,
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
          }
      ),
    );
  }


  Widget chatList(context, index, ChatRoom chatRoom) {
    return Padding(
      padding: EdgeInsets.only(right: 25, left: 25, top: 30),
      child: MaterialButton(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
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
            _messageStreamSubscription =
                FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
                  print('채팅리스트에서 Received FCM with: ${message.data} at ${DateTime.now()}');
                  _updateList();
                }
                );
          });
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: SvgPicture.asset(
                'assets/icon/icon_profile.svg',
                height: 50,
                color: Color(0xff7898ff),
              ),
            ),
            Expanded(
                child: Container(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${chatRoom.partner!.name}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        (chatRoom.lastChatTime == '기록 없음' || chatRoom.lastChatTime == null)? '':
                        '${DateFormat('hh:mm aaa').format(DateTime.parse('${chatRoom.lastChatTime}'))}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xff888888),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '${chatRoom.lastChatContent}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xffA4A4A4),
                        ),
                      ),
                      chatRoom.numberOfUnreadChat == 0  || chatRoom.numberOfUnreadChat == null?
                            SizedBox(
                                height: 24,
                                width: 24,
                              ):
                              Container(
                                height: 24,
                                width: 24,
                                decoration: BoxDecoration(
                                  color: Color(0xff7898ff),
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '${chatRoom.numberOfUnreadChat}',
                                  style: TextStyle(
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
