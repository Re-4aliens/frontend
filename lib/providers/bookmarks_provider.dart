import 'package:aliens/mockdatas/board_mockdata.dart';
import 'package:aliens/models/board_model.dart';
import 'package:aliens/models/market_articles.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../apis/apis.dart';
import '../models/comment_model.dart';
import '../models/market_comment.dart';

class BookmarksProvider with ChangeNotifier {
  List<MarketBoard>? articleList;
  bool loading = false;
  List<MarketBoard>? bookmarksList;
  List<int>? marketArticleBookmarkCount;


  addBookmarks(int articleId, int index) async {
    loading = true;
    try {
      //좋아요 요청
      print('이건되나');
      marketArticleBookmarkCount![index] = await APIs.marketbookmark(articleId);
      print('이건???');

    } catch (e) {
      if (e == "AT-C-002") {
        await APIs.getAccessToken();
        //좋아요 요청
        marketArticleBookmarkCount![index] = await APIs.marketbookmark(articleId);

      } else {
      }
    }
    loading = false;
    notifyListeners();
    getbookmarksCounts();
    print('이것도 될라나;;');
  }

  getbookmarksCounts() async {
    final index = 0; // 원하는 페이지 번호 또는 index를 설정
    articleList = await APIs.getMarketArticles(index);
    marketArticleBookmarkCount = articleList!.map((marketboard) => marketboard.marketArticleBookmarkCount ?? 0).toList();
    print('북마크 개수: $marketArticleBookmarkCount');
  }


}