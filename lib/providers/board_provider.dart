import 'package:aliens/models/board_model.dart';
import 'package:flutter/widgets.dart';
import 'package:aliens/services/apis.dart';

// 게시물 관련 데이터를 관리하는 FLUTTER의 ChangeNotifier를 사용하는 상태 관리 클래스
// 게시물 데이터 가져오기, 좋아요 추가하기, 게시물 목록 관리하는 메서드 포함

class BoardProvider with ChangeNotifier {
  List<Board> articleList = [];
  bool loading = false;
  List<int> likeCounts = [];

  Future<void> getAllArticles() async {
    _setLoading(true);
    try {
      articleList = await APIs.TotalArticles(0);
    } catch (e) {
      if (e == "AT-C-002") {
        await APIs.getAccessToken();
        articleList = await APIs.TotalArticles(0);
      }
    }
    await getLikeCounts();
    _setLoading(false);
  }

  Future<void> getArticles(String boardCategory) async {
    _setLoading(true);
    try {
      articleList = await APIs.getArticles(boardCategory, 0);
    } catch (e) {
      if (e == "AT-C-002") {
        await APIs.getAccessToken();
        articleList = await APIs.getArticles(boardCategory, 0);
      }
    }
    await getLikeCounts();
    _setLoading(false);
  }

  Future<void> getMoreArticles(String boardCategory, int page) async {
    _setLoading(true);
    try {
      articleList.addAll(await APIs.getArticles(boardCategory, page));
    } catch (e) {
      if (e == "AT-C-002") {
        await APIs.getAccessToken();
        articleList.addAll(await APIs.getArticles(boardCategory, page));
      }
    }
    await getLikeCounts();
    _setLoading(false);
  }

  Future<void> getMoreAllArticles(int page) async {
    _setLoading(true);
    try {
      articleList.addAll(await APIs.TotalArticles(page));
    } catch (e) {
      if (e == "AT-C-002") {
        await APIs.getAccessToken();
        articleList.addAll(await APIs.TotalArticles(page));
      }
    }
    await getLikeCounts();
    _setLoading(false);
  }

  Future<bool> addPost(Board board) async {
    bool value = false;
    try {
      value = await APIs.postArticles(board);
    } catch (e) {
      if (e == "AT-C-002") {
        await APIs.getAccessToken();
        value = await APIs.postArticles(board);
      }
    }
    return value;
  }

  Future<void> addLike(int articleId, int index) async {
    _setLoading(true);
    try {
      likeCounts[index] = await APIs.addLike(articleId);
    } catch (e) {
      if (e == "AT-C-002") {
        await APIs.getAccessToken();
        likeCounts[index] = await APIs.addLike(articleId);
      }
    }
    _setLoading(false);
  }

  Future<void> getLikedList() async {
    _setLoading(true);
    try {
      articleList = await APIs.getLikedPost(0);
    } catch (e) {
      if (e == "AT-C-002") {
        await APIs.getAccessToken();
        articleList = await APIs.getLikedPost(0);
      }
    }
    await getLikeCounts();
    _setLoading(false);
  }

  Future<void> getMoreLikedList(int page) async {
    _setLoading(true);
    try {
      articleList.addAll(await APIs.getLikedPost(page));
    } catch (e) {
      if (e == "AT-C-002") {
        await APIs.getAccessToken();
        articleList.addAll(await APIs.getLikedPost(page));
      }
    }
    await getLikeCounts();
    _setLoading(false);
  }

  Future<void> getMyArticles() async {
    _setLoading(true);
    try {
      articleList = await APIs.getMyArticles(0);
    } catch (e) {
      if (e == "AT-C-002") {
        await APIs.getAccessToken();
        articleList = await APIs.getMyArticles(0);
      }
    }
    await getLikeCounts();
    _setLoading(false);
  }

  Future<void> getMoreMyArticles(int page) async {
    _setLoading(true);
    try {
      articleList.addAll(await APIs.getMyArticles(page));
    } catch (e) {
      if (e == "AT-C-002") {
        await APIs.getAccessToken();
        articleList.addAll(await APIs.getMyArticles(page));
      }
    }
    await getLikeCounts();
    _setLoading(false);
  }

  Future<void> getMyCommentArticles() async {
    _setLoading(true);
    try {
      articleList = await APIs.getCommentArticles(0);
    } catch (e) {
      if (e == "AT-C-002") {
        await APIs.getAccessToken();
        articleList = await APIs.getCommentArticles(0);
      }
    }
    await getLikeCounts();
    _setLoading(false);
  }

  Future<void> getMoreMyCommentArticles(int page) async {
    _setLoading(true);
    try {
      articleList.addAll(await APIs.getCommentArticles(page));
    } catch (e) {
      if (e == "AT-C-002") {
        await APIs.getAccessToken();
        articleList.addAll(await APIs.getCommentArticles(page));
      }
    }
    await getLikeCounts();
    _setLoading(false);
  }

  Future<void> getLikeCounts() async {
    likeCounts = articleList.map((board) => board.likeCount ?? 0).toList();
  }

  void _setLoading(bool value) {
    loading = value;
    notifyListeners();
  }
}
