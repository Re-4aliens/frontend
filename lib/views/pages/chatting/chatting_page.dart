import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:aliens/repository/sql_message_database.dart';
import 'package:aliens/repository/sql_message_repository.dart';
import 'package:aliens/views/components/chat_dialog_widget.dart';
import 'package:async/async.dart';
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
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:web_socket_channel/io.dart';
import 'package:sqflite/sqflite.dart';
import '../../../apis/apis.dart';
import '../../../apis/firebase_apis.dart';
import '../../../models/chatRoom_model.dart';
import '../../../models/message_model.dart';
import '../../../models/partner_model.dart';
import '../../../models/vsGames.dart';
import '../../../providers/chat_provider.dart';
import 'package:web_socket_channel/io.dart';

List<MessageModel> _list = [];

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
  late String createdDate;
  bool isNewChat = true;
  bool bottomFlag = false;
  var isChecked = false;
  late AsyncMemoizer _memoizer;
  List<Map> requestBuffer = [];
  var sendChannel;
  var readChannel;
  var bulkReadChannel;

  Future<List<MessageModel>>? myFuture;
  FlutterLocalNotificationsPlugin?  _flutterLocalNotificationsPlugin;

  StreamSubscription<dynamic>? responseSubscription;
  StreamSubscription<dynamic>? readResponseSubscription;


  @override
  void initState() {
    super.initState();
    connectWebSocket();

    var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    //var initializationSettingsIOS = IOSInitializationSettings();

    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid);

    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _flutterLocalNotificationsPlugin!.initialize(initializationSettings);

    _messageStreamSubscription =
        FirebaseMessaging.onMessage.listen((RemoteMessage message) async {

          //채팅에 대한 fcm인 경우
          if(message.data['chatContent'] != null && message.data['roomId'] != null){
            // 메시지 데이터 구조 로깅, 현재 시간도 같이 로그에 출력
            print('Received 새로운 채팅에 대한 FCM with: ${message.data} at ${DateTime.now()}');
            //받은 fcm 저장하고 보여주기
            var newChat = MessageModel(
                chatType: int.parse(message.data['chatType']),
                chatContent: message.data['chatContent'],
                roomId: int.parse(message.data['roomId']),
                senderId: int.parse(message.data['senderId']),
                senderName: message.data['senderName'],
                receiverId: int.parse(message.data['receiverId']),
                sendTime: message.data['sendTime'],
                unreadCount: 1,
                chatId: int.parse(message.data['chatId'])
            );
            await SqlMessageRepository.create(newChat);
            await SqlMessageRepository.getList(widget.partner.roomId!, widget.memberDetails.memberId!);
            setState(() {
            });

            //단일 읽음 처리
            sendReadRequest(message);
          }
          //상대방이 읽었다는 것에 대한 fcm인 경우
          else if (message.data['chatId'] != null && message.data['roomId'] != null){
            print('Received FCM with: ${message.data} at ${DateTime.now()}');

            await SqlMessageRepository.update(widget.partner, int.parse(message.data['chatId']));
            setState(() {});
          }
          //상대방이 일괄 읽었다는 것에 대한 fcm인 경우
          else {
            print('Bulk Received FCM with: ${message.data} at ${DateTime.now()}' '${message.senderId}');

            await SqlMessageRepository.bulkUpdate(widget.partner);
            setState(() {});
            }
          }

        );

    _unreadListFuc();
    _getCreatedDate();
    _memoizer = AsyncMemoizer();
  }

  _unreadListFuc() async {
    List<MessageModel> unreadlist = await APIs.getMessages(widget.partner.roomId, context);

    //1. 리스트 업데이트
    for (final message in unreadlist) {
      print(message.chatContent);

      await SqlMessageRepository.create(message);
    }
    setState(() {
    });
  }

  void _getCreatedDate() async {
    //createdDate = await SqlMessageRepository.getCreatedTime(widget.partner.roomId!);
  }

  @override
  void dispose() {
    super.dispose();
    sendChannel.sink.close();
    readChannel.sink.close();
    bulkReadChannel.sink.close();

    _scrollController.dispose();

    responseSubscription?.cancel();
    responseSubscription = null;

    readResponseSubscription?.cancel();
    readResponseSubscription = null;


    FirebaseMessaging.onMessage.drain();
    _messageStreamSubscription?.cancel();
  }

  void sendMessage() async {
    Map<String, dynamic> request = {
      'requestId': DataUtils.makeUUID(),
      //'fcmToken': "dGMgDEHjQ02mFoAse9E9M2:APA91bE993Xpeg5v29-mzNgEhJ5usLzw3OOGnMXMawT5WYNu1I9MVyYzKuTqgXAZpSfc0xQcEPQTxtzP1OgsVc2c8Q0TNbxV-N-uBlDkh2AoEu-6UqFYo78UXVOWMBnZ47RbZ-rxlL79",
      //'fcmToken': "fxfKtVLpSSS9Wpsffoj64l:APA91bG2iCjrWsm8VV9XH4UD4bOPq7Ox1dEU7vwXc1gKMZ2JV2suNuGo9Wxggye7EYrAMfpHRE7i5j3mWTBD2Ig3MgyOQa4rin5QzZMVRwtIhRwHNIsLOjpiYD69G9ZT03-oJqv0eHVQ",
      //'fcmToken': "dNRrfFS3lkpGjrmR8h_02c:APA91bGFN8mw7ncHT3xG6k3P__ylVyyP6jbeNSRnAsDp-QCBoXAGCtGV9SboimtCPOBvibSxsCm2BUy8twurtB_eiynrHQetthqRnbtjoAulKrHxAX2k64k3tseYbUbk9AKaQmg7_E_F",
      'chatType': 0,
      'chatContent': _newMessage,
      'roomId': widget.partner.roomId,
      'senderId': widget.memberDetails.memberId,
      'senderName': widget.memberDetails.name,
      'receiverId': widget.partner.memberId,
      'sendTime': DateTime.now().toString(),
    };
    await sendChannel.sink.add(json.encode(request));
    requestBuffer.add(request);
    updateUi();
  }

  void sendVSMessage() async {

    // 랜덤 인덱스 생성
    Random random = Random();
    int randomIndex = random.nextInt(vsGames.length);

    Map<String, dynamic> request = {
      'requestId': DataUtils.makeUUID(),
      'chatType': 1,
      'chatContent': vsGames[randomIndex]['question'],
      'roomId': widget.partner.roomId,
      'senderId': widget.memberDetails.memberId,
      'senderName': widget.memberDetails.name,
      'receiverId': widget.partner.memberId,
      'sendTime': DateTime.now().toString(),
    };
    await sendChannel.sink.add(json.encode(request));
    requestBuffer.add(request);
    updateUi();
  }

  void sendReadRequest(RemoteMessage message) async {
    print('단일 읽음처리');
    Map<String, dynamic> request = {
      'requestId': DataUtils.makeUUID(),
      //'fcmToken': "dGMgDEHjQ02mFoAse9E9M2:APA91bE993Xpeg5v29-mzNgEhJ5usLzw3OOGnMXMawT5WYNu1I9MVyYzKuTqgXAZpSfc0xQcEPQTxtzP1OgsVc2c8Q0TNbxV-N-uBlDkh2AoEu-6UqFYo78UXVOWMBnZ47RbZ-rxlL79",
      //'fcmToken': "fxfKtVLpSSS9Wpsffoj64l:APA91bG2iCjrWsm8VV9XH4UD4bOPq7Ox1dEU7vwXc1gKMZ2JV2suNuGo9Wxggye7EYrAMfpHRE7i5j3mWTBD2Ig3MgyOQa4rin5QzZMVRwtIhRwHNIsLOjpiYD69G9ZT03-oJqv0eHVQ",
      //'fcmToken': "es5mW8PaTlOVqSk0HQhfjg:APA91bHsLBa767QE2AtQ0G6d0XKjClMskrWkojRLl1705UhHC4gOhszoR6oaJ8LqLWrhdR6OW1UEfUFFUls6lPAhxC9IsPJ-b253mfN5B4lhGap79mqW2JWo8vzHEJFBYWG2CeP9MkJC",
      'chatId': message.data['chatId'],
      'roomId': message.data['roomId'],
    };
    await readChannel.sink.add(json.encode(request));
    setState(() {

    });
  }

  void sendBulkReadRequest() async {
    Map<String, dynamic> request = {
      'requestId': DataUtils.makeUUID(),
      //'fcmToken': "es5mW8PaTlOVqSk0HQhfjg:APA91bHsLBa767QE2AtQ0G6d0XKjClMskrWkojRLl1705UhHC4gOhszoR6oaJ8LqLWrhdR6OW1UEfUFFUls6lPAhxC9IsPJ-b253mfN5B4lhGap79mqW2JWo8vzHEJFBYWG2CeP9MkJC",
      //'fcmToken': "dGMgDEHjQ02mFoAse9E9M2:APA91bE993Xpeg5v29-mzNgEhJ5usLzw3OOGnMXMawT5WYNu1I9MVyYzKuTqgXAZpSfc0xQcEPQTxtzP1OgsVc2c8Q0TNbxV-N-uBlDkh2AoEu-6UqFYo78UXVOWMBnZ47RbZ-rxlL79",
      //'fcmToken': "fxfKtVLpSSS9Wpsffoj64l:APA91bG2iCjrWsm8VV9XH4UD4bOPq7Ox1dEU7vwXc1gKMZ2JV2suNuGo9Wxggye7EYrAMfpHRE7i5j3mWTBD2Ig3MgyOQa4rin5QzZMVRwtIhRwHNIsLOjpiYD69G9ZT03-oJqv0eHVQ",
      'partnerId': widget.partner.memberId,
      'roomId': widget.partner.roomId,
    };
    await bulkReadChannel.sink.add(json.encode(request));
  }

  void connectWebSocket() async {
    String chatToken = '';
    try {
      chatToken = await APIs.getChatToken();
    } catch (e) {
      print(e);
      if(e == "AT-C-002"){
        await APIs.getAccessToken();
        chatToken = await APIs.getChatToken();
      }
    }

    final wsUrl = Uri.parse('ws://3.34.2.246:8081/ws/chat/message/send');
    final wsReadUrl = Uri.parse('ws://3.34.2.246:8081/ws/chat/message/read');
    final wsAllReadUrl = Uri.parse('ws://3.34.2.246:8081/ws/chat/room/read');
    var header = {
      'Authorization': chatToken
    };
    sendChannel = IOWebSocketChannel.connect(wsUrl, headers: header);
    readChannel = IOWebSocketChannel.connect(wsReadUrl, headers: header);
    bulkReadChannel = IOWebSocketChannel.connect(wsAllReadUrl, headers: header);

    sendBulkReadRequest();

    sendChannel.stream.listen((message) async {
      messageSendResponseHandler(message);
    }, onError: (error) {
      print('Error: $error');
    }, onDone: () {
      print('WebSocket connection closed');
    });

    readChannel.stream.listen((message) async {
      readResponseHandler(message);
    }, onError: (error) {
      print('Error: $error');
    }, onDone: () {
      print('WebSocket connection closed');
    });

    bulkReadChannel.stream.listen((message) async {
      bulkReadResponseHandler(message);
    }, onError: (error) {
      print('Error: $error');
    }, onDone: () {
      print('WebSocket connection closed');
    });
  }

  void readResponseHandler(message) {
    print('Received response: $message');
    if(json.decode(message)['status'] == 'success'){
      setState(() {});
    }
  }

  void bulkReadResponseHandler(message) async {
    print('bulk read channel Received response: $message');
    if(json.decode(message)['status'] == 'success'){
      //await SqlMessageRepository.bulkUpdate(widget.partner);
      setState(() {});
    }
  }

  void messageSendResponseHandler(message) async{
    print('웹소켓 전송 Received response: $message');
    if (json.decode(message)['status'] == 'success') {

      var requestId = json.decode(message)['requestId'];
      // requestBuffer에서 해당 requestId를 가진 request를 반환
      var request = requestBuffer.firstWhere((element) => element['requestId'] == requestId);

      print(json.decode(message)['chatId']);
      var chat = MessageModel(
          chatId: json.decode(message)['chatId'],
          // TODO chat Type 수정
          chatType: request['chatType'],
          chatContent: request['chatContent'],
          roomId: request['roomId'],
          senderId: request['senderId'],
          senderName: request['senderName'],
          receiverId: request['receiverId'],
          sendTime: request['sendTime'],
          unreadCount: 1
      );
      //저장됨
      await SqlMessageRepository.create(chat);
      setState(() {});

      requestBuffer.remove(request);
    }
  }

  /*

  채팅 내역 화면에 보여주기

   */
  Future<List<MessageModel>> _loadChatList() async {
    //3. 업데이트된 리스트 불러오기
    return await SqlMessageRepository.getList(widget.partner.roomId!, widget.memberDetails.memberId!);
  }
/*

  Future<void> _showNotification(String content) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails('your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin!.show(
      0,
      '메시지가 도착했습니다.',
      content,
      platformChannelSpecifics,
      payload: content,
    );
  }

 */

  void onSelectNotification(String? payload) async {
    debugPrint("$payload");
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Notification Payload'),
          content: Text('Payload: $payload'),
        ));
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  StreamSubscription<RemoteMessage>? _messageStreamSubscription;

  getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print(token);
  }


  void updateUi() async {
    setState(() {
      //텍스트폼 비우기
      _controller.clear();
      _newMessage = '';
    });
  }



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
                widget.partner.profileImage == null ?
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
                ) :
                InkWell(
                  onTap: (){
                    showDialog(
                        context: context,
                        builder: (_) => Scaffold(
                          backgroundColor: Colors.transparent,
                          body: ProfileDialog(
                            partner: widget.partner,
                          ),
                        ));
                  },
                  child: Container(
                    height: 35,
                    width: 35,
                    margin: const EdgeInsets.only(right: 10.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(widget.partner.profileImage!)
                        )
                    ),
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
                      builder: (builder) => ChatDialog(partner: widget.partner, context: context,));
                },
                //아이콘 수정 필요
                icon: SvgPicture.asset(
                  'assets/icon/ICON_more.svg',
                  height: 20,
                ),
              )
            ],
          ),
          body: widget.partner.roomState == 'OPEN' ? Column(children: [
            Expanded(
                child: Container(
                    padding: const EdgeInsets.only(top: 15),
                    color: Color(0xffF5F7FF),
                    child: FutureBuilder<List<MessageModel>>(
                              future: _loadChatList(),
                              builder: (context, snapshot){
                                if(snapshot.hasError) return Center(child: Text('${snapshot.error}'),);
                                if(snapshot.hasData){
                                  _list = snapshot.data!;
                                  var datas = snapshot.data;

                                  WidgetsBinding.instance
                                      .addPostFrameCallback((timeStamp) {
                                    _scrollController.animateTo(
                                        _scrollController.position.maxScrollExtent,
                                        duration: Duration(milliseconds: 10),
                                        curve: Curves.easeIn);
                                  });

                                  return ListView(
                                    controller: _scrollController,
                                    children: List.generate(datas!.length, (index) {
                                      final currentDate = DateTime.parse(datas[index].sendTime!);
                                      String? nextTime = index == datas.length - 1 ? null : DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(datas[index + 1]!.sendTime!));
                                      String? currentTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(datas[index].sendTime!));
                                      bool nextDiff = nextTime == null ? false : DateTime.parse(nextTime).difference(DateTime.parse(currentTime)).inMinutes > 1;

                                      bool _showingTime(index){

                                        //마지막 채팅인 경우 true
                                        if(index == datas.length - 1){
                                          return true;
                                        }
                                        //다음 말풍선이 본인이 아니면 true
                                        else if(datas[index + 1].senderId != datas[index].senderId){
                                          return true;
                                        }
                                        //다음 말풍선 시간이랑 차이가 있으면 true
                                        else if(nextDiff) {
                                          return true;
                                        }
                                        else {
                                          return false;
                                        }
                                      }

                                      bool _showingPic(index){
                                        if (index == 0){
                                          return true;
                                        }
                                        else if(datas[index].senderId != datas[index - 1].senderId){
                                          return true;
                                        }
                                        if(index == datas.length - 1){
                                          return false;
                                        }
                                        else if(nextDiff && datas[index].senderId == datas[index + 1].senderId){
                                          return true;
                                        }
                                        else {
                                          return false;
                                        }
                                      }
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
                                                  sendTime: datas[index].sendTime,
                                                  unreadCount: datas[index].unreadCount
                                              ),
                                              memberDetails: widget.memberDetails,
                                              showingTime: _showingTime(index),
                                              showingPic: _showingPic(index)
                                          )
                                        ],
                                      );
                                    }),
                                  );
                                } else return Center(child: Text('저장된 메세지 없음'));
                              })
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
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: Color(0xffC9C9C9),
                                  width: 1,
                                )),
                            padding: EdgeInsets.symmetric(horizontal: 20),
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
                                  onPressed:
                                    _newMessage.trim().isEmpty
                                        ? null
                                        : sendMessage
                                  ,
                                  icon: SvgPicture.asset(
                                    'assets/icon/ICON_send.svg',
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
                          });
                          sendVSMessage();
                        },
                        child: Container(
                          height: 150,
                          width: 150,
                          alignment: Alignment.center,
                          //TODO 이미지 교체
                          child: Image.asset(
                              'assets/character/vsGame_button.png'
                          ),
                        ),
                      ),
                      Text(
                        'chatting4'.tr(),
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
          ]) : Container(
            alignment: Alignment.center,
            color: Color(0xffF5F7FF),
            child: Text('chatting2'.tr(), style: TextStyle(color: Color(0xff888888)),),
          )
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
          margin: EdgeInsets.only(top: 20, bottom: 15),
          child: Text(
            '${DateFormat('yyyy/MM/dd').format(DateTime.parse(date))}',
            style: TextStyle(color: Colors.white),
          ),
        ),
        if (index == 0)
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Text(
              'chatting3'.tr(),
              style: TextStyle(color: Color(0xff717171), fontSize: 12),
            ),
          )
      ],
    );
  }
}
