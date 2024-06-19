import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:aliens/services/apis.dart';

// 토큰 유효성 검사

class TokenValidationService {
  static const storage = FlutterSecureStorage();

  Future<bool> checkTokenValidity() async {
    var accessToken = await storage.read(key: 'token');
    var refreshToken = await storage.read(key: 'refreshToken');

    if (accessToken == null || refreshToken == null) {
      print('로그인 필요');
      return false;
    }

    final jwtAccessToken = JWT.decode(accessToken);
    final jwtRefreshToken = JWT.decode(refreshToken);

    DateTime accessTokenTimestamp = DateTime.fromMillisecondsSinceEpoch(
        jwtAccessToken.payload['iat'] * 1000);
    DateTime refreshTokenTimestamp = DateTime.fromMicrosecondsSinceEpoch(
        jwtRefreshToken.payload['iat'] * 1000);

    Duration accessTokenDiff = DateTime.now().difference(accessTokenTimestamp);
    Duration refreshTokenDiff =
        DateTime.now().difference(refreshTokenTimestamp);

    print(
        '지금 시간: ${DateTime.now()}\n엑세스 토큰 저장 시간: $accessTokenTimestamp\n 차이: $accessTokenDiff');
    print(
        '지금 시간: ${DateTime.now()}리프레시 토큰 저장 시간: $refreshTokenTimestamp\n 차이: $refreshTokenDiff');

    //refresh token 유효 기간(30일) 만료
    if (refreshTokenDiff >= const Duration(days: 30)) {
      print("refresh token 만료");
      await _clearStorage();
      return false;
    }
    // 시간 음수 오류 처리
    else if (accessTokenDiff < Duration.zero ||
        refreshTokenDiff < Duration.zero) {
      print('시간 음수 오류');
      await _clearStorage();
      return false;
    }
    // access token 유효 기간(1일) 만료
    else if (accessTokenDiff >= const Duration(days: 1)) {
      print('access token 만료');
      if (await APIs.getAccessToken()) {
        return true;
      } else {
        await _clearStorage();
        return false;
      }
    }
    return true;
  }

  Future<void> _clearStorage() async {
    await storage.delete(key: 'auth');
    await storage.delete(key: 'token');
    await storage.delete(key: 'refreshToken');
  }
}
