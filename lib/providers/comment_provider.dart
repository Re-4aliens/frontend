import 'package:aliens/services/auth_service.dart';
import 'package:flutter/widgets.dart';
import 'package:aliens/models/comment_model.dart';
import 'package:aliens/services/comment_service.dart';

class CommentProvider with ChangeNotifier {
  List<Comment>? commentListData;
  bool loading = false;

  getComments(int articleId) async {
    loading = true;
    try {
      commentListData = await CommentService.getCommentsList(articleId);
    } catch (e) {
      if (e == "AT-C-002") {
        await AuthService.getAccessToken();
        commentListData = await CommentService.getCommentsList(articleId);
      } else {}
    }
    loading = false;
    notifyListeners();
  }

  addComment(String content, int articleId) async {
    print('board id : $articleId');
    try {
      await CommentService.postComment(content, articleId);
    } catch (e) {
      if (e == "AT-C-002") {
        await AuthService.getAccessToken();
        await CommentService.postComment(content, articleId);
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
      await CommentService.postNestedComment(content, commentId);
    } catch (e) {
      if (e == "AT-C-002") {
        await AuthService.getAccessToken();
        await CommentService.postNestedComment(content, commentId);
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
      value = await CommentService.deleteComment(articleCommentId);
    } catch (e) {
      if (e == "AT-C-002") {
        await AuthService.getAccessToken();
        value = await CommentService.deleteComment(articleCommentId);
      } else {}
    }
    loading = false;
    notifyListeners();
    getComments(articleId);
    return value;
  }
}
