import 'dart:async';

import 'package:aliens/mockdatas/board_mockdata.dart';
import 'package:aliens/models/chatRoom_model.dart';
import 'package:aliens/models/screenArgument.dart';
import 'package:aliens/repository/comment_repository.dart';
import 'package:aliens/repository/sql_message_database.dart';
import 'package:aliens/views/pages/chatting/chatting_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../mockdatas/comment_mockdata.dart';
import '../../../models/comment_model.dart';
import '../../../models/board_model.dart';
import '../../../models/countries.dart';
import 'package:flutter/services.dart';

import '../../../models/message_model.dart';
import '../../components/board_dialog_widget.dart';
import '../../components/comment_dialog_widget.dart';

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
  bool isNestedComments = false;
  String boardCategory = '';
  int parentsCommentIndex = -1;

  void sendComment() async {

    updateUi();
  }

  void updateUi() async {
    setState(() {
      //텍스트폼 비우기
      _controller.clear();
      _newComment = '';
    });
    FocusScope.of(context).unfocus();
  }


  @override
  void initState() {
    switch (widget.board.category){
      case '자유게시판':
        boardCategory = 'free-posting'.tr();
        break;
      case '음식게시판':
        boardCategory = 'food'.tr();
        break;
      case '음악게시판':
        boardCategory = 'music'.tr();
        break;
      case '패션게시판':
        boardCategory = 'fashion'.tr();
        break;
      case '게임게시판':
        boardCategory = 'game'.tr();
        break;
      default:
    }
  }

  String getNationCode(_nationality){
    var nationCode = '';
    for (Map<String, String> country in countries) {
      if (country['name'] == _nationality) {
        nationCode = country['code']!;
        break;
      }
    }
    return nationCode;
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
        setState(() {
          isNestedComments = false;
          parentsCommentIndex = -1;
        });
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(boardCategory, style: TextStyle(fontSize: 16.spMin),),
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
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0, bottom: 15, left: 10, right: 15).r,
                          child: SvgPicture.asset(
                            'assets/icon/icon_profile.svg',
                            width: 34.r,
                            color: Color(0xff7898ff),
                          ),
                        ),
                        Flexible(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(right: 10),
                            child: Text(
                              '${widget.board.member!.name}/${getNationCode(widget.board.member!.nationality)}',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16.spMin),
                            ),
                          ),
                        ),
                        Text(
                          DataUtils.getTime(widget.board.createdAt),
                          style: TextStyle(
                              fontSize: 16.spMin, color: Color(0xffc1c1c1)),
                        ),
                        InkWell(
                          onTap: (){
                            showDialog(context: context, builder: (builder){
                              return BoardDialog(context: context,);
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0).w,
                            child:
                            Icon(Icons.more_vert, color: Color(0xffc1c1c1)),
                          ),
                        )
                      ],
                    ),

                    //내용
                    subtitle: Container(
                      padding: EdgeInsets.only(left: 15.w, bottom: 15.h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10,).h,
                            child: Text(
                              '${widget.board.title}',
                              style: TextStyle(fontSize: 14.spMin, fontWeight: FontWeight.bold, color: Color(0xff444444)),
                            ),
                          ),
                          widget.board.imageUrls == null
                              ? SizedBox()
                              : Container(
                                  height: 100.h,
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: widget.board.imageUrls!.length,
                                      itemBuilder: (context, index) {
                                        return Row(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(right: 10.w),
                                              height: 80.h,
                                              width: 80.h,
                                              decoration: BoxDecoration(
                                                  color: Color(0xfff8f8f8),
                                                  borderRadius:
                                                      BorderRadius.circular(10).r),
                                              child: Icon(Icons
                                                  .add_photo_alternate_outlined),
                                            ),
                                          ],
                                        );
                                      }),
                                ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 25.0).h,
                            child: Text(
                              '${widget.board.content}',
                              style: TextStyle(fontSize: 14.spMin),
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4.0).r,
                                child: Icon(
                                  Icons.thumb_up_alt_sharp,
                                  color: Color(0xffc1c1c1),
                                  size: 20.h,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 4, right: 15).r,
                                child: widget.board.likeCount == 0
                                    ? Text('')
                                    : Text('${widget.board.likeCount}'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0).r,
                                child: Icon(
                                  Icons.chat_bubble,
                                  color: Color(0xffc1c1c1),
                                  size: 20.h,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0).r,
                                child: Text('${widget.board.commentCount}'),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),

                  ),
                  Divider(color: Color(0xffF5F7FF), thickness: 2.h),
                  Container(
                    height: 50.h,
                    margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10).r,
                    decoration: BoxDecoration(
                        color: Color(0xffe7e7e7),
                        borderRadius: BorderRadius.circular(10).r),
                    alignment: Alignment.center,
                    child: Text('광고'),
                  ),

                  //댓글 위젯
                  for (int i = 0; i < commentListMock.length; i++)
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30).r,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right: 10.0).r,
                                        child: SvgPicture.asset(
                                          'assets/icon/icon_profile.svg',
                                          width: 25.r,
                                          color: Color(0xffc1c1c1),
                                        ),
                                      ),
                                      Text(
                                        '${commentListMock[i].member!.name}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold, fontSize: 14.spMin),
                                      ),
                                      Text(
                                        '/',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold, fontSize: 14.spMin),
                                      ),
                                      Text(
                                        getNationCode(commentListMock[i].member!.nationality),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold, fontSize: 14.spMin),
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [

                                      Text(
                                        DataUtils.getTime(commentListMock[i].createdAt),
                                        style: TextStyle(
                                            fontSize: 12.spMin, color: Color(0xffc1c1c1)),
                                      ),
                                      InkWell(
                                        onTap: (){
                                          showDialog(context: context, builder: (builder){
                                            return CommentDialog(context: context, onpressed: (){
                                              setState(() {
                                                isNestedComments = true;
                                                parentsCommentIndex = i;
                                              });
                                              Navigator.pop(context);
                                            },
                                            isNestedComment: false);
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 8.0).r,
                                          child: Icon(Icons.more_vert,
                                              color: Color(0xffc1c1c1)),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 13).r,
                                child: Text(
                                  '${commentListMock[i].content}',
                                  style: TextStyle(fontSize: 14.spMin, color: Color(0xff616161)),
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
                                            padding: EdgeInsets.all(10).r,
                                            alignment: Alignment.centerRight,
                                            child: Icon(
                                              Icons.subdirectory_arrow_right,
                                              size: 20.h,
                                              color: Color(0xffc1c1c1),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Color(0xffF4F4F4),
                                            borderRadius: BorderRadius.circular(10).r,
                                          ),
                                          width: 300.w,
                                          padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
                                          margin: EdgeInsets.only(top: 15.h, bottom: 0.h, right: 30.w, left: 0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(right: 10.0).w,
                                                    child: SvgPicture.asset(
                                                      'assets/icon/icon_profile.svg',
                                                      width: 25.r,
                                                      color: Color(0xffc1c1c1),
                                                    ),
                                                  ),
                                                  Flexible(
                                                    child: Container(
                                                      alignment: Alignment.centerLeft,
                                                      padding: EdgeInsets.only(right: 10),
                                                      child: Text(
                                                        '${commentListMock[i].childs![j].member!.name}/${getNationCode(commentListMock[i].childs![j].member!.nationality)}',
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.bold, fontSize: 14.spMin),
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    DataUtils.getTime(commentListMock[i].childs![j].createdAt),
                                                    style: TextStyle(
                                                        fontSize: 12.spMin, color: Color(0xffc1c1c1)),
                                                  ),
                                                  InkWell(
                                                    onTap: (){
                                                      showDialog(context: context, builder: (builder){
                                                        return CommentDialog(context: context, onpressed: (){
                                                          setState(() {
                                                            isNestedComments = true;
                                                          });
                                                          Navigator.pop(context);
                                                        },
                                                          isNestedComment: true,);
                                                      });
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 8.0).w,
                                                      child: Icon(Icons.more_vert,
                                                          color: Color(0xffc1c1c1)),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5).h,
                                                child: Text(
                                                  '${commentListMock[i].childs![j].content}',
                                                  style: TextStyle(fontSize: 14.spMin, color: Color(0xff616161)),
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
            ).r,
            child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xffefefef),
                    borderRadius: BorderRadius.circular(10).r,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10).w,
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
                          hintText: isNestedComments? "comment2".tr() : "comment1".tr(),
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
                        onPressed: () {
                          if(isNestedComments){
                            Comment newValue = Comment(
                                boardArticleCommentId: 1,
                                content: _newComment,
                                createdAt: DateTime.now().toString(),
                                childs: [],
                                member: CommentMember(
                                    name: "daisy",
                                    nationality: "Japan",
                                    profileImageUrl: ""
                                )
                            );
                            CommentRepository.addCommentChilds(parentsCommentIndex, newValue);
                            parentsCommentIndex = -1;
                            isNestedComments = false;
                          }
                          else{
                            Comment newValue = Comment(
                              boardArticleCommentId: 1,
                              content: _newComment,
                              createdAt: DateTime.now().toString(),
                              childs: [],
                              member: CommentMember(
                                name: "daisy",
                                nationality: "Japan",
                                profileImageUrl: ""
                              )
                            );
                            CommentRepository.addComment(newValue);
                          }
                          updateUi();
                        },
                        icon: SvgPicture.asset(
                          'assets/icon/icon_send.svg',
                          height: 22.r,
                          color: _newComment.trim().isEmpty
                              ? Color(0xffc1c1c1)
                              : Color(0xff7898ff),
                        ),
                      ),
                    ],
                  )),
          ),
        ]),
      ),
    );
  }
}