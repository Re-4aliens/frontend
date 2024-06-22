import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';
import 'package:aliens/models/signup_model.dart';
import '../util/image_util.dart';
import 'dart:io';

class UserService extends APIService {
  /*

  회원가입

   */
  static Future<bool> signUp(SignUpModel member) async {
    const url = 'http://3.34.2.246:8080/api/v1/member';

    var request = http.MultipartRequest('POST', Uri.parse(url));

    // FormData 텍스트 필드 추가
    request.fields['email'] = member.email!;
    request.fields['password'] = member.password!;
    request.fields['mbti'] = member.mbti!;
    request.fields['gender'] = member.gender!;
    request.fields['nationality'] = member.nationality!;
    request.fields['birthday'] = member.birthday!;
    request.fields['name'] = member.name!;

    if (member.selfIntroduction != null &&
        member.selfIntroduction!.isNotEmpty) {
      request.fields['selfIntroduction'] = member.selfIntroduction!;
    } else {
      request.fields['selfIntroduction'] = ' ';
    }
    // FormData 파일 필드 추가
    if (member.profileImage != null && member.profileImage!.isNotEmpty) {
      var file = await ImageUtil.compressImageToMultipartFile(
        'profileImage',
        member.profileImage!,
      );
      request.files.add(file);
    }

    // request 전송
    var response = await request.send();

    // success
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      return true;
      // fail
    } else {
      print(await response.stream.bytesToString());
      return false;
    }
  }

  /*

    개인 정보 조회

  */
  static Future<Map<String, dynamic>> getMemberDetails() async {
    var url = 'http://3.34.2.246:8080/api/v1/member'; //mocksever

    //토큰 읽어오기
    var jwtToken = await APIService.storage.read(key: 'token');

    //accessToken만 보내기
    jwtToken = json.decode(jwtToken!)['data']['accessToken'];

    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json'
      },
    );

    if (response.statusCode == 200) {
      print(json.decode(utf8.decode(response.bodyBytes)));
      return json.decode(utf8.decode(response.bodyBytes))['data'];
    } else {
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-002') {
        // 엑세스 토큰 만료
        throw 'AT-C-002';
      } else if (json.decode(utf8.decode(response.bodyBytes))['code'] ==
          'AT-C-007') {
        // 로그아웃된 토큰
        throw 'AT-C-007';
      } else {
        // 예외
      }
      throw Exception('요청 오류');
    }
  }

  /*

  mbti 수정

   */
  static Future<bool> updateMBTI(String mbti) async {
    var url = 'http://3.34.2.246:8080/api/v1/member';

    // 토큰 읽어오기
    var jwtToken = await APIService.storage.read(key: 'token');

    // 액세스 토큰만 보내기
    jwtToken = json.decode(jwtToken!)['data']['accessToken'];

    // 업데이트할 MBTI 정보를 담은 Map 생성
    var requestData = {
      'mbti': mbti,
    };
    var response = await http.patch(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json',
      },
      body: json.encode(requestData),
    );
    //성공
    if (response.statusCode == 200) {
      print(json.decode(utf8.decode(response.bodyBytes)));
      return true;
    }
    //실패
    else {
      print(json.decode(utf8.decode(response.bodyBytes)));
      return false;
    }
  }

  /*

프로필 수정

 */

  static Future<bool> updateProfile(File profileImageFile) async {
    var url = 'http://3.34.2.246:8080/api/v1/member/profile-image';

    // 토큰 읽어오기
    var jwtToken = await APIService.storage.read(key: 'token');

    // 액세스 토큰만 보내기
    jwtToken = json.decode(jwtToken!)['data']['accessToken'];

    // MultipartFile로 변환
    var profileImage = await ImageUtil.compressImageToMultipartFile(
      'profileImage',
      profileImageFile.path,
    );

    // FormData 생성
    var formData = http.MultipartRequest('PUT', Uri.parse(url));
    formData.headers['Authorization'] = 'Bearer $jwtToken';
    formData.files.add(profileImage);

    // 요청 전송
    var response = await formData.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      return true;
    } else {
      print(response.reasonPhrase);
      return false;
    }
  }

  /*

  자기소개 변경

  */
  static Future<bool> updateSelfIntroduction(String selfIntroduction) async {
    var url = 'http://3.34.2.246:8080/api/v1/member/self-introduction';

    //토큰 읽어오기
    var jwtToken = await APIService.storage.read(key: 'token');

    // 액세스 토큰만 보내기
    jwtToken = json.decode(jwtToken!)['data']['accessToken'];

    // 업데이트할 MBTI 정보를 담은 Map 생성
    var requestData = {
      'selfIntroduction': selfIntroduction,
    };

    var response = await http.put(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json',
      },
      body: json.encode(requestData),
    );

    //성공
    if (response.statusCode == 200) {
      print(json.decode(utf8.decode(response.bodyBytes)));
      return true;
    }
    //실패
    else {
      print(json.decode(utf8.decode(response.bodyBytes)));
      return false;
    }
  }

  /*
    
    회원 매칭상태 조회

  */
  static Future<String> getApplicantStatus() async {
    var url = 'http://3.34.2.246:8080/api/v1/applicant/status'; //mocksever

    //토큰 읽어오기
    var jwtToken = await APIService.storage.read(key: 'token');

    //accessToken만 보내기
    jwtToken = json.decode(jwtToken!)['data']['accessToken'];

    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json'
      },
    );
    //success
    if (response.statusCode == 200) {
      print('${json.decode(utf8.decode(response.bodyBytes))}');
      return json.decode(utf8.decode(response.bodyBytes))['data']['status'];

      //fail
    }
    print(json.decode(utf8.decode(response.bodyBytes)));
    if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-002') {
      print('액세스 토큰 만료');
      throw 'AT-C-002';
    } else if (json.decode(utf8.decode(response.bodyBytes))['code'] ==
        'AT-C-007') {
      print('로그아웃된 토큰');
      throw 'AT-C-007';
    } else if (json.decode(utf8.decode(response.bodyBytes))['code'] ==
        'MT-C-005') {
      print('정보 없음');
      return "NotAppliedAndNotMatched";
    } else {}
    throw Exception('요청 오류');
  }

  /*

  회원 정보 삭제
  http://13.125.205.5ㅐ9:8080/api/v1/member/906

   */
  static Future<void> deleteInfo(memberId) async {
    var url = 'http://3.34.2.246:8080/api/v1/member/$memberId';

    var response = await http.delete(
      Uri.parse(url),
    );

    //success
    if (response.statusCode == 200) {
      print(json.decode(utf8.decode(response.bodyBytes)));

      //fail
    } else {
      print(response.body);
    }
  }

  /*

  매칭 신청 

   */
  static Future<bool> inquiry(String question) async {
    var url = 'http://3.34.2.246:8080/api/v1/member/question'; //mocksever

    //토큰 읽어오기
    var jwtToken = await APIService.storage.read(key: 'token');

    //accessToken만 보내기
    jwtToken = json.decode(jwtToken!)['data']['accessToken'];

    var response = await http.post(Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $jwtToken',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          "question": question,
        }));

    //success
    if (response.statusCode == 200) {
      print(json.decode(utf8.decode(response.bodyBytes)));
      return true;
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
      return false;
    }
  }

  /*

  선호 언어 수정 > 매칭 신청 정보 수정

   */
  static Future<bool> updatePreferLanguage(
      String firstPreferLanguage, String secondPreferLanguage) async {
    var url = 'http://3.34.2.246:8080/api/v1/applicant/prefer-languages';

    // 토큰 읽어오기
    var jwtToken = await APIService.storage.read(key: 'token');

    // 액세스 토큰만 보내기
    jwtToken = json.decode(jwtToken!)['data']['accessToken'];

    var response = await http.patch(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "firstPreferLanguage": firstPreferLanguage,
        "secondPreferLanguage": secondPreferLanguage,
      }),
    );
    //성공
    if (response.statusCode == 200) {
      print(json.decode(utf8.decode(response.bodyBytes)));
      return true;
    }
    //실패
    else {
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-002') {
        print('액세스 토큰 만료');
        throw 'AT-C-002';
      } else if (json.decode(utf8.decode(response.bodyBytes))['code'] ==
          'AT-C-007') {
        print('로그아웃된 토큰');
        throw 'AT-C-007';
      } else if (json.decode(utf8.decode(response.bodyBytes))['code'] ==
          'MT-C-005') {
        print('정보 없음');
        return false;
      } else {}
      throw Exception('요청 오류');
    }
  }
}
