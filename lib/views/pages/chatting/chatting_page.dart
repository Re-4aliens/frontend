import 'dart:async';
import 'dart:math';
import 'package:aliens/services/chat_service.dart';
import 'package:aliens/repository/sql_message_repository.dart';
import 'package:aliens/views/components/chat_dialog_widget.dart';
import 'package:async/async.dart';
import 'package:aliens/views/components/message_bubble_widget.dart';
import 'package:aliens/views/components/profile_dialog_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import '../../../models/message_model.dart';
import '../../../models/partner_model.dart';
import '../../../models/vs_game.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


List<MessageModel> _list = [];

class ChattingPage extends StatefulWidget {
  const ChattingPage({
    super.key,
    required this.partner,
  });

  final Partner partner;

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage>
    with WidgetsBindingObserver {
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
  late final _messageStreamSubscription;
  List<Map> requestBuffer = [];

  Future<List<MessageModel>>? myFuture;
  FlutterLocalNotificationsPlugin? _flutterLocalNotificationsPlugin;

  StreamSubscription<dynamic>? responseSubscription;
  StreamSubscription<dynamic>? readResponseSubscription;

  late ChatService chatService;

  // 알림 설정
  void _initializeNotifications() {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = const DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _flutterLocalNotificationsPlugin!.initialize(initializationSettings);
  }

  @override
  void initState() {
    super.initState();
    chatService = ChatService();
    WidgetsBinding.instance.addObserver(this);
    ChatService.connectWebSocket();
    _initializeNotifications();

    _messageStreamSubscription =
        FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      //채팅에 대한 fcm인 경우
      if (message.data['chatContent'] != null &&
          message.data['roomId'] != null) {
        // 메시지 데이터 구조 로깅, 현재 시간도 같이 로그에 출력
        print(
            'Received 새로운 채팅에 대한 FCM with: ${message.data} at ${DateTime.now()}');
        //받은 fcm 저장하고 보여주기
        var newChat = MessageModel(
            type: message.data['type'],
            content: message.data['chatContent'],
            roomId: int.parse(message.data['roomId']),
            senderId: int.parse(message.data['senderId']),
            receiverId: int.parse(message.data['receiverId']),
            sendTime: message.data['sendTime'],
            isRead: true, // 수정 필요 (1)
            id: int.parse(message.data['chatId']));
        await SqlMessageRepository.create(newChat);
        await SqlMessageRepository.getList(widget.partner.roomId!, 0);
        setState(() {});

        //단일 읽음 처리
        ChatService.sendReadRequest(message);
      }
      //상대방이 읽었다는 것에 대한 fcm인 경우
      else if (message.data['chatId'] != null &&
          message.data['roomId'] != null) {
        print('Received FCM with: ${message.data} at ${DateTime.now()}');

        await SqlMessageRepository.update(
            widget.partner, int.parse(message.data['chatId']));
        setState(() {});
      }
      //상대방이 일괄 읽었다는 것에 대한 fcm인 경우
      else {
        print('Bulk Received FCM with: ${message.data} at ${DateTime.now()}'
            '${message.senderId}');

        await SqlMessageRepository.bulkUpdate(widget.partner);
        setState(() {});
      }
    });

    _unreadListFuc();
    _memoizer = AsyncMemoizer();
  }

  _unreadListFuc() async {
    List<MessageModel> unreadlist =
        await ChatService.getMessages(widget.partner.roomId, context);

    //1. 리스트 업데이트
    for (final message in unreadlist) {
      print(message.content);

      await SqlMessageRepository.create(message);
    }
    setState(() {});
  }

  /*
 
    채팅 내역 화면에 보여주기
  
  */
  Future<List<MessageModel>> _loadChatList() async {
    return await SqlMessageRepository.getList(widget.partner.roomId!, 0);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // 앱이 포그라운드로 전환될 때
      ChatService.connectWebSocket();
    } else if (state == AppLifecycleState.paused) {
      // 앱이 백그라운드로 전환될 때
      ChatService.disconnectWebSocket();
    }
  }

  @override
  void dispose() {
    super.dispose();
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
      'chatType': 0,
      'chatContent': _newMessage,
      'roomId': widget.partner.roomId,
      'senderId': 0,
      'senderName': widget.memberDetails.name,
      'receiverId': widget.partner.memberId,
      'sendTime': DateTime.now().toString(),
    };
    ChatService.sendMessage(request);
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
      'senderId': 0,
      'senderName': widget.memberDetails.name,
      'receiverId': widget.partner.memberId,
      'sendTime': DateTime.now().toString(),
    };
    ChatService.sendVSMessage(request);
    updateUi();
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
          } else {
            return Future.value(true);
          }
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
                  widget.partner.profileImage == null
                      ? Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: IconButton(
                            icon: SvgPicture.asset(
                              'assets/icon/icon_profile.svg',
                              color: const Color(0xff7898ff),
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
                        )
                      : InkWell(
                          onTap: () {
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
                                    image: NetworkImage(
                                        widget.partner.profileImage!))),
                          ),
                        ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.partner.name}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${widget.partner.nationality}',
                        style: const TextStyle(
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
                        builder: (builder) => ChatDialog(
                              partner: widget.partner,
                              context: context,
                            ));
                  },
                  //아이콘 수정 필요
                  icon: SvgPicture.asset(
                    'assets/icon/ICON_more.svg',
                    height: 20,
                  ),
                )
              ],
            ),
            body: widget.partner.roomState == 'OPEN'
                ? Column(children: [
                    Expanded(
                        child: Container(
                            padding: const EdgeInsets.only(top: 15),
                            color: const Color(0xffF5F7FF),
                            child: FutureBuilder<List<MessageModel>>(
                                future: _loadChatList(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return Center(
                                      child: Text('${snapshot.error}'),
                                    );
                                  }
                                  if (snapshot.hasData) {
                                    _list = snapshot.data!;
                                    var datas = snapshot.data;

                                    WidgetsBinding.instance
                                        .addPostFrameCallback((timeStamp) {
                                      _scrollController.animateTo(
                                          _scrollController
                                              .position.maxScrollExtent,
                                          duration:
                                              const Duration(milliseconds: 10),
                                          curve: Curves.easeIn);
                                    });

                                    return ListView(
                                      controller: _scrollController,
                                      children:
                                          List.generate(datas!.length, (index) {
                                        final currentDate = DateTime.parse(
                                            datas[index].sendTime!);
                                        String? nextTime = index ==
                                                datas.length - 1
                                            ? null
                                            : DateFormat('yyyy-MM-dd HH:mm:ss')
                                                .format(DateTime.parse(
                                                    datas[index + 1]
                                                        .sendTime!));
                                        String? currentTime =
                                            DateFormat('yyyy-MM-dd HH:mm:ss')
                                                .format(DateTime.parse(
                                                    datas[index].sendTime!));
                                        bool nextDiff = nextTime == null
                                            ? false
                                            : DateTime.parse(nextTime)
                                                    .difference(DateTime.parse(
                                                        currentTime))
                                                    .inMinutes >
                                                1;

                                        bool _showingTime(index) {
                                          //마지막 채팅인 경우 true
                                          if (index == datas.length - 1) {
                                            return true;
                                          }
                                          //다음 말풍선이 본인이 아니면 true
                                          else if (datas[index + 1].senderId !=
                                              datas[index].senderId) {
                                            return true;
                                          }
                                          //다음 말풍선 시간이랑 차이가 있으면 true
                                          else if (nextDiff) {
                                            return true;
                                          } else {
                                            return false;
                                          }
                                        }

                                        bool _showingPic(index) {
                                          if (index == 0) {
                                            return true;
                                          } else if (datas[index].senderId !=
                                              datas[index - 1].senderId) {
                                            return true;
                                          }
                                          if (index == datas.length - 1) {
                                            return false;
                                          } else if (nextDiff &&
                                              datas[index].senderId ==
                                                  datas[index + 1].senderId) {
                                            return true;
                                          } else {
                                            return false;
                                          }
                                        }

                                        return Column(
                                          children: [
                                            if (index == 0 ||
                                                currentDate.year !=
                                                    DateTime.parse(
                                                            datas[index - 1]
                                                                .sendTime!)
                                                        .year ||
                                                currentDate.month !=
                                                    DateTime.parse(
                                                            datas[index - 1]
                                                                .sendTime!)
                                                        .month ||
                                                currentDate.day !=
                                                    DateTime.parse(
                                                            datas[index - 1]
                                                                .sendTime!)
                                                        .day)
                                              _timeBubble(index,
                                                  currentDate.toString()),
                                            MessageBubble(
                                                message: MessageModel(
                                                    id: datas[index].id,
                                                    type: datas[index].type,
                                                    content:
                                                        datas[index].content,
                                                    roomId: datas[index].roomId,
                                                    senderId:
                                                        datas[index].senderId,
                                                    receiverId:
                                                        datas[index].receiverId,
                                                    sendTime:
                                                        datas[index].sendTime,
                                                    isRead:
                                                        datas[index].isRead),
                                                memberDetails:
                                                    widget.memberDetails,
                                                showingTime:
                                                    _showingTime(index),
                                                showingPic: _showingPic(index))
                                          ],
                                        );
                                      }),
                                    );
                                  } else {
                                    return const Center(
                                        child: Text('저장된 메세지 없음'));
                                  }
                                }))),
                    Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 10,
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(
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
                                        color: const Color(0xffFAFAFA),
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(
                                          color: const Color(0xffC9C9C9),
                                          width: 1,
                                        )),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: TextField(
                                          decoration: const InputDecoration(
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
                                              : sendMessage,
                                          icon: SvgPicture.asset(
                                            'assets/icon/ICON_send.svg',
                                            height: 22,
                                            color: const Color(0xff7898ff),
                                          ),
                                        ),
                                      ],
                                    )),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: isChecked
                              ? MediaQuery.of(context).size.height * .35
                              : 0,
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
                                      'assets/character/vsGame_button.png'),
                                ),
                              ),
                              Text(
                                'chatting4'.tr(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Color(0xff888888),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ])
                : Container(
                    alignment: Alignment.center,
                    color: const Color(0xffF5F7FF),
                    child: Text(
                      'chatting2'.tr(),
                      style: const TextStyle(color: Color(0xff888888)),
                    ),
                  )),
      ),
    );
  }

  Widget _timeBubble(int index, String date) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xff9B9B9B),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          margin: const EdgeInsets.only(top: 20, bottom: 15),
          child: Text(
            DateFormat('yyyy/MM/dd').format(DateTime.parse(date)),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        if (index == 0)
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Text(
              'chatting3'.tr(),
              style: const TextStyle(color: Color(0xff717171), fontSize: 12),
            ),
          )
      ],
    );
  }
}
