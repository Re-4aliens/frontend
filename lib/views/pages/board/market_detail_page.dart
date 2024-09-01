import 'package:aliens/services/market_service.dart';
import 'package:aliens/models/market_board_model.dart';
import 'package:aliens/models/screen_argument.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../models/countries.dart';
import 'package:flutter/services.dart';
import '../../../models/message_model.dart';
import 'package:aliens/providers/bookmarks_provider.dart';
import 'package:aliens/providers/market_comment_provider.dart';
import '../../components/board_drawer_widget.dart';
import '../../components/marketcomment_dialog.dart';
import 'market_board_page.dart';

class MarketDetailPage extends StatefulWidget {
  const MarketDetailPage(
      {super.key,
      required this.screenArguments,
      required this.marketBoard,
      required this.index,
      required this.backPage});
  final ScreenArguments screenArguments;
  final MarketBoard marketBoard;
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

  String getNationCode(nationality) {
    var nationCode = '';
    for (Map<String, String> country in countries) {
      if (country['name'] == nationality) {
        nationCode = country['code']!;
        break;
      }
    }
    return nationCode;
  }

  @override
  void initState() {
    super.initState();
    final marketcommentProvider =
        Provider.of<MarketCommentProvider>(context, listen: false);
    marketcommentProvider.getMarketComments(widget.marketBoard.id ?? -1);
    if (widget.index == -1) {
      bookmark = widget.marketBoard.greatCount!;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> whatStatus = [
      'BRAND_NEW'.tr(),
      'ALMOST_NEW'.tr(),
      'SLIGHT_DEFECT'.tr(),
      'USED'.tr()
    ];
    String productQuality = widget.marketBoard.productQuality;
    String statusText = widget.marketBoard.saleStatus;

    final marketcommentProvider = Provider.of<MarketCommentProvider>(context);
    final bookmarkProvider = Provider.of<BookmarksProvider>(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        setState(() {
          isNestedComments = false;
          parentsCommentId = -1;
        });
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color(0xff7898ff),
          toolbarHeight: 56,
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
                          memberDetails: widget.screenArguments.memberDetails),
                    ));
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
                icon: const Icon(Icons.format_list_bulleted_outlined),
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
        ),
        body: isDrawerStart
            ? BoardDrawerWidget(
                screenArguments: widget.screenArguments,
                isTotalBoard: false,
                onpressd: () {},
              )
            : Column(children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding:
                          EdgeInsets.only(right: 24.w, left: 24.w, top: 12.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.marketBoard.title,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.spMin,
                                      color: Colors.black),
                                ),
                              ),
                              Container(
                                width: 80.spMin,
                                height: 35.spMin,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(
                                      color: const Color(0xFFEBEBEB)),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      getstatusText(statusText),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: const Color(0xff888888),
                                          fontSize: 14.spMin),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ), //제목 넣는 곳
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          Divider(
                            thickness: 1.h,
                            color: const Color(0xffebebeb),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          Row(
                            children: [
                              Text(
                                '₩ ',
                                style: TextStyle(
                                    fontSize: 16.spMin,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                widget.marketBoard.price.toString(),
                                style: TextStyle(
                                    fontSize: 16.spMin,
                                    fontWeight: FontWeight.bold),
                              ) //가격넣는곳
                            ],
                          ), //가격
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          Divider(
                            thickness: 1.h,
                            color: const Color(0xffebebeb),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.005),
                          Row(
                            children: [
                              Text(
                                'market-productQuality'.tr(),
                                style: TextStyle(
                                  fontSize: 16.spMin,
                                  color: const Color(0xff888888),
                                ),
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: whatStatus.map((condition) {
                                      final bool isSelected =
                                          getProductstatusText(
                                                  productQuality) ==
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
                                                  : const Color(0xffC1C1C1),
                                            ),
                                          ),
                                          selected: isSelected,
                                          backgroundColor: isSelected
                                              ? const Color(0xff7898FF)
                                              : Colors.white,
                                          selectedColor:
                                              const Color(0xff7898ff),
                                          onSelected: (isSelected) {
                                            setState(() {
                                              productQuality =
                                                  isSelected ? condition : '';
                                            });
                                          },
                                          labelPadding: EdgeInsets.only(
                                              left: 12.w, right: 12.w),
                                          // 선택 영역 패딩 조절
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                              color: isSelected
                                                  ? const Color(0xff7898FF)
                                                  : const Color(0xffC1C1C1),
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                20), // 선택 테두리 둥글기 조절
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ],
                          ), //상품상태넣는 곳
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.005),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children:
                                  widget.marketBoard.imageUrls.map((imageUrl) {
                                return Container(
                                  margin: const EdgeInsets.only(right: 20).r,
                                  width: 197.spMin,
                                  height: 207.spMin,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10).r,
                                    color: const Color(0xffF8F8F8),
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
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.02),
                          Text(
                            widget.marketBoard.content, //내용
                            textAlign: TextAlign.start,
                            style: TextStyle(fontSize: 16.spMin),
                          ), //내용 넣는 곳
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.02),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                DataUtils.getTime(
                                    widget.marketBoard.createdAt), //createdAt
                                style: TextStyle(
                                  color: const Color(0xffa8a8a8),
                                  fontSize: 16.spMin,
                                ),
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      if (widget.index == -1) {
                                        bookmark =
                                            await MarketService.marketBookmark(
                                                widget.marketBoard.id!,
                                                widget.index);
                                      } else {
                                        bookmarkProvider.addBookmarks(
                                            widget.marketBoard.id!,
                                            widget.index);
                                      }
                                      setState(() {});
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0).r,
                                      child: SvgPicture.asset(
                                        'assets/icon/ICON_good.svg',
                                        width: 18.r,
                                        height: 18.r,
                                        color: const Color(0xffc1c1c1),
                                      ),
                                    ),
                                  ),
                                  widget.index == -1
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                                  left: 4, right: 15)
                                              .r,
                                          child: Text('$bookmark',
                                              style: TextStyle(
                                                  fontSize: 16.spMin,
                                                  color:
                                                      const Color(0xffc1c1c1))),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.only(
                                                  left: 4, right: 15)
                                              .r,
                                          child: bookmarkProvider.greatCount![
                                                      widget.index] ==
                                                  0
                                              ? Text('0',
                                                  style: TextStyle(
                                                      fontSize: 16.spMin,
                                                      color: const Color(
                                                          0xffc1c1c1)))
                                              : Text(
                                                  '${bookmarkProvider.greatCount![widget.index]}',
                                                  style: TextStyle(
                                                      fontSize: 16.spMin,
                                                      color: const Color(
                                                          0xffc1c1c1))),
                                        ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0).r,
                                    child: SvgPicture.asset(
                                      'assets/icon/icon_comment.svg',
                                      width: 18.r,
                                      height: 18.r,
                                      color: const Color(0xffc1c1c1),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0).r,
                                    child: Text(
                                      '${widget.marketBoard.commentCount}',
                                      style: TextStyle(
                                          fontSize: 16.spMin,
                                          color: const Color(0xffc1c1c1)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Divider(
                            thickness: 1.2.h,
                            color: const Color(0xffE5EBFF),
                          ),

                          //댓글
                          marketcommentProvider.loading ||
                                  marketcommentProvider.commentListData == null
                              ? Container(
                                  alignment: Alignment.center,
                                  child: const Image(
                                      image: AssetImage(
                                          "assets/illustration/loading_01.gif")))
                              : Column(
                                  children: [
                                    for (int index = 0;
                                        index <
                                            marketcommentProvider
                                                .commentListData!.length;
                                        index++)
                                      Container(
                                        child: Column(
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                          vertical: 15,
                                                          horizontal: 30)
                                                      .r,
                                              color: parentsCommentId ==
                                                      marketcommentProvider
                                                          .commentListData![
                                                              index]
                                                          .id
                                                  ? const Color(0xffF5F7FF)
                                                  : Colors.white,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            10.0)
                                                                    .r,
                                                            child: widget
                                                                        .marketBoard
                                                                        .memberProfileDto ==
                                                                    null
                                                                ? SvgPicture
                                                                    .asset(
                                                                    'assets/icon/icon_profile.svg',
                                                                    width: 25.r,
                                                                    color: const Color(
                                                                        0xffc1c1c1),
                                                                  )
                                                                : Container(
                                                                    height:
                                                                        25.r,
                                                                    width: 25.r,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      image:
                                                                          DecorationImage(
                                                                        image: NetworkImage(widget
                                                                            .marketBoard
                                                                            .memberProfileDto!
                                                                            .profileImageUrl),
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                  ),
                                                          ),
                                                          Text(
                                                            marketcommentProvider
                                                                .commentListData![
                                                                    index]
                                                                .memberProfileDto
                                                                .name,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize:
                                                                    14.spMin),
                                                          ),
                                                          Text(
                                                            '/',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize:
                                                                    14.spMin),
                                                          ),
                                                          Text(
                                                            getNationCode(marketcommentProvider
                                                                .commentListData![
                                                                    index]
                                                                .memberProfileDto
                                                                .nationality),
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize:
                                                                    14.spMin),
                                                          )
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Text(
                                                            DataUtils.getTime(
                                                                marketcommentProvider
                                                                    .commentListData![
                                                                        index]
                                                                    .createdAt),
                                                            style: TextStyle(
                                                                fontSize:
                                                                    12.spMin,
                                                                color: const Color(
                                                                    0xffc1c1c1)),
                                                          ),
                                                          InkWell(
                                                            onTap: () {
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (builder) {
                                                                    return MarketCommentDialog(
                                                                      context:
                                                                          context,
                                                                      onpressed:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          isNestedComments =
                                                                              true;
                                                                          parentsCommentId = marketcommentProvider
                                                                              .commentListData![index]
                                                                              .id;
                                                                        });
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      isNestedComment:
                                                                          false,
                                                                      marketcomment:
                                                                          marketcommentProvider
                                                                              .commentListData![index],
                                                                    );
                                                                  });
                                                            },
                                                            child: Padding(
                                                              padding: const EdgeInsets
                                                                          .only(
                                                                      left: 8.0)
                                                                  .r,
                                                              child: SvgPicture
                                                                  .asset(
                                                                'assets/icon/ICON_more.svg',
                                                                width: 25.r,
                                                                height: 25.r,
                                                                color: const Color(
                                                                    0xffc1c1c1),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                                top: 13)
                                                            .r,
                                                    child: Text(
                                                      marketcommentProvider
                                                          .commentListData![
                                                              index]
                                                          .content,
                                                      style: TextStyle(
                                                          fontSize: 14.spMin,
                                                          color: const Color(
                                                              0xff616161)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            //대댓글
                                            marketcommentProvider
                                                        .commentListData![index]
                                                        .children ==
                                                    null
                                                ? const SizedBox()
                                                : Column(
                                                    children: [
                                                      for (int j = 0;
                                                          j <
                                                              marketcommentProvider
                                                                  .commentListData![
                                                                      index]
                                                                  .children!
                                                                  .length;
                                                          j++)
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Expanded(
                                                              child: Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(10)
                                                                        .r,
                                                                alignment: Alignment
                                                                    .centerRight,
                                                                child:
                                                                    SvgPicture
                                                                        .asset(
                                                                  'assets/icon/ICON_reply.svg',
                                                                  width: 15.r,
                                                                  height: 15.r,
                                                                  color: const Color(
                                                                      0xffc1c1c1),
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: const Color(
                                                                    0xffF4F4F4),
                                                                borderRadius:
                                                                    BorderRadius
                                                                            .circular(10)
                                                                        .r,
                                                              ),
                                                              width: 300.w,
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          15.h,
                                                                      horizontal:
                                                                          20.w),
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      top: 15.h,
                                                                      bottom:
                                                                          0.h,
                                                                      right:
                                                                          30.w,
                                                                      left: 0),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.only(right: 10.0).w,
                                                                        child: widget.marketBoard.memberProfileDto ==
                                                                                null
                                                                            ? SvgPicture.asset(
                                                                                'assets/icon/icon_profile.svg',
                                                                                width: 25.r,
                                                                                color: const Color(0xffc1c1c1),
                                                                              )
                                                                            : Container(
                                                                                height: 25.r,
                                                                                width: 25.r,
                                                                                decoration: BoxDecoration(
                                                                                  shape: BoxShape.circle,
                                                                                  image: DecorationImage(
                                                                                    image: NetworkImage(widget.marketBoard.memberProfileDto!.profileImageUrl),
                                                                                    fit: BoxFit.cover,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                      ),
                                                                      Flexible(
                                                                        child:
                                                                            Container(
                                                                          alignment:
                                                                              Alignment.centerLeft,
                                                                          padding:
                                                                              const EdgeInsets.only(right: 10),
                                                                          child:
                                                                              Text(
                                                                            '${marketcommentProvider.commentListData![index].children![j].memberProfileDto.name}/${getNationCode(marketcommentProvider.commentListData![index].children![j].memberProfileDto.nationality)}',
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            style:
                                                                                TextStyle(fontWeight: FontWeight.bold, fontSize: 14.spMin),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        DataUtils.getTime(marketcommentProvider
                                                                            .commentListData![index]
                                                                            .children![j]
                                                                            .createdAt),
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                12.spMin,
                                                                            color: const Color(0xffc1c1c1)),
                                                                      ),
                                                                      InkWell(
                                                                        onTap:
                                                                            () {
                                                                          showDialog(
                                                                              context: context,
                                                                              builder: (builder) {
                                                                                return MarketCommentDialog(
                                                                                    context: context,
                                                                                    onpressed: () {
                                                                                      setState(() {
                                                                                        isNestedComments = true;
                                                                                      });
                                                                                      Navigator.pop(context);
                                                                                    },
                                                                                    isNestedComment: true,
                                                                                    marketcomment: marketcommentProvider.commentListData![index]);
                                                                              });
                                                                        },
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.only(left: 8.0).w,
                                                                          child:
                                                                              SvgPicture.asset(
                                                                            'assets/icon/ICON_more.svg',
                                                                            width:
                                                                                22.r,
                                                                            height:
                                                                                22.r,
                                                                            color:
                                                                                const Color(0xffc1c1c1),
                                                                          ),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets.only(top: 5)
                                                                            .h,
                                                                    child: Text(
                                                                      marketcommentProvider
                                                                          .commentListData![
                                                                              index]
                                                                          .children![
                                                                              j]
                                                                          .content,
                                                                      style: TextStyle(
                                                                          fontSize: 14
                                                                              .spMin,
                                                                          color:
                                                                              const Color(0xff616161)),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                    ],
                                                  ),
                                            const Divider(
                                              thickness: 1.5,
                                              color: Color(0xfff8f8f8),
                                            )
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
                  padding: const EdgeInsets.symmetric(
                    vertical: 30,
                    horizontal: 20,
                  ).r,
                  child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xffefefef),
                        borderRadius: BorderRadius.circular(10).r,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10).w,
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
                              hintText: isNestedComments
                                  ? "comment2".tr()
                                  : "comment1".tr(),
                              hintStyle:
                                  const TextStyle(color: Color(0xffb1b1b1)),
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
                              if (_newComment != '') {
                                if (isNestedComments) {
                                  marketcommentProvider.addNestedMarketComment(
                                      _newComment,
                                      parentsCommentId,
                                      widget.marketBoard.id!);
                                  //여기 페이지 재로드하는거나 marketcommentprovider 재로드를 넣어야할거같아
                                  parentsCommentId = -1;
                                  isNestedComments = false;
                                } else {
                                  marketcommentProvider.addMarketComment(
                                      _newComment, widget.marketBoard.id!);
                                }
                                updateUi();
                              }
                            },
                            icon: SvgPicture.asset(
                              'assets/icon/ICON_send.svg',
                              height: 22.r,
                              color: _newComment.trim().isEmpty
                                  ? const Color(0xffc1c1c1)
                                  : const Color(0xff7898ff),
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

String getProductstatusText(String? productQuality) {
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

String getstatusText(String? saleStatus) {
  List<String> Status = [
    'SELL'.tr(),
    'END'.tr(),
  ];

  switch (saleStatus) {
    case 'SELL':
      return Status[0];
    case 'END':
      return Status[1];
    default:
      return '';
  }
}
