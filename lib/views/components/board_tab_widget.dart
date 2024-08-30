import 'package:aliens/models/screen_argument.dart';
import 'package:aliens/views/components/total_article_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aliens/providers/board_provider.dart';

class TotalBoardWidget extends StatefulWidget {
  const TotalBoardWidget({super.key, required this.screenArguments});

  final ScreenArguments screenArguments;

  @override
  State<StatefulWidget> createState() => _TotalBoardWidgetState();
}

class _TotalBoardWidgetState extends State<TotalBoardWidget>
    with AutomaticKeepAliveClientMixin<TotalBoardWidget> {
  final ScrollController _scrollController = ScrollController();
  int page = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final boardProvider = Provider.of<BoardProvider>(context, listen: false);
      boardProvider.getAllArticles();
    });

    _scrollController.addListener(() {
      if (_scrollController.offset ==
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        page++;
        final boardProvider =
            Provider.of<BoardProvider>(context, listen: false);
        boardProvider.getMoreAllArticles(page);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // AutomaticKeepAliveClientMixin의 기능을 호출
    final boardProvider = Provider.of<BoardProvider>(context);
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: boardProvider.loading && page == 0
          ? const Center(
              child: Image(
                  image: AssetImage("assets/illustration/loading_01.gif")),
            )
          : ListView.builder(
              controller: _scrollController,
              itemCount: boardProvider.articleList.length +
                  (boardProvider.loading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == boardProvider.articleList.length) {
                  // 스크롤 끝에서 로딩 중일 때 보여줄 로딩 표시
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final board = boardProvider.articleList[index];

                return Column(
                  children: [
                    TotalArticleWidget(
                        board: board,
                        screenArguments: widget.screenArguments,
                        index: index),
                    const Divider(
                      thickness: 2,
                      color: Color(0xffE5EBFF),
                    )
                  ],
                );
              },
            ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
