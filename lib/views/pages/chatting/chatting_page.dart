import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../../providers/chatting_provider.dart';

List<Map<String, dynamic>> chatList = [
  {'text': 'hi', 'time': '17:26pm'}
];

var channel;

class ChattingPage extends StatefulWidget {
  const ChattingPage({super.key});

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> {
  final _controller = TextEditingController();
  var _newMessage = '';
  bool isLoading = true;
  bool isKeypadUp = false;

  //키패드가 업되어있는 상태면
  void _sendMessage() {
    setState(() {
      FocusScope.of(context).unfocus();

      chatList.add({
        'text': _newMessage,
        'time': '17:26 pm',
      });
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
    dynamic partner = ModalRoute.of(context)!.settings.arguments;
    bool isKeyboardOpen = false;

    return Scaffold(
      resizeToAvoidBottomInset: !isChecked,
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
              child: SvgPicture.asset(
                'assets/icon/icon_profile.svg',
                height: 35,
                color: Color(0xff7898ff),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  partner['name'],
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  partner['nationality'],
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
      body: Container(
        color: Color(0xffF5F7FF),
        child: Column(children: [
          Expanded(
              child:
                  /*
            StreamBuilder(
              stream: channel.stream,
              builder: (context, snapshot){
                //데이터를 받아오기 전 보여줄 위젯
                if (snapshot.hasData == false) {
                  //로딩 화면으로 수정
                  return Center(child: CircularProgressIndicator());
                }
                //오류가 생기면 보여줄 위젯
                else if (snapshot.hasError) {
                  //오류가 생기면 보여줄 위젯
                  return Container();
                }else{
                  return
                  */
                  ListView.builder(
                      reverse: true,
                      itemCount: chatList.length,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 30),
                              child: SvgPicture.asset(
                                'assets/icon/icon_profile.svg',
                                height: 40,
                                color: Color(0xff7898ff),
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: 270, // 최대 너비 지정
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(30),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 5,
                                              spreadRadius: 0.5,
                                              offset: const Offset(0, 3))
                                        ]),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 18),
                                    margin: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    child: Text(
                                      '${chatList[index]['text']}',
                                      style: TextStyle(
                                        color: Color(0xff616161),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                    '${chatList[index]['time']}',
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      })
              //}
              //}
              //),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.add,
                      color: Color(0xff7898ff),
                      size: 30,),
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
                height: isChecked ? 340 : 0,
                alignment: Alignment.center,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: (){
                        setState(() {
                          isChecked = false;
                        });
                        print(MediaQuery.of(context).viewInsets.bottom);
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
                              color: Colors.black.withOpacity(0.1)
                            )
                          ]
                        ),
                        alignment: Alignment.center,
                        child: Text('밸런스게임'),
                        margin: EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                    Text('밸런스게임\n제안하기',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xff888888),
                      fontWeight: FontWeight.bold,
                      fontSize: 14
                    ),),
                  ],
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
