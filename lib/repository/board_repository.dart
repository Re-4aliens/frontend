


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
    try{
      articleList = await APIs.getArticles(boardCategory);
    }catch (e){
      await APIs.getAccessToken();
      articleList = await APIs.getArticles(boardCategory);
    }
    loading = false;

    notifyListeners();
  }

  addPost(Board _board) async {
    try {
      await APIs.postArticles(_board);
    } catch (e){
      if(e == "AT-C-002"){
        await APIs.getAccessToken();
        await APIs.postArticles(_board);
      }
      else{
        return false;
      }
    }

    return true;
    /*

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


}