import 'dart:convert';
import 'package:aliens/util/image_util.dart';
import 'package:http/http.dart' as http;
import 'api_service.dart';
import 'package:aliens/models/market_board_model.dart';
import 'package:http_parser/http_parser.dart';

class MarketService extends APIService {
  /*

    상품판매글 모두 조회 > 장터 게시판 조회

  */
  static Future<List<MarketBoard>> getMarketArticles(int page) async {
    final url = '$domainUrl/boards/market?page=$page&size=10';
    var jwtToken = await APIService.storage.read(key: 'token') ?? '';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': jwtToken,
        'Content-Type': 'application/json;charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      var responseBody = json.decode(utf8.decode(response.bodyBytes));
      List<dynamic> result = responseBody['result'];
      return result.map((dynamic item) => MarketBoard.fromJson(item)).toList();
    } else {
      var responseBody = json.decode(utf8.decode(response.bodyBytes));
      if (responseBody['code'] == 'AT-C-002') {
        throw 'AT-C-002';
      } else if (responseBody['code'] == 'AT-C-007') {
        throw 'AT-C-007';
      } else {
        throw Exception('요청 오류');
      }
    }
  }

  /*

    장터 게시글 상세 조회

  */
  static Future<MarketBoard> getMarketArticle(int articleId) async {
    final url = '$domainUrl/boards/market/details?id=$articleId';
    var jwtToken = await APIService.storage.read(key: 'token') ?? '';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': jwtToken,
        'Content-Type': 'application/json;charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      var responseBody = json.decode(utf8.decode(response.bodyBytes));
      dynamic result = responseBody['result'];
      return MarketBoard.fromJson(result);
    } else {
      var responseBody = json.decode(utf8.decode(response.bodyBytes));
      if (responseBody['code'] == 'AT-C-002') {
        throw 'AT-C-002';
      } else if (responseBody['code'] == 'AT-C-007') {
        throw 'AT-C-007';
      } else {
        throw Exception('요청 오류');
      }
    }
  }

  /*

    상품 판매글 생성

  */
  static Future<bool> createMarketArticle(MarketBoard marketArticle) async {
    const url = '$domainUrl/boards/market';

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
      'title': marketArticle.title,
      'content': marketArticle.content,
      'saleStatus': marketArticle.saleStatus,
      'price': marketArticle.price.toString(),
      'productQuality': marketArticle.productQuality,
    });

    // JSON 데이터를 MultipartFile로 추가
    var jsonPart = http.MultipartFile.fromString(
      'request',
      jsonPayload,
      contentType: MediaType('application', 'json'),
    );
    request.files.add(jsonPart);

    if (marketArticle.imageUrls.isNotEmpty) {
      for (String imagePath in marketArticle.imageUrls) {
        if (imagePath.isNotEmpty) {
          var file = await ImageUtil.compressImageToMultipartFile(
            'marketBoardImages',
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

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        return true;
      } else {
        final responseBody = await response.stream.bytesToString();
        final responseJson = json.decode(responseBody);

        final errorCode = responseJson['code'];
        if (errorCode == 'AT-C-002') {
          throw 'AT-C-002';
        } else if (errorCode == 'AT-C-007') {
          throw 'AT-C-007';
        } else {
          throw Exception('상품 판매글 생성 오류');
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  /*

  특정 판매글 수정(테스트 실패)

  */
  static Future<bool> updateMarketArticle(
      int articleId, MarketBoard marketArticle) async {
    String url = '$domainUrl/boards/market?id=$articleId';

    var jwtToken = await APIService.storage.read(key: 'token');
    if (jwtToken == null) {
      throw Exception('JWT token is null');
    }

    var requestBody = jsonEncode({
      'title': marketArticle.title,
      'content': marketArticle.content,
      'saleStatus': marketArticle.saleStatus,
      'price': marketArticle.price.toString(),
      'productQuality': marketArticle.productQuality,
    });

    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Authorization': jwtToken,
        'Content-Type': 'application/json;charset=UTF-8',
      },
      body: requestBody,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      final responseBody = json.decode(utf8.decode(response.bodyBytes));
      final errorCode = json.decode(responseBody)['code'];

      if (errorCode == 'AT-C-002') {
        throw 'AT-C-002';
      } else if (errorCode == 'AT-C-007') {
        throw 'AT-C-007';
      } else {
        throw Exception('상품 판매글 수정 오류');
      }
    }
  }

  /* 

    특정 판매글 삭제

  */
  static Future<String> deleteMarketArticle(int articleId) async {
    try {
      var jwtToken = await APIService.storage.read(key: 'token');
      final accessToken = json.decode(jwtToken!)['data']['accessToken'];

      final url = Uri.parse('$domainUrl/api/v2/market-articles/$articleId');

      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(utf8.decode(response.bodyBytes));
        final message = responseBody['message'];
        return message;
      } else {
        final responseBody = json.decode(utf8.decode(response.bodyBytes));
        final errorCode = responseBody['code'];

        if (errorCode == 'AT-C-002') {
          throw 'AT-C-002';
        } else if (errorCode == 'AT-C-007') {
          throw 'AT-C-007';
        } else {
          throw Exception('상품 판매글 삭제 오류');
        }
      }
    } catch (error) {
      throw Exception('상품 판매글 삭제 오류: $error');
    }
  }

  /* 

    특정 판매글 찜 등록

  */
  static Future<int> marketBookmark(int articleId, int index) async {
    var url =
        '$domainUrl/api/v2/market-articles/$articleId/bookmarks?page=$index&size=10&sort=createdAt,desc';

    var jwtToken = await APIService.storage.read(key: 'token') ?? '';

    var response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': jwtToken,
        'Content-Type': 'application/json',
      },
    );

    var jsonResponse = json.decode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      return jsonResponse['data']['marketArticleBookmarkCount'];
    } else {
      var errorCode = jsonResponse['code'];

      if (errorCode == 'AT-C-002') {
        throw 'AT-C-002';
      } else if (errorCode == 'AT-C-007') {
        throw 'AT-C-007';
      } else {
        throw '기타 에러: $errorCode';
      }
    }
  }

  /*
  
    상품 판매글 검색 > 장터게시글 검색
  
  */
  static Future<List<MarketBoard>> searchMarket(String keyword) async {
    try {
      var jwtToken = await APIService.storage.read(key: 'token') ?? '';

      final response = await http.get(
        Uri.parse(
            '$domainUrl/boards/market/search?search-keyword=$keyword&page=0&size=10'),
        headers: {
          'Authorization': jwtToken,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        final List<dynamic> articlesData = data['result'];

        // 데이터를 List<MarketBoard> 객체로 반환
        List<MarketBoard> articles = articlesData.map((articleData) {
          return MarketBoard.fromJson(articleData);
        }).toList();

        return articles;
      } else {
        if (json.decode(utf8.decode(response.bodyBytes))['code'] ==
            'AT-C-002') {
          // 액세스 토큰 만료
          throw 'AT-C-002';
        } else if (json.decode(utf8.decode(response.bodyBytes))['code'] ==
            'AT-C-007') {
          // 로그아웃된 토큰
          throw 'AT-C-007';
        } else {
          throw Exception('요청 오류');
        }
      }
    } catch (error) {
      return [];
    }
  }
}
