import 'dart:async';
import 'package:aliens/apis/apis.dart';
import 'package:aliens/mockdatas/board_mockdata.dart';
import 'package:aliens/models/chatRoom_model.dart';
import 'package:aliens/models/market_articles.dart';
import 'package:aliens/models/memberDetails_model.dart';
import 'package:aliens/models/screenArgument.dart';
import 'package:aliens/repository/sql_message_database.dart';
import 'package:aliens/views/pages/chatting/chatting_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../mockdatas/comment_mockdata.dart';
import '../../../mockdatas/market_comment_mockdata.dart';
import '../../../models/comment_model.dart';
import '../../../models/board_model.dart';
import '../../../models/countries.dart';
import 'package:flutter/services.dart';

import '../../../models/market_comment.dart';
import '../../../models/message_model.dart';
import '../../../providers/bookmarks_provider.dart';
import '../../../providers/market_comment_provider.dart';
import '../../components/board_dialog_widget.dart';
import '../../components/board_drawer_widget.dart';
import '../../components/comment_dialog_widget.dart';
import '../../components/marketcomment_dialog.dart';
import '../home_page.dart';
import 'market_board_page.dart';

class MarketDetailPage extends StatefulWidget {
  const MarketDetailPage(
  {super.key, required this.screenArguments, required this.marketBoard, required this.productStatus, required this.StatusText, required this.index, required this.backPage});
  final ScreenArguments screenArguments;
  final MarketBoard marketBoard;
  //final MemberDetails memberDetails;
  final String productStatus;
  final String StatusText;
  final int index;
  final String backPage;




  @override
  State<StatefulWidget> createState() => _MarketDetailPageState();
}

class _MarketDetailPageState extends State<MarketDetailPage> {
  final _controller = TextEditingController();
  var _newComment = '';
  bool isNestedComments = false;
  int parentsCommentId = -1;
  bool showLoading = false;
  int bookmark = -1;
  bool isDrawerStart = false;


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

  void initState() {
    super.initState();
    final marketcommentProvider = Provider.of<MarketCommentProvider>(context, listen: false);
    marketcommentProvider.getMarketComments(widget.marketBoard.articleId!);
    if(widget.index == -1) {
      bookmark = widget.marketBoard.marketArticleBookmarkCount!;
    };

  }

  @override
  Widget build(BuildContext context) {
    print('${widget.marketBoard}');
    //print('Data from marketBoard: ${widget.marketBoard.createdAt}');
    /*print('comment:${widget.marketBoard.commentsCount}');
    print('marketArticleBookmarkCount:${widget.marketBoard.marketArticleBookmarkCount}');*/


    List<String> whatStatus = [
      'Brand_New'.tr(), 'Almost_New'.tr(), 'Slight_Defect'.tr(), 'Used'.tr()
    ];
    String productStatus = '${widget.marketBoard.productStatus}';
    String StatusText = '${widget.marketBoard.marketArticleStatus}';
    final marketcommentProvider = Provider.of<MarketCommentProvider>(context);
    final bookmarkProvider = Provider.of<BookmarksProvider>(context);



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
          backgroundColor:Color(0xff7898ff),
          toolbarHeight:56,
          leadingWidth: 100,
          leading: Row(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) => MarketBoardPage(
                          screenArguments: widget.screenArguments,
                          marketBoard: widget.marketBoard,
                          memberDetails: widget.screenArguments.memberDetails!
                      ),
                    )
                  );
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
            ? BoardDrawerWidget(screenArguments: widget.screenArguments, isTotalBoard: false, onpressd: () {  },
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
                                '${widget.marketBoard.title}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                    fontSize: 20.spMin,
                                    color: Colors.black
                                ),
                              ),
                            ),
                            Container(
                              width: 80.spMin,
                              height: 35.spMin,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(color: Color(0xFFEBEBEB)),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(getStatusText(StatusText),
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
                            Text('${widget.marketBoard.price.toString()}',
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
                              'market-productStatus'.tr(),
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
                                    final bool isSelected = getProductStatusText(productStatus) ==
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
                            children: widget.marketBoard.imageUrls!.map((imageUrl) {
                              return Container(
                                margin: EdgeInsets.only(right: 20).r,
                                width: 197.spMin,
                                height: 207.spMin,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10).r,
                                  color: Color(0xffF8F8F8),
                                ),
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
//사진
                        SizedBox(height: MediaQuery.of(context).size.height*0.02),
                        Text(
                          '${widget.marketBoard.content}', //내용
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
                            Text(
                              DataUtils.getTime(widget.marketBoard.createdAt),//createdAt
                              style: TextStyle(
                                color: Color(0xffa8a8a8),
                                fontSize: 16.spMin,
                              ),
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    //print('부크마크: ${bookmarkProvider.marketArticleBookmarkCount?[widget.index]}');
                                    if(widget.index == -1){
                                      bookmark = await APIs.marketbookmark(widget.marketBoard.articleId!, widget.index);
                                    }else{
                                      bookmarkProvider.addBookmarks(widget.marketBoard.articleId!, widget.index);
                                    }
                                    setState(() {});
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0).r,
                                    child: SvgPicture.asset(
                                      'assets/icon/ICON_good.svg',
                                      width: 18.r,
                                      height: 18.r,
                                      color: Color(0xffc1c1c1),
                                    ),
                                  ),
                                ),
                                widget.index == -1 ?
                                Padding(
                                  padding: EdgeInsets.only(left: 4, right: 15).r,
                                  child:
                                  Text('${bookmark}',style: TextStyle(fontSize: 16.spMin,color: Color(0xffc1c1c1))),
                                ):
                                Padding(
                                  padding: EdgeInsets.only(left: 4, right: 15).r,
                                  child:
                                  bookmarkProvider.marketArticleBookmarkCount![widget.index] == 0
                                      ? Text('0',style: TextStyle(fontSize: 16.spMin,color: Color(0xffc1c1c1)))
                                      : Text('${bookmarkProvider.marketArticleBookmarkCount![widget.index]}',style: TextStyle(fontSize: 16.spMin,color: Color(0xffc1c1c1))),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0).r,
                                  child: SvgPicture.asset(
                                    'assets/icon/icon_comment.svg',
                                    width: 18.r,
                                    height: 18.r,
                                    color: Color(0xffc1c1c1),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0).r,
                                  child: Text('${widget.marketBoard.commentsCount}',
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
                        marketcommentProvider.loading || marketcommentProvider.commentListData == null?
                        Container(
                            alignment: Alignment.center,
                            child: Image(
                                image: AssetImage(
                                    "assets/illustration/loading_01.gif")))
                            :
                        Column(
                          children: [
                            for(int index = 0; index < marketcommentProvider.commentListData!.length; index++)
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
                                                    '${marketcommentProvider.commentListData![index].member!.name}',
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold, fontSize: 14.spMin),
                                                  ),
                                                  Text(
                                                    '/',
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold, fontSize: 14.spMin),
                                                  ),
                                                  Text(
                                                    getNationCode(marketcommentProvider.commentListData![index].member!.nationality),
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold, fontSize: 14.spMin),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [

                                                  Text(
                                                    DataUtils.getTime(marketcommentProvider.commentListData![index].createdAt),
                                                    style: TextStyle(
                                                        fontSize: 12.spMin, color: Color(0xffc1c1c1)),
                                                  ),
                                                  InkWell(
                                                    onTap: (){

                                                      print(marketcommentProvider.commentListData!);
                                                      showDialog(context: context, builder: (builder){
                                                        return MarketCommentDialog(context: context, onpressed: (){
                                                          setState(() {
                                                            isNestedComments = true;
                                                            parentsCommentId = marketcommentProvider.commentListData![index].articleCommentId!;
                                                          });
                                                          Navigator.pop(context);
                                                        },
                                                          isNestedComment: false,
                                                          marketcomment: marketcommentProvider.commentListData![index],
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
                                              '${marketcommentProvider.commentListData![index].content}',
                                              style: TextStyle(fontSize: 14.spMin, color: Color(0xff616161)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    //대댓글
                                    marketcommentProvider.commentListData![index].childs == null ? SizedBox() :
                                    Column(
                                      children: [
                                        for(int j = 0 ; j < marketcommentProvider.commentListData![index].childs!.length; j++)
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
                                                              '${marketcommentProvider.commentListData![index].childs![j].member!.name}/${getNationCode(marketcommentProvider.commentListData![index].childs![j].member!.nationality)}',
                                                              overflow: TextOverflow.ellipsis,
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight.bold, fontSize: 14.spMin),
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          DataUtils.getTime(marketcommentProvider.commentListData![index].childs![j].createdAt),
                                                          style: TextStyle(
                                                              fontSize: 12.spMin, color: Color(0xffc1c1c1)),
                                                        ),
                                                        InkWell(
                                                          onTap: (){
                                                            showDialog(context: context, builder: (builder){
                                                              return MarketCommentDialog(context: context, onpressed: (){
                                                                setState(() {
                                                                  isNestedComments = true;
                                                                });
                                                                Navigator.pop(context);
                                                              },
                                                                isNestedComment: true,
                                                                marketcomment: marketcommentProvider.commentListData![index]);
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
                                                        '${marketcommentProvider.commentListData![index].childs![j].content}',
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
                                marketcommentProvider.addNestedMarketComment(_newComment, parentsCommentId, widget.marketBoard.articleId!);
                                //여기 페이지 재로드하는거나 marketcommentprovider 재로드를 넣어야할거같아
                                parentsCommentId = -1;
                                isNestedComments = false;

                              }
                              else{
                                marketcommentProvider.addMarketComment(_newComment, widget.marketBoard.articleId!);
                              }
                              updateUi();
                            }

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
String getProductStatusText(String? productStatus) {
  List<String> whatStatus = [
    'Brand_New'.tr(),
    'Almost_New'.tr(),
    'Slight_Defect'.tr(),
    'Used'.tr(),
  ];

  switch (productStatus) {
    case '새 것':
      return whatStatus[0];
    case '거의 새 것':
      return whatStatus[1];
    case '약간의 하자':
      return whatStatus[2];
    case '사용감 있음':
      return whatStatus[3];
    default:
      return '';
  }
}

String getStatusText(String? marketArticleStatus){
  List<String> Status = [
    'sale'.tr(),
    'sold-out'.tr(),
  ];

  switch (marketArticleStatus) {
    case '판매 중':
      return Status[0];
    case '판매 완료':
      return Status[1];
    default:
      return '';
  }
}