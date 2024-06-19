import 'package:flutter/widgets.dart';

import 'package:aliens/services/apis.dart';
import '../models/comment_model.dart';
import '../models/market_comment.dart';

class MarketCommentProvider with ChangeNotifier {
  List<Comment>? commentListData;
  bool loading = false;
  MarketComment? marketcomment;

  getMarketComments(int articleId) async {
    loading = true;
    try {
      commentListData = await APIs.getCommentsList(
          articleId); //getMarketArticleComments 을 getCommentsList로 수정
    } catch (e) {
      if (e == "AT-C-002") {
        await APIs.getAccessToken();
        commentListData = await APIs.getCommentsList(
            articleId); //getMarketArticleComments 을 getCommentsList로 수정
      } else {
        // 오류 처리 로직
      }
    }
    loading = false;
    notifyListeners();
  }

  addMarketComment(String content, int articleId) async {
    try {
      await APIs.postComment(
          content, articleId); //createMarketArticleComment 을 postComment로 수정
    } catch (e) {
      if (e == "AT-C-002") {
        await APIs.getAccessToken();
        await APIs.postComment(
            content, articleId); //createMarketArticleComment 을 postComment로 수정
      } else {
        return false;
      }
    }
    //TODO fcm 전송

    notifyListeners();
    getMarketComments(articleId);
    return true;
  }

  addNestedMarketComment(String content, int commentId, int articleId) async {
    try {
      await APIs.addMarketArticleCommentReply(content, commentId, articleId);
    } catch (e) {
      if (e == "AT-C-002") {
        await APIs.getAccessToken();
        await APIs.addMarketArticleCommentReply(content, commentId, articleId);
      } else {
        return false;
      }
    }
    //TODO fcm 전송

    notifyListeners();
    getMarketComments(articleId);

    return true;
  }

  deleteMarketComment(int articleId) async {
    bool value = false;
    loading = true;
    try {
      value = await APIs.deleteComment(
          articleId); //deleteMarketArticleComment 을 deleteComment 로 수정
    } catch (e) {
      if (e == "AT-C-002") {
        await APIs.getAccessToken();
        value = await APIs.deleteComment(
            articleId); //deleteMarketArticleComment 을 deleteComment 로 수정
      } else {}
    }
    loading = false;
    notifyListeners();
    getMarketComments(articleId);

    return value;
  }
}
