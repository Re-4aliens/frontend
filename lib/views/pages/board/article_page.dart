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

import '../../../mockdatas/comment_mockdata.dart';
import '../../../models/board_model.dart';
import '../../../models/countries.dart';
import 'package:flutter/services.dart';

class ArticlePage extends StatefulWidget {
  const ArticlePage(
      {super.key, required this.board});

  final Board board;

  @override
  State<StatefulWidget> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  final _controller = TextEditingController();
  var _newComment = '';

  @override
  Widget build(BuildContext context) {
    var nationCode = '';
    for (Map<String, String> country in countries) {
      if (country['name'] == widget.board.member!.nationality.toString()) {
        nationCode = country['code']!;
        break;
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('${widget.board.category}'),
        backgroundColor: Color(0xff7898ff),
        elevation: 0,
      ),
      body: Column(children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListTile(
                  //제목
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
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
                            '${widget.board.member!.name}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          Text(
                            '/',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          Text(
                            '${nationCode}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          )
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '1분 전',
                            style:
                            TextStyle(fontSize: 16, color: Color(0xffc1c1c1)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Icon(Icons.more_vert, color: Color(0xffc1c1c1)),
                          )
                        ],
                      ),
                    ],
                  ),

                  //내용
                  subtitle: Container(
                    padding: EdgeInsets.only(left: 15, bottom: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10,),
                          child: Text(
                            '${widget.board.title}',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff444444)),
                          ),
                        ),
                        widget.board.imageUrls == null
                            ? SizedBox()
                            : Container(
                                height: 100,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: widget.board.imageUrls!.length,
                                    itemBuilder: (context, index) {
                                      return Row(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(right: 10),
                                            height: 80,
                                            width: 80,
                                            decoration: BoxDecoration(
                                                color: Color(0xfff8f8f8),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Icon(Icons
                                                .add_photo_alternate_outlined),
                                          ),
                                        ],
                                      );
                                    }),
                              ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 25.0),
                          child: Text(
                            '${widget.board.content}',
                            style: TextStyle(fontSize: 16),
                          ),
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
                              child: widget.board.likeCount == 0
                                  ? Text('')
                                  : Text('${widget.board.likeCount}'),
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
                              child: Text('${widget.board.commentCount}'),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),

                ),
                Divider(color: Color(0xffF5F7FF), thickness: 2),
                Container(
                  height: 50,
                  margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  decoration: BoxDecoration(
                      color: Color(0xffe7e7e7),
                      borderRadius: BorderRadius.circular(10)),
                  alignment: Alignment.center,
                  child: Text('광고'),
                ),

                //댓글 위젯
                for (int i = 0; i < commentListMock.length; i++)
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10.0),
                                      child: SvgPicture.asset(
                                        'assets/icon/icon_profile.svg',
                                        width: 25,
                                        color: Color(0xffc1c1c1),
                                      ),
                                    ),
                                    Text(
                                      '${commentListMock[i].member!.name}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold, fontSize: 14),
                                    ),
                                    Text(
                                      '/',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold, fontSize: 14),
                                    ),
                                    Text(
                                      '${nationCode}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold, fontSize: 14),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '1분 전',
                                      style: TextStyle(
                                          fontSize: 12, color: Color(0xffc1c1c1)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Icon(Icons.more_vert,
                                          color: Color(0xffc1c1c1)),
                                    )
                                  ],
                                )
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 13),
                              child: Text(
                                '${commentListMock[i].content}',
                                style: TextStyle(fontSize: 16, color: Color(0xff616161)),
                              ),
                            ),
                          ],
                        ),
                      ),

                      //대댓글
                      commentListMock[i].childs == null ? SizedBox() :
                          Column(
                            children: [
                              for(int j = 0 ; j < commentListMock[i].childs!.length; j++)
                                 Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.all(15),
                                          alignment: Alignment.centerRight,
                                          child: Icon(
                                            Icons.subdirectory_arrow_right,
                                            size: 20,
                                            color: Color(0xffc1c1c1),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Color(0xffF4F4F4),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        width: 330,
                                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                                        margin: EdgeInsets.only(top: 15, bottom: 0, right: 30, left: 0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.only(right: 10.0),
                                                      child: SvgPicture.asset(
                                                        'assets/icon/icon_profile.svg',
                                                        width: 25,
                                                        color: Color(0xffc1c1c1),
                                                      ),
                                                    ),
                                                    Text(
                                                      '${commentListMock[i].childs![j].member!.name}',
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.bold, fontSize: 14),
                                                    ),
                                                    Text(
                                                      '/',
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.bold, fontSize: 14),
                                                    ),
                                                    Text(
                                                      '${nationCode}',
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.bold, fontSize: 14),
                                                    )
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      '1분 전',
                                                      style: TextStyle(
                                                          fontSize: 12, color: Color(0xffc1c1c1)),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 8.0),
                                                      child: Icon(Icons.more_vert,
                                                          color: Color(0xffc1c1c1)),
                                                    )
                                                  ],
                                                )
                                              ],
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5),
                                              child: Text(
                                                '${commentListMock[i].childs![j].content}',
                                                style: TextStyle(fontSize: 14, color: Color(0xff616161)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                            ],
                          ),
                      Divider(thickness: 1.5, color: Color(0xfff8f8f8),)
                    ],
                  ),
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            vertical: 30,
            horizontal: 20,
          ),
          child: Expanded(
            child: Container(
                decoration: BoxDecoration(
                  color: Color(0xffefefef),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                          maxLines: null,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(255),
                          ],
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        hintText: "댓글을 입력하세요.",
                        hintStyle: TextStyle(color: Color(0xffb1b1b1)),
                        border: InputBorder.none,
                      ),
                      onTap: () {
                        if (_newComment.trim().isEmpty) {}
                      },
                      controller: _controller,
                      onChanged: (value) {
                        setState(() {
                          _newComment = value;
                        });
                      },
                    )),
                    IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset(
                        'assets/icon/icon_send.svg',
                        height: 22,
                        color: _newComment.trim().isEmpty
                            ? Color(0xffc1c1c1)
                            : Color(0xff7898ff),
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ]),
    );
  }
}
