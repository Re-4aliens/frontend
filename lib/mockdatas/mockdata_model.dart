import 'package:aliens/models/screenArgument.dart';
import 'package:aliens/models/signup_model.dart';

import '../models/applicant_model.dart';
import '../models/memberDetails_model.dart';
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
      profileImage: '',
      age: 22,
    ),
    "MATCHED",
    Applicant(
        member: Member(
            name: 'Daisy',
            nationality: 'South Korea',
            gender: 'FEMALE',
            mbti: 'ENFP',
            age: 22,
            profileImage: '',
            countryImage: ''),
        preferLanguages:
            PreferLanguages(firstPreferLanguage: 'KOREA', secondPreferLanguage: 'ENGLISH')),
    [
      Partner(
        roomState: "OPEN",
        roomId: 1,
          name: '파트너1',
          nationality: 'South Korea',
          gender: 'FEMALE',
          mbti: 'ENFP',
          memberId: 712,
          profileImage: '',
          firstPreferLanguage: "KOREAN",
      secondPreferLanguage: "ENGLISH"),
      Partner(
          roomState: "OPEN",
          roomId: 2,
          name: '파트너2',
          nationality: 'South Korea',
          gender: 'MALE',
          mbti: 'ISTJ',
          memberId: 3,
          profileImage: '',
          firstPreferLanguage: "KOREAN",
          secondPreferLanguage: "ENGLISH"),
      Partner(
          roomState: "OPEN",
          roomId: 3,
          name: '파트너3',
          nationality: 'South Korea',
          gender: 'MALE',
          mbti: 'ISTJ',
          memberId: 193,
          profileImage: '',
          firstPreferLanguage: "KOREAN",
          secondPreferLanguage: "ENGLISH"),
      Partner(
          roomState: "OPEN",
          roomId: 4,
          name: '파트너4',
          nationality: 'South Korea',
          gender: 'MALE',
          mbti: 'ISTJ',
          memberId: 948,
          profileImage: '',
          firstPreferLanguage: "KOREAN",
          secondPreferLanguage: "ENGLISH")
    ]
);


ScreenArguments mockScreenArgument_2 = ScreenArguments(
    MemberDetails(
      memberId: 1017,
      mbti: 'ENFP',
      name: 'Daisy',
      nationality: 'South Korea',
      email: 'gorus132@naver.com',
      gender: 'FEMALE',
      birthday: '2001-02-01',
      profileImage: '',
      age: 22,
    ),
    "MATCHED",
    Applicant(
        member: Member(
            name: 'Daisy',
            nationality: 'South Korea',
            gender: 'FEMALE',
            mbti: 'ENFP',
            age: 22,
            profileImage: '',
            countryImage: ''),
        preferLanguages:
        PreferLanguages(firstPreferLanguage: 'KOREA', secondPreferLanguage: 'ENGLISH')),
    [
      Partner(
          roomState: "OPEN",
          roomId: 43,
          name: '파트너1',
          nationality: 'South Korea',
          gender: 'FEMALE',
          mbti: 'ENFP',
          memberId: 16,
          profileImage: '',
          firstPreferLanguage: "KOREAN",
          secondPreferLanguage: "ENGLISH"),
      Partner(
          roomState: "OPEN",
          roomId: 2,
          name: '파트너2',
          nationality: 'South Korea',
          gender: 'MALE',
          mbti: 'ISTJ',
          memberId: 3,
          profileImage: '',
          firstPreferLanguage: "KOREAN",
          secondPreferLanguage: "ENGLISH"),
      Partner(
          roomState: "OPEN",
          roomId: 3,
          name: '파트너3',
          nationality: 'South Korea',
          gender: 'MALE',
          mbti: 'ISTJ',
          memberId: 193,
          profileImage: '',
          firstPreferLanguage: "KOREAN",
          secondPreferLanguage: "ENGLISH"),
      Partner(
          roomState: "OPEN",
          roomId: 4,
          name: '파트너4',
          nationality: 'South Korea',
          gender: 'MALE',
          mbti: 'ISTJ',
          memberId: 948,
          profileImage: '',
          firstPreferLanguage: "KOREAN",
          secondPreferLanguage: "ENGLISH")
    ]
);

SignUpModel signUpModel = SignUpModel(
  email: 'gorus132@gmail.com',
  name: 'Daisy',
  mbti: 'ENFP',
  gender: 'FEMALE',
  nationality: 'India',
  password: '1234567',
  birthday: '1993-09-13',
  profileImage: '',
  selfIntroduction: '',

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