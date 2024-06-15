import 'dart:async';

import 'package:aliens/mockdatas/board_mockdata.dart';
import 'package:aliens/models/chatRoom_model.dart';
import 'package:aliens/models/memberDetails_model.dart';
import 'package:aliens/models/screenArgument.dart';
import 'package:aliens/providers/comment_provider.dart';
import 'package:aliens/repository/sql_message_database.dart';
import 'package:aliens/views/pages/chatting/chatting_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../apis/apis.dart';
import '../../../mockdatas/comment_mockdata.dart';
import '../../../models/comment_model.dart';
import '../../../models/board_model.dart';
import '../../../models/countries.dart';
import 'package:flutter/services.dart';

import '../../../models/message_model.dart';
import '../../../repository/board_provider.dart';
import '../../components/board_dialog_widget.dart';
import '../../components/comment_dialog_widget.dart';
import '../../components/total_article_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage(
      {super.key, required this.screenArguments, required this.category, required this.nationCode});

  final ScreenArguments screenArguments;
  final String category;
  final String nationCode;

  @override
  State<StatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _controller = TextEditingController();
  var _keyword = '';
  String boardCategory = '';
  bool searched =false;
  List<Board> searchResults = []; //검색결과


  void updateUi() async {
    setState(() {
      //텍스트폼 비우기
      _controller.clear();
      _keyword = '';
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

  Widget _ResultsWidget() {
    if (searchResults.isEmpty) {
      return Center(
        child: Container()
      );
    } else {
      return ListView.builder(
          itemCount: searchResults.length,
          itemBuilder: (context, index) {
            final board = searchResults[index];
            return Column(
              children: [
                TotalArticleWidget(
                  board: board,
                  nationCode: board.member!.nationality.toString(),
                  screenArguments: widget.screenArguments,
                  index: index,
                ),
                Divider(
                  thickness: 2,
                  color: Color(0xffE5EBFF),
                )
              ],
            );
          });
    }
  }




  @override
  Widget build(BuildContext context) {
    final commentProvider = Provider.of<CommentProvider>(context);
    final boardProvider = Provider.of<BoardProvider>(context);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              setState(() {
                Navigator.of(context).pop();
              });
            },
            icon: SvgPicture.asset(
              'assets/icon/icon_back.svg',
              color: Color(0xff616161),
              width: 24.w,
              height: MediaQuery.of(context).size.height * 0.02,
            ),
          ),
          //toolbarHeight: 90,
          title: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xffEFEFEF),
            ),
            padding: EdgeInsets.only(left: 10.w),
            child: TextFormField(
              textInputAction: TextInputAction.go,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'search1'.tr()
              ),
              onFieldSubmitted: (value) async {
                setState(() {
                  _keyword = value;
                });
                searchResults = await APIs.TotalSearch(value);
                setState(() {
                  print("검색성공");
                  searched = true;
                });
              },
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: searched == false
            ? Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/icon/icon_search.svg',
                  width: 60.r,
                  height: 60.r,
                  color: Color(0xffc1c1c1),
                ),
                Text('search2'.tr(),
                style: TextStyle(
                  fontSize: 15.spMin,
                  color: Color(0xff888888),
                  fontWeight: FontWeight.bold
                ),
                ),
              ]),
        )
            //결과 위젯
            :_ResultsWidget(),
      );
  }
}



