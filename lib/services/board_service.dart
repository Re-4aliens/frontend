import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:aliens/models/board_model.dart';
import 'package:aliens/services/api_service.dart';
import 'package:aliens/util/image_util.dart';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';

class BoardService extends APIService {
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
    print("$boardCategory 게시판 조회");
    const url = '$domainUrl/boards/category?category=FREE&page=0&size=10';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json;charset=UTF-8',
      },
    );

    print("요청 시도");
    print(response.statusCode);

    if (response.statusCode == 200) {
      final responseBody = json.decode(utf8.decode(response.bodyBytes));
      final result = responseBody['result'];

      print("카테고리 : ${result[0]["category"]}");
      List<dynamic> body = result;
      List<Board> boards =
          body.map((dynamic item) => Board.fromJson(item)).toList();
      return boards;
    } else {
      throw Exception('요청 오류');
    }
  }

  /* 
  
    게시물 등록 
    
  */
  static Future<bool> postArticle(Board newBoard) async {
    const url = '$domainUrl/boards/normal';

    var jwtToken = await APIService.storage.read(key: 'token') ?? '';

    if (jwtToken.isEmpty) {
      throw Exception('JWT 토큰이 없습니다.');
    }

    Dio dio = Dio();
    // dio.options.headers['Content-Type'] = 'multipart/form-data';
    dio.options.headers['Authorization'] = jwtToken;

    // 이미지 파일 추가
    List<MultipartFile> imageFiles = [];
    if (newBoard.imageUrls != null && newBoard.imageUrls!.isNotEmpty) {
      for (String imagePath in newBoard.imageUrls!) {
        if (imagePath.isNotEmpty) {
          var file = await ImageUtil.compressImageToMultipartFile(
            'boardImages',
            imagePath,
          );
          print(file);
          print("여기 들어오고 있나?");
          imageFiles.add(file);
        }
      }
    }

    print(imageFiles.runtimeType);

    var formData = FormData.fromMap({
      'boardImages': imageFiles,
      'request': MultipartFile.fromString(
        jsonEncode({
          "title": newBoard.title ?? '',
          "content": newBoard.content ?? '',
          "boardCategory": newBoard.category ?? '',
        }),
        contentType: MediaType('application', 'json'),
      ),
    });

    try {
      var response = await dio.post(url, data: formData);

      if (response.statusCode == 200) {
        print("게시글 등록 성공");
        return true;
      } else {
        print("게시글 등록 실패");
        return false;
      }
    } catch (e) {
      print("통신 실패요");
      if (e is DioError) {
        // DioError의 경우, 추가 정보를 제공할 수 있습니다.
        print("DioError 타입: ${e.type}");
        if (e.response != null) {
          print("서버 응답: ${e.response}");
        } else {
          print("응답 없음. 요청 데이터: ${e.requestOptions}");
        }
      }
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
