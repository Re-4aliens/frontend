import 'dart:async';
import 'dart:convert';

import 'package:aliens/repository/sql_message_database.dart';
import 'package:aliens/repository/sql_message_repository.dart';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

import 'package:aliens/models/applicant_model.dart';
import 'package:aliens/models/memberDetails_model.dart';
import 'package:aliens/models/screenArgument.dart';
import 'package:aliens/views/components/message_bubble_widget.dart';
import 'package:aliens/views/components/profileDialog_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:web_socket_channel/io.dart';
import 'package:sqflite/sqflite.dart';
import '../../../apis.dart';
import '../../../models/chatRoom_model.dart';
import '../../../models/message_model.dart';
import '../../../models/partner_model.dart';
import '../../../providers/chat_provider.dart';

List<MessageModel> _list = [];
var channel;
var readChannel;

class ChattingPage extends StatefulWidget {
  const ChattingPage(
      {super.key,
      required this.applicant,
      required this.partner,
      required this.memberDetails});

  final Applicant? applicant;
  final Partner partner;
  final MemberDetails memberDetails;

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> {
  final _controller = TextEditingController();

  final ScrollController _scrollController = ScrollController();
  var _newMessage = '';
  bool isLoading = true;
  bool isKeypadUp = false;
  var itemLength = 0;
  bool isSended = false;
  static String createdDate = '1999-01-01';
  bool isNewChat = true;
  bool bottomFlag = false;

  StreamSubscription<dynamic>? responseSubscription;

  void getMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      // 메시지 데이터 구조 로깅, 현재 시간도 같이 로그에 출력
      print('Received FCM message with data: ${message.data} at ${DateTime.now()}');

      //받은 fcm 저장하고 보여주기
      var field = json.decode(message.data as String);
      var newChat = MessageModel(
          chatType: field['chatType'],
          chatContent: field['chatContent'],
          roomId: field['roomId'],
          senderId: field['senderId'],
          senderName: field['senderName'],
          receiverId: field['receiverId'],
          sendTime: field['sendTime']
      );
      //저장됨
      await SqlMessageRepository.create(newChat);
      updateUi();

      //읽음 처리 전송

      //응답받으면 업데이트하기


    });
  }


  void createdChat() async {
    //응답값 설정
    Map<String, dynamic> response = {
      'requestId': DataUtils.makeUUID(),
      'fcmToken': "fxTG0oKYRsWj9sIdE1CLHS:APA91bF69Yq8OF_DfJgo4OEcOx2Qy6TyZIptRYPEmgbSLX_w_XQ5-CsCuE9UPNz9bn4QMP_Ic_8IDvREHC3Osq_1LXl3nUOatbfyOfp-N6ejpNYXJIPf6b8C7hHdr7423aqDNWdZK2yy",
      'chatType': 0,
      'chatContent': _newMessage,
      'roomId': widget.partner.roomId,
      'senderId': widget.memberDetails.memberId,
      'senderName': "Ryan",
      'receiverId': widget.partner.memberId,
      'sendTime': DateTime.now().toString(),
    };

    updateUi();

    //웹소켓 전송
    channel.sink.add(json.encode(response));

    if (responseSubscription == null) {
      responseSubscription = channel.stream.listen((message) async {
        print('Received response: $message');
        if(json.decode(message)['status'] == 'success'){
          var chat = MessageModel(
              chatType: 0,
              chatContent: response['chatContent'],
              roomId: response['roomId'],
              senderId: response['senderId'],
              senderName: response['senderName'],
              receiverId: response['receiverId'],
              sendTime: response['sendTime']
          );
          //저장됨
          await SqlMessageRepository.create(chat);
          setState(() {});
        }
      }, onError: (error) {
        print('Error: $error');
      }, onDone: () {
        print('WebSocket connection closed');
      });
    }

  }

  Future<List<MessageModel>> _loadChatList(unReadChatList) async {

    //리스트 업데이트
    for (final message in unReadChatList) {
      await SqlMessageRepository.create(message);
    }

/*
    //읽음 처리 보내기
    Map<String, dynamic> response = {
      "requestId": DataUtils.makeUUID(),
      "fcmToken": "",
      "chatId" : 123
    };
    readChannel.sink.add(json.encode(response));

    //성공하면 수정
 */


    //업데이트된 리스트 불러오기
    return await SqlMessageRepository.getList(widget.partner.roomId!);
  }

  @override
  void initState() {
    super.initState();
    final wsUrl = Uri.parse('ws://13.125.205.59:8081/ws/chat');
    final wsReadUrl = Uri.parse('ws://13.125.205.59:8081/ws/read');

    _scrollController.addListener(() {
      scrollListener();
    });
    createdDate = DateTime.now().toString();

    channel = IOWebSocketChannel.connect(wsUrl);
    readChannel = IOWebSocketChannel.connect(wsReadUrl);
  }

  @override
  void dispose() {
    super.dispose();
    channel.sink.close();
    readChannel.sink.close();

    _scrollController.dispose();

    responseSubscription?.cancel();
    responseSubscription = null;
  }

  scrollListener() async {
    /*
    if (_scrollController.offset == _scrollController.position.maxScrollExtent
        && !_scrollController.position.outOfRange) {
      if(_list.last.chatId != 1){
        _list.insertAll(_list.length, await APIs.getPreviousMessages(_list.last.chatId!));
      }
      setState(() {
        itemLength = _list.length;
      });
    }

     */
  }

  void updateUi() async {
    setState(() {
      //텍스트폼 비우기
      //스크롤 아래로 내리기
      bottomFlag = true;
      _controller.clear();
      _newMessage = '';
    });
  }

  //랜덤채팅 바 보여주기
  var isChecked = false;

  @override
  Widget build(BuildContext context) {
    bool isKeyboardOpen = false;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (isChecked) {
            isChecked = false;
            return Future.value(false);
          } else
            return Future.value(true);
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 7,
            shadowColor: Colors.black26,
            toolbarHeight: 90,
            backgroundColor: Colors.white,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: SvgPicture.asset(
                'assets/icon/icon_back.svg',
                height: 16,
              ),
              color: Colors.black,
            ),
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: IconButton(
                    icon: SvgPicture.asset(
                      'assets/icon/icon_profile.svg',
                      color: Color(0xff7898ff),
                    ),
                    iconSize: 35,
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (_) => Scaffold(
                                backgroundColor: Colors.transparent,
                                body: ProfileDialog(
                                  partner: widget.partner,
                                ),
                              ));
                    },
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.partner.name}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${widget.partner.nationality}',
                      style: TextStyle(
                        color: Color(0xff626262),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () {
                  //print(arguments.partners);
                  showDialog(
                      context: context,
                      builder: (builder) => Dialog(
                            elevation: 0,
                            backgroundColor: Color(0xffffffff),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Container(
                              padding: EdgeInsets.all(30),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "어떤 서비스를 원하세요?",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(25.0),
                                    child: Text(
                                      "대화 상대방을 신고 또는 차단하고 싶다면 아래 버튼을 클릭해주세요.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(13),
                                    decoration: BoxDecoration(
                                        color: Color(0xff7898FF),
                                        borderRadius: BorderRadius.circular(5)),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "신고하기",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(13),
                                    decoration: BoxDecoration(
                                        color: Color(0xff7898FF),
                                        borderRadius: BorderRadius.circular(5)),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "차단하기",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ));
                },
                //아이콘 수정 필요
                icon: SvgPicture.asset(
                  'assets/icon/icon_more.svg',
                  height: 20,
                ),
              )
            ],
          ),
          body: Column(children: [
            Expanded(
                child: Container(
                    padding: const EdgeInsets.only(top: 15),
                    color: Color(0xffF5F7FF),
                    child: FutureBuilder<List<MessageModel>>(
                      future: APIs.getMessages(widget.partner.roomId),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(child: Text('${snapshot}'));
                        }
                        if (snapshot.hasData) {
                          //받아온 안읽은 채팅리스트
                          var unReadChatList = snapshot.data;
                          //안읽은 채팅이 있으면 DB에 저장해서 보여주기
                          return FutureBuilder<List<MessageModel>>(
                            future: _loadChatList(unReadChatList),
                              builder: (context, snapshot){
                                if(snapshot.hasError) return Center(child: Text('채팅 불러오는데 오류'),);
                                if(snapshot.hasData){
                                  _list = snapshot.data!;
                                  var datas = snapshot.data;

                                  WidgetsBinding.instance
                                      .addPostFrameCallback((timeStamp) {
                                    _scrollController.animateTo(
                                        _scrollController.position.maxScrollExtent,
                                        duration: Duration(milliseconds: 200),
                                        curve: Curves.easeIn);
                                  });
                                  return ListView(
                                    controller: _scrollController,
                                    children: List.generate(datas!.length, (index) {
                                      final currentDate =
                                      DateTime.parse(datas[index].sendTime!);
                                      return Column(
                                        children: [
                                          if (index == 0 ||
                                              currentDate.year !=
                                                  DateTime.parse(
                                                      datas[index - 1].sendTime!)
                                                      .year ||
                                              currentDate.month !=
                                                  DateTime.parse(
                                                      datas[index - 1].sendTime!)
                                                      .month ||
                                              currentDate.day !=
                                                  DateTime.parse(
                                                      datas[index - 1].sendTime!)
                                                      .day)
                                            _timeBubble(index, currentDate.toString()),
                                          MessageBubble(
                                              message: MessageModel(
                                                  chatId: datas[index].chatId,
                                                  chatType: datas[index].chatType,
                                                  chatContent: datas[index].chatContent,
                                                  roomId: datas[index].roomId,
                                                  senderId: datas[index].senderId,
                                                  senderName: datas[index].senderName,
                                                  receiverId: datas[index].receiverId,
                                                  sendTime: datas[index].sendTime),
                                              memberDetails: widget.memberDetails,
                                              showingTime: true,
                                              showingPic: index == 0
                                                  ? true
                                                  : datas[index].senderId !=
                                                  datas[index - 1].senderId)
                                        ],
                                      );
                                    }),
                                  );
                                } else return Center(child: Text('저장된 메세지 없음'));
                          });
                        } else
                          return Center(child: Text('받아올 메세지 없음'),);
                      },
                    )
                )
            ),
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 10,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.add,
                          color: Color(0xff7898ff),
                          size: 30,
                        ),
                        onPressed: () {
                          setState(() {
                            if (isChecked) {
                              isChecked = false;
                              FocusScope.of(context).unfocus();
                            } else {
                              isChecked = true;
                              FocusScope.of(context).unfocus();
                            }
                          });
                        },
                      ),
                      Expanded(
                        child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xffFAFAFA),
                                borderRadius: BorderRadius.circular(360),
                                border: Border.all(
                                  color: Color(0xffC9C9C9),
                                  width: 1,
                                )),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                Expanded(
                                    child: TextField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                  onTap: () {
                                    setState(() {
                                      isChecked = false;
                                    });
                                  },
                                  controller: _controller,
                                  onChanged: (value) {
                                    setState(() {
                                      _newMessage = value;
                                    });
                                  },
                                )),
                                IconButton(
                                  onPressed: _newMessage.trim().isEmpty
                                      ? null
                                      : createdChat,
                                  icon: SvgPicture.asset(
                                    'assets/icon/icon_send.svg',
                                    height: 22,
                                    color: Color(0xff7898ff),
                                  ),
                                ),
                              ],
                            )),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ),
                Container(
                  height:
                      isChecked ? MediaQuery.of(context).size.height * .35 : 0,
                  alignment: Alignment.center,
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            isChecked = false;
                            _scrollController.animateTo(
                                _scrollController.position.minScrollExtent,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.ease);
                          });
                          /*
                          _list.insert(0, MessageModel(
                            chatId: _list.length,
                            chatType: 1,
                            chatContent: '밸런스 게임',
                            roomId: widget.partner.roomId,
                            senderId: widget.memberDetails.memberId,
                            senderName: widget.memberDetails.name,
                            receiverId: widget.partner.memberId,
                            sendTime: DateTime.now().toString(),
                            unReadCount: 1,
                          ),);*/
                        },
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Color(0xffF5F7FF),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                    color: Colors.black.withOpacity(0.1))
                              ]),
                          alignment: Alignment.center,
                          child: Text('밸런스게임'),
                          margin: EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                      Text(
                        '밸런스게임\n제안하기',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color(0xff888888),
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }

  Widget _timeBubble(int index, String date) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Color(0xff9B9B9B),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20),
          margin: EdgeInsets.only(top: 20),
          child: index == 0
              ? Text(
                  '${DateFormat('yyyy/MM/dd').format(DateTime.parse(createdDate))}',
                  style: TextStyle(color: Colors.white),
                )
              : Text(
                  '${DateFormat('yyyy/MM/dd').format(DateTime.parse(date))}',
                  style: TextStyle(color: Colors.white),
                ),
        ),
        if (index == 0)
          Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 20.0),
            child: Text(
              "새로운 대화를 시작합니다.",
              style: TextStyle(color: Color(0xff717171), fontSize: 12),
            ),
          )
      ],
    );
  }
}
