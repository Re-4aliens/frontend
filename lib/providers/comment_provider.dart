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
}
