import 'package:flutter/widgets.dart';

import 'package:aliens/services/apis.dart';
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
      } else {}
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

  deleteComment(int articleCommentId, int articleId) async {
    bool value = false;
    loading = true;
    try {
      value = await APIs.deleteComment(articleCommentId);
    } catch (e) {
      if (e == "AT-C-002") {
        await APIs.getAccessToken();
        value = await APIs.deleteComment(articleCommentId);
      } else {}
    }
    loading = false;
    notifyListeners();
    getComments(articleId);
    return value;
  }
}
