import 'package:aliens/mockdatas/board_mockdata.dart';
import 'package:aliens/models/board_model.dart';
import 'package:aliens/models/market_articles.dart';
import 'package:aliens/models/notification_article_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../apis/apis.dart';
import '../models/comment_model.dart';

class NotiBoardProvider with ChangeNotifier {
  //notifyListeners();

  List<NotificationArticle> notiArticleList= [];
  bool loading = false;
  List<bool> isReadList = [];

  getNotiArticles() async {
    loading = true;
    try{
      notiArticleList = await APIs.getNotiList();
    } catch (e) {
      if (e == "AT-C-002") {
        await APIs.getAccessToken();
        notiArticleList = await APIs.getNotiList();
      } else {
      }
    }
    getReadValue();
    loading = false;
    notifyListeners();
  }

  getReadValue() async {
    isReadList = notiArticleList!.map((board) => board.isRead ?? false).toList();
  }

  putReadValue(int index, int personalNoticeId) async {
    try{
      if(await APIs.readNotification(personalNoticeId)){
        isReadList[index] = false;
      }
    } catch (e) {
      if (e == "AT-C-002") {
        await APIs.getAccessToken();
        if(await APIs.readNotification(personalNoticeId)){
          isReadList[index] = false;
        }
      } else {
      }
    }
    print(isReadList[index]);
    getNotiArticles();
    notifyListeners();
  }
}
