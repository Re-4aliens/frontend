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

  List<Board>? articleList;
  bool loading = false;
  List<Board>? likedList;
  List<int>? likeCounts;

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
    loading = false;
    notifyListeners();
  }

  addPost(Board _board) async {
    try {
      await APIs.postArticles(_board);
    } catch (e) {
      if (e == "AT-C-002") {
        await APIs.getAccessToken();
        await APIs.postArticles(_board);
      } else {
        return false;
      }
    }

    return true;
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
      likedList = await APIs.getLikedPost(0);
    } catch (e) {
      if (e == "AT-C-002") {
        await APIs.getAccessToken();
        //게시판 좋아요 리스트 요청
        likedList = await APIs.getLikedPost(0);
      } else {
      }
    }
    loading = false;
    notifyListeners();
  }

  getMoreLikedList(int page) async {
    loading = true;
    try {
      //게시판 좋아요 리스트 요청
      likedList!.addAll(await APIs.getLikedPost(page));
    } catch (e) {
      if (e == "AT-C-002") {
        await APIs.getAccessToken();
        likedList!.addAll(await APIs.getLikedPost(page));
      } else {
      }
    }
    loading = false;
    notifyListeners();
  }

  getMyArticles() async {
    loading = true;
    try{
      articleList = await APIs.getMyArticles();
    } catch (e) {
      if (e == "AT-C-002") {
        await APIs.getAccessToken();
        articleList = await APIs.getMyArticles();
      } else {
      }
    }
    loading = false;
    notifyListeners();
  }

  getMyCommentArticles() async {
    loading = true;
    try{
      articleList = await APIs.getCommentArticles();
    } catch (e) {
      if (e == "AT-C-002") {
        await APIs.getAccessToken();
        articleList = await APIs.getCommentArticles();
      } else {
      }
    }
    loading = false;
    notifyListeners();
  }

}
