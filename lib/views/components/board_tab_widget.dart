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

class TotalBoardWidget extends StatefulWidget {
  const TotalBoardWidget({super.key, required this.screenArguments});

  final ScreenArguments screenArguments;

  @override
  State<StatefulWidget> createState() => _TotalBoardWidgetState();
}

class _TotalBoardWidgetState extends State<TotalBoardWidget> {

/*
  StreamSubscription<RemoteMessage>? _messageStreamSubscription;
  Future<List<ChatRoom>>? futureChatRoomList;
  late List<ChatRoom> _chatRoomList;
  bool flag = true;
*/
  @override
  void initState() {
    /*
    //채팅 정보 받아오기
    futureChatRoomList = _getChatRoomList();
    _messageStreamSubscription =
        FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
          print('채팅리스트에서 Received FCM with: ${message.data} at ${DateTime.now()}');
          _updateList();
        }
        );

     */
  }
  @override
  void dispose() {
    //_messageStreamSubscription?.cancel();
  }

  /*
  Future<List<ChatRoom>> _getChatRoomList() async {
    List<ChatRoom> _chatRoomList = List<ChatRoom>.generate(widget.screenArguments.partners!.length, (index) => ChatRoom(partner: widget.screenArguments.partners![index]));
    Map<String, dynamic> chatSummary;

    try{
      chatSummary = await APIs.getChatSummary(context);
    } catch(e){
      await APIs.getAccessToken();
      chatSummary = await APIs.getChatSummary(context);
    }

    for (int i = 0; i < _chatRoomList.length; i++) {
      if(_chatRoomList[i].partner!.roomState == 'CLOSE'){
        _chatRoomList[i].lastChatContent = 'chatting1'.tr();
        _chatRoomList[i].lastChatTime = '기록 없음';
        _chatRoomList[i].numberOfUnreadChat = 0;
      }
      else{
        for(int j = 0; j < _chatRoomList.length; j++){
          if (_chatRoomList[i].partner!.roomId == chatSummary['chatSummaries'][j]['roomId']) {
            _chatRoomList[i].lastChatContent = chatSummary['chatSummaries'][j]['lastChatContent'];
            _chatRoomList[i].lastChatTime = chatSummary['chatSummaries'][j]['lastChatTime'];
            _chatRoomList[i].numberOfUnreadChat = chatSummary['chatSummaries'][j]['numberOfUnreadChat'];
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
    return _chatRoomList;
  }

   */


  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
        color: Color(0xffF5F7FF),
      ),
      child: ListView.builder(
          itemCount: 1,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Text('게시물 리스트')
             ],
            );
          }),
    );
  }


}
