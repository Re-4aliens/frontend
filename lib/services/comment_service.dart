import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';
import 'package:aliens/models/comment_model.dart';
import 'package:aliens/models/board_model.dart';
import 'package:aliens/models/market_comment.dart';

class CommentService extends APIService {
  /*

  특정 게시물 댓글 조회

  */
  static Future<List<Comment>> getCommentsList(int boardId) async {
    var url = '$domainUrl/comments/boards?id=$boardId';

    var jwtToken = await APIService.storage.read(key: 'token') ?? '';

    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': jwtToken,
        'Content-Type': 'application/json;charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      var responseBody = json.decode(utf8.decode(response.bodyBytes));
      List<dynamic> body = responseBody['result'];
      print(body);
      return body.map((dynamic item) => Comment.fromJson(item)).toList();
    } else {
      var responseBody = json.decode(utf8.decode(response.bodyBytes));

      if (responseBody['code'] == 'AT-C-002') {
        // 액세스 토큰 만료
        throw 'AT-C-002';
      } else if (responseBody['code'] == 'AT-C-007') {
        // 로그아웃된 토큰
        throw 'AT-C-007';
      } else {
        throw Exception('요청 오류');
      }
    }
  }

  /*

  부모 댓글 등록

  */
  static Future<bool> postComment(String content, int boardId) async {
    var url = '$domainUrl/comments/parent';

    var jwtToken = await APIService.storage.read(key: 'token') ?? '';

    print('jwtToken : $jwtToken');
    print('boardId : $boardId');
    print('content : $content');

    var response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': jwtToken,
        'Content-Type': 'application/json;charset=UTF-8'
      },
      body: jsonEncode({
        "boardId": boardId,
        "content": content,
      }),
    );

    print("부모 댓글 등록 시도");

    if (response.statusCode == 200) {
      print("부모 댓글 등록 성공");
      return true;
    } else {
      var responseBody = json.decode(utf8.decode(response.bodyBytes));
      print(responseBody);
      if (responseBody['code'] == 'AT-C-002') {
        // 액세스 토큰 만료
        throw 'AT-C-002';
      } else if (responseBody['code'] == 'AT-C-007') {
        // 로그아웃된 토큰
        throw 'AT-C-007';
      } else {
        return false;
      }
    }
  }

  /*

  자식 댓글 생성

  */
  static Future<bool> postNestedComment(
      int boardId, String content, int commentId) async {
    print("자식 댓글 생성 시도");
    var url = '$domainUrl/comments/child';

    print('boardId : $boardId, content : $content, commentId : $commentId');
    //토큰 읽어오기
    var jwtToken = await APIService.storage.read(key: 'token') ?? '';

    print(jwtToken);

    var response = await http.post(Uri.parse(url),
        headers: {
          'Authorization': jwtToken,
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          'boardId': boardId,
          'content': content,
          'parentCommentId': commentId,
        }));

    print(response.statusCode);

    //success
    if (response.statusCode == 200) {
      return true;
      //fail
    } else {
      print(json.decode(utf8.decode(response.bodyBytes)));
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-002') {
        // 액세스 토큰 만료
        throw 'AT-C-002';
      } else if (json.decode(utf8.decode(response.bodyBytes))['code'] ==
          'AT-C-007') {
        // 로그인된 토큰
        throw 'AT-C-007';
      } else {}
      return false;
    }
  }

  /*

  댓글 삭제

   */
  static Future<bool> deleteComment(int commentId) async {
    var url = '$domainUrl/comments?id=$commentId';

    var jwtToken = await APIService.storage.read(key: 'token') ?? '';

    var response = await http.delete(
      Uri.parse(url),
      headers: {
        'Authorization': jwtToken,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  /* 

    내가 댓글 단 게시글 조회 
    
  */
  static Future<List<Board>> getCommentArticles(int page) async {
    final url = '$domainUrl/my-boards?page=$page&size=10';

    var jwtToken = await APIService.storage.read(key: 'token') ?? '';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': jwtToken,
        'Content-Type': 'application/json;charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(utf8.decode(response.bodyBytes));
      List<dynamic> result = responseBody['result'];
      return result.map((dynamic item) => Board.fromJson(item)).toList();
    } else {
      throw Exception('요청 오류');
    }
  }

  /*

    상품 판매글 댓글 전체 조회

  */
  static Future<List<MarketComment>> getMarketArticleComments(
      int marketArticleId) async {
    try {
      var jwtToken = await APIService.storage.read(key: 'token');
      final accessToken = json.decode(jwtToken!)['data']['accessToken'];

      final url = Uri.parse(
          '$domainUrl/api/v2/market-boards/$marketArticleId/market-board-comments');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> body =
            json.decode(utf8.decode(response.bodyBytes))['data'];
        return body
            .map((dynamic item) => MarketComment.fromJson(item))
            .toList();
      } else {
        final responseBody = json.decode(utf8.decode(response.bodyBytes));
        final errorCode = responseBody['code'];

        if (errorCode == 'AT-C-002') {
          throw 'AT-C-002';
        } else if (errorCode == 'AT-C-007') {
          throw 'AT-C-007';
        } else {
          throw Exception('댓글 조회 오류');
        }
      }
    } catch (error) {
      throw Exception('댓글 조회 오류: $error');
    }
  }

  /*

    상품 판매글 부모 댓글 등록

  */
  static Future<bool> createMarketArticleComment(
      String content, int boardId) async {
    var url = '$domainUrl/api/v2/market-boards/$boardId/market-board-comments';

    var jwtToken = await APIService.storage.read(key: 'token');

    jwtToken = json.decode(jwtToken!)['data']['accessToken'];

    var response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "content": content,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      var responseBody = json.decode(utf8.decode(response.bodyBytes));
      if (responseBody['code'] == 'AT-C-002') {
        throw 'AT-C-002';
      } else if (responseBody['code'] == 'AT-C-007') {
        throw 'AT-C-007';
      } else {
        return false;
      }
    }
  }

  /*

    특정 판매글 댓글 삭제

  */
  static Future<bool> deleteMarketArticleComment(int boardCommentId) async {
    try {
      var jwtToken = await APIService.storage.read(key: 'token');
      final accessToken = json.decode(jwtToken!)['data']['accessToken'];

      final url =
          Uri.parse('$domainUrl/api/v2/market-board-comments/$boardCommentId');

      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        final responseBody = json.decode(utf8.decode(response.bodyBytes));
        final errorCode = responseBody['code'];

        if (errorCode == 'AT-C-002') {
          throw 'AT-C-002';
        } else if (errorCode == 'AT-C-007') {
          throw 'AT-C-007';
        } else {
          throw Exception('댓글 삭제 오류');
        }
      }
    } catch (error) {
      throw Exception('댓글 삭제 오류: $error');
    }
  }

  /*

    특정 상품 판매글 댓글에 대댓글 등록
    (자식댓글 테스트 실패)

  */
  static Future<bool> addMarketArticleCommentReply(
      String content, int commentId, int boardId) async {
    try {
      var jwtToken = await APIService.storage.read(key: 'token');
      final accessToken = json.decode(jwtToken!)['data']['accessToken'];

      final url = Uri.parse(
          '$domainUrl/api/v2/market-boards/$boardId/market-board-comments/$commentId');

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: json.encode({'content': content}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        final responseBody = json.decode(utf8.decode(response.bodyBytes));
        final errorCode = responseBody['code'];

        if (errorCode == 'AT-C-002') {
          throw 'AT-C-002';
        } else if (errorCode == 'AT-C-007') {
          throw 'AT-C-007';
        } else {
          throw Exception('대댓글 생성 오류');
        }
      }
    } catch (error) {
      throw Exception('대댓글 생성 오류: $error');
    }
  }
}
