import 'dart:async';

import 'package:aliens/mockdatas/board_mockdata.dart';
import 'package:aliens/models/chatRoom_model.dart';
import 'package:aliens/models/memberDetails_model.dart';
import 'package:aliens/models/screenArgument.dart';
import 'package:aliens/providers/comment_provider.dart';
import 'package:aliens/repository/sql_message_database.dart';
import 'package:aliens/views/pages/chatting/chatting_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../apis/apis.dart';
import '../../../mockdatas/comment_mockdata.dart';
import '../../../models/comment_model.dart';
import '../../../models/board_model.dart';
import '../../../models/countries.dart';
import 'package:flutter/services.dart';

import '../../../models/message_model.dart';
import '../../../repository/board_provider.dart';
import '../../components/board_dialog_widget.dart';
import '../../components/comment_dialog_widget.dart';

class ArticlePage extends StatefulWidget {
  const ArticlePage(
      {super.key, required this.board, required this.memberDetails, required this.index});

  final Board board;
  final MemberDetails memberDetails;
  final int index;

  @override
  State<StatefulWidget> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  final _controller = TextEditingController();
  var _newComment = '';
  bool isNestedComments = false;
  String boardCategory = '';
  int parentsCommentId = -1;

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

    final commentProvider = Provider.of<CommentProvider>(context, listen: false);
    commentProvider.getComments(widget.board.articleId!);
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
    final commentProvider = Provider.of<CommentProvider>(context);
    final boardProvider = Provider.of<BoardProvider>(context);
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
        setState(() {
          isNestedComments = false;
          parentsCommentId = -1;
        });
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(boardCategory, style: TextStyle(fontSize: 18.spMin),),
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
                              return BoardDialog(context: context, board: widget.board, memberDetails: widget.memberDetails, boardCategory: "",);
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0).w,
                            child:
                            SvgPicture.asset(
                                'assets/icon/ICON_more.svg',
                                width: 25.r,
                                height: 25.r,
                                color: Color(0xffc1c1c1)
                            ),
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
                          widget.board.imageUrls!.isEmpty
                              ? SizedBox()
                              : Container(
                            height: 100.h,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: widget.board.imageUrls!.length,
                                itemBuilder: (context, index) {
                                  return Row(
                                    children: [
                                      InkWell(
                                        onTap: (){
                                          showDialog(context: context, builder: (context){
                                            return GestureDetector(
                                              onTap: (){Navigator.pop(context);},
                                              child: InteractiveViewer(
                                                child: Image.network(widget.board.imageUrls![index]),
                                              ),
                                            );
                                          });
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(right: 10.w),
                                          height: 80.h,
                                          width: 80.h,
                                          decoration: BoxDecoration(
                                              color: Color(0xfff8f8f8),
                                              borderRadius:
                                              BorderRadius.circular(10).r,
                                            image: DecorationImage(
                                              image: NetworkImage(widget.board.imageUrls![index]),
                                              fit: BoxFit.cover,
                                            )
                                          ),
                                        ),
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
                              InkWell(
                                onTap: (){
                                  if(widget.index != -1)
                                    boardProvider.addLike(widget.board.articleId!, widget.index);
                                },
                                child: Padding(
                                    padding: const EdgeInsets.all(4.0).r,
                                    child: SvgPicture.asset(
                                      'assets/icon/ICON_good.svg',
                                      width: 30.r,
                                      height: 30.r,
                                      color: Color(0xffc1c1c1),
                                    )
                                ),
                              ),
                              widget.index == -1 ? Padding(
                                padding: EdgeInsets.only(left: 4, right: 15).r,
                                child:
                                widget.board.likeCount == 0 || widget.board.likeCount == null? Text('') : Text('${widget.board.likeCount}'),
                              ):
                              Padding(
                                padding: EdgeInsets.only(left: 4, right: 15).r,
                                child:
                                boardProvider.likeCounts![widget.index] == 0 || boardProvider.likeCounts == null? Text('') : Text('${boardProvider.likeCounts![widget.index]}'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0).r,
                                child: SvgPicture.asset(
                                  'assets/icon/icon_comment.svg',
                                  width: 30.r,
                                  height: 30.r,
                                  color: Color(0xffc1c1c1),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0).r,
                                child: widget.board.commentsCount == 0
                                    ? Text('')
                                    : Text(
                                    '${widget.board.commentsCount}')
                              ),
                            ],
                          )
                        ],
                      ),
                    ),

                  ),
                  Divider(color: Color(0xffF5F7FF), thickness: 2.h),
                  /*
                  Container(
                    height: 50.h,
                    margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10).r,
                    decoration: BoxDecoration(
                        color: Color(0xffe7e7e7),
                        borderRadius: BorderRadius.circular(10).r),
                    alignment: Alignment.center,
                    child: Text('광고'),
                  ),

                   */


                  //댓글 위젯
                  commentProvider.loading || commentProvider.commentListData == null?
                  Container(
                      alignment: Alignment.center,
                      child: Image(
                          image: AssetImage(
                              "assets/illustration/loading_01.gif")))
                      :
                  Column(
                    children: [
                      for(int index = 0; index < commentProvider.commentListData!.length; index++)
                        Container(
                          child: Column(
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
                                              '${commentProvider.commentListData![index].member!.name}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold, fontSize: 14.spMin),
                                            ),
                                            Text(
                                              '/',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold, fontSize: 14.spMin),
                                            ),
                                            Text(
                                              getNationCode(commentProvider.commentListData![index].member!.nationality),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold, fontSize: 14.spMin),
                                            )
                                          ],
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [

                                            Text(
                                              DataUtils.getTime(commentProvider.commentListData![index].createdAt),
                                              style: TextStyle(
                                                  fontSize: 12.spMin, color: Color(0xffc1c1c1)),
                                            ),
                                            InkWell(
                                              onTap: (){

                                                print(commentProvider.commentListData!);
                                                showDialog(context: context, builder: (builder){
                                                  return CommentDialog(context: context, onpressed: (){
                                                    setState(() {
                                                      isNestedComments = true;
                                                      parentsCommentId = commentProvider.commentListData![index].articleCommentId!;
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                    isNestedComment: false,
                                                    comment: commentProvider.commentListData![index],
                                                    memberDetials: widget.memberDetails,
                                                    articleId: widget.board.articleId!,
                                                  );
                                                });
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 8.0).r,
                                                child: SvgPicture.asset(
                                                  'assets/icon/ICON_more.svg',
                                                  width: 25.r,
                                                  height: 25.r,
                                                  color: Color(0xffc1c1c1),
                                                ),
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
                                        '${commentProvider.commentListData![index].content}',
                                        style: TextStyle(fontSize: 14.spMin, color: Color(0xff616161)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              //대댓글
                              commentProvider.commentListData![index].childs == null ? SizedBox() :
                              Column(
                                children: [
                                  for(int j = 0 ; j < commentProvider.commentListData![index].childs!.length; j++)
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.all(10).r,
                                            alignment: Alignment.centerRight,
                                            child: SvgPicture.asset(
                                              'assets/icon/ICON_reply.svg',
                                              width: 15.r,
                                              height: 15.r,
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
                                                        '${commentProvider.commentListData![index].childs![j].member!.name}/${getNationCode(commentProvider.commentListData![index].childs![j].member!.nationality)}',
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.bold, fontSize: 14.spMin),
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    DataUtils.getTime(commentProvider.commentListData![index].childs![j].createdAt),
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
                                                          isNestedComment: true,
                                                          comment: commentProvider.commentListData![index].childs![j],
                                                          memberDetials: widget.memberDetails,
                                                        articleId: widget.board.articleId!,);
                                                      });
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 8.0).w,
                                                      child: SvgPicture.asset(
                                                        'assets/icon/ICON_more.svg',
                                                        width: 22.r,
                                                        height: 22.r,
                                                        color: Color(0xffc1c1c1),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5).h,
                                                child: Text(
                                                  '${commentProvider.commentListData![index].childs![j].content}',
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
                        )
                    ],
                  )



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
                        print('${parentsCommentId}');
                        if(_newComment != ''){
                          if(isNestedComments){
                            commentProvider.addNestedComment(_newComment, parentsCommentId, widget.board.articleId!);
                            parentsCommentId = -1;
                            isNestedComments = false;
                          }
                          else{
                            commentProvider.addComment(_newComment, widget.board.articleId!);
                          }
                        }
                        updateUi();
                      },
                      icon: SvgPicture.asset(
                        'assets/icon/ICON_send.svg',
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
