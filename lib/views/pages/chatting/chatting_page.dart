import 'package:aliens/views/components/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../providers/redis_provider.dart';
import 'package:provider/provider.dart';
import 'package:redis/redis.dart';

List<Map<String, dynamic>> chatList = [
  {'text': 'hi', 'time': ''}
];

class ChattingPage extends StatefulWidget {
  const ChattingPage({super.key});

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> {
  final _controller = TextEditingController();
  var _newMessage = '';
  bool isLoading = true;

  //Redis 연결에 필요한 변수들
  RedisConnection redis = RedisConnection();
  late PubSub pubsub; //메세지 발송에 필요한 것
  late Command cmd;

  void _sendMessage() {
    setState(() {
      FocusScope.of(context).unfocus();
      //데이터 베이스에 추가 SET
      RedisConnection().connect('localhost', 6379)
      .then((value){
        value.send_object(["SET",'text', _newMessage]);
      }

      );
      _controller.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  //실행 시 redis 연결
  _init() async {
    try {
      //서버 주소와 포트 번호로 연결
      //cmd = await redis.connect('localhost', 6379);
      pubsub = PubSub(cmd);
      //채널과 연결
      //pubsub.subscribe(['message-channel']);
    } catch (e) {
      print('에러');
      print(e);
    }

    //불러왔으면 로딩 끝
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          appBar: AppBar(),
          title: '',
          onPressed: () {},
        ),
        body: isLoading
            ? Container(
                child: CircularProgressIndicator(),
              )
            : StreamBuilder(
                stream: pubsub.getStream(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData == false) {
                    //로딩 화면으로 수정
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    //오류가 생기면 보여줄 위젯
                    //미정
                    return Container();
                  } else {
                    //final chatDocs = snapshot.data!.docs;
                    /*
                    String data = await cmd.send_object(["GET", 'text'])
                    .then((var response) => response.toString());

                     */
                    final message = snapshot.data.first;
                    return Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                          ),
                          child: Column(children: [
                            Expanded(
                              child: ListView.builder(
                                  reverse: true,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, index) {
                                    return Text(snapshot.data.toString());
                                  }),
                            ),
                            /// Newmassage
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.grey,
                              ),
                              child: Row(
                                children: [
                                  Expanded(child: TextField(
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
                                      icon: Icon(Icons.send))
                                ],
                              ),
                            ),
                          ]),
                        );
                  }
                },
              ));
    //var redisData = Provider.of<RedisProvider>(context, listen: false);
  }
}
