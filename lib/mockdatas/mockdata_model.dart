import 'package:aliens/models/matching_applicant_model.dart';
import 'package:aliens/models/screen_argument.dart';
import 'package:aliens/models/signup_model.dart';

import '../models/member_details_model.dart';
import '../models/message_model.dart';
import '../models/partner_model.dart';

var token = const [
  {
    "accessToken": "213ss.s.21231232.axdasdas21451.1252134",
    "refreshToken": "213ss.s.21231232.axdasdas21451.1252134"
  }
];

var memberDetails = const [
  {
    "email": "exaple_user@exaple.com",
    "mbti": "ENFJ",
    "gender": "MALE",
    "nationality": "Korea",
    "birthday": "2000-01-01",
    "name": "RYAN",
    "profileImage": "url",
    "age": 26
  }
];

var status = const [
  /*
  경우에 따라
  MATCHED, PENDING, NOT_APPLIED 입력
   */
  {"status": "MATCHED"}
];

var applicant = const [
  {
    "member": {
      "name": "Jenny",
      "gender": "Female",
      "mbti": "INTJ",
      "nationality": "Korea",
      "age": 26,
      "profileImage": "url/example",
      "countryImage": "url/example"
    },
    "preferLanguages": {
      "firstPreferLanguage": "string",
      "secondPreferLanguage": "string"
    }
  }
];

var partners = const [
  {
    "members": [
      {
        "memberId": 1,
        "name": "Jenny",
        "mbti": "ENTJ",
        "gender": "FEMALE",
        "nationality": "Korean",
        "profileImage": "url",
        "countryImage": "url"
      },
      {
        "memberId": 1,
        "name": "Jenny",
        "mbti": "ENTJ",
        "gender": "FEMALE",
        "nationality": "Korean",
        "profileImage": "url",
        "countryImage": "url"
      },
    ]
  }
];

ScreenArguments mockScreenArgument_1 = ScreenArguments(
    MemberDetails(
      memberId: 955,
      mbti: 'ENFP',
      name: 'Daisy',
      nationality: 'South Korea',
      email: 'gorus132@naver.com',
      gender: 'FEMALE',
      birthday: '2001-02-01',
      profileImageURL: '',
    ),
    "AppliedAndMatched",
    MatchingApplicant(
      memberId: 2,
      matchingRound: 1,
      firstPreferLanguage: 'KOREAN',
      secondPreferLanguage: 'ENGLISH',
    ),
    [
      Partner(
        roomStatus: "OPEN",
        chatRoomId: 1,
        name: '파트너1',
        nationality: 'South Korea',
        gender: 'FEMALE',
        mbti: 'ENFP',
        partnerMemberId: 712,
        profileImageUrl: '',
        aboutMe: '',
        firstPreferLanguage: "KOREAN",
        secondPreferLanguage: "ENGLISH",
        relation: "SPECIAL",
      ),
      Partner(
        roomStatus: "OPEN",
        chatRoomId: 2,
        name: '파트너2',
        nationality: 'South Korea',
        gender: 'MALE',
        mbti: 'ISTJ',
        partnerMemberId: 3,
        profileImageUrl: '',
        aboutMe: '',
        firstPreferLanguage: "KOREAN",
        secondPreferLanguage: "ENGLISH",
        relation: "SPECIAL",
      ),
      Partner(
        roomStatus: "OPEN",
        chatRoomId: 3,
        name: '파트너3',
        nationality: 'South Korea',
        gender: 'MALE',
        mbti: 'ISTJ',
        partnerMemberId: 193,
        profileImageUrl: '',
        aboutMe: '',
        firstPreferLanguage: "KOREAN",
        secondPreferLanguage: "ENGLISH",
        relation: "SPECIAL",
      ),
      Partner(
        roomStatus: "OPEN",
        chatRoomId: 4,
        name: '파트너4',
        nationality: 'South Korea',
        gender: 'MALE',
        mbti: 'ISTJ',
        partnerMemberId: 948,
        profileImageUrl: '',
        aboutMe: '',
        firstPreferLanguage: "KOREAN",
        secondPreferLanguage: "ENGLISH",
        relation: "SPECIAL",
      )
    ]);

ScreenArguments mockScreenArgument_2 = ScreenArguments(
    MemberDetails(
      memberId: 1017,
      mbti: 'ENFP',
      name: 'Daisy',
      nationality: 'South Korea',
      email: 'gorus132@naver.com',
      gender: 'FEMALE',
      birthday: '2001-02-01',
      profileImageURL: '',
    ),
    "MATCHED",
    MatchingApplicant(
      memberId: 1,
      matchingRound: 1,
      firstPreferLanguage: 'KOREAN',
      secondPreferLanguage: 'ENGLISH',
    ),
    [
      Partner(
        roomStatus: "OPEN",
        chatRoomId: 43,
        name: '파트너1',
        nationality: 'South Korea',
        gender: 'FEMALE',
        mbti: 'ENFP',
        partnerMemberId: 16,
        profileImageUrl: '',
        aboutMe: '',
        firstPreferLanguage: "KOREAN",
        secondPreferLanguage: "ENGLISH",
        relation: "SPECIAL",
      ),
      Partner(
        roomStatus: "OPEN",
        chatRoomId: 2,
        name: '파트너2',
        nationality: 'South Korea',
        gender: 'MALE',
        mbti: 'ISTJ',
        partnerMemberId: 3,
        profileImageUrl: '',
        aboutMe: '',
        firstPreferLanguage: "KOREAN",
        secondPreferLanguage: "ENGLISH",
        relation: "SPECIAL",
      ),
      Partner(
        roomStatus: "OPEN",
        chatRoomId: 3,
        name: '파트너3',
        nationality: 'South Korea',
        gender: 'MALE',
        mbti: 'ISTJ',
        partnerMemberId: 193,
        profileImageUrl: '',
        aboutMe: '',
        firstPreferLanguage: "KOREAN",
        secondPreferLanguage: "ENGLISH",
        relation: "SPECIAL",
      ),
      Partner(
        roomStatus: "OPEN",
        chatRoomId: 4,
        name: '파트너4',
        nationality: 'South Korea',
        gender: 'MALE',
        mbti: 'ISTJ',
        partnerMemberId: 948,
        profileImageUrl: '',
        aboutMe: '',
        firstPreferLanguage: "KOREAN",
        secondPreferLanguage: "ENGLISH",
        relation: "SPECIAL",
      )
    ]);

SignUpModel signUpModel = SignUpModel(
  email: 'gorus132@gmail.com',
  name: 'Daisy',
  mbti: 'ENFP',
  gender: 'FEMALE',
  nationality: 'India',
  password: '1234567',
  birthday: '1993-09-13',
  profileImage: '',
  aboutMe: '',
);

void saveMockData() async {
  var chat = MessageModel(
    chatId: 2,
    chatType: 0,
    chatContent: "h",
    roomId: 1,
    senderId: 955,
    senderName: "Ryan",
    receiverId: 712,
    sendTime: "2023-07-17 13:56:33.583170",
    unreadCount: 0,
  );
  //await SqlMessageRepository.create(chat);
  //updateUi();
}
