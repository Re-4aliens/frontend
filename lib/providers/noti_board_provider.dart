import 'package:aliens/models/notification_article_model.dart';
import 'package:flutter/widgets.dart';
import 'package:aliens/services/auth_service.dart';
import 'package:aliens/services/notification_service.dart';

class NotiBoardProvider with ChangeNotifier {
  //notifyListeners();

  List<NotificationArticle> notiArticleList = [];
  bool loading = false;
  List<bool> isReadList = [];

  getNotiArticles() async {
    loading = true;
    try {
      notiArticleList = await NotificationService.getNotiList();
    } catch (e) {
      if (e == "AT-C-002") {
        await AuthService.getAccessToken();
        notiArticleList = await NotificationService.getNotiList();
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
    print("Put Read Value");
    try {
      print("try에는 들어가나..??");
      if (await NotificationService.readNotification(personalNoticeId)) {
        isReadList[index] = false;
      }
    } catch (e) {
      if (e == "AT-C-002") {
        await AuthService.getAccessToken();
        if (await NotificationService.readNotification(personalNoticeId)) {
          isReadList[index] = false;
        }
      }
    }
    getNotiArticles();
    notifyListeners();
  }
}
