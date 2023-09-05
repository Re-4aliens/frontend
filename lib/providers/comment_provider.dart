import 'package:aliens/mockdatas/board_mockdata.dart';
import 'package:aliens/models/board_model.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../apis/apis.dart';
import '../models/comment_model.dart';

class CommentProvider with ChangeNotifier {


  List<Comment>? commentListData;
  bool loading = false;

  getComments(int articleId) async {
    loading = true;
    try {
      commentListData = await APIs.getCommentsList(articleId);
    } catch (e) {
      if (e == "AT-C-002") {
        await APIs.getAccessToken();
        commentListData = await APIs.getCommentsList(articleId);
      } else {
      }
    }
    loading = false;
    notifyListeners();
  }


  addComment(String content, int articleId) async {
    try {
      await APIs.postComment(content, articleId);
    } catch (e) {
      if (e == "AT-C-002") {
        await APIs.getAccessToken();
        await APIs.postComment(content, articleId);
      } else {
        return false;
      }
    }
    //TODO fcm 전송


    notifyListeners();
    getComments(articleId);
    return true;
  }

  addNestedComment(String content, int commentId, int articleId) async {
    try {
      await APIs.postNestedComment(content, commentId);
    } catch (e) {
      if (e == "AT-C-002") {
        await APIs.getAccessToken();
        await APIs.postNestedComment(content, commentId);
      } else {
        return false;
      }
    }
    //TODO fcm 전송


    notifyListeners();
    getComments(articleId);
    return true;
  }

  deleteComment(int articleId) async {
    bool value = false;
    loading = true;
    try {
      value =  await APIs.deleteComment(articleId);
    } catch (e) {
      if (e == "AT-C-002") {
        await APIs.getAccessToken();
        value = await APIs.deleteComment(articleId);
      } else {
      }
    }
    loading = false;
    notifyListeners();
    return value;
  }


}
