import 'dart:async';

import 'package:aliens/apis/apis.dart';
import 'package:aliens/mockdatas/mockdata_model.dart';
import 'package:aliens/models/chatRoom_model.dart';
import 'package:aliens/models/memberDetails_model.dart';
import 'package:aliens/models/screenArgument.dart';
import 'package:aliens/repository/sql_message_database.dart';
import 'package:aliens/views/pages/board/market_detail_page.dart';
import 'package:aliens/views/pages/board/search_page.dart';
import 'package:aliens/views/pages/chatting/chatting_page.dart';
import 'package:aliens/views/pages/home_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../models/market_articles.dart';
import '../../../models/message_model.dart';
import '../../../providers/bookmarks_provider.dart';
import '../../components/board_drawer_widget.dart';


class MarketBoardPage extends StatefulWidget {
  const MarketBoardPage({super.key, required this.screenArguments, required this.marketBoard, required this.index,});
  final ScreenArguments screenArguments;
  final MarketBoard? marketBoard;
  final int index;

  //final MemberDetails memberDetails;




  @override
  State<StatefulWidget> createState() => _MarketBoardPageState();
}

class _MarketBoardPageState extends State<MarketBoardPage> {
  bool isDrawerStart = false;
  List<MarketBoard> marketBoardList = [];
  //String createdAt = '';



  void initState() {
    super.initState();
    _fetchMarketArticles();

    final bookmarkProvider = Provider.of<BookmarksProvider>(context, listen: false);
    print(10);
    bookmarkProvider.getbookmarksCounts();
    print(11);
    print('북마크될라나: ${bookmarkProvider.marketArticleBookmarkCount?[widget.index]}');
    print('북마크: ${bookmarkProvider.marketArticleBookmarkCount?[widget.index] == 0}');
  }

  Future<void> _fetchMarketArticles() async {
    try {
      var fetchedData = await APIs.getMarketArticles(); // API 호출 함수 호출
      print(fetchedData);
      setState(() {
        marketBoardList = fetchedData; // 불러온 데이터를 리스트에 할당
        for (var marketBoard in marketBoardList) {
         // print('createdAt: ${marketBoard.createdAt}');
      //    print('status: ${marketBoard.marketArticleStatus}');
       //   print('productstatus: ${marketBoard.productStatus}');
        //  print('comment:${marketBoard.commentsCount}');

        }
        /*final bookmarkProvider = Provider.of<BookmarksProvider>(context, listen: false);
        print(10);
        bookmarkProvider.getbookmarksCounts();
        print(11);
        print('북마크될라나: ${bookmarkProvider.marketArticleBookmarkCount?[widget.index]}');
        print('북마크: ${bookmarkProvider.marketArticleBookmarkCount?[widget.index] == 0}');
        print('북마크개수:${bookmarkProvider.marketArticleBookmarkCount}');*/

      });
    } catch (error) {
      // 에러 처리
      print("API 호출 중 오류 발생: $error");
    }
  }


  @override
  Widget build(BuildContext context) {

    final double screenWidth = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth <= 700;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff7898ff),
          toolbarHeight: 56,
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
                    width: 17.r,
                    height: 17.r,
                  )
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    isDrawerStart = !isDrawerStart;
                  });
                },
                icon: SvgPicture.asset(
                  'assets/icon/ICON_list.svg',
                  width: 20.r,
                  height: 20.r,
                  color: Colors.white,
                ),
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
          actions: [
            Padding(padding: EdgeInsets.all(8),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) => SearchPage(screenArguments: widget.screenArguments, category: "패션게시판",)),
                  );
                },
                child: SvgPicture.asset(
                  'assets/icon/icon_search.svg',
                  width: 25.r,
                  height: 25.r,
                  color: Colors.white,
                ),
              ),
            ),
          ],


        ),
        body: isDrawerStart
            ? BoardDrawerWidget(
          screenArguments: widget.screenArguments,
          isTotalBoard: false,
          onpressd: () {},
        )
            : Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/market/notice');
              },
              child: Container(
                margin: EdgeInsets.only(right: 10, left: 10, top: 10, bottom: 10).r,
                padding: EdgeInsets.only(right: 10, left: 10).r,
                width: double.infinity,
                height: 42.spMin,
                decoration: BoxDecoration(
                  color: Color(0xffE7E7E7),
                  borderRadius: BorderRadius.circular(10), // 모서리를 둥글게 만듦
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(child: Container()),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icon/icon_info.svg',
                          color: Color(0xff616161),
                          width: 18.spMin,
                          height: 18.spMin,
                        ),
                        Text(
                          '  ${'market-noti'.tr()}',
                          style: TextStyle(
                              fontSize: 14.spMin,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff616161)
                          ),
                        )
                      ],
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 18.spMin,
                      color: Color(0xffC1C1C1),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: _contentWidget(),
            )
          ],
        )


    );
  }


  Widget _contentWidget() {
    final bookmarkProvider = Provider.of<BookmarksProvider>(context);

    return ListView.separated(

      itemBuilder: (BuildContext context, int index) {
        MarketBoard marketBoard = marketBoardList[index];
        String productStatusText = getProductStatusText(marketBoard.productStatus);
        String StatusText = getStatusText(marketBoard.marketArticleStatus);

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    MarketDetailPage(
                      screenArguments: widget.screenArguments,
                      marketBoard: marketBoard,
                        productStatus: getProductStatusText(marketBoard.productStatus), 
                      StatusText: getStatusText(marketBoard.marketArticleStatus), index: index,
                     // memberDetails: widget.memberDetails,
                    ),
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.only(
                right: 20.w, left: 20.w, top: 12.h, bottom: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 124.spMin,
                  height: 124.spMin,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(marketBoard.imageUrls?.first ?? ""), // 첫 번째 이미지를 가져오기
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                            left: 10.w, right: 10.w, top: 2.h, bottom: 2.h),
                        height: 21.spMin,
                        child: Text(
                          '[$productStatusText]', // 상품 상태 정보
                          style: TextStyle(
                              fontSize: 10.spMin, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          color: Color(0xff7898FF),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 5.w),
                Container(
                  width: MediaQuery.of(context).size.width - 170.w,
                  height: 124.spMin,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                           '[$StatusText]', // 상태 정보 사용
                            style: TextStyle(
                              color: marketBoard.marketArticleStatus == '판매 중'?Color(0xff616161): Color(0xffFF375B),
                              fontSize: 16.spMin,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                          DataUtils.getTime(marketBoard.createdAt),
                                style: TextStyle(
                                  color: Color(0xffC1C1C1),
                                  fontSize: 12.spMin,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return SimpleDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              20.0),
                                        ),
                                        children: [
                                          SimpleDialogOption(
                                            child: Text('${'modify'.tr()}'),
                                            onPressed: () {},
                                          ),
                                          SimpleDialogOption(
                                            child: Text(
                                                '${'chatting-report1'.tr()}'),
                                            onPressed: () {},
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: SvgPicture.asset(
                                  'assets/icon/ICON_more.svg',
                                  width: 16.r,
                                  height: 16.r,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        marketBoard.title ?? "", // 제목 정보 사용
                        style: TextStyle(fontSize: 16.spMin),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        '${marketBoard.price.toString() ?? ""}원', // 가격 정보 사용
                        style: TextStyle(
                            fontSize: 16.spMin, fontWeight: FontWeight.w700),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SvgPicture.asset(
                            'assets/icon/ICON_good.svg',
                            width: 16.r,
                            height: 16.r,
                            color: Color(0xffc1c1c1),
                          ),

                          bookmarkProvider.marketArticleBookmarkCount?[index] == 0
                              ? Text('0',style: TextStyle(fontSize: 16.spMin,color: Color(0xffc1c1c1)))
                              : Text('${bookmarkProvider.marketArticleBookmarkCount![index]}',
                              style: TextStyle(
                                fontSize: 14.spMin,
                                color: Color(0xffc1c1c1),
                              )
                          ),

                          /*Text(
                            ' ${marketBoard.marketArticleBookmarkCount ?? 0}  ',
                            style: TextStyle(
                              fontSize: 14.spMin,
                              color: Color(0xffc1c1c1),
                            ),
                          ),*/
                          SvgPicture.asset(
                            'assets/icon/icon_comment.svg',
                            width: 16.r,
                            height: 16.r,
                            color: Color(0xffc1c1c1),
                          ),
                          Text(
                            ' ${marketBoard.commentsCount ?? 0}',
                            style: TextStyle(
                              fontSize: 14.spMin,
                              color: Color(0xffc1c1c1),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Container(
          height: 1.h,
          color: Color(0xffE5EBFF),
        );
      },
      itemCount: marketBoardList.length,
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
