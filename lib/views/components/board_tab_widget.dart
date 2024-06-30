import 'package:aliens/models/screen_argument.dart';
import 'package:aliens/views/components/total_article_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/countries.dart';
import 'package:aliens/providers/board_provider.dart';

class TotalBoardWidget extends StatefulWidget {
  const TotalBoardWidget({super.key, required this.screenArguments});

  final ScreenArguments screenArguments;

  @override
  State<StatefulWidget> createState() => _TotalBoardWidgetState();
}

class _TotalBoardWidgetState extends State<TotalBoardWidget> {
  final ScrollController _scrollController = ScrollController();
  int page = 0;

  @override
  void initState() {
    super.initState();
    final boardProvider = Provider.of<BoardProvider>(context, listen: false);
    boardProvider.getAllArticles();

    _scrollController.addListener(() {
      if (_scrollController.offset ==
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        print('추가');
        page++;
        boardProvider.getMoreAllArticles(page);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final boardProvider = Provider.of<BoardProvider>(context);
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: boardProvider.loading
          ? Container(
              alignment: Alignment.center,
              child: const Image(
                  image: AssetImage("assets/illustration/loading_01.gif")))
          : ListView.builder(
              controller: _scrollController,
              itemCount: boardProvider.articleList.length,
              itemBuilder: (context, index) {
                var nationCode = '';
                final memberNationality = boardProvider
                    .articleList[index].memberProfileDto?.nationality
                    .toString();
                for (Map<String, String> country in countries) {
                  if (country['name']!.toUpperCase() == memberNationality) {
                    nationCode = country['code'] ?? '';
                    break;
                  }
                }

                final board = boardProvider.articleList[index];

                return Column(
                  children: [
                    TotalArticleWidget(
                        board: board,
                        nationCode: nationCode,
                        screenArguments: widget.screenArguments,
                        index: index),
                    const Divider(
                      thickness: 2,
                      color: Color(0xffE5EBFF),
                    )
                  ],
                );
              }),
    );
  }
}
