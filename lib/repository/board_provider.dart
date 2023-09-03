import 'package:aliens/mockdatas/board_mockdata.dart';
import 'package:aliens/models/board_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../apis/apis.dart';
import '../models/comment_model.dart';

class BoardProvider with ChangeNotifier {
  //notifyListeners();

  List<Board>? articleList;
  bool loading = false;

  getAllArticles() async {
    loading = true;
    try{
      articleList = await APIs.TotalArticles();
    } catch (e) {
      if (e == "AT-C-002") {
        await APIs.getAccessToken();
        articleList = await APIs.TotalArticles();
      } else {
      }
    }
    loading = false;
    notifyListeners();
  }

  getArticles(String boardCategory) async {
    loading = true;
    try{
      articleList = await APIs.getArticles(boardCategory);
    } catch (e) {
      if (e == "AT-C-002") {
        await APIs.getAccessToken();
        articleList = await APIs.getArticles(boardCategory);
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

  deletePost(int articleId) async {
    bool value = false;
    loading = true;
    try {
      value =  await APIs.deleteArticles(articleId);
    } catch (e) {
      if (e == "AT-C-002") {
        await APIs.getAccessToken();
        value = await APIs.deleteArticles(articleId);
      } else {
      }
    }
    loading = false;
    notifyListeners();
    return value;
  }

  addLike(int articleId) async {

    loading = true;
    try {

      //좋아요 요청
      await APIs.addLike(articleId);

      //이미 좋아요를 눌렀으면
      //해제 요청
      //await APIs.cancleLike(articleId);

    } catch (e) {
      if (e == "AT-C-002") {
        await APIs.getAccessToken();
        //좋아요 요청
        await APIs.addLike(articleId);

        //이미 좋아요를 눌렀으면
        //해제 요청
        //await APIs.cancleLike(articleId);
      } else {
      }
    }
    loading = false;
    notifyListeners();
  }

}
