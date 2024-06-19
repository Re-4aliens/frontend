import 'package:aliens/models/notification_article_model.dart';
import 'package:flutter/widgets.dart';

import 'package:aliens/services/apis.dart';

class NotiBoardProvider with ChangeNotifier {
  //notifyListeners();

  List<NotificationArticle> notiArticleList = [];
  bool loading = false;
  List<bool> isReadList = [];

  getNotiArticles() async {
    loading = true;
    try {
      notiArticleList = await APIs.getNotiList();
    } catch (e) {
      if (e == "AT-C-002") {
        await APIs.getAccessToken();
        notiArticleList = await APIs.getNotiList();
      } else {}
    }
    getReadValue();
    loading = false;
    notifyListeners();
  }

  getReadValue() async {
    isReadList = notiArticleList.map((board) => board.isRead ?? false).toList();
  }

  putReadValue(int index, int personalNoticeId) async {
    try {
      if (await APIs.readNotification(personalNoticeId)) {
        isReadList[index] = false;
      }
    } catch (e) {
      if (e == "AT-C-002") {
        await APIs.getAccessToken();
        if (await APIs.readNotification(personalNoticeId)) {
          isReadList[index] = false;
        }
      } else {}
    }
    print(isReadList[index]);
    getNotiArticles();
    notifyListeners();
  }
}
