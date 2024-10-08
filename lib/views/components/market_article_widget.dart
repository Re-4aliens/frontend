import 'package:aliens/models/market_board_model.dart';
import 'package:aliens/models/member_details_model.dart';
import 'package:aliens/models/message_model.dart';
import 'package:aliens/models/screen_argument.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:aliens/views/pages/board/market_detail_page.dart';
import 'package:aliens/providers/board_provider.dart';
import 'package:aliens/services/user_service.dart';
import 'package:aliens/views/components/market_dialog_widget.dart';

class MarketArticleWidget extends StatefulWidget {
  const MarketArticleWidget({
    super.key,
    required this.marketBoard,
    required this.memberDetails,
    required this.screenArguments,
    required this.index,
    required this.productQualityText,
    required this.statusText,
  });

  final ScreenArguments screenArguments;
  final MarketBoard marketBoard;
  final MemberDetails memberDetails;
  final String productQualityText;
  final String statusText;
  final int index;

  @override
  State<StatefulWidget> createState() => _MarketArticleWidgetState();
}

class _MarketArticleWidgetState extends State<MarketArticleWidget> {
  String createdAt = '';
  String? email;

  @override
  void initState() {
    super.initState();
    initialize();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final boardProvider = Provider.of<BoardProvider>(context, listen: false);
      boardProvider.getLikeCounts();
    });
  }

  void initialize() async {
    final userEmail = await UserService.fetchUserEmail();

    setState(() {
      email = userEmail;
    });
  }

  @override
  Widget build(BuildContext context) {
    final boardProvider = Provider.of<BoardProvider>(context);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MarketDetailPage(
              screenArguments: widget.screenArguments,
              marketBoard: widget.marketBoard,
              index: widget.index,
              backPage: 'marketboard',
            ),
          ),
        );
      },
      child: Container(
        padding:
            EdgeInsets.only(right: 20.w, left: 20.w, top: 12.h, bottom: 12.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 100.spMin,
              height: 100.spMin,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                image: widget.marketBoard.imageUrls.isEmpty
                    ? null
                    : DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(widget.marketBoard.imageUrls.first),
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
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      color: Color(0xff7898FF),
                    ),
                    child: Text(
                      '[${widget.productQualityText}]',
                      style: TextStyle(fontSize: 10.spMin, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10.w),
            SizedBox(
              width: MediaQuery.of(context).size.width - 170.w,
              height: 110.spMin,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '[${widget.statusText}]',
                        style: TextStyle(
                          color: widget.marketBoard.saleStatus == 'SELL'
                              ? const Color(0xff616161)
                              : const Color(0xffFF375B),
                          fontSize: 16.spMin,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            DataUtils.getTime(widget.marketBoard.createdAt),
                            style: TextStyle(
                              color: const Color(0xffC1C1C1),
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
                                    marketBoard: widget.marketBoard,
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
                  SizedBox(height: 10.h),
                  Text(
                    widget.marketBoard.title,
                    style: TextStyle(fontSize: 16.spMin),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    '${widget.marketBoard.price.toString()}원',
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
                        color: const Color(0xffc1c1c1),
                      ),
                      Text(
                        '${widget.marketBoard.greatCount ?? 0}',
                        style: TextStyle(
                          fontSize: 14.spMin,
                          color: const Color(0xffc1c1c1),
                        ),
                      ),
                      SvgPicture.asset(
                        'assets/icon/icon_comment.svg',
                        width: 16.r,
                        height: 16.r,
                        color: const Color(0xffc1c1c1),
                      ),
                      Text(
                        ' ${widget.marketBoard.commentCount ?? 0}',
                        style: TextStyle(
                          fontSize: 14.spMin,
                          color: const Color(0xffc1c1c1),
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
  }
}
