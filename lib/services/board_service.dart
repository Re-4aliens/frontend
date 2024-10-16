import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import 'package:aliens/models/board_model.dart';
import 'package:aliens/services/api_service.dart';
import 'package:aliens/util/image_util.dart';
import 'dart:async';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

Future<void> showAlert(BuildContext context, String message) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text("alert".tr()),
        content: Text(message),
      );
    },
  );
}

class BoardService extends APIService {
  /* 
  
    전체 게시판 글 전부 조회 
    
  */
  static Future<List<Board>> getTotalArticles(int page, int size) async {
    final url = '$domainUrl/boards?page=$page&size=$size';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json;charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(utf8.decode(response.bodyBytes));
      final result = responseBody['result'];

      List<dynamic> body = result;
      print(body);
      List<Board> boards =
          body.map((dynamic item) => Board.fromJson(item)).toList();

      return boards;
    } else {
      throw Exception('요청 오류');
    }
  }

  /* 
  
    전체 게시판 검색 
    
  */

  static Future<List<Board>> searchTotal(String keyword, int page) async {
    final response = await http.get(
      Uri.parse(
          '$domainUrl/boards/search?search-keyword=$keyword&page=$page&size=10'),
      headers: {
        'Content-Type': 'application/json;charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(utf8.decode(response.bodyBytes));
      final List<dynamic> articlesData = responseBody['result'];
      List<Board> articles = articlesData.map((articleData) {
        return Board.fromJson(articleData);
      }).toList();
      articles = List.from(articles.reversed);

      return articles;
    } else {
      throw Exception('요청 오류');
    }
  }

  /* 
  
    나의 게시글 조회 
  
  */
  static Future<List<Board>> getMyArticles(int page) async {
    final url = '$domainUrl/boards/writes?page=$page&size=10';

    var jwtToken = await APIService.storage.read(key: 'token') ?? '';

    if (jwtToken.isEmpty) {
      throw Exception('JWT 토큰이 없습니다.');
    }

    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': jwtToken, 'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(utf8.decode(response.bodyBytes));
      final result = responseBody['result'];
      List<dynamic> body = result;
      List<Board> boards =
          body.map((dynamic item) => Board.fromJson(item)).toList();
      boards = List.from(boards.reversed);
      return boards;
    } else {
      throw Exception('요청 오류');
    }
  }

  /* 
  
    특정 게시판 게시물 조회 
    
  */
  static Future<List<Board>> getArticles(
      String boardCategory, int page, int size) async {
    final url =
        '$domainUrl/boards/category?category=${boardCategory.toLowerCase()}&page=$page&size=$size';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json;charset=UTF-8;',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(utf8.decode(response.bodyBytes));
      final result = responseBody['result'];

      List<dynamic> body = result;
      List<Board> boards =
          body.map((dynamic item) => Board.fromJson(item)).toList();
      return boards;
    } else {
      throw Exception('요청 오류');
    }
  }

  /* 
  
    게시글 등록
    
  */
  static Future<bool> postArticle(BuildContext context, Board newBoard) async {
    const url = '$domainUrl/boards/normal';

    var jwtToken = await APIService.storage.read(key: 'token');
    if (jwtToken == null) {
      throw Exception('JWT token is null');
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(url),
    );

    request.headers['Authorization'] = jwtToken;

    var jsonPayload = jsonEncode({
      'title': newBoard.title,
      'content': newBoard.content,
      'boardCategory': newBoard.category,
    });

    var jsonPart = http.MultipartFile.fromString(
      'request',
      jsonPayload,
      contentType: MediaType('application', 'json'),
    );
    request.files.add(jsonPart);

    if (newBoard.imageUrls.isNotEmpty) {
      for (String imagePath in newBoard.imageUrls) {
        if (imagePath.isNotEmpty) {
          var file = await ImageUtil.compressImageToMultipartFile(
            'boardImages',
            imagePath,
          );
          request.files.add(file);
        }
      }
    } else {
      var file = http.MultipartFile.fromString(
        'marketBoardImages',
        '',
        filename: 'empty.txt',
        contentType: MediaType('text', 'plain'),
      );
      request.files.add(file);
    }

    try {
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        return true;
      } else {
        if (responseBody.contains("B5")) {
          await showAlert(context, "post-time-error".tr());
        }
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  /* 
  
    게시물 삭제 
  
  */
  static Future<bool> deleteArticle(int articleId) async {
    final url = '$domainUrl/boards?id=$articleId';

    var jwtToken = await APIService.storage.read(key: 'token') ?? '';

    if (jwtToken.isEmpty) {
      throw Exception('JWT 토큰이 없습니다.');
    }

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
  
    게시물 상세 조회
  
  */
  static Future<Board> getArticleDetail(int boardId) async {
    final url = '$domainUrl/boards/normal?boardId=$boardId';

    var jwtToken = await APIService.storage.read(key: 'token') ?? '';

    if (jwtToken.isEmpty) {
      throw Exception('JWT 토큰이 없습니다.');
    }

    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': jwtToken,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      var responseData = json.decode(utf8.decode(response.bodyBytes));
      return Board.fromJson(responseData['result']);
    } else {
      throw Exception(utf8.decode(response.bodyBytes));
    }
  }

  /* 
  
    좋아요 등록 
  
  */
  static Future<bool> addLike(int articleId) async {
    final url = '$domainUrl/great?board-id=$articleId';

    var jwtToken = await APIService.storage.read(key: 'token') ?? '';

    if (jwtToken.isEmpty) {
      throw Exception('JWT 토큰이 없습니다.');
    }

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': jwtToken,
        'Content-Type': 'application/json;charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  /* 
  
    좋아요 리스트 > 본인이 좋아요한 게시글 조회 
    
  */
  static Future<List<Board>> getLikedPost(int page) async {
    final url = '$domainUrl/great/my-board?page=$page&size=10';

    var jwtToken = await APIService.storage.read(key: 'token') ?? '';

    if (jwtToken.isEmpty) {
      throw Exception('JWT 토큰이 없습니다.');
    }

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': jwtToken,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(utf8.decode(response.bodyBytes));
      final result = responseBody['result'];
      List<dynamic> body = result;
      List<Board> boards =
          body.map((dynamic item) => Board.fromJson(item)).toList();
      boards = List.from(boards.reversed);
      return boards;
    } else {
      throw Exception('요청 오류');
    }
  }
}
