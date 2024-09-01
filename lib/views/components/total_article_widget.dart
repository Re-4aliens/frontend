import 'package:aliens/services/market_service.dart';
import 'package:aliens/models/market_board_model.dart';
import 'package:aliens/models/message_model.dart';
import 'package:aliens/models/screen_argument.dart';
import 'package:aliens/views/pages/board/info_article_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../models/board_model.dart';
import 'package:aliens/providers/bookmarks_provider.dart';
import 'package:aliens/providers/board_provider.dart';
import '../pages/board/article_page.dart';
import '../pages/board/market_detail_page.dart';
import 'board_dialog_widget.dart';
import 'package:aliens/models/countries.dart';

class TotalArticleWidget extends StatefulWidget {
  const TotalArticleWidget(
      {super.key,
      required this.board,
      required this.screenArguments,
      required this.index,
      this.marketBoard});

  final Board board;
  final ScreenArguments screenArguments;
  final MarketBoard? marketBoard;
  final int index;

  @override
  State<StatefulWidget> createState() => _TotalArticleWidgetState();
}

class _TotalArticleWidgetState extends State<TotalArticleWidget> {
  String createdAt = '';
  String boardCategory = '';
  List<Board> articles = [];

  @override
  void initState() {
    super.initState();
    final boardProvider = Provider.of<BoardProvider>(context, listen: false);
    final bookmarkProvider =
        Provider.of<BookmarksProvider>(context, listen: false);

    boardProvider.getLikeCounts();
    bookmarkProvider.getbookmarksCounts(0);

    print(widget.board.category);

    switch (widget.board.category) {
      case 'FREE':
        boardCategory = 'free-posting'.tr();
        break;
      case 'FOOD':
        boardCategory = 'food'.tr();
        break;
      case 'MUSIC':
        boardCategory = 'music'.tr();
        break;
      case 'FASHION':
        boardCategory = 'fashion'.tr();
        break;
      case 'GAME':
        boardCategory = 'game'.tr();
        break;
      case 'INFO':
        boardCategory = 'info'.tr();
        break;
      case 'MARKET':
        boardCategory = 'market'.tr();
        break;
      default:
    }
  }

  String getNationCode(nationality) {
    var nationCode = '';
    for (Map<String, String> country in countries) {
      if (country['name']! == nationality) {
        nationCode = country['code']!;
        break;
      }
    }
    return nationCode;
  }

  @override
  Widget build(BuildContext context) {
    final boardProvider = Provider.of<BoardProvider>(context);

    return GestureDetector(
      onTap: () {
        if (widget.board.category == "INFO") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InfoArticlePage(board: widget.board),
            ),
          );
        } else if (widget.board.category == "MARKET") {
          MarketService.getMarketArticle(widget.board.id!).then((data) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MarketDetailPage(
                  screenArguments: widget.screenArguments,
                  marketBoard: data,
                  index: -1,
                  backPage: '',
                ),
              ),
            ).then((value) => boardProvider.getAllArticles());
          });
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArticlePage(
                board: widget.board,
                memberDetails: widget.screenArguments.memberDetails,
                index: widget.index,
              ),
            ),
          );
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 15).r,
                      child: widget.board.memberProfileDto == null
                          ? SvgPicture.asset(
                              'assets/icon/icon_profile.svg',
                              width: 30.r,
                              color: const Color(0xff7898ff),
                            )
                          : Container(
                              height: 30.r,
                              width: 30.r,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(widget
                                      .board.memberProfileDto!.profileImageUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text(
                              widget.board.memberProfileDto?.name ?? '',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.spMin),
                            ),
                            Text(
                              '/',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.spMin),
                            ),
                            Text(
                              getNationCode(
                                  widget.board.memberProfileDto?.nationality),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.spMin),
                            )
                          ],
                        ),
                        Text(
                          '[$boardCategory]',
                          style: TextStyle(
                              color: const Color(0xff888888),
                              fontSize: 12.spMin),
                        )
                      ],
                    )
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      DataUtils.getTime(widget.board.createdAt),
                      style: TextStyle(
                          fontSize: 16.spMin, color: const Color(0xffc1c1c1)),
                    ),
                    InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (builder) {
                              return BoardDialog(
                                board: widget.board,
                                memberDetails:
                                    widget.screenArguments.memberDetails,
                                boardCategory: "전체게시판",
                              );
                            });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0).w,
                        child: SvgPicture.asset(
                          'assets/icon/ICON_more.svg',
                          width: 25.r,
                          height: 25.r,
                          color: const Color(0xffc1c1c1),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(height: 5.h), // 간격 조정
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5).h,
                        child: Text(
                          widget.board.title,
                          style: TextStyle(
                              fontSize: 14.spMin,
                              color: const Color(0xff444444),
                              fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                      widget.board.category == "정보게시판"
                          ? SizedBox(
                              height: 5.h,
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.only(top: 5, bottom: 10.0).h,
                              child: Text(
                                widget.board.content,
                                style: TextStyle(
                                    fontSize: 14.spMin,
                                    color: const Color(0xff616161)),
                                maxLines: 2,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                    ],
                  ),
                ),
                widget.board.imageUrls.isEmpty
                    ? const SizedBox()
                    : Container(
                        margin: const EdgeInsets.only(left: 10).w,
                        height: 70.h,
                        width: 70.h,
                        decoration: BoxDecoration(
                          color: const Color(0xfff8f8f8),
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: NetworkImage(widget.board.imageUrls[0]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
              ],
            ),
            SizedBox(height: 5.h), // 간격 조정
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    if (widget.board.category != "장터게시판") {
                      boardProvider.addLike(widget.board.id!, widget.index);
                    } else {
                      boardProvider.greatCounts[widget.index] =
                          await MarketService.marketBookmark(
                              widget.board.id!, widget.index);
                    }
                    setState(() {});
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 4.0, right: 4.0, left: 4.0)
                            .r,
                    child: SvgPicture.asset(
                      'assets/icon/ICON_good.svg',
                      width: 25.r,
                      height: 25.r,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4, right: 15).w,
                  child: boardProvider.greatCounts[widget.index] == 0
                      ? const Text('')
                      : Text('${boardProvider.greatCounts[widget.index]}'),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 4.0, right: 4.0, left: 4.0).r,
                  child: SvgPicture.asset(
                    'assets/icon/icon_comment.svg',
                    width: 25.r,
                    height: 25.r,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 4.0, right: 4.0, left: 4.0).r,
                  child: widget.board.commentCount == 0
                      ? const Text('')
                      : Text('${widget.board.commentCount}'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  String getProductStatusText(String? productQuality) {
    List<String> whatStatus = [
      'Brand_New'.tr(),
      'Almost_New'.tr(),
      'Slight_Defect'.tr(),
      'Used'.tr(),
    ];

    switch (productQuality) {
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

  String getStatusText(String? saleStatus) {
    List<String> Status = [
      'sale'.tr(),
      'sold-out'.tr(),
    ];

    switch (saleStatus) {
      case '판매 중':
        return Status[0];
      case '판매 완료':
        return Status[1];
      default:
        return '';
    }
  }
}
