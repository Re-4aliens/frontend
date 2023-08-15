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
import '../../mockdatas/board_mockdata.dart';
import '../../repository/sql_message_repository.dart';
import '../pages/board/article_page.dart';

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
      decoration: BoxDecoration(color: Colors.white),
      child: ListView.builder(
          itemCount: totalBoardList.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                ListTile(
                  //제목
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: SvgPicture.asset(
                          'assets/icon/icon_profile.svg',
                          width: 35,
                          color: Color(0xff7898ff),
                        ),
                      ),
                      Text(
                        '${totalBoardList[index].member!.nickname}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(
                        '/',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(
                        'KR',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      )
                    ],
                  ),

                  //내용
                  subtitle: Container(
                    padding: EdgeInsets.only(left: 15, bottom: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        totalBoardList[index].imageUrls == null ?
                        SizedBox():
                        Container(
                          height: 100,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: totalBoardList[index].imageUrls!.length,
                              itemBuilder: (context, index){
                                return Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(right: 10),
                                      height: 80,
                                      width: 80,
                                      decoration: BoxDecoration(
                                          color: Color(0xfff8f8f8),
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Icon(Icons.add_photo_alternate_outlined),
                                    ),
                                  ],
                                );
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 25.0),
                          child: Text('${totalBoardList[index].title}', style: TextStyle(fontSize: 16),),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Icon(
                                Icons.thumb_up_alt_sharp,
                                color: Color(0xffc1c1c1),
                                size: 20,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 4, right: 15),
                              child: totalBoardList[index].likeCount == 0
                                  ? Text('')
                                  : Text(
                                  '${totalBoardList[index].likeCount}'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Icon(
                                Icons.chat_bubble,
                                color: Color(0xffc1c1c1),
                                size: 20,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                  '${totalBoardList[index].commentCount}'),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),

                  //더보기
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '1분 전',
                        style: TextStyle(
                            fontSize: 16, color: Color(0xffc1c1c1)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child:
                        Icon(Icons.more_vert, color: Color(0xffc1c1c1)),
                      )
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ArticlePage(board: totalBoardList[index], boardCategory: "자유게시판")),

                    );
                  },
                ),
                Divider(
                  thickness: 2,
                  color: Color(0xffE5EBFF),
                )
              ],
            );
          }),
    );
  }


}
