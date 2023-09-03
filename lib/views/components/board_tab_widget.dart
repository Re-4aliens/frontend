import 'dart:async';

import 'package:aliens/models/chatRoom_model.dart';
import 'package:aliens/models/screenArgument.dart';
import 'package:aliens/repository/sql_message_database.dart';
import 'package:aliens/views/components/board_dialog_widget.dart';
import 'package:aliens/views/components/info_article_widget.dart';
import 'package:aliens/views/components/report_and_block_iOS_dialog_widget.dart';
import 'package:aliens/views/components/report_iOS_dialog_widget.dart';
import 'package:aliens/views/components/total_article_widget.dart';
import 'package:aliens/views/pages/chatting/chatting_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../apis/apis.dart';
import '../../mockdatas/board_mockdata.dart';
import '../../models/countries.dart';
import '../../repository/board_provider.dart';
import '../../repository/sql_message_repository.dart';
import '../pages/board/article_page.dart';

class TotalBoardWidget extends StatefulWidget {
  const TotalBoardWidget({super.key, required this.screenArguments});

  final ScreenArguments screenArguments;

  @override
  State<StatefulWidget> createState() => _TotalBoardWidgetState();
}

class _TotalBoardWidgetState extends State<TotalBoardWidget> {

  @override
  void initState() {
    final boardProvider = Provider.of<BoardProvider>(context, listen: false);
    boardProvider.getAllArticles();
  }

  @override
  Widget build(BuildContext context) {
    final boardProvider = Provider.of<BoardProvider>(context);
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: boardProvider.loading
          ? Container(
          alignment: Alignment.center,
          child: Image(
              image: AssetImage(
                  "assets/illustration/loading_01.gif")))
          : ListView.builder(
          itemCount: boardProvider.articleList!.length,
          itemBuilder: (context, index) {
            var nationCode = '';
            for (Map<String, String> country in countries) {
              if (country['name'] == boardProvider.articleList![index].member!.nationality.toString()) {
                nationCode = country['code']!;
                break;
              }
            }
            return Column(
              children: [
                TotalArticleWidget(board: boardProvider.articleList![index], nationCode: nationCode),
                Divider(
                  thickness: 2,
                  color: Color(0xffE5EBFF),
                )
              ],
            );
          }),
    );
  }


}
