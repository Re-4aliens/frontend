import 'package:aliens/models/screenArgument.dart';
import 'package:aliens/views/components/message_bubble_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../models/message_model.dart';

List<MessageModel> _list = [
];

var channel;

class ChattingPage extends StatefulWidget {
  const ChattingPage(
      {super.key, required this.screenArguments, required this.memberIndex});

  final ScreenArguments screenArguments;
  final int memberIndex;

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> {
  final _controller = TextEditingController();
  var _newMessage = '';
  bool isLoading = true;
  bool isKeypadUp = false;
/*
  //키패드가 업되어있는 상태면
  void _sendMessage() {
    setState(() {
      FocusScope.of(context).unfocus();
      _list.add(
        MessageModel(
            roomId: 1,
            receiverId:
            widget.screenArguments.partners['partners']
            [widget.memberIndex]['name'],
            senderId: widget.screenArguments.applicant['email'],
            message: _newMessage,
            messageCategory: 'NORMAL_MESSAGE,'),
      );

      //데이터 베이스에 추가 SET
      //channel.sink.add(_newMessage);
      //텍스트폼 비우기
      _controller.clear();
      _newMessage = '';
    });
  }


 */
  @override
  void initState() {
    super.initState();
    final wsUrl = Uri.parse('');
    //channel = IOWebSocketChannel.connect(wsUrl);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //channel.sink.close();
  }

  //랜덤채팅 바 보여주기
  var isChecked = false;

  @override
  Widget build(BuildContext context) {
    //final arguments = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    bool isKeyboardOpen = false;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      /*
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
                    onPressed: (){
                      showDialog(
                          context: context,
                          builder: (_) => Scaffold(
                            backgroundColor: Colors.transparent,
                            body: Center(
                              child: Container(
                                width: 340,
                                height: 275,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      bottom: 0,
                                      child: Container(
                                        width: 340,
                                        height: 225,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(20),
                                          color: Colors.white,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                GestureDetector(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(15.0),
                                                    child: Icon(Icons.close),
                                                  ),
                                                  onTap: (){
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            ),
                                            Text(
                                              '${widget.screenArguments.partners['partners']
                                              [widget.memberIndex]['name']}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 36,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(15),
                                              child: Text(
                                                '안녕하세요! 경영학과 23학번 입니다!',
                                                style: TextStyle(
                                                  color: Color(0xff888888),
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Color(0xffF1F1F1),
                                                borderRadius:
                                                BorderRadius.circular(20),
                                              ),
                                              padding: EdgeInsets.only(
                                                  top: 5,
                                                  bottom: 5,
                                                  left: 15,
                                                  right: 20),
                                              child: Stack(
                                                children: [
                                                  Text(
                                                    '       ${widget.screenArguments.partners['partners']
                                                    [widget.memberIndex]['nationality']}, ${widget.screenArguments.partners['partners']
                                                    [widget.memberIndex]['mbti']}',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color:
                                                        Color(0xff616161)),
                                                  ),
                                                  Positioned(
                                                    left: 0,
                                                    top: 0,
                                                    bottom: 0,
                                                    child: SvgPicture.asset(
                                                      'assets/flag/${widget.screenArguments.partners['partners']
                                                      [widget.memberIndex]['nationality']}.svg',
                                                      width: 20,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 30,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 340,
                                      height: 105,
                                      child: Stack(
                                        children: [
                                          Align(
                                            alignment: Alignment.topCenter,
                                            child: Container(
                                              width: 100,
                                              height: 100,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(100),
                                                  color: Colors.white),
                                              padding: EdgeInsets.all(5),
                                              child: SvgPicture.asset(
                                                'assets/icon/icon_profile.svg',
                                                color: Color(0xffEBEBEB),
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Container(
                                              height: 20,
                                              width: 20,
                                              child: Icon(
                                                widget.screenArguments.partners['partners']
                                                [widget.memberIndex]['gender'] == 'MALE' ? Icons.male_rounded : Icons.female_rounded,
                                                size: 15,
                                                color: Color(0xff7898ff),
                                              ),
                                              decoration: BoxDecoration(
                                                color: Color(0xffebebeb),
                                                borderRadius:
                                                BorderRadius.circular(10),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ));
                    },
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.screenArguments.partners['partners']
                      [widget.memberIndex]['name'],
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.screenArguments.partners['partners']
                      [widget.memberIndex]['nationality'],
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
                      builder: (builder) => CupertinoAlertDialog(
                        actions: [
                          TextButton(onPressed: () {}, child: Text('신고하기')),
                          TextButton(onPressed: () {}, child: Text('차단하기')),
                        ],
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
                  child: StreamBuilder(
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                        case ConnectionState.active:
                        case ConnectionState.done:



                          if (_list.isNotEmpty) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: ListView.builder(
                                  itemCount: _list.length,
                                  itemBuilder: (context, index) {
                                    return MessageBuble(
                                      message: _list[index],
                                      applicant: widget.screenArguments.applicant,
                                    );
                                  }),
                            );
                          } else {
                            return Center(
                              child: Text('start chat'),
                            );
                          }
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
                                roomId: 1,
                                receiverId:
                                widget.screenArguments.partners['partners']
                                [widget.memberIndex]['name'],
                                senderId: widget.screenArguments.applicant['email'],
                                message: '밸런스 게임',
                                messageCategory: 'VS_GAME_MESSAGE'),
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

       */
    );
  }
}
