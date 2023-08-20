


import 'package:aliens/mockdatas/board_mockdata.dart';
import 'package:aliens/models/board_model.dart';

class BoardRepository{
  static void addPost(Board _board) {
    switch (_board.category){
      case '자유게시판':
        freePostingBoardList.insert(0, _board);
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
}

