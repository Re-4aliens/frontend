import 'package:aliens/models/board_model.dart';
import 'package:flutter/widgets.dart';
import 'package:aliens/services/board_service.dart';
import 'package:aliens/services/auth_service.dart';
import 'package:aliens/services/comment_service.dart';

// 게시물 관련 데이터를 관리하는 FLUTTER의 ChangeNotifier를 사용하는 상태 관리 클래스
// 게시물 데이터 가져오기, 좋아요 추가하기, 게시물 목록 관리하는 메서드 포함

class BoardProvider with ChangeNotifier {
  List<Board> articleList = [];
  bool loading = false;
  List<int> likeCounts = [];

  Future<void> getAllArticles() async {
    _setLoading(true);
    try {
      articleList = await BoardService.getTotalArticles(0);
    } catch (e) {
      if (e == "AT-C-002") {
        await AuthService.getAccessToken();
        articleList = await BoardService.getTotalArticles(0);
      }
    }
    await getLikeCounts();
    _setLoading(false);
  }

  Future<void> getArticles(String boardCategory) async {
    _setLoading(true);
    try {
      articleList = await BoardService.getArticles(boardCategory, 0);
    } catch (e) {
      if (e == "AT-C-002") {
        await AuthService.getAccessToken();
        articleList = await BoardService.getArticles(boardCategory, 0);
      }
    }
    await getLikeCounts();
    _setLoading(false);
  }

  Future<void> getMoreArticles(String boardCategory, int page) async {
    _setLoading(true);
    try {
      articleList.addAll(await BoardService.getArticles(boardCategory, page));
    } catch (e) {
      if (e == "AT-C-002") {
        await AuthService.getAccessToken();
        articleList.addAll(await BoardService.getArticles(boardCategory, page));
      }
    }
    await getLikeCounts();
    _setLoading(false);
  }

  Future<void> getMoreAllArticles(int page) async {
    _setLoading(true);
    try {
      articleList.addAll(await BoardService.getTotalArticles(page));
    } catch (e) {
      if (e == "AT-C-002") {
        await AuthService.getAccessToken();
        articleList.addAll(await BoardService.getTotalArticles(page));
      }
    }
    await getLikeCounts();
    _setLoading(false);
  }

  Future<bool> addPost(Board board) async {
    bool value = false;
    try {
      value = await BoardService.postArticle(board);
    } catch (e) {
      if (e == "AT-C-002") {
        await AuthService.getAccessToken();
        value = await BoardService.postArticle(board);
      }
    }
    return value;
  }

  Future<void> addLike(int articleId, int index) async {
    _setLoading(true);
    try {
      likeCounts[index] = await BoardService.addLike(articleId);
    } catch (e) {
      if (e == "AT-C-002") {
        await AuthService.getAccessToken();
        likeCounts[index] = await BoardService.addLike(articleId);
      }
    }
    _setLoading(false);
  }

  Future<void> getLikedList() async {
    _setLoading(true);
    try {
      articleList = await BoardService.getLikedPost(0);
    } catch (e) {
      if (e == "AT-C-002") {
        await AuthService.getAccessToken();
        articleList = await BoardService.getLikedPost(0);
      }
    }
    await getLikeCounts();
    _setLoading(false);
  }

  Future<void> getMoreLikedList(int page) async {
    _setLoading(true);
    try {
      articleList.addAll(await BoardService.getLikedPost(page));
    } catch (e) {
      if (e == "AT-C-002") {
        await AuthService.getAccessToken();
        articleList.addAll(await BoardService.getLikedPost(page));
      }
    }
    await getLikeCounts();
    _setLoading(false);
  }

  Future<void> getMyArticles() async {
    _setLoading(true);
    try {
      articleList = await BoardService.getMyArticles(0);
    } catch (e) {
      if (e == "AT-C-002") {
        await AuthService.getAccessToken();
        articleList = await BoardService.getMyArticles(0);
      }
    }
    await getLikeCounts();
    _setLoading(false);
  }

  Future<void> getMoreMyArticles(int page) async {
    _setLoading(true);
    try {
      articleList.addAll(await BoardService.getMyArticles(page));
    } catch (e) {
      if (e == "AT-C-002") {
        await AuthService.getAccessToken();
        articleList.addAll(await BoardService.getMyArticles(page));
      }
    }
    await getLikeCounts();
    _setLoading(false);
  }

  Future<void> getMyCommentArticles() async {
    _setLoading(true);
    try {
      articleList = await CommentService.getCommentArticles(0);
    } catch (e) {
      if (e == "AT-C-002") {
        await AuthService.getAccessToken();
        articleList = await CommentService.getCommentArticles(0);
      }
    }
    await getLikeCounts();
    _setLoading(false);
  }

  Future<void> getMoreMyCommentArticles(int page) async {
    _setLoading(true);
    try {
      articleList.addAll(await CommentService.getCommentArticles(page));
    } catch (e) {
      if (e == "AT-C-002") {
        await AuthService.getAccessToken();
        articleList.addAll(await CommentService.getCommentArticles(page));
      }
    }
    await getLikeCounts();
    _setLoading(false);
  }

  Future<void> getLikeCounts() async {
    likeCounts = articleList.map((board) => board.likeCount ?? 0).toList();
  }

  void _setLoading(bool value) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (loading != value) {
        loading = value;
        notifyListeners();
      }
    });
  }
}