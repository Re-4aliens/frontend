import 'package:aliens/mockdatas/board_mockdata.dart';
import 'package:aliens/models/board_model.dart';
import 'package:aliens/models/market_articles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../apis/apis.dart';
import '../models/comment_model.dart';

class BoardProvider with ChangeNotifier {
  //notifyListeners();

  List<Board> articleList= [];
  bool loading = false;
  List<int> likeCounts = [];

  getAllArticles() async {
    loading = true;
    try{
      articleList = await APIs.TotalArticles(0);
    } catch (e) {
      if (e == "AT-C-002") {
        await APIs.getAccessToken();
        articleList = await APIs.TotalArticles(0);
      } else {
      }
    }
    getLikeCounts();
    loading = false;
    notifyListeners();
  }

  getArticles(String boardCategory) async {
    loading = true;
    try{
      articleList = await APIs.getArticles(boardCategory, 0);
    } catch (e) {
      if (e == "AT-C-002") {
        await APIs.getAccessToken();
        articleList = await APIs.getArticles(boardCategory, 0);
      } else {
      }
    }
    getLikeCounts();
    loading = false;
    notifyListeners();
  }

  getMoreArticles(String boardCategory, int page) async {
    loading = true;
    try{
      articleList!.addAll(await APIs.getArticles(boardCategory, page));
    } catch (e) {
      if (e == "AT-C-002") {
        await APIs.getAccessToken();
        articleList!.addAll(await APIs.getArticles(boardCategory, page));
      } else {
      }
    }
    getLikeCounts();
    loading = false;
    notifyListeners();
  }

  getMoreAllArticles(int page) async {
    loading = true;
    try{
      articleList!.addAll(await APIs.TotalArticles(page));
    } catch (e) {
      if (e == "AT-C-002") {
        await APIs.getAccessToken();
        articleList!.addAll(await APIs.TotalArticles(page));
      } else {
      }
    }
    getLikeCounts();
    loading = false;
    notifyListeners();
  }

  addPost(Board _board) async {
    bool value = false;
    try {
      value = await APIs.postArticles(_board);
    } catch (e) {
      if (e == "AT-C-002") {
        await APIs.getAccessToken();
        value = await APIs.postArticles(_board);
      } else {
        return false;
      }
    }

    return value;
  }



  addLike(int articleId, int index) async {
    loading = true;
    try {
      //좋아요 요청
      likeCounts![index] = await APIs.addLike(articleId);

    } catch (e) {
      if (e == "AT-C-002") {
        await APIs.getAccessToken();
        //좋아요 요청
        likeCounts![index] = await APIs.addLike(articleId);

      } else {
      }
    }
    loading = false;
    notifyListeners();
  }

  getLikeCounts() async {
    likeCounts = articleList!.map((board) => board.likeCount ?? 0).toList();
  }

  getLikedList() async {
    loading = true;
    try {
      //게시판 좋아요 리스트 요청
      articleList = await APIs.getLikedPost(0);
    } catch (e) {
      if (e == "AT-C-002") {
        await APIs.getAccessToken();
        //게시판 좋아요 리스트 요청
        articleList = await APIs.getLikedPost(0);
      } else {
      }
    }
    getLikeCounts();
    loading = false;
    notifyListeners();
  }

  getMoreLikedList(int page) async {
    loading = true;
    try {
      //게시판 좋아요 리스트 요청
      articleList!.addAll(await APIs.getLikedPost(page));
    } catch (e) {
      if (e == "AT-C-002") {
        await APIs.getAccessToken();
        articleList!.addAll(await APIs.getLikedPost(page));
      } else {
      }
    }
    getLikeCounts();
    loading = false;
    notifyListeners();
  }

  getMyArticles() async {
    loading = true;
    try{
      articleList = await APIs.getMyArticles(0);
    } catch (e) {
      if (e == "AT-C-002") {
        await APIs.getAccessToken();
        articleList = await APIs.getMyArticles(0);
      } else {
      }
    }
    getLikeCounts();
    loading = false;
    notifyListeners();
  }

  getMoreMyArticles(int page) async {
    loading = true;
    try{
      articleList!.addAll(await APIs.getMyArticles(page));
    } catch (e) {
      if (e == "AT-C-002") {
        await APIs.getAccessToken();
        articleList!.addAll(await APIs.getMyArticles(page));
      } else {
      }
    }
    getLikeCounts();
    loading = false;
    notifyListeners();
  }

  getMyCommentArticles() async {
    loading = true;
    try{
      articleList = await APIs.getCommentArticles(0);
    } catch (e) {
      if (e == "AT-C-002") {
        await APIs.getAccessToken();
        articleList = await APIs.getCommentArticles(0);
      } else {
      }
    }
    getLikeCounts();
    loading = false;
    notifyListeners();
  }

  getMoreMyCommentArticles(int page) async {
    loading = true;
    try{
      articleList!.addAll(await APIs.getCommentArticles(page));
    } catch (e) {
      if (e == "AT-C-002") {
        await APIs.getAccessToken();
        articleList!.addAll(await APIs.getCommentArticles(page));
      } else {
      }
    }
    getLikeCounts();
    loading = false;
    notifyListeners();
  }

}
