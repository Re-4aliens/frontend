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
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../mockdatas/comment_mockdata.dart';
import '../../../mockdatas/market_comment_mockdata.dart';
import '../../../models/comment_model.dart';
import '../../../models/board_model.dart';
import '../../../models/countries.dart';
import 'package:flutter/services.dart';

import '../../../models/message_model.dart';
import '../../components/board_dialog_widget.dart';
import '../../components/board_drawer_widget.dart';
import '../../components/comment_dialog_widget.dart';
import '../home_page.dart';

class MarketDetailPage extends StatefulWidget {
  const MarketDetailPage(
  {super.key, required this.screenArguments});
  final ScreenArguments screenArguments;


  @override
  State<StatefulWidget> createState() => _MarketDetailPageState();
}

class _MarketDetailPageState extends State<MarketDetailPage> {
  final _controller = TextEditingController();
  var _newComment = '';
  bool isNestedComments = false;
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
    final double screenWidth = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth <= 700;

    List<String> whatStatus = [
      '미개봉', '거의 새 것', '약간의 하자', '사용감 있음'
    ];
    String productStatus = '거의 새 것';
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
          backgroundColor:Color(0xff7898ff),
          toolbarHeight:56,
          leadingWidth: 100,
          leading: Row(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    Navigator.of(context).pop();
                  });
                },
                icon: SvgPicture.asset(
                  'assets/icon/icon_back.svg',
                  color: Colors.white,
                  width: 18.w,
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
          ),
          title: Text('market'.tr(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.spMin,
              )
          ),
          centerTitle: true,


        ),
        body:isDrawerStart
            ? BoardDrawerWidget(screenArguments: widget.screenArguments, isTotalBoard: true, onpressd: () {  },
        )
            :Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(right: 24.w, left: 24.w, top: 12.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '가죽쪼리팔아요',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                    fontSize: 20.spMin,
                                    color: Colors.black
                                ),
                              ),
                            ),
                            Container(
                              width: 75.spMin,
                              height: 35.spMin,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(color: Color(0xFFEBEBEB)),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('판매중',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Color(0xff888888),
                                            fontSize: 14.spMin
                                        ),
                                      ),
                                ],
                              ),

                              ),

                          ],
                        ),//제목 넣는 곳
                        SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                        Divider(thickness: 1.h,color: Color(0xffebebeb),),
                        SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                        Row(
                          children: [
                            Text('₩ ',
                              style: TextStyle(fontSize: 16.spMin,fontWeight: FontWeight.bold),
                            ),
                            Text('25000',
                              style: TextStyle(fontSize: 16.spMin,fontWeight: FontWeight.bold),
                            )//가격넣는곳
                          ],
                        ),//가격
                        SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                        Divider(thickness: 1.h,color: Color(0xffebebeb),),
                        SizedBox(height: MediaQuery.of(context).size.height*0.005),
                        Row(
                          children: [
                            Text(
                            '상품상태',
                            style: TextStyle(
                              fontSize: 16.spMin,
                              color: Color(0xff888888),
                            ),
                          ),
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children:
                                  whatStatus.map((condition) {
                                    final bool isSelected = productStatus ==
                                        condition;
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 4.w),
                                      child: ChoiceChip(
                                        label: Text(
                                          condition,
                                          style: TextStyle(
                                            fontSize: 14.spMin,
                                            color: isSelected
                                                ? Colors.white
                                                : Color(0xffC1C1C1),
                                          ),
                                        ),
                                        selected: isSelected,
                                        backgroundColor: isSelected ? Color(
                                            0xff7898FF) : Colors.white,
                                        selectedColor: Color(0xff7898ff),
                                        onSelected: (isSelected) {
                                          setState(() {
                                            productStatus =
                                            isSelected ? condition : '';
                                          });
                                        },
                                        labelPadding: EdgeInsets.only(
                                            left: 12.w, right: 12.w),
                                        // 선택 영역 패딩 조절
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                            color: isSelected ? Color(
                                                0xff7898FF) : Color(
                                                0xffC1C1C1),
                                          ),
                                          borderRadius: BorderRadius.circular(20), // 선택 테두리 둥글기 조절
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),//상품상태넣는 곳
                        SizedBox(height: MediaQuery.of(context).size.height*0.005),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 20).r,
                                width: 197.spMin,
                                height: 207.spMin,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10).r,
                                  color: Color(0xffF8F8F8),
                                ),
                                child: Icon(Icons.add_photo_alternate_outlined,//사진 넣는 곳
                                  size: 66.spMin,
                                  color: Color(0xffebebeb),
                                  ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 20).r,
                                width: 197.spMin,
                                height: 207.spMin,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10).r,
                                  color: Color(0xffF8F8F8),
                                ),
                                child: Icon(Icons.add_photo_alternate_outlined,//사진 넣는 곳
                                  size: 66.spMin,
                                  color: Color(0xffebebeb),
                                ),
                              ),
                              Container(
                                width: 197.spMin,
                                height: 207.spMin,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10).r,
                                  color: Color(0xffF8F8F8),
                                ),
                                child: Icon(Icons.add_photo_alternate_outlined,//사진 넣는 곳
                                  size: 66.h,
                                  color: Color(0xffebebeb),
                                ),
                              )
                            ],
                          ),
                        ),//사진
                        SizedBox(height: MediaQuery.of(context).size.height*0.02),
                        Text(
                          '제품명 : 가죽쪼리\n가격 : 25,000원\n상세정보 : 거의 새 상품이나 마찬가지입니다.\n딱 한 번만 신었어요\n휴대폰 번호 : 010-1234-5678', //내용
                          textAlign: TextAlign.start,
                          style: TextStyle(
                          fontSize: 16.spMin
                        ),
                        ),//내용 넣는 곳
                        SizedBox(height: MediaQuery.of(context).size.height*0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('23.08.06 22:10',//createdAt
                              style: TextStyle(
                                color: Color(0xffa8a8a8),
                                fontSize: 16.spMin,
                              ),
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(4.0).r,
                                  child: Icon(
                                    Icons.thumb_up_alt_sharp,
                                    color: Color(0xffc1c1c1),
                                    size: 18.spMin,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 4, right: 15).r,
                                  child: Text('10',
                                    style: TextStyle(
                                      fontSize: 16.spMin,
                                      color: Color(0xffc1c1c1)
                                    ),
                                  )
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0).r,
                                  child: Icon(
                                    Icons.chat_bubble,
                                    color: Color(0xffc1c1c1),
                                    size: 18.spMin,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0).r,
                                  child: Text('1',
                                    style: TextStyle(
                                        fontSize: 16.spMin,
                                        color: Color(0xffc1c1c1)
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Divider(thickness: 1.2.h,color: Color(0xffE5EBFF),),

                        //댓글
                        for (int i = 0; i < MarketcommentListMock.length; i++)
                          Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 15, /*horizontal: 30*/).r,
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
                                              '${MarketcommentListMock[i].member!.name}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold, fontSize: 14.spMin),
                                            ),
                                            Text(
                                              '/',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold, fontSize: 14.spMin),
                                            ),
                                            Text(
                                              getNationCode(MarketcommentListMock[i].member!.nationality),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold, fontSize: 14.spMin),
                                            )
                                          ],
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [

                                            Text(
                                              DataUtils.getTime(MarketcommentListMock[i].createdAt),
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
                                        '${MarketcommentListMock[i].content}',
                                        style: TextStyle(fontSize: 14.spMin, color: Color(0xff616161)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              //대댓글
                              MarketcommentListMock[i].childs == null ? SizedBox() :
                              Column(
                                children: [
                                  for(int j = 0 ; j < MarketcommentListMock[i].childs!.length; j++)
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Container(
                                           // padding: EdgeInsets.all(10).r,
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
                                                        '${MarketcommentListMock[i].childs![j].member!.name}/${getNationCode(MarketcommentListMock[i].childs![j].member!.nationality)}',
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.bold, fontSize: 14.spMin),
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    DataUtils.getTime(MarketcommentListMock[i].childs![j].createdAt),
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
                                                  '${MarketcommentListMock[i].childs![j].content}',
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
