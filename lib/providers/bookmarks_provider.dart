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
      marketArticleBookmarkCount![index] = await APIs.marketbookmark(articleId, index);
      print('이건???');

    } catch (e) {
      if (e == "AT-C-002") {
        await APIs.getAccessToken();
        //좋아요 요청
        marketArticleBookmarkCount![index] = await APIs.marketbookmark(articleId, index);

      } else {
      }
    }
    loading = false;
    notifyListeners();
    getbookmarksCounts(0);
  }

  getbookmarksCounts(int page) async {
    //final index = 0; // 원하는 페이지 번호 또는 index를 설정
    articleList = await APIs.getMarketArticles(page);
    marketArticleBookmarkCount = articleList!.map((marketboard) => marketboard.marketArticleBookmarkCount ?? 0).toList();
    print('북마크 개수: ${marketArticleBookmarkCount?.length}');
  }

  getMoreBookmarksCounts(int page) async {
    // 새로운 게시글 리스트를 받아옵니다.
    List<MarketBoard>? newArticles = await APIs.getMarketArticles(page);

    // 받아온 게시글 리스트가 null이거나 비어있지 않은 경우에만 처리합니다.
    if (newArticles != null && newArticles.isNotEmpty) {
      // 기존 게시글 리스트에 새로운 게시글을 추가합니다.
      articleList!.addAll(newArticles);

      // 북마크 카운트를 업데이트합니다.
      marketArticleBookmarkCount!.addAll(newArticles.map((marketboard) => marketboard.marketArticleBookmarkCount ?? 0).toList());

      print('북마크 개수: ${marketArticleBookmarkCount?.length}');
    }
  }



}