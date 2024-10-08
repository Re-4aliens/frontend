import 'package:aliens/models/member_details_model.dart';
import 'package:aliens/models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../models/board_model.dart';
import 'package:aliens/providers/board_provider.dart';
import '../pages/board/article_page.dart';
import '../pages/board/info_article_page.dart';
import 'board_dialog_widget.dart';
import 'package:aliens/services/user_service.dart';

class ArticleWidget extends StatefulWidget {
  const ArticleWidget(
      {super.key,
      required this.board,
      required this.nationCode,
      required this.memberDetails,
      required this.index});

  final Board board;
  final String nationCode;
  final MemberDetails memberDetails;
  final int index;

  @override
  State<StatefulWidget> createState() => _ArticleWidgetState();
}

class _ArticleWidgetState extends State<ArticleWidget> {
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

    return GestureDetector(
      onTap: () {
        widget.board.category == "INFO"
            ? Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => InfoArticlePage(board: widget.board)),
              )
            : Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ArticlePage(
                    board: widget.board,
                    memberDetails: widget.memberDetails,
                    index: widget.index,
                    isTotal: false,
                  ),
                ),
              );
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
                              '${widget.board.memberProfileDto?.name}/${widget.nationCode}',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.spMin),
                            ),
                          ],
                        ),
                      ],
                    ),
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
                                memberDetails: widget.memberDetails,
                                isTotal: false,
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
                    ),
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
                      widget.board.category == "INFO"
                          ? SizedBox(height: 5.h)
                          : Padding(
                              padding:
                                  const EdgeInsets.only(top: 5, bottom: 10).h,
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
                  onTap: () {
                    boardProvider.addLike(widget.board.id!, widget.index, false,
                        widget.board.category);
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
            ),
          ],
        ),
      ),
    );
  }
}
