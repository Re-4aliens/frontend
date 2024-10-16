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
import 'package:flutter/scheduler.dart';

class ChattingPage extends StatefulWidget {
  const ChattingPage({
    super.key,
    required this.partner,
    required this.memberId,
  });

  final Partner partner;
  final int memberId;

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
  bool _initialScrollCompleted = false; // 초기 스크롤 플래그 추가

  final TextEditingController _controller = TextEditingController();
  bool isChecked = false;
  String _newMessage = '';

  Set<String> unreadMessagesByMe = {}; // 내가 읽지 않은 상대방의 메시지
  Set<String> unreadMessagesByOthers = {}; // 다른 사람이 아직 읽지 않은 메시지 저장
  Map<String, MessageModel> messageMap = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _fetchInitialMessages();
    initializeWebSocket();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.minScrollExtent &&
          !isFetchingMore) {
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
    ChatService.connectWebSocket(
        widget.partner.chatRoomId ?? 0, widget.memberId);

    messageSubscription =
        ChatService.messageStream.listen((MessageModel message) {
      if (mounted) {
        ChatService.sendReadRequest(
            widget.partner.chatRoomId!, widget.memberId);
        setState(() {
          messageDeque.addLast(message); // 메시지를 순서대로 추가
          if (!message.isRead!) {
            if (message.senderId == widget.memberId) {
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
          if (readBy == widget.memberId) {
            List<String> readMessagesByMe = unreadMessagesByMe
                .where((messageId) =>
                    messageMap[messageId]?.receiverId == widget.memberId)
                .toList();

            for (var messageId in readMessagesByMe) {
              messageMap[messageId]?.isRead = true;
            }
            unreadMessagesByMe.removeAll(readMessagesByMe);
          } else if (readBy == widget.partner.partnerMemberId) {
            List<String> readMessagesByOthers = unreadMessagesByOthers
                .where((messageId) =>
                    messageMap[messageId]?.senderId ==
                    widget.partner.partnerMemberId)
                .toList();

            for (var messageId in readMessagesByOthers) {
              messageMap[messageId]?.isRead = true;
            }
            unreadMessagesByOthers.removeAll(readMessagesByOthers);
          }
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
          await ChatService.getMessages(widget.partner.chatRoomId!);

      initialMessages.sort((a, b) => a.sendTime!.compareTo(b.sendTime!));

      setState(() {
        for (var message in initialMessages) {
          messageDeque.addLast(message); // 메시지를 순서대로 추가
          if (message.senderId == widget.memberId && message.isRead == false) {
            unreadMessagesByOthers.add(message.id!);
          }
          if (message.receiverId == widget.memberId &&
              message.isRead == false) {
            unreadMessagesByMe.add(message.id!);
          }
        }
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients && !_initialScrollCompleted) {
      _initialScrollCompleted = true; // 스크롤 완료 상태로 설정
      _scrollController.jumpTo(
        _scrollController.position.maxScrollExtent,
      );
    }
  }

  Future<void> _fetchMoreMessages() async {
    if (messageDeque.isEmpty || isFetchingMore) return;

    setState(() {
      isFetchingMore = true;
    });

    try {
      List<MessageModel> moreMessages = await ChatService.getMessages(
        widget.partner.chatRoomId!,
      );

      moreMessages.sort((a, b) => a.sendTime!.compareTo(b.sendTime!));

      setState(() {
        for (var message in moreMessages.reversed) {
          messageDeque.addFirst(message); // 이전 메시지를 앞에 추가
          if (message.senderId == widget.memberId && message.isRead == false) {
            unreadMessagesByOthers.add(message.id!);
          }
        }
        isFetchingMore = false;
      });
    } catch (e) {
      setState(() {
        isFetchingMore = false;
      });
    }
  }

  void sendMessage() async {
    Map<String, dynamic> request = {
      'type': 'NORMAL',
      'content': _newMessage,
      'roomId': widget.partner.chatRoomId!,
      'senderId': widget.memberId,
      'receiverId': widget.partner.partnerMemberId,
    };

    MessageModel message = MessageModel.fromJson(request);

    ChatService.sendMessage(message);
    updateUi();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 100,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void sendVSMessage() async {
    Random random = Random();
    int randomIndex = random.nextInt(vsGames.length);

    Map<String, dynamic> request = {
      'type': 'BALANCE_GAME',
      'content': vsGames[randomIndex]['question'],
      'roomId': widget.partner.chatRoomId!,
      'senderId': widget.memberId,
      'receiverId': widget.partner.partnerMemberId,
    };

    MessageModel message = MessageModel.fromJson(request);
    ChatService.sendMessage(message);
    updateUi();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
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
            toolbarHeight: 70,
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
                widget.partner.profileImageUrl == null
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
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Container(
                            height: 38,
                            width: 38,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(
                                    widget.partner.profileImageUrl!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
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
          body: widget.partner.roomStatus != 'CLOSE'
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
                                      child: Text('저장된 메시지 없음'),
                                    );
                                  }
                                  var datas = snapshot.data!;

                                  // 스크롤 초기 하단 이동 처리
                                  SchedulerBinding.instance
                                      .addPostFrameCallback((_) {
                                    _scrollToBottom();
                                  });

                                  return ListView.builder(
                                    controller: _scrollController,
                                    itemCount: datas.length,
                                    itemBuilder: (context, index) {
                                      DateTime currentDate;
                                      try {
                                        currentDate =
                                            datas[index].sendTime != null
                                                ? DateTime.parse(
                                                    datas[index].sendTime!)
                                                : DateTime.now();
                                      } catch (e) {
                                        currentDate = DateTime.now();
                                      }

                                      DateTime? nextDate;
                                      if (index < datas.length - 1) {
                                        try {
                                          nextDate = datas[index + 1]
                                                      .sendTime !=
                                                  null
                                              ? DateTime.parse(
                                                  datas[index + 1].sendTime!)
                                              : DateTime.now();
                                        } catch (e) {
                                          nextDate = DateTime.now();
                                        }
                                      } else {
                                        nextDate = null;
                                      }

                                      bool nextDiff = nextDate == null
                                          ? false
                                          : nextDate
                                                  .difference(currentDate)
                                                  .inMinutes >
                                              1;

                                      return Column(
                                        children: [
                                          if (index == 0 ||
                                              currentDate.year !=
                                                  (datas[index - 1].sendTime != null
                                                          ? DateTime.parse(
                                                              datas[index - 1]
                                                                  .sendTime!)
                                                          : DateTime.now())
                                                      .year ||
                                              currentDate.month !=
                                                  (datas[index - 1].sendTime != null
                                                          ? DateTime.parse(
                                                              datas[index - 1]
                                                                  .sendTime!)
                                                          : DateTime.now())
                                                      .month ||
                                              currentDate.day !=
                                                  (datas[index - 1].sendTime !=
                                                              null
                                                          ? DateTime.parse(
                                                              datas[index - 1]
                                                                  .sendTime!)
                                                          : DateTime.now())
                                                      .day)
                                            _timeBubble(
                                                index, currentDate.toString()),
                                          MessageBubble(
                                            message: MessageModel(
                                                id: datas[index].id,
                                                type: datas[index].type,
                                                content: datas[index].content,
                                                roomId: datas[index].roomId!,
                                                senderId: datas[index].senderId,
                                                receiverId:
                                                    datas[index].receiverId,
                                                sendTime: datas[index].sendTime,
                                                isRead: datas[index].isRead),
                                            showingTime: _showingTime(
                                                index, datas, nextDiff),
                                            showingPic: _showingPic(
                                                index, datas, nextDiff),
                                            memberId: widget.memberId,
                                            partnerProfileImageUrl: widget
                                                    .partner.profileImageUrl ??
                                                "",
                                          )
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
                          padding: const EdgeInsets.only(
                            bottom: 20,
                            top: 10,
                            right: 10,
                            left: 10,
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
                                  height: 48,
                                  decoration: BoxDecoration(
                                      color: const Color(0xffFAFAFA),
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                        color: const Color(0xffC9C9C9),
                                        width: 1,
                                      )),
                                  padding: const EdgeInsets.only(
                                    left: 20,
                                    right: 10,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: TextField(
                                        expands: true,
                                        minLines: null,
                                        maxLines: null,
                                        style: const TextStyle(fontSize: 14),
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
                                  ),
                                ),
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
