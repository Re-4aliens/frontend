import 'dart:convert';
import 'package:aliens/models/comment_model.dart';
import 'package:http/http.dart' as http;
import 'api_service.dart';
import 'package:aliens/models/signup_model.dart';
import '../util/image_util.dart';
import 'package:http_parser/http_parser.dart';
import 'package:aliens/models/market_board_model.dart';
import 'package:aliens/models/member_details_model.dart';
import 'package:aliens/models/board_model.dart';

class UserService extends APIService {
  /* 

    사용자 정보 저장

  */
  static Future<String> fetchUserEmail() async {
    var userInfo = await APIService.storage.read(key: 'auth');
    if (userInfo != null && userInfo.isNotEmpty) {
      var decodedUserInfo = json.decode(userInfo);
      return decodedUserInfo['email'];
    }
    return '';
  }

  /*

  회원가입

   */
  static Future<bool> signUp(SignUpModel member) async {
    const url = '$domainUrl/members';

    var request = http.MultipartRequest('POST', Uri.parse(url));

    // 프로필 이미지 추가
    if (member.profileImage != null && member.profileImage!.isNotEmpty) {
      var file = await ImageUtil.compressImageToMultipartFile(
        'profileImage',
        member.profileImage!,
      );
      request.files.add(file);
    } else {
      // 프로필 이미지가 없을 경우 빈 파일로 대체
      var file = http.MultipartFile.fromString(
        'profileImage',
        '',
        filename: 'empty.txt',
        contentType: MediaType('text', 'plain'), // 빈 파일의 Content-Type 설정
      );
      request.files.add(file);
    }

    // JSON 데이터를 문자열로 변환
    var jsonPayload = jsonEncode({
      'email': member.email,
      'password': member.password,
      'name': member.name,
      'mbti': member.mbti,
      'gender': member.gender,
      'nationality': member.nationality,
      'birthday': member.birthday,
      'aboutMe': member.aboutMe ?? '',
    });

    // JSON 데이터를 MultipartFile로 추가
    var jsonPart = http.MultipartFile.fromString(
      'request',
      jsonPayload,
      contentType: MediaType('application', 'json'),
    );
    request.files.add(jsonPart);

    // 요청 보내기
    var response = await request.send();

    if (response.statusCode == 200) {
      return true;
    } else {
      var responseBody = await response.stream.bytesToString();
      return false;
    }
  }

  /*

    개인 정보 조회

  */
  static Future<MemberDetails> getMemberDetails() async {
    var url = '$domainUrl/members';

    var jwtToken = await APIService.storage.read(key: 'token') ?? '';

    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': jwtToken,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      var responseBody = json.decode(utf8.decode(response.bodyBytes));
      return MemberDetails.fromJson(responseBody['result']);
    } else {
      throw Exception('요청 오류');
    }
  }

  /*

    작성자와 사용자 동일 여부 (장터게시판)

  */
  static bool isMarketAuthor(
      MemberDetails memberDetails, MarketBoard marketBoard) {
    return memberDetails.name == marketBoard.memberProfileDto?.name &&
        memberDetails.profileImageUrl ==
            marketBoard.memberProfileDto?.profileImageUrl &&
        memberDetails.nationality == marketBoard.memberProfileDto?.nationality;
  }

  /*

    작성자와 사용자 동일 여부 (일반게시판)

  */
  static bool isBoardtAuthor(MemberDetails memberDetails, Board board) {
    return memberDetails.name == board.memberProfileDto?.name &&
        memberDetails.profileImageUrl ==
            board.memberProfileDto?.profileImageUrl &&
        memberDetails.nationality == board.memberProfileDto?.nationality;
  }

  /*

    작성자와 사용자 동일 여부 (댓글)

  */
  static bool isCommentAuthor(MemberDetails memberDetails, Comment comment) {
    return memberDetails.name == comment.memberProfileDto.name &&
        memberDetails.profileImageUrl ==
            comment.memberProfileDto.profileImageUrl &&
        memberDetails.nationality == comment.memberProfileDto.nationality;
  }

  /*

  mbti 변경

   */
  static Future<bool> updateMBTI(String newMBTI) async {
    var url = '$domainUrl/members/mbti';

    var jwtToken = await APIService.storage.read(key: 'token') ?? '';

    var response = await http.patch(
      Uri.parse(url),
      headers: {
        'Authorization': jwtToken,
        'Content-Type': 'application/json;charset=UTF-8',
      },
      body: newMBTI,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  /*

프로필 수정

 */

  static Future<bool> updateProfile(String profileImage) async {
    var url = '$domainUrl/members/profile-image';

    var jwtToken = await APIService.storage.read(key: 'token') ?? '';

    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers['Authorization'] = jwtToken;

    if (profileImage.isNotEmpty) {
      var file = await ImageUtil.compressImageToMultipartFile(
        'newProfileImage',
        profileImage, // 프로필 이미지의 Content-Type 설정
      );
      request.files.add(file);
    } else {
      // 프로필 이미지가 없을 경우 빈 파일로 대체
      var file = http.MultipartFile.fromString(
        'newProfileImage',
        '',
        filename: 'empty.txt',
        contentType: MediaType('text', 'plain'), // 빈 파일의 Content-Type 설정
      );
      request.files.add(file);
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      return true;
    } else {
      var responseBody = await response.stream.bytesToString();
      return false;
    }
  }

  /*

  자기소개 변경

  */
  static Future<bool> updateSelfIntroduction(String newAboutMe) async {
    var url = '$domainUrl/members/about-me';

    var jwtToken = await APIService.storage.read(key: 'token') ?? '';

    var response = await http.patch(
      Uri.parse(url),
      headers: {
        'Authorization': jwtToken,
        'Content-Type': 'application/json;charset=UTF-8',
      },
      body: newAboutMe,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  /*
    
    회원 매칭상태 조회

  */
  static Future<String> getApplicantStatus() async {
    var url = '$domainUrl/members/status';

    var jwtToken = await APIService.storage.read(key: 'token');

    if (jwtToken != null) {
      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': jwtToken,
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        var responseBody = json.decode(utf8.decode(response.bodyBytes));
        var matchingStatus = responseBody['result']['status'];

        await APIService.storage.write(
            key: 'memberId',
            value: responseBody['result']['memberId'].toString());

        String? memberIdString = await APIService.storage.read(key: 'memberId');
        print(memberIdString);

        return matchingStatus; // 매칭상태 반환
      } else {
        return "NotAppliedAndNotMatched";
      }
    } else {
      // jwtToken이 null인 경우
      throw 'TokenNotFound';
    }
  }

  /*

  회원 정보 삭제 => 회원탈퇴랑 같은거 같으나 기존 코드라 둠

   */
  static Future<void> deleteInfo(memberId) async {
    var url = 'http://3.34.2.246:8080/api/v1/member/$memberId';

    var response = await http.delete(
      Uri.parse(url),
    );

    //success
    if (response.statusCode == 200) {
      //fail
    } else {}
  }

  /*

  매칭 신청 // 매칭 신청 api작성했으나 기존 코드라서 둠

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
      return true;
    }
    //fail
    else {
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-002') {
        // 액세스 토큰 만료
        throw 'AT-C-002';
      } else if (json.decode(utf8.decode(response.bodyBytes))['code'] ==
          'AT-C-007') {
        // 로그아웃된 토큰
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
    var url = '$domainUrl/matchings/applications';

    var jwtToken = await APIService.storage.read(key: 'token') ?? '';

    var response = await http.put(
      Uri.parse(url),
      headers: {
        'Authorization': jwtToken,
        'Content-Type': 'application/json;charset=UTF-8',
      },
      body: jsonEncode({
        "firstPreferLanguage": firstPreferLanguage,
        "secondPreferLanguage": secondPreferLanguage,
      }),
    );

    if (response.statusCode == 200) {
      var responseBody = json.decode(utf8.decode(response.bodyBytes));
      return true;
    } else {
      var responseBody = json.decode(utf8.decode(response.bodyBytes));
      if (responseBody['code'] == 'AT-C-002') {
        // 액세스 토큰 만료
        throw 'AT-C-002';
      } else if (responseBody['code'] == 'AT-C-007') {
        // 로그아웃된 토큰
        throw 'AT-C-007';
      } else if (responseBody['code'] == 'MT-C-005') {
        // 정보 없음
        return false;
      } else {
        throw Exception('요청 오류');
      }
    }
  }
}
