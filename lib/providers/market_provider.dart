import 'package:aliens/models/market_board_model.dart';
import 'package:aliens/services/market_service.dart';
import 'package:flutter/widgets.dart';
import 'package:aliens/services/board_service.dart';
import 'package:aliens/services/auth_service.dart';

class MarketProvider with ChangeNotifier {
  List<MarketBoard> articleList = [];
  bool loading = false;
  List<int> greatCounts = [];

  void _setLoading(bool value) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loading = value;
      notifyListeners();
    });
  }

  Future<void> reload() async {
    _setLoading(true);
    try {
      articleList =
          await MarketService.getMarketArticles(0, articleList.length);
    } catch (e) {
      if (e == "AT-C-002") {
        await AuthService.getAccessToken();
        articleList =
            await MarketService.getMarketArticles(0, articleList.length);
      }
    }
    await getLikeCounts();
    _setLoading(false);
  }

  Future<void> getLikeCounts() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      greatCounts = articleList.map((board) => board.greatCount ?? 0).toList();
      notifyListeners();
    });
  }

  Future<void> getMarketArticles() async {
    _setLoading(true);

    try {
      articleList = await MarketService.getMarketArticles(0, 10);
    } catch (e) {
      if (e == "AT-C-002") {
        await AuthService.getAccessToken();
        articleList = await MarketService.getMarketArticles(0, 10);
      }
    }
    await getLikeCounts();
    _setLoading(false);
  }

  Future<void> getMoreMarketArticles(int page) async {
    _setLoading(true);
    try {
      articleList.addAll(await MarketService.getMarketArticles(page, 10));
    } catch (e) {
      if (e == "AT-C-002") {
        await AuthService.getAccessToken();
        articleList.addAll(await MarketService.getMarketArticles(page, 10));
      }
    }
    await getLikeCounts();
    _setLoading(false);
  }

  Future<void> addLike(int articleId, int index) async {
    try {
      if (await BoardService.addLike(articleId)) {
        reload();
      }
    } catch (e) {
      if (e == "AT-C-002") {
        await AuthService.getAccessToken();
        if (await BoardService.addLike(articleId)) {
          reload();
        }
      }
    }
  }

  Future<bool> addMarketPost(MarketBoard marketBoard) async {
    bool value = false;
    try {
      value = await MarketService.createMarketArticle(marketBoard);
    } catch (e) {
      if (e == "AT-C-002") {
        await AuthService.getAccessToken();
        value = await MarketService.createMarketArticle(marketBoard);
      }
    }
    return value;
  }
}
