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
  Queue<MessageModel> messageDeque = DoubleLinkedQueue();
  StreamSubscription<MessageModel>? messageSubscription;
  StreamSubscription<int>? readReceiptSubscription;
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  bool isFetchingMore = false;

  final TextEditingController _controller = TextEditingController();
  bool isChecked = false;
  String _newMessage = '';

  Set<String> unreadMessagesByOthers = {};
  Map<String, MessageModel> messageMap = {};

  @override
  void initState() {
    super.initState();
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

  void initializeWebSocket() {
    ChatService.connectWebSocket(widget.partner.roomId! + 98);

    messageSubscription =
        ChatService.messageStream.listen((MessageModel message) {
      if (mounted) {
        setState(() {
          messageDeque.addLast(message);
          _sendReadReceipt(message);
          if (!message.isRead!) {
            if (message.senderId != widget.partner.memberId) {
              unreadMessagesByOthers.add(message.id!);
            }
          }
        });
      }
    });

    readReceiptSubscription =
        ChatService.readReceiptStream.listen((int readBy) {
      if (mounted) {
        setState(() {
          List<String> readMessages = unreadMessagesByOthers
              .where((messageId) => messageMap[messageId]?.senderId == readBy)
              .toList();

          for (var messageId in readMessages) {
            messageMap[messageId]?.isRead = true;
          }

          unreadMessagesByOthers.removeAll(readMessages);
        });
      }
    });
  }

  Future<void> _fetchInitialMessages() async {
    setState(() {
      isLoading = true;
    });

    try {
      List<MessageModel> initialMessages =
          await ChatService.getMessages(widget.partner.roomId! + 98);

      initialMessages.sort((a, b) => a.sendTime!.compareTo(b.sendTime!));

      setState(() {
        for (var message in initialMessages) {
          messageDeque.addLast(message);
          if (message.receiverId == widget.partner.memberId &&
              message.isRead == false) {
            unreadMessagesByOthers.add(message.id!);
          }
        }
        isLoading = false;
      });

      _sendBulkReadReceipt(initialMessages);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // 오류 발생 시 에러 처리 로직 추가
      print('메시지 로드 중 오류 발생: $e');
    }
  }

  Future<void> _fetchMoreMessages() async {
    if (messageDeque.isEmpty || isFetchingMore) return;

    setState(() {
      isFetchingMore = true;
    });

    try {
      List<MessageModel> moreMessages = await ChatService.getMessages(
        widget.partner.roomId! + 98,
      );

      moreMessages.sort((a, b) => a.sendTime!.compareTo(b.sendTime!));

      setState(() {
        for (var message in moreMessages.reversed) {
          messageDeque.addFirst(message);
          if (message.receiverId == widget.partner.memberId &&
              message.isRead == false) {
            unreadMessagesByOthers.add(message.id!);
          }
        }
        isFetchingMore = false;
      });
    } catch (e) {
      setState(() {
        isFetchingMore = false;
      });
      // 오류 발생 시 에러 처리 로직 추가
      print('추가 메시지 로드 중 오류 발생: $e');
    }
  }

  void _sendReadReceipt(MessageModel message) {
    if (message.receiverId == widget.partner.memberId && !message.isRead!) {
      ChatService.sendReadRequest(message.roomId! + 98, message.senderId!);
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

  void sendMessage() async {
    Map<String, dynamic> request = {
      'type': 'NORMAL',
      'content': _newMessage,
      'roomId': widget.partner.roomId! + 98,
      'senderId': 0,
      'receiverId': widget.partner.memberId,
    };

    MessageModel message = MessageModel.fromJson(request);

    ChatService.sendMessage(message);
    setState(() {
      messageDeque.addLast(message); // 메시지를 전송한 후 즉시 화면에 반영
    });
    updateUi();
  }

  void sendVSMessage() async {
    Random random = Random();
    int randomIndex = random.nextInt(vsGames.length);

    Map<String, dynamic> request = {
      'type': 'BALANCE_GAME',
      'content': vsGames[randomIndex]['question'],
      'roomId': widget.partner.roomId! + 98,
      'senderId': 0,
      'receiverId': widget.partner.memberId,
    };

    MessageModel message = MessageModel.fromJson(request);
    ChatService.sendMessage(message);
    setState(() {
      messageDeque.addLast(message); // 메시지를 전송한 후 즉시 화면에 반영
    });
    updateUi();
  }

  void updateUi() {
    setState(() {
      _controller.clear();
      _newMessage = '';
    });
  }

  bool _showingTime(index, datas, nextDiff) {
    if (index == datas.length - 1) {
      return true;
    } else if (datas[index + 1].senderId != datas[index].senderId) {
      return true;
    } else if (nextDiff) {
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
                        child: isLoading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : StreamBuilder<List<MessageModel>>(
                                stream: Stream.periodic(
                                        const Duration(milliseconds: 100),
                                        (_) => messageDeque.toList())
                                    .asBroadcastStream(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return Center(
                                      child: Text('${snapshot.error}'),
                                    );
                                  }
                                  if (!snapshot.hasData ||
                                      snapshot.data!.isEmpty) {
                                    return const Center(
                                        child: Text('저장된 메시지 없음'));
                                  }
                                  var datas = snapshot.data!;
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((timeStamp) {
                                    _scrollController.animateTo(
                                        _scrollController
                                            .position.maxScrollExtent,
                                        duration:
                                            const Duration(milliseconds: 10),
                                        curve: Curves.easeIn);
                                  });

                                  return ListView.builder(
                                    controller: _scrollController,
                                    itemCount: datas.length,
                                    itemBuilder: (context, index) {
                                      final currentDate = DateTime.parse(
                                          datas[index].sendTime!);
                                      String? nextTime = index ==
                                              datas.length - 1
                                          ? null
                                          : DateFormat('yyyy-MM-dd HH:mm:ss')
                                              .format(DateTime.parse(
                                                  datas[index + 1].sendTime!));
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
                                            _timeBubble(
                                                index, currentDate.toString()),
                                          MessageBubble(
                                              message: MessageModel(
                                                  id: datas[index].id,
                                                  type: datas[index].type,
                                                  content: datas[index].content,
                                                  roomId:
                                                      datas[index].roomId! + 98,
                                                  senderId:
                                                      datas[index].senderId,
                                                  receiverId:
                                                      datas[index].receiverId,
                                                  sendTime:
                                                      datas[index].sendTime,
                                                  isRead: datas[index].isRead),
                                              showingTime: _showingTime(
                                                  index, datas, nextDiff),
                                              showingPic: _showingPic(
                                                  index, datas, nextDiff))
                                        ],
                                      );
                                    },
                                  );
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
