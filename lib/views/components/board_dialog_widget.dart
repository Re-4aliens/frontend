import 'package:aliens/models/member_details_model.dart';
import 'package:aliens/providers/board_provider.dart';
import 'package:aliens/views/components/report_dialog_widget.dart';
import 'package:aliens/views/components/report_ios_dialog_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:aliens/services/board_service.dart';
import 'package:aliens/services/user_service.dart'; // Import UserService
import '../../models/board_model.dart';

class BoardDialog extends StatefulWidget {
  final Board board;
  final MemberDetails memberDetails;
  final String boardCategory;

  const BoardDialog({
    Key? key,
    required this.board,
    required this.memberDetails,
    required this.boardCategory,
  }) : super(key: key);

  @override
  _BoardDialogState createState() => _BoardDialogState();
}

class _BoardDialogState extends State<BoardDialog> {
  String email = '';

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    final userEmail = await UserService.fetchUserEmail();
    setState(() {
      email = userEmail;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return androidDialog();
    } else {
      return iOSDialog();
    }
  }

  Widget androidDialog() {
    final boardProvider = Provider.of<BoardProvider>(context);
    return Dialog(
      elevation: 0,
      backgroundColor: const Color(0xffffffff),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0).r,
      ),
      child: Container(
        padding: const EdgeInsets.all(30).r,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'chatting-dialog1'.tr(),
              style: TextStyle(fontSize: 16.spMin, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 25.h,
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                showDialog(
                    context: context,
                    builder: (builder) =>
                        ReportDialog(id: widget.board.id!, context: context));
              },
              child: Container(
                padding: const EdgeInsets.all(13).r,
                decoration: BoxDecoration(
                    color: const Color(0xff7898FF),
                    borderRadius: BorderRadius.circular(5).r),
                alignment: Alignment.center,
                child: Text(
                  'chatting-report1'.tr(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              height: 25.h,
            ),
            widget.memberDetails.email == email
                ? InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (_) => FutureBuilder(
                              future:
                                  BoardService.deleteArticle(widget.board.id!),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.hasData == false) {
                                  //받아오는 동안
                                  return Container(
                                      child: const Image(
                                          image: AssetImage(
                                              "assets/illustration/loading_01.gif")));
                                } else {
                                  //받아온 후
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    switch (widget.boardCategory) {
                                      case '전체게시판':
                                        boardProvider.getAllArticles();
                                        break;
                                      case '일반게시판':
                                        boardProvider
                                            .getArticles(widget.board.category);
                                        break;
                                      case '나의 게시글':
                                        boardProvider
                                            .getArticles(widget.board.category);
                                        break;
                                      case '좋아하는 게시글':
                                        boardProvider.getLikedList();
                                        break;
                                      default:
                                    }
                                  });
                                  return Container(
                                      child: const Image(
                                          image: AssetImage(
                                              "assets/illustration/loading_01.gif")));
                                }
                              }));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(13).r,
                      decoration: BoxDecoration(
                          color: const Color(0xff7898FF),
                          borderRadius: BorderRadius.circular(5).r),
                      alignment: Alignment.center,
                      child: Text(
                        'delete'.tr(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget iOSDialog() {
    final boardProvider = Provider.of<BoardProvider>(context);
    return Dialog(
        elevation: 0,
        backgroundColor: const Color(0xffffffff),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0).r,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ).r,
              onTap: () {
                Navigator.pop(context);
                showDialog(
                    context: context,
                    builder: (builder) => iOSReportDialog(
                          memberId: widget.board.id!,
                        ));
              },
              child: Container(
                height: 80.h,
                alignment: Alignment.center,
                child: Text(
                  'chatting-report1'.tr(),
                  style: TextStyle(
                    fontSize: 16.0.spMin,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            widget.memberDetails.email == email
                ? const Divider(
                    thickness: 1,
                  )
                : const SizedBox(),
            widget.memberDetails.email == email
                ? InkWell(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    ).r,
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (_) => FutureBuilder(
                              future:
                                  BoardService.deleteArticle(widget.board.id!),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.hasData == false) {
                                  //받아오는 동안
                                  return Container(
                                      child: const Image(
                                          image: AssetImage(
                                              "assets/illustration/loading_01.gif")));
                                } else {
                                  //받아온 후
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    switch (widget.boardCategory) {
                                      case '전체게시판':
                                        boardProvider.getAllArticles();
                                        break;
                                      case '일반게시판':
                                        boardProvider
                                            .getArticles(widget.board.category);
                                        break;
                                      case '나의 게시글':
                                        boardProvider
                                            .getArticles(widget.board.category);
                                        break;
                                      case '좋아하는 게시글':
                                        boardProvider.getLikedList();
                                        break;
                                      default:
                                    }
                                  });
                                  return Container(
                                      child: const Image(
                                          image: AssetImage(
                                              "assets/illustration/loading_01.gif")));
                                }
                              }));
                    },
                    child: Container(
                      height: 80.h,
                      alignment: Alignment.center,
                      child: Text(
                        'delete'.tr(),
                        style: TextStyle(
                          fontSize: 16.0.spMin,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
        ));
  }
}
