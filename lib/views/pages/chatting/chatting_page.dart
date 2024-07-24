import 'dart:async';
import 'dart:collection';
import 'dart:math';
import 'package:aliens/services/chat_service.dart';
import 'package:aliens/views/components/chat_dialog_widget.dart';
import 'package:aliens/views/components/message_bubble_widget.dart';
import 'package:aliens/views/components/profile_dialog_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../models/message_model.dart';
import '../../../models/partner_model.dart';
import '../../../models/vs_game.dart';

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
  Queue<MessageModel> messageDeque =
      DoubleLinkedQueue(); // 메시지를 시간순대로 정렬하여 화면에 출력할 deque
  StreamSubscription<MessageModel>? messageSubscription;
  StreamSubscription<int>? readReceiptSubscription;
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  bool isFetchingMore = false;

  late ChatService chatService;

  final TextEditingController _controller = TextEditingController();
  bool isChecked = false;
  String _newMessage = '';

  Set<String> unreadMessagesByOthers = {}; // 다른 사용자(상대방)가 읽은 않은 메시지 ID
  Map<String, MessageModel> messageMap = {}; // UUID를 키로 사용하는 Map (순서 x)

  // 웹소켓 초기화
  void initializeWebSocket() {
    ChatService.connectWebSocket().then((_) {
      ChatService.subscribeWebSocket(widget.partner.roomId!);
    });

    // 메시지 수신
    messageSubscription =
        ChatService.messageStream.listen((MessageModel message) {
      setState(() {
        String messageId = DataUtils.makeUUID();
        messageDeque.addLast(message);
        messageMap[messageId] = message;
        _sendReadReceipt(message);
        if (!message.isRead!) {
          if (message.senderId != widget.partner.memberId) {
            unreadMessagesByOthers.add(messageId);
          }
        }
      });
    });

    // 읽음 처리 수신
    readReceiptSubscription =
        ChatService.readReceiptStream.listen((int readBy) {
      setState(() {
        List<String> readMessages = unreadMessagesByOthers
            .where((messageId) => messageMap[messageId]?.senderId == readBy)
            .toList();

        for (var messageId in readMessages) {
          messageMap[messageId]?.isRead = true;
        }

        unreadMessagesByOthers.removeAll(readMessages);
      });
    });
  }

  Future<void> _fetchInitialMessages() async {
    setState(() {
      isLoading = true;
    });
    List<MessageModel> initialMessages =
        await ChatService.getMessages(widget.partner.roomId);
    initialMessages.sort((a, b) => a.sendTime!.compareTo(b.sendTime!));
    setState(() {
      for (var message in initialMessages) {
        String messageId = DataUtils.makeUUID(); // UUID 생성
        messageDeque.addLast(message);
        messageMap[messageId] = message;
        if (message.receiverId == widget.partner.memberId &&
            message.isRead == false) {
          unreadMessagesByOthers.add(messageId);
        }
      }
      isLoading = false;
    });
    _sendBulkReadReceipt(initialMessages);
  }

  Future<void> _fetchMoreMessages() async {
    if (messageDeque.isEmpty || isFetchingMore) return;

    setState(() {
      isFetchingMore = true;
    });

    List<MessageModel> moreMessages = await ChatService.getMessages(
      widget.partner.roomId,
    );

    moreMessages.sort((a, b) => a.sendTime!.compareTo(b.sendTime!));
    setState(() {
      for (var message in moreMessages.reversed) {
        String messageId = DataUtils.makeUUID(); // UUID 생성
        messageDeque.addFirst(message);
        messageMap[messageId] = message;
        if (message.receiverId == widget.partner.memberId &&
            message.isRead == false) {
          unreadMessagesByOthers.add(messageId);
        }
      }
      isFetchingMore = false;
    });
  }

  void _sendReadReceipt(MessageModel message) {
    if (message.receiverId == widget.partner.memberId && !message.isRead!) {
      ChatService.sendReadRequest(message.roomId!, message.senderId!);
      setState(() {
        message.isRead = true;
      });
    }
  }

  void _sendBulkReadReceipt(List<MessageModel> messages) {
    for (var message in messages) {
      _sendReadReceipt(message);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _fetchInitialMessages();
      initializeWebSocket();
    } else if (state == AppLifecycleState.paused) {
      ChatService.disconnectWebSocket();
      messageSubscription?.cancel();
      readReceiptSubscription?.cancel();
    }
  }

  @override
  void initState() {
    super.initState();
    chatService = ChatService();
    WidgetsBinding.instance.addObserver(this);

    _fetchInitialMessages();
    initializeWebSocket();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == 0 && !isFetchingMore) {
        _fetchMoreMessages();
      }
    });
  }

  @override
  void dispose() {
    ChatService.disconnectWebSocket();
    messageSubscription?.cancel();
    readReceiptSubscription?.cancel();
    _scrollController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void sendMessage() async {
    Map<String, dynamic> request = {
      'type': 'NORMAL',
      'content': _newMessage,
      'roomId': widget.partner.roomId,
      'senderId': 0,
      'receiverId': widget.partner.memberId,
    };

    MessageModel message = MessageModel.fromJson(request);

    ChatService.sendMessage(message);
    updateUi();
  }

  void sendVSMessage() async {
    // 랜덤 인덱스 생성
    Random random = Random();
    int randomIndex = random.nextInt(vsGames.length);

    Map<String, dynamic> request = {
      'type': 'BALANCE_GAME',
      'content': vsGames[randomIndex]['question'],
      'roomId': widget.partner.roomId,
      'senderId': 0,
      'receiverId': widget.partner.memberId,
    };

    MessageModel message = MessageModel.fromJson(request);
    ChatService.sendMessage(message);
    updateUi();
  }

  void updateUi() {
    // 텍스트 폼 비우기
    setState(() {
      _controller.clear();
      _newMessage = '';
    });
  }

  bool _showingTime(index, datas, nextDiff) {
    //마지막 채팅인 경우 true
    if (index == datas.length - 1) {
      return true;
    }
    //다음 말풍선이 본인이 아니면 true
    else if (datas[index + 1].senderId != datas[index].senderId) {
      return true;
    }
    //다음 말풍선 시간이랑 차이가 있으면 true
    else if (nextDiff) {
      return true;
    } else {
      return false;
    }
  }

  bool _showingPic(index, datas, nextDiff) {
    if (index == 0) {
      return true;
    } else if (datas[index].senderId != datas[index - 1].senderId) {
      return true;
    }
    if (index == datas.length - 1) {
      return false;
    } else if (nextDiff && datas[index].senderId == datas[index + 1].senderId) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (isChecked) {
            setState(() {
              isChecked = false;
            });
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
                  showDialog(
                      context: context,
                      builder: (builder) => ChatDialog(
                            partner: widget.partner,
                            context: context,
                          ));
                },
                icon: SvgPicture.asset(
                  'assets/icon/ICON_more.svg',
                  height: 20,
                ),
              )
            ],
          ),
          body: widget.partner.roomState == 'OPEN'
              ? Column(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(top: 15),
                        color: const Color(0xffF5F7FF),
                        child: StreamBuilder<List<MessageModel>>(
                          stream: ChatService.messageStream.map((message) {
                            messageDeque.add(message);
                            return messageDeque.toList();
                          }),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Center(
                                child: Text('${snapshot.error}'),
                              );
                            }
                            if (snapshot.hasData) {
                              var datas = snapshot.data!;
                              WidgetsBinding.instance
                                  .addPostFrameCallback((timeStamp) {
                                _scrollController.animateTo(
                                    _scrollController.position.maxScrollExtent,
                                    duration: const Duration(milliseconds: 10),
                                    curve: Curves.easeIn);
                              });

                              return ListView.builder(
                                controller: _scrollController,
                                itemCount: datas.length,
                                itemBuilder: (context, index) {
                                  final currentDate =
                                      DateTime.parse(datas[index].sendTime!);
                                  String? nextTime = index == datas.length - 1
                                      ? null
                                      : DateFormat('yyyy-MM-dd HH:mm:ss')
                                          .format(DateTime.parse(
                                              datas[index + 1].sendTime!));
                                  String? currentTime =
                                      DateFormat('yyyy-MM-dd HH:mm:ss').format(
                                          DateTime.parse(
                                              datas[index].sendTime!));
                                  bool nextDiff = nextTime == null
                                      ? false
                                      : DateTime.parse(nextTime)
                                              .difference(
                                                  DateTime.parse(currentTime))
                                              .inMinutes >
                                          1;

                                  return Column(
                                    children: [
                                      if (index == 0 ||
                                          currentDate.year !=
                                              DateTime.parse(datas[index - 1]
                                                      .sendTime!)
                                                  .year ||
                                          currentDate.month !=
                                              DateTime.parse(datas[index - 1]
                                                      .sendTime!)
                                                  .month ||
                                          currentDate.day !=
                                              DateTime.parse(datas[index - 1]
                                                      .sendTime!)
                                                  .day)
                                        _timeBubble(
                                            index, currentDate.toString()),
                                      MessageBubble(
                                          message: MessageModel(
                                              id: datas[index].id,
                                              type: datas[index].type,
                                              content: datas[index].content,
                                              roomId: datas[index].roomId,
                                              senderId: datas[index].senderId,
                                              receiverId:
                                                  datas[index].receiverId,
                                              sendTime: datas[index].sendTime,
                                              isRead: datas[index].isRead),
                                          showingTime: _showingTime(
                                              index, datas, nextDiff),
                                          showingPic: _showingPic(
                                              index, datas, nextDiff))
                                    ],
                                  );
                                },
                              );
                            } else {
                              return const Center(child: Text('저장된 메세지 없음'));
                            }
                          },
                        ),
                      ),
                    ),
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
                                    isChecked = !isChecked;
                                    FocusScope.of(context).unfocus();
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
                  ],
                )
              : Container(
                  alignment: Alignment.center,
                  color: const Color(0xffF5F7FF),
                  child: Text(
                    'chatting2'.tr(),
                    style: const TextStyle(color: Color(0xff888888)),
                  ),
                ),
        ),
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
