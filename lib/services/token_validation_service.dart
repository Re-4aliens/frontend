import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:aliens/services/auth_service.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
// 토큰 유효성 검사

class TokenValidationService {
  static const storage = FlutterSecureStorage();

  Future<bool> checkTokenValidity() async {
    var accessToken = await storage.read(key: 'token');
    var refreshToken = await storage.read(key: 'refreshToken');

    if (accessToken == null || refreshToken == null) {
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

    //refresh token 유효 기간(30일) 만료
    if (refreshTokenDiff >= const Duration(days: 30)) {
      // 리프레시 토큰 만료
      await _clearStorage();
      return false;
    }
    // 시간 음수 오류 처리
    else if (accessTokenDiff < Duration.zero ||
        refreshTokenDiff < Duration.zero) {
      // 시간 음수 오류
      await _clearStorage();
      return false;
    }
    // access token 유효 기간(1일) 만료
    else if (accessTokenDiff >= const Duration(days: 1)) {
      // 액세스 토큰 만료
      if (await AuthService.getAccessToken()) {
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
