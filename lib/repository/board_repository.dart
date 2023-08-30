


import 'package:aliens/mockdatas/board_mockdata.dart';
import 'package:aliens/models/board_model.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../apis/apis.dart';

class BoardProvider with ChangeNotifier{

  //notifyListeners();

  List<Board>? articleList;
  bool loading = false;


  getArticles(String boardCategory) async {
    loading = true;
    articleList = await APIs.getArticles(boardCategory);
    loading = false;

    notifyListeners();
  }

/*

  void addPost(Board _board) {
    switch (_board.category){
      case '자유게시판':
        freePostingArticleList!.insert(0, _board);
        totalBoardList.insert(0, _board);
        break;
      case '음식게시판':
        foodBoardList.insert(0, _board);
        totalBoardList.insert(0, _board);
        break;
      case '음악게시판':
        musicBoardList.insert(0, _board);
        totalBoardList.insert(0, _board);
        break;
      case '패션게시판':
        fashionBoardList.insert(0, _board);
        totalBoardList.insert(0, _board);
        break;
      case '게임게시판':
        gameBoardList.insert(0, _board);
        totalBoardList.insert(0, _board);
        break;

      case '정보게시판':
        infoBoardList.insert(0, _board);
        totalBoardList.insert(0, _board);
        break;
      default:
        totalBoardList.add(_board);
    }
  }

 */
}

