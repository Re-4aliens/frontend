import 'package:aliens/models/applicant_model.dart';
import 'package:aliens/models/memberDetails_model.dart';
import 'package:aliens/models/screenArgument.dart';
import 'package:aliens/views/components/message_bubble_widget.dart';
import 'package:aliens/views/components/profileDialog_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../apis.dart';
import '../../../models/chatRoom_model.dart';
import '../../../models/message_model.dart';
import '../../../models/partner_model.dart';


List<MessageModel> _list = [];
var channel;

class ChattingPage extends StatefulWidget {
  const ChattingPage(
      {super.key, required this.applicant, required this.partner, required this.chatRoom, required this.memberDetails});

  final Applicant? applicant;
  final Partner partner;
  final ChatRoom chatRoom;
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
  var itemLength = 1;

  void _sendMessage() {
    setState(() {
      FocusScope.of(context).unfocus();
      _list.add(
        MessageModel(
          chatId: _list.length,
          chatType: 0,
          chatContent: _newMessage,
            roomId: widget.chatRoom.roomId,
            senderId: widget.memberDetails.memberId,
            senderName: widget.memberDetails.name,
            receiverId: widget.partner.memberId,
            sendTime: DateTime.now().toString(),
            unReadCount: 1,
        ),
      );

      //데이터 베이스에 추가 SET
      //channel.sink.add(_newMessage);
      //텍스트폼 비우기
      _controller.clear();
      _newMessage = '';
    });
  }

  @override
  void initState() {
    super.initState();
    final wsUrl = Uri.parse('');

    _scrollController.addListener(() {
      scrollListener();
    });


    if(_list.isEmpty)
      _list.add(
        MessageModel(
            chatId: -1,
            chatType: -1,
            chatContent: '시작',
            roomId: widget.chatRoom.roomId,
            senderId: widget.memberDetails.memberId,
            senderName: widget.memberDetails.name,
            receiverId: widget.partner.memberId,
            sendTime: DateTime.now().toString(),
            unReadCount: 1,
        ),
      );
    //channel = IOWebSocketChannel.connect(wsUrl);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //channel.sink.close();

    _scrollController.dispose();
  }
  scrollListener() async {
    if (_scrollController.offset == _scrollController.position.maxScrollExtent
        && !_scrollController.position.outOfRange) {
      if(_list.last.chatId != 1){
        _list.insertAll(_list.length, await APIs.getPreviousMessages(_list.last.chatId!));
      }
      setState(() {
        itemLength = _list.length;
      });
    }
  }

  //랜덤채팅 바 보여주기
  var isChecked = false;

  @override
  Widget build(BuildContext context) {
    //final arguments = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    bool isKeyboardOpen = false;



    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (isChecked) {
            isChecked = false;
            return Future.value(false);
          } else
            return Future.value(false);
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
                                body: ProfileDialog(partner: widget.partner,),
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
                                  Text("어떤 서비스를 원하세요?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                                  Padding(
                                    padding: const EdgeInsets.all(25.0),
                                    child: Text("대화 상대방을 신고 또는 차단하고 싶다면 아래 버튼을 클릭해주세요.", textAlign: TextAlign.center, style: TextStyle(fontSize: 16,),),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(13),
                                    decoration: BoxDecoration(
                                      color: Color(0xff7898FF),
                                      borderRadius: BorderRadius.circular(5)
                                    ),
                                    alignment: Alignment.center,
                                    child: Text("신고하기", style: TextStyle(color: Colors.white),),
                                  ),
                                  SizedBox(height: 10,),
                                  Container(
                                    padding: EdgeInsets.all(13),
                                    decoration: BoxDecoration(
                                        color: Color(0xff7898FF),
                                        borderRadius: BorderRadius.circular(5)
                                    ),
                                    alignment: Alignment.center,
                                    child: Text("차단하기", style: TextStyle(color: Colors.white),),
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
              color: Color(0xffF5F7FF),
              child: FutureBuilder(
                future: APIs.getMessages(),
                builder: (context, snapshot) {
                  if(snapshot.hasData == false){
                    return Center(
                      child: Text('받아오는 중'),
                    );
                  }
                 else {
                   if(itemLength == 1){
                     _list = snapshot.data!;
                     itemLength = _list.length;
                   }
                   print('길이: ${itemLength}');
                        return Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: ListView.builder(
                            reverse: true,
                              controller: _scrollController,
                              itemCount: itemLength,
                              itemBuilder: (context, index) {
                                return MessageBubble(
                                  message: MessageModel(
                                    chatId: _list![index].chatId,
                                    chatType: _list![index].chatType,
                                    chatContent: _list![index].chatContent,
                                    roomId: _list![index].roomId,
                                    senderId: _list![index].senderId,
                                    receiverId: _list[index].receiverId,
                                    senderName: _list![index].senderName,
                                    sendTime: _list![index].sendTime,
                                    unReadCount: _list![index].unReadCount,
                                  ),
                                  applicant: widget.applicant,
                                  showingTime: index == 0,
                                  showingPic: _list!.length - 1 == index,
                                );
                              }),
                        );

                  }
                },
              ),
            )),
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
                                      : _sendMessage,
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
                          });
                          _list.add(
                            MessageModel(
                                chatId: _list.length,
                                chatType: 1,
                                chatContent: '밸런스 게임',
                                roomId: widget.chatRoom.roomId,
                                senderId: widget.memberDetails.memberId,
                                senderName: widget.memberDetails.name,
                                receiverId: widget.partner.memberId,
                                sendTime: DateTime.now().toString(),
                                unReadCount: 1,
                            ),
                          );
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
}
