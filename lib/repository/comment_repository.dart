


import 'package:aliens/mockdatas/board_mockdata.dart';
import 'package:aliens/mockdatas/comment_mockdata.dart';
import 'package:aliens/models/comment_model.dart';
import 'package:aliens/models/board_model.dart';

class CommentRepository{
  static void addComment(Comment _newComment) {
    commentListMock.add(_newComment);
  }

  static void addCommentChilds(int _parentsCommentIndex, Comment _newComment){
    commentListMock[_parentsCommentIndex].childs?.add(_newComment);
  }
}

