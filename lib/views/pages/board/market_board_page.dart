import 'dart:async';
import 'package:aliens/models/member_details_model.dart';
import 'package:aliens/models/screen_argument.dart';
import 'package:aliens/views/components/market_article_widget.dart';
import 'package:aliens/views/pages/board/search_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../models/market_board_model.dart';
import 'package:aliens/providers/market_provider.dart';
import '../../components/board_drawer_widget.dart';
import 'package:aliens/services/user_service.dart';

class MarketBoardPage extends StatefulWidget {
  const MarketBoardPage(
      {super.key,
      required this.screenArguments,
      required this.marketBoard,
      required this.memberDetails});
  final ScreenArguments screenArguments;
  final MarketBoard? marketBoard;
  final MemberDetails memberDetails;

  @override
  State<StatefulWidget> createState() => _MarketBoardPageState();
}

class _MarketBoardPageState extends State<MarketBoardPage> {
  final ScrollController _scrollController = ScrollController();
  MemberDetails? memberDetails;
  bool isDrawerStart = false;
  int page = 0;

  @override
  void initState() {
    super.initState();
    fetchMemberDetails();
    final marketProvider = Provider.of<MarketProvider>(context, listen: false);
    marketProvider.getMarketArticles();

    _scrollController.addListener(() {
      if (_scrollController.offset ==
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        page++;
        marketProvider.getMoreMarketArticles(page);
      }
    });
  }

  Future<void> fetchMemberDetails() async {
    try {
      final details = await UserService.getMemberDetails();
      setState(() {
        memberDetails = details;
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final marketProvider = Provider.of<MarketProvider>(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff7898ff),
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
                  )),
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
              )),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SearchPage(
                              screenArguments: widget.screenArguments,
                              category: "MARKET",
                            )),
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
                      margin: const EdgeInsets.only(
                              right: 10, left: 10, top: 10, bottom: 10)
                          .r,
                      padding: const EdgeInsets.only(right: 10, left: 10).r,
                      width: double.infinity,
                      height: 42.spMin,
                      decoration: BoxDecoration(
                        color: const Color(0xffE7E7E7),
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
                                color: const Color(0xff616161),
                                width: 18.spMin,
                                height: 18.spMin,
                              ),
                              Text(
                                '  ${'market-noti'.tr()}',
                                style: TextStyle(
                                    fontSize: 14.spMin,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xff616161)),
                              )
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 18.spMin,
                            color: const Color(0xffC1C1C1),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        controller: _scrollController,
                        itemCount: marketProvider.articleList.length,
                        itemBuilder: (context, index) {
                          MarketBoard marketBoard =
                              marketProvider.articleList[index];

                          return Column(
                            children: [
                              MarketArticleWidget(
                                marketBoard: marketBoard,
                                memberDetails:
                                    widget.screenArguments.memberDetails,
                                screenArguments: widget.screenArguments,
                                index: index,
                                productQualityText: getProductStatusText(
                                    marketBoard.productQuality),
                                statusText:
                                    getStatusText(marketBoard.saleStatus),
                              ),
                              const Divider(
                                thickness: 2,
                                color: Color(0xffE5EBFF),
                              )
                            ],
                          );
                        }),
                  )
                ],
              ));
  }

  String getProductStatusText(String? productQuality) {
    List<String> whatStatus = [
      'BRAND_NEW'.tr(),
      'ALMOST_NEW'.tr(),
      'SLIGHT_DEFECT'.tr(),
      'USED'.tr(),
    ];

    switch (productQuality) {
      case 'BRAND_NEW':
        return whatStatus[0];
      case 'ALMOST_NEW':
        return whatStatus[1];
      case 'SLIGHT_DEFECT':
        return whatStatus[2];
      case 'USED':
        return whatStatus[3];
      default:
        return '';
    }
  }

  String getStatusText(String? saleStatus) {
    List<String> status = [
      'SELL'.tr(),
      'END'.tr(),
    ];

    switch (saleStatus) {
      case 'SELL':
        return status[0];
      case 'END':
        return status[1];
      default:
        return '';
    }
  }
}
