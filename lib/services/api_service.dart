import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const String domainUrl = 'https://friendship-aliens.com';

class APIService {
  static String? token;
  static String? refreshToken;

  static const storage = FlutterSecureStorage();
}
