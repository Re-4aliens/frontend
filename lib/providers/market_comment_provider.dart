import 'package:aliens/mockdatas/board_mockdata.dart';
import 'package:aliens/models/board_model.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../apis/apis.dart';
import '../models/comment_model.dart';
import '../models/market_comment.dart';

class MarketCommentProvider with ChangeNotifier {


  List<MarketComment>? commentListData;
  bool loading = false;
  MarketComment? marketcomment;

  getMarketComments(int articleId) async {
    loading = true;
    try {
      commentListData = await APIs.getMarketArticleComments(articleId);
    } catch (e) {
      if (e == "AT-C-002") {
        await APIs.getAccessToken();
        commentListData = await APIs.getMarketArticleComments(articleId);
      } else {
        // 오류 처리 로직
      }
    }
    loading = false;
    notifyListeners();
  }


  addMarketComment(String content, int articleId) async {
    try {
      await APIs.createMarketArticleComment(content,articleId);
    } catch (e) {
      if (e == "AT-C-002") {
        await APIs.getAccessToken();
        await APIs.createMarketArticleComment(content,articleId);
      } else {
        return false;
      }
    }
    //TODO fcm 전송


    notifyListeners();
    return true;
  }

  addNestedMarketComment(int commentId, int ArticleCommentId, String content) async {
    try {
      await APIs.addMarketArticleCommentReply(commentId, ArticleCommentId, content);
    } catch (e) {
      if (e == "AT-C-002") {
        await APIs.getAccessToken();
        await APIs.addMarketArticleCommentReply(commentId, ArticleCommentId, content);
      } else {
        return false;
      }
    }
    //TODO fcm 전송


    notifyListeners();
    return true;
  }
  deleteMarketComment(int articleId) async {
    bool value = false;
    loading = true;
    try {
      value =  await APIs.deleteMarketArticleComment(articleId);
    } catch (e) {
      if (e == "AT-C-002") {
        await APIs.getAccessToken();
        value = await APIs.deleteMarketArticleComment(articleId);
      } else {
      }
    }
    loading = false;
    notifyListeners();
    return value;
  }

}