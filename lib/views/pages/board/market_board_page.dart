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
import '../../components/market_dialog_widget.dart';


class MarketBoardPage extends StatefulWidget {
  const MarketBoardPage({super.key, required this.screenArguments, required this.marketBoard, required this.memberDetails});
  final ScreenArguments screenArguments;
  final MarketBoard? marketBoard;
  final MemberDetails memberDetails;

 // final int index;


  @override
  State<StatefulWidget> createState() => _MarketBoardPageState();
}

class _MarketBoardPageState extends State<MarketBoardPage> {
  bool isDrawerStart = false;
  List<MarketBoard> marketBoardList = [];
  ScrollController _scrollController = ScrollController();
  bool loading= false;

  //String createdAt = '';
  int page = 0;


  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        if (!loading) {
          _loadData();
        }
      }
    });

    final bookmarkProvider = Provider.of<BookmarksProvider>(context, listen: false);
    //초기 page값은 0
    //0번째 페이지 북마크 리스트를 받아옵니다.
    bookmarkProvider.getbookmarksCounts(page);
    //0번째 페이지 게시글 리스트도 받아옵니다.
    fetchMarketArticles();
  }


  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  Future<void> _loadData() async {

    //다음 받아올 페이지를 위해 +1 해준다.
    page++;

    if (!loading) {
      setState(() {
        loading = true;
      });

      try {
        print("page is ${page}");

        // +1 된 페이지 게시글 리스트를 받아온다.
        var fetchedData = await APIs.getMarketArticles(page);

        setState(() {
          marketBoardList.addAll(fetchedData); // 기존 리스트에 추가한다.
          loading = false; // 로딩 완료
        });

        final bookmarkProvider = Provider.of<BookmarksProvider>(context, listen: false);
        // +1된 페이지 북마크 리스트를 받아온다.
        // 받아온 게시글 리스트는 addAll로 추가된 것이므로 북마크 리스트도 addAll로 추가해서 업데이트하는 로직필요
        bookmarkProvider.getMoreBookmarksCounts(page);

      } catch (e) {
        if (e == "AT-C-002") {
          await APIs.getAccessToken();
        } else {
          // 에러 처리
        }
      } finally {
        setState(() {
          loading = false;
        });
      }
    }
  }


  @override

  Future<void> fetchMarketArticles() async {
    try {
      var fetchedData = await APIs.getMarketArticles(0); // API 호출 함수 호출
      print(fetchedData);
      setState(() {
        marketBoardList = fetchedData; // 불러온 데이터를 리스트에 할당
      });
    } catch (error) {
      // 에러 처리
      print("API 호출 중 오류 발생: $error");
    }
  }


  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.height;
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
                        builder: (context) =>
                            SearchPage(screenArguments: widget.screenArguments,
                              category: "장터게시판",
                              nationCode: '',)),
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
                margin: EdgeInsets
                    .only(right: 10, left: 10, top: 10, bottom: 10)
                    .r,
                padding: EdgeInsets
                    .only(right: 10, left: 10)
                    .r,
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

    return marketBoardList.isEmpty
        ? Container(
        alignment: Alignment.center,
        child: Image(image: AssetImage("assets/illustration/loading_01.gif")))
        : ListView.separated(
      controller: _scrollController,
      itemBuilder: (BuildContext context, int index) {
        if (index < marketBoardList.length) {
          MarketBoard marketBoard = marketBoardList[index];
          String productStatusText =
          getProductStatusText(marketBoard.productStatus);
          String StatusText =
          getStatusText(marketBoard.marketArticleStatus);

          return InkWell(
            onTap: () {
              Navigator.push(

                context,
                MaterialPageRoute(
                  builder: (context) => MarketDetailPage(
                    screenArguments: widget.screenArguments,
                    marketBoard: marketBoard,
                    productStatus: getProductStatusText(
                        marketBoard.productStatus),
                    StatusText: getStatusText(
                        marketBoard.marketArticleStatus),
                    index: index, backPage: 'marketboard',
                  ),
                ),
              );
              print('${widget.marketBoard.toString()}');

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
                      image: marketBoard.imageUrls!.isEmpty ? null : DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            marketBoard.imageUrls?.first ?? ""),
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
                            '[$productStatusText]',
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
                    width: MediaQuery
                        .of(context)
                        .size
                        .width - 170.w,
                    height: 124.spMin,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '[$StatusText]',
                              style: TextStyle(
                                color: marketBoard.marketArticleStatus == '판매 중'
                                    ? Color(0xff616161)
                                    : Color(0xffFF375B),
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
                                      builder: (builder) {
                                        return MarketBoardDialog(
                                          context: context,
                                          marketBoard: marketBoard,
                                          memberDetails: widget.memberDetails,
                                          screenArguments: widget.screenArguments,
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
                          marketBoard.title ?? "",
                          style: TextStyle(fontSize: 16.spMin),
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          '${marketBoard.price.toString() ?? ""}원',
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
                            Text(
                              '${marketBoard.marketArticleBookmarkCount ?? 0}',
                              style: TextStyle(
                                fontSize: 14.spMin,
                                color: Color(0xffc1c1c1),
                              ),
                            ),
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
        } else {
          if (!loading) {
            _loadData();
          }
          return Container(
            alignment: Alignment.center,
            child: Container(
                alignment: Alignment.center,
                child: Image(image: AssetImage("assets/illustration/loading_01.gif"))),
          );
        }
      },
      separatorBuilder: (BuildContext context, int index) {
        return Container(
          height: 1.h,
          color: Color(0xffE5EBFF),
        );
      },
      itemCount: marketBoardList.length ,
    );
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

  String getStatusText(String? marketArticleStatus) {
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


}

