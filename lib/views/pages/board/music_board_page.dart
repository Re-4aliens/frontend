import 'dart:async';

import 'package:aliens/mockdatas/board_mockdata.dart';
import 'package:aliens/models/chatRoom_model.dart';
import 'package:aliens/models/screenArgument.dart';
import 'package:aliens/repository/sql_message_database.dart';
import 'package:aliens/views/pages/chatting/chatting_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../components/board_drawer_widget.dart';
import 'article_page.dart';


class MusicBoardPage extends StatefulWidget {
  const MusicBoardPage({super.key, required this.screenArguments});
  final ScreenArguments screenArguments;


  @override
  State<StatefulWidget> createState() => _MusicBoardPageState();
}

class _MusicBoardPageState extends State<MusicBoardPage> {
  bool isDrawerStart = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            '음악 게시판',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          toolbarHeight: 56,
          elevation: 0,
          shadowColor: Colors.black26,
          backgroundColor: Color(0xff7898ff),
          leadingWidth: 100,
          leading: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: SvgPicture.asset(
                      'assets/icon/icon_back.svg',
                      color: Colors.white,
                      width: 24,
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isDrawerStart = !isDrawerStart;
                      });
                    },
                    icon: Icon(Icons.format_list_bulleted_outlined),
                    color: Colors.white,
                  ),
                ],
              )
            ],
          ),
          actions: [
            IconButton(onPressed: (){}, icon: Icon(Icons.notifications_none)),
            IconButton(onPressed: (){}, icon: Icon(Icons.search)),
          ],
        ),
        body: isDrawerStart ? BoardDrawerWidget(screenArguments: widget.screenArguments, isTotalBoard: false,) :Container(
          decoration: BoxDecoration(color: Colors.white),
          child: ListView.builder(
              itemCount: musicBoardList.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      //제목
                      title: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: SvgPicture.asset(
                              'assets/icon/icon_profile.svg',
                              width: 35,
                              color: Color(0xff7898ff),
                            ),
                          ),
                          Text(
                            '${musicBoardList[index].member!.nickname}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          Text(
                            '/',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          Text(
                            'KR',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          )
                        ],
                      ),

                      //내용
                      subtitle: Container(
                        padding: EdgeInsets.only(left: 15, bottom: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            musicBoardList[index].imageUrls == null ?
                            SizedBox():
                            Container(
                              height: 100,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: musicBoardList[index].imageUrls!.length,
                                  itemBuilder: (context, index){
                                    return Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(right: 10),
                                          height: 80,
                                          width: 80,
                                          decoration: BoxDecoration(
                                              color: Color(0xfff8f8f8),
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: Icon(Icons.add_photo_alternate_outlined),
                                        ),
                                      ],
                                    );
                                  }),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10, bottom: 25.0),
                              child: Text('${musicBoardList[index].title}', style: TextStyle(fontSize: 16),),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Icon(
                                    Icons.thumb_up_alt_sharp,
                                    color: Color(0xffc1c1c1),
                                    size: 20,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 4, right: 15),
                                  child: musicBoardList[index].likeCount == 0
                                      ? Text('')
                                      : Text(
                                      '${musicBoardList[index].likeCount}'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Icon(
                                    Icons.chat_bubble,
                                    color: Color(0xffc1c1c1),
                                    size: 20,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                      '${musicBoardList[index].commentCount}'),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),

                      //더보기
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '1분 전',
                            style: TextStyle(
                                fontSize: 16, color: Color(0xffc1c1c1)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child:
                            Icon(Icons.more_vert, color: Color(0xffc1c1c1)),
                          )
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ArticlePage(board: musicBoardList[index], boardCategory: "자유게시판")),

                        );
                      },
                    ),
                    Divider(
                      thickness: 2,
                      color: Color(0xffE5EBFF),
                    )
                  ],
                );
              }),
        ));
  }
}
