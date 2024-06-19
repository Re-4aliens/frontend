


/*
class AuthProvider with ChangeNotifier {
  static final storage = FlutterSecureStorage();

  Future<bool> login(Auth auth, BuildContext context) async {
    const url =
        'http://13.125.205.59:8080/api/v1/member/authentication'; //mocksever

    var response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email" : auth.email,
          "password" : auth.password,
        }));

    //success
    if (response.statusCode == 200) {
      print(json.decode(response.body));


      //로그인 정보 저장
      await storage.write(
        key: 'auth',
        value: jsonEncode(auth),
      );

      //토큰 저장
      await storage.write(
        key: 'token',
        value: jsonEncode(json.decode(response.body)['response']),
      );



      return true;
      //fail
    } else {
      print(response.body);
      return false;
    }
  }

  Future<void> logout(BuildContext context) async {
    print('로그아웃 시도');
    const url =
        'http://13.125.205.59:8080/api/v1/member/authentication'; //mocksever

    //토큰 읽어오기
    var accessToken = await storage.read(key: 'token');
    var refreshToken = await storage.read(key: 'token');

    //accessToken만 보내기
    accessToken = json.decode(accessToken!)['accessToken'];
    refreshToken = json.decode(refreshToken!)['refreshToken'];


    var response = await http.delete(Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
        'RefreshToken': '$refreshToken',
      },
    );

    //success
    if (response.statusCode == 200) {

      //토큰 및 정보 삭제
      await storage.delete(key: 'auth');
      await storage.delete(key: 'token');
      print('로그아웃, 정보 지움');

      //스택 비우고 화면 이동
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false
      );

      //fail
    } else {
      print(response.body);
    }
  }

  Future<void> signUp(Member member, BuildContext context) async {
    print('회원가입 시도');

    const url =
        'http://13.125.205.59:8080/api/v1/member';

    var response = await http.post(Uri.parse(url),
        body: jsonEncode({
          "email" : member.email,
          "password" : member.password,
          "mbti": member.mbti,
          "gender": member.gender,
          "nationality": member.nationality,
          "birthday": member.birthday,
          "name": member.name,
          "profileImage": member.profileImage,
        }));

    //success
    if (response.statusCode == 200) {
      print(json.decode(response.body));

      //storage에 작성할 모델
      final Auth auth = new Auth();

      //------ 로그인 api 요청
      auth.email = member.email;
      auth.password = member.password;

      //로그인 정보 저장
      await storage.write(
        key: 'auth',
        value: jsonEncode(auth),
      );
      //http 요청
      login(auth, context);

      //fail
    } else {
      print(json.decode(response.body));
    }
  }
/*
  Future<void> withdraw(BuildContext context) async {
    print('탈퇴 시도');
    const url =
        'http://13.125.205.59:8080/api/v1/member/authentication'; //mocksever

    var response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email" : auth.email,
          "password" : auth.password,
        }));

    //success
    if (response.statusCode == 200) {
      print(json.decode(response.body));
      //토큰 저장
      await storage.write(
        key: 'token',
        value: response.body,
      );
      print('탈퇴 성공');

      //fail
    } else {
      print(response.body);
    }

  }


 */
}

 */
