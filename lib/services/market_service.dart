import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'api_service.dart';
import '../util/image_util.dart';
import 'package:aliens/models/market_articles.dart';

class MarketService extends APIService {
  /*

    상품판매글 모두 조회 > 장터 게시판 조회

  */
  static Future<List<MarketBoard>> getMarketArticles(int page) async {
    final url = '$domainUrl/boards/market?page=$page&size=10';
    var jwtToken = await APIService.storage.read(key: 'token') ?? '';

    jwtToken = json.decode(jwtToken)['data']['accessToken'];

    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json'
      },
    );

    if (response.statusCode == 200) {
      print(json.decode(utf8.decode(response.bodyBytes)));
      List<dynamic> body = json.decode(utf8.decode(response.bodyBytes))['data'];
      return body.map((dynamic item) => MarketBoard.fromJson(item)).toList();
    } else {
      print(json.decode(utf8.decode(response.bodyBytes)));
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-002') {
        print('액세스 토큰 만료');
        throw 'AT-C-002';
      } else if (json.decode(utf8.decode(response.bodyBytes))['code'] ==
          'AT-C-007') {
        print('로그아웃된 토큰');
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
    jwtToken = json.decode(jwtToken)['data']['accessToken'];

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': jwtToken,
        'Content-Type': 'application/json;charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      print(json.decode(utf8.decode(response.bodyBytes)));
      dynamic body = json.decode(utf8.decode(response.bodyBytes))['data'];
      return MarketBoard.fromJson(body);

      //fail
    } else {
      print(json.decode(utf8.decode(response.bodyBytes)));
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-002') {
        print('액세스 토큰 만료');
        throw 'AT-C-002';
      } else if (json.decode(utf8.decode(response.bodyBytes))['code'] ==
          'AT-C-007') {
        print('로그아웃된 토큰');
        throw 'AT-C-007';
      } else {}
      throw Exception('요청 오류');
    }
  }

  /*

    상품 판매글 생성

  */
  static Future<bool> createMarketArticle(MarketBoard marketArticle) async {
    try {
      var jwtToken = await APIService.storage.read(key: 'token');
      final accessToken = json.decode(jwtToken!)['data']['accessToken'];

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$domainUrl/api/v2/market-articles'),
      );

      request.fields['title'] = marketArticle.title!;
      request.fields['content'] = marketArticle.content!;
      request.fields['price'] = marketArticle.price.toString();
      request.fields['productStatus'] = marketArticle.productStatus!;
      request.fields['marketArticleStatus'] =
          marketArticle.marketArticleStatus!;

      if (marketArticle.imageUrls != null &&
          marketArticle.imageUrls!.isNotEmpty) {
        for (String imagePath in marketArticle.imageUrls!) {
          if (imagePath.isNotEmpty) {
            var file = await ImageUtil.compressImageToMultipartFile(
              'imageUrls',
              imagePath,
            );
            request.files.add(file);
          }
        }
      }

      request.headers['Authorization'] = 'Bearer $accessToken';

      var response = await request.send();

      if (response.statusCode == 200) {
        return true;
      } else {
        final responseBody = await response.stream.bytesToString();
        final errorCode = json.decode(responseBody)['code'];

        if (errorCode == 'AT-C-002') {
          throw 'AT-C-002';
        } else if (errorCode == 'AT-C-007') {
          throw 'AT-C-007';
        } else {
          throw Exception('상품 판매글 생성 오류');
        }
      }
    } catch (error) {
      throw Exception('상품 판매글 생성 오류: $error');
    }
  }

  /*

  특정 판매글 수정

  */
  static Future<bool> updateMarketArticle(
      int articleId, MarketBoard marketArticle) async {
    try {
      var jwtToken = await APIService.storage.read(key: 'token');
      final accessToken = json.decode(jwtToken!)['data']['accessToken'];

      final url = Uri.parse('$domainUrl/api/v2/market-articles/$articleId');

      final request = http.MultipartRequest('PATCH', url);

      request.headers['Authorization'] = 'Bearer $accessToken';

      request.fields['title'] = marketArticle.title!;
      request.fields['content'] = marketArticle.content!;
      request.fields['price'] = marketArticle.price.toString();
      request.fields['productStatus'] = marketArticle.productStatus!;
      request.fields['marketArticleStatus'] =
          marketArticle.marketArticleStatus!;

      if (marketArticle.imageUrls != null &&
          marketArticle.imageUrls!.isNotEmpty) {
        for (String imageUrl in marketArticle.imageUrls!) {
          if (imageUrl.isNotEmpty) {
            final response = await http.get(Uri.parse(imageUrl));
            final bytes = response.bodyBytes;
            const fileName = 'image.jpg';

            final Directory tempDir = Directory.systemTemp;
            final File imageFile = File('${tempDir.path}/$fileName');
            await imageFile.writeAsBytes(bytes);

            var file =
                await http.MultipartFile.fromPath('imageUrls', imageFile.path);
            request.files.add(file);
          }
        }
      }

      final response = await request.send();

      if (response.statusCode == 200) {
        return true;
      } else {
        final responseBody = await response.stream.bytesToString();
        final errorCode = json.decode(responseBody)['code'];

        if (errorCode == 'AT-C-002') {
          throw 'AT-C-002';
        } else if (errorCode == 'AT-C-007') {
          throw 'AT-C-007';
        } else {
          throw Exception('상품 판매글 수정 오류');
        }
      }
    } catch (error) {
      throw Exception('상품 판매글 수정 오류: $error');
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

    var jwtToken = await APIService.storage.read(key: 'token');

    jwtToken = json.decode(jwtToken!)['data']['accessToken'];

    var response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $jwtToken',
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
      jwtToken = json.decode(jwtToken)['data']['accessToken'];

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
      print('Error fetching market search results: $error');
      return [];
    }
  }
}
