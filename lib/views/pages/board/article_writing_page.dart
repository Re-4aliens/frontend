import 'dart:async';

import 'package:aliens/mockdatas/board_mockdata.dart';
import 'package:aliens/models/board_model.dart';
import 'package:aliens/models/chatRoom_model.dart';
import 'package:aliens/models/screenArgument.dart';
import 'package:aliens/repository/board_repository.dart';
import 'package:aliens/repository/sql_message_database.dart';
import 'package:aliens/views/pages/chatting/chatting_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../models/countries.dart';
import '../../components/board_drawer_widget.dart';
import '../../components/button.dart';
import 'article_page.dart';

class ArticleWritingPage extends StatefulWidget {
  const ArticleWritingPage({super.key, required this.screenArguments, required this.category});

  final ScreenArguments screenArguments;
  final String category;

  @override
  State<StatefulWidget> createState() => _ArticleWritingPageState();
}

class _ArticleWritingPageState extends State<ArticleWritingPage> {

  String boardCategory = "카테고리를 선택해주세요.";
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    switch (widget.category){
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'post'.tr(),
            style: TextStyle(
              fontSize: 18.sp,
              color: Colors.black,
            ),
          ),
          toolbarHeight: 56,
          shadowColor: Colors.black26,
          backgroundColor: Colors.white,
          leadingWidth: 100,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Center(
              child: Text(
                "cancel".tr(),
                style: TextStyle(
                  color: Color(0xff888888),
                  fontSize: 14.sp,
                ),
              ),
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            children: [
              Expanded(
                  flex: 7,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0).w,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20).r,
                                  ),
                                ),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                  barrierColor: Colors.black.withOpacity(0.3),
                                  builder: (BuildContext context) {
                                    return Container(
                                      height: 480.h,
                                      child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(top: 30, left: 16.0, bottom: 25 ).r,
                                                child: Text("post4".tr(), style: TextStyle(color: Color(0xff121212), fontSize: 18.sp, fontWeight: FontWeight.bold)),
                                              ),
                                             Expanded(child: SingleChildScrollView(
                                               child: Column(
                                                 children: [
                                                   ListTile(
                                                     title: Text("free-posting".tr(), style: TextStyle(color: Color(0xff888888), fontSize: 16.sp),),
                                                     onTap: (){
                                                       setState(() {
                                                         boardCategory = "free-posting".tr();
                                                       });
                                                       Navigator.pop(context);
                                                     },
                                                   ),
                                                   ListTile(
                                                     title: Text("game".tr(), style: TextStyle(color: Color(0xff888888), fontSize: 16.sp)),
                                                     onTap: (){
                                                       setState(() {
                                                         boardCategory = "game".tr();
                                                       });
                                                       Navigator.pop(context);
                                                     },
                                                   ),
                                                   ListTile(
                                                     title: Text("fashion".tr(), style: TextStyle(color: Color(0xff888888), fontSize: 16.sp)),
                                                     onTap: (){
                                                       setState(() {
                                                         boardCategory = "fashion".tr();
                                                       });
                                                       Navigator.pop(context);
                                                     },
                                                   ),
                                                   ListTile(
                                                     title: Text("food".tr(), style: TextStyle(color: Color(0xff888888), fontSize: 16.sp)),
                                                     onTap: (){
                                                       setState(() {
                                                         boardCategory = "food".tr();
                                                       });
                                                       Navigator.pop(context);
                                                     },
                                                   ),
                                                   ListTile(
                                                     title: Text("music".tr(), style: TextStyle(color: Color(0xff888888), fontSize: 16.sp)),
                                                     onTap: (){
                                                       setState(() {
                                                         boardCategory = "music".tr();
                                                       });
                                                       Navigator.pop(context);
                                                     },
                                                   ),
                                                   ListTile(
                                                     title: Text("info".tr(), style: TextStyle(color: Color(0xff888888), fontSize: 16.sp)),
                                                     onTap: (){
                                                       setState(() {
                                                         boardCategory = "info".tr();
                                                       });
                                                       Navigator.pop(context);
                                                     },
                                                   )
                                                 ],
                                               ),
                                             ))
                                            ],
                                          ),
                                    );
                                  });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 65.h,
                                  padding: EdgeInsets.only(
                                    top: 25,
                                    bottom: 17,
                                  ).r,
                                  child: Text(boardCategory, style: TextStyle(
                                    color: Color(0xff616161),
                                    fontSize: 16.sp
                                  ),),
                                ),
                                Icon(Icons.arrow_drop_down, size: 40.w, color: Color(0xff888888),)
                              ],
                            ),
                          ),
                          Divider(
                            thickness: 1,
                            color: Color(0xffebebeb),
                          ),
                          Container(
                            height: 65.h,
                            child: TextFormField(
                              controller: _titleController,
                                textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                hintText: "post2".tr(),
                                border: InputBorder.none,
                                counterText: '',
                                hintStyle: TextStyle(
                                  color: Color(0xffd9d9d9),
                                  fontSize: 18.sp,
                                )
                              ),
                              maxLength: 30,
                            ),
                            alignment: Alignment.center,
                          ),
                          Divider(
                            thickness: 1,
                            color: Color(0xffebebeb),
                          ),
                          Container(
                            padding: EdgeInsets.all(10).r,
                            height: 150.h,
                            child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 20).r,
                                    height: 130.h,
                                    width: 130.h,
                                    decoration: BoxDecoration(
                                        color: Color(0xfff8f8f8),
                                        borderRadius:
                                        BorderRadius.circular(10).r),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                            Icons.add_photo_alternate_outlined, color: Color(0xffaeaeae),),
                                        Text('0/3', style: TextStyle(color: Color(0xffaeaeae)),)
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(right: 20).r,
                                    height: 130.h,
                                    width: 130.h,
                                    decoration: BoxDecoration(
                                        color: Color(0xfff8f8f8),
                                        borderRadius:
                                        BorderRadius.circular(10).r),
                                    alignment: Alignment.center,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xffebebeb),
                                      ),
                                      child: Icon(Icons.add, color: Color(0xffd2d2d2),),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(right: 20).r,
                                    height: 130.h,
                                    width: 130.h,
                                    decoration: BoxDecoration(
                                        color: Color(0xfff8f8f8),
                                        borderRadius:
                                        BorderRadius.circular(10).r),
                                    alignment: Alignment.center,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xffebebeb),
                                      ),
                                      child: Icon(Icons.add, color: Color(0xffd2d2d2),),
                                    ),
                                  ),
                                ],
                                ),
                          ),
                          Container(
                            child: TextFormField(
                              controller: _contentController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  helperStyle: TextStyle(
                                      color: Color(0xffc1c1c1), fontSize: 16.sp)),
                              maxLines: 10,
                              maxLength: 200, // 글자 길이 제한
                              keyboardType: TextInputType.multiline,
                            ),
                            )
                        ],
                      ),
                    ),
                  )),
              Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.all(20).r,
                    child: Button(
                      child: Text('post3'.tr()),
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        switch (boardCategory){
                          case 'Free Posting Board':
                            boardCategory = '자유게시판';
                            break;
                          case 'Food Board':
                            boardCategory = '음식게시판';
                            break;
                          case 'Music Board':
                            boardCategory = '음악게시판';
                            break;
                          case 'Fashion Board':
                            boardCategory = '패션게시판';
                            break;
                          case 'Game Board':
                            boardCategory = '게임게시판';
                            break;
                          case 'Information Board':
                            boardCategory = '정보게시판';
                            break;
                          default:
                        }

                        Board _newBoard = Board(
                          boardArticleId: 1,
                          category: boardCategory,
                          title: _titleController.text,
                          content: _contentController.text,
                          likeCount: 0,
                          commentCount: 0,
                          imageUrls: null,
                          member: Member(
                            memberId: 1,
                            nationality: "South Korea",
                            name: "Daisy",
                            profileImageUrl: "",
                          ),
                          createdAt: DateTime.now().toString()
                        );

                        BoardRepository.addPost(_newBoard);

                        Navigator.pop(context);
                        },
                      isEnabled: true,
                    ),
                  )),
            ],
          ),
        ));
  }
}
