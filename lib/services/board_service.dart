import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:aliens/models/board_model.dart';
import 'package:aliens/services/api_service.dart';
import 'package:aliens/util/image_util.dart';
import 'dart:async';
import 'package:http_parser/http_parser.dart';

class BoardService extends APIService {
  static String getCategoryValue(String category) {
    switch (category) {
      case "자유게시판":
        return 'free';
      case "게임게시판":
        return 'game';
      case "패션게시판":
        return 'fashion';
      case "음식게시판":
        return 'food';
      case "음악게시판":
        return 'music';
      case "정보게시판":
        return 'info';
    }
    return '';
  }

  /* 
  
    전체 게시판 글 전부 조회 
    
  */
  static Future<List<Board>> getTotalArticles(int page) async {
    final url = '$domainUrl/boards?page=$page&size=10';

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
  static Future<List<Board>> searchTotal(String keyword) async {
    final response = await http.get(
      Uri.parse(
          '$domainUrl/boards/search?search-keyword=$keyword&page=0&size=10'),
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

      return articles;
    } else {
      throw Exception('요청 오류');
    }
  }

  /* 
  
    특정 카테고리 게시판 검색

  */
  static Future<List<Board>> searchCategory(
      String category, String keyword) async {
    String category0 = getCategoryValue(category);
    print(category0);
    final response = await http.get(
      Uri.parse(
          '$domainUrl/boards/category/search?search-keyword=$keyword&category=$category0&page=0&size=10'),
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

      return articles;
    } else {
      print(json.decode(utf8.decode(response.bodyBytes)));
      throw Exception('요청 오류');
    }
  }

  /* 
  
    나의 게시글 조회 
  
  */
  static Future<List<Board>> getMyArticles(int page) async {
    const url = '$domainUrl/boards/writes?=0&size=10';

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
      return boards;
    } else {
      throw Exception('요청 오류');
    }
  }

  /* 
  
    특정 게시판 게시물 조회 
    
  */
  static Future<List<Board>> getArticles(String boardCategory, int page) async {
    final url =
        '$domainUrl/boards/category?category=$boardCategory&page=0&size=10';

    print(url);

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json;charset=UTF-8;',
      },
    );

    print(response.statusCode);

    if (response.statusCode == 200) {
      final responseBody = json.decode(utf8.decode(response.bodyBytes));
      print(responseBody);
      final result = responseBody['result'];

      List<dynamic> body = result;
      List<Board> boards =
          body.map((dynamic item) => Board.fromJson(item)).toList();
      print(boards);
      return boards;
    } else {
      print(json.decode(utf8.decode(response.bodyBytes)));
      throw Exception('요청 오류');
    }
  }

  /* 
  
    게시물 등록 
    
  */
  static Future<bool> postArticle(Board newBoard) async {
    String category = getCategoryValue(newBoard.category!);
    print(category);
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
      'boardCategory': category,
    });

    var jsonPart = http.MultipartFile.fromString(
      'request',
      jsonPayload,
      contentType: MediaType('application', 'json'),
    );
    request.files.add(jsonPart);

    if (newBoard.imageUrls != null && newBoard.imageUrls!.isNotEmpty) {
      for (String imagePath in newBoard.imageUrls!) {
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
        contentType: MediaType('text', 'plain'), // 빈 파일의 Content-Type 설정
      );
      request.files.add(file);
    }

    for (var file in request.files) {
      print('File: ${file.filename}, Content-Type: ${file.contentType}');
    }

    try {
      var response = await request.send();

      print(response.statusCode);

      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
        print("게시글 등록 성공");
        return true;
      } else {
        print(await response.stream.bytesToString());
        print("게시글 등록 실패");
        return false;
      }
    } catch (e) {
      print("통신 실패요");
      print(e);
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
  
    좋아요 등록 
  
  */
  static Future<int> addLike(int articleId) async {
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
      var responseData = json.decode(utf8.decode(response.bodyBytes));
      return responseData['data']['likeCount'];
    } else {
      return -1;
    }
  }

  /* 
  
    좋아요 리스트 > 본인이 좋아요한 게시글 조회 
    
  */
  static Future<List<Board>> getLikedPost(int page) async {
    const url = '$domainUrl/great/my-board?page=0&size=10';

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
      return boards;
    } else {
      throw Exception('요청 오류');
    }
  }

  /*
  
    공지사항 전체조회 (테스트 실패)
  
  */
  static Future<List<dynamic>> boardNotice() async {
    const url = '$domainUrl/boards/announcements?page=0&size=10';

    try {
      // 토큰 읽어오기
      var jwtToken = await APIService.storage.read(key: 'token');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $jwtToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print("불러오기 성공");
        final responseData = json.decode(utf8.decode(response.bodyBytes));
        final data = responseData['data'];
        if (data != null && data is List) {
          return data;
        }
      }
      return [];
    } catch (error) {
      return [];
    }
  }
}
