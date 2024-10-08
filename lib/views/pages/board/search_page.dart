import 'package:aliens/models/screen_argument.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import 'package:aliens/providers/board_provider.dart';
import '../../components/total_article_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({
    super.key,
    required this.screenArguments,
    required this.category,
  });

  final ScreenArguments screenArguments;
  final String category;

  @override
  State<StatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final ScrollController _scrollController = ScrollController();
  final _controller = TextEditingController();
  var _keyword = '';
  bool searched = false;
  int page = 0; // 페이지 관리 변수
  bool isLoadingMore = false; // 추가 데이터 로딩 중 여부

  @override
  void initState() {
    super.initState();

    // 스크롤 리스너 추가
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !isLoadingMore) {
        setState(() {
          isLoadingMore = true;
        });
        page++; // 페이지 증가
        await _loadMoreSearchResults(); // 서버에 더 많은 데이터 요청
        setState(() {
          isLoadingMore = false;
        });
      }
    });
  }

  Future<void> _loadMoreSearchResults() async {
    final boardProvider = Provider.of<BoardProvider>(context, listen: false);
    await boardProvider.getMoreSearchArticles(_keyword, page);
    setState(() {
      // 추가된 데이터를 표시하기 위해 상태 업데이트
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _ResultsWidget() {
    final boardProvider = Provider.of<BoardProvider>(context);
    if (boardProvider.articleList.isEmpty) {
      return Center(child: Container());
    } else {
      return ListView.builder(
          controller: _scrollController, // 스크롤 컨트롤러 추가
          itemCount: boardProvider.articleList.length,
          itemBuilder: (context, index) {
            final board = boardProvider.articleList[index];
            return Column(
              children: [
                TotalArticleWidget(
                  board: board,
                  screenArguments: widget.screenArguments,
                  index: index,
                ),
                const Divider(
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
    final boardProvider = Provider.of<BoardProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: SvgPicture.asset(
            'assets/icon/icon_back.svg',
            color: const Color(0xff616161),
            width: 24.w,
            height: MediaQuery.of(context).size.height * 0.02,
          ),
        ),
        title: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xffEFEFEF),
          ),
          padding: EdgeInsets.only(left: 10.w),
          child: TextFormField(
            textInputAction: TextInputAction.go,
            controller: _controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'search1'.tr(),
            ),
            onFieldSubmitted: (value) async {
              setState(() {
                _keyword = value;
                page = 0; // 페이지 초기화
                searched = true;
              });
              final boardProvider =
                  Provider.of<BoardProvider>(context, listen: false);
              await boardProvider.getSearchArticles(_keyword); // 초기 검색 데이터 요청
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
                      color: const Color(0xffc1c1c1),
                    ),
                    Text(
                      'search2'.tr(),
                      style: TextStyle(
                        fontSize: 15.spMin,
                        color: const Color(0xff888888),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]),
            )
          : _ResultsWidget(), // 검색 결과 위젯 표시
    );
  }
}
