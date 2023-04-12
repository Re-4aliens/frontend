import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../../providers/chatting_provider.dart';

List<Map<String, dynamic>> chatList = [
  {'text': 'hi', 'time': ''}
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

  void _sendMessage() {
    setState(() {
      FocusScope.of(context).unfocus();
      /*
      chatList.add({
        'text': _newMessage,
        'time': '',
      });*/
      //데이터 베이스에 추가 SET
      channel.sink.add(_newMessage);
      //텍스트폼 비우기
      _controller.clear();
      _newMessage = '';
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final wsUrl = Uri.parse('');
    channel = IOWebSocketChannel.connect(wsUrl);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    channel.sink.close();
  }

  //랜덤채팅 바 보여주기
  var isChecked = false;

  @override
  Widget build(BuildContext context) {
    dynamic chatName = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new),
          color: Colors.black,
        ),
        title: Row(
          children: [
            Text(
              '${chatName}',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(context: context, builder: (builder) => CupertinoAlertDialog(
                actions: [
                  TextButton(onPressed: (){}, child: Text('신고하기')),
                  TextButton(onPressed: (){}, child: Text('차단하기')),
                ],
              ));
            },
            //아이콘 수정 필요
            icon: Icon(CupertinoIcons.bars),
            color: Colors.black,
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
        ),
        child: Column(children: [
          Expanded(
            child: StreamBuilder(
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
                  return ListView.builder(
                      reverse: true,
                      itemCount: chatList.length,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Icon(
                                Icons.account_circle,
                                color: Color(0xFFA8A8A8),
                                size: 35,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(120)),
                              width: 145,
                              padding:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                              margin:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                              child: Text('${snapshot.data}'),
                            ),
                          ],
                        );
                      });
                }
              }
            ),
          ),

          isChecked?
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            //height: MediaQuery.of(context).viewInsets.bottom,
            height: MediaQuery.of(context).size.height/3,
            alignment: Alignment.center,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          FocusScope.of(context).unfocus();
                          isChecked = false;
                        });
                      },
                    ),
                    Expanded(
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(360),
                              border: Border.all(
                                color: Colors.grey,
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
                                    ),
                                  ),
                              IconButton(
                                onPressed:
                                _newMessage.trim().isEmpty ? null : _sendMessage,
                                icon: Icon(Icons.send),
                              ),
                            ],
                          )),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                InkWell(
                  onTap: (){
                    setState(() {
                      isChecked = false;
                    });
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.grey.shade200
                    ),
                    alignment: Alignment.center,
                    child: Text('랜덤게임\n제안하기'),
                  ),
                )
              ],
            )
          ):
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
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      isChecked = true;
                    });
                  },
                ),
                Expanded(
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(360),
                          border: Border.all(
                            color: Colors.grey,
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
                            onPressed:
                            _newMessage.trim().isEmpty ? null : _sendMessage,
                            icon: Icon(Icons.send),
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
        ]),
      ),
    );
  }
}
