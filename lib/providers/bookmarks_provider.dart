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
    articleList = await APIs.getMarketArticles();
    marketArticleBookmarkCount = articleList!.map((marketboard) => marketboard.marketArticleBookmarkCount ?? 0).toList();
    //print(marketboard.marketArticleBookmarkCount ?? 0);
   // print('북마크개수:${marketArticleBookmarkCount}');
  }

}