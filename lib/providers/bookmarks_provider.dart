import 'package:aliens/models/market_board_model.dart';
import 'package:flutter/widgets.dart';
import 'package:aliens/services/auth_service.dart';
import 'package:aliens/services/market_service.dart';

class BookmarksProvider with ChangeNotifier {
  List<MarketBoard>? articleList;
  bool loading = false;
  List<MarketBoard>? bookmarksList;
  List<int>? greatCount;

  addBookmarks(int articleId, int index) async {
    loading = true;
    try {
      //좋아요 요청
      greatCount![index] = await MarketService.marketBookmark(articleId, index);
    } catch (e) {
      if (e == "AT-C-002") {
        await AuthService.getAccessToken();
        //좋아요 요청
        greatCount![index] =
            await MarketService.marketBookmark(articleId, index);
      } else {
        // 다른 예외 처리
      }
    }
    loading = false;
    notifyListeners();
    getbookmarksCounts(0);
  }

  getbookmarksCounts(int page) async {
    articleList = await MarketService.getMarketArticles(page);
    greatCount =
        articleList?.map((marketboard) => marketboard.greatCount ?? 0).toList();
    notifyListeners();
  }

  getMoreBookmarksCounts(int page) async {
    // 새로운 게시글 리스트를 받아옵니다.
    List<MarketBoard>? newArticles =
        await MarketService.getMarketArticles(page);

    // 받아온 게시글 리스트가 null이거나 비어있지 않은 경우에만 처리합니다.
    if (newArticles.isNotEmpty) {
      // 기존 게시글 리스트에 새로운 게시글을 추가합니다.
      articleList?.addAll(newArticles);

      // 북마크 카운트를 업데이트합니다.
      greatCount?.addAll(newArticles
          .map((marketboard) => marketboard.greatCount ?? 0)
          .toList());

      print('북마크 개수: ${greatCount?.length}');
      notifyListeners();
    }
  }
}
