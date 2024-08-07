import 'package:aliens/models/screen_argument.dart';
import 'package:aliens/models/signup_model.dart';

import '../models/applicant_model.dart';
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
      mbti: 'ENFP',
      name: 'Daisy',
      nationality: 'South Korea',
      gender: 'FEMALE',
      birthday: '2001-02-01',
      profileImageUrl: '',
      selfIntroduction: '안녕하세요',
    ),
    "AppliedAndMatched",
    Applicant(
        member: Member(
            name: 'Daisy',
            nationality: 'South Korea',
            gender: 'FEMALE',
            mbti: 'ENFP',
            age: 22,
            profileImage: '',
            countryImage: ''),
        preferLanguages: PreferLanguages(
            firstPreferLanguage: 'KOREA', secondPreferLanguage: 'ENGLISH')),
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
    ]);

ScreenArguments mockScreenArgument_2 = ScreenArguments(
    MemberDetails(
      mbti: 'ENFP',
      name: 'Daisy',
      nationality: 'South Korea',
      gender: 'FEMALE',
      birthday: '2001-02-01',
      profileImageUrl: '',
      selfIntroduction: '안녕요',
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
        preferLanguages: PreferLanguages(
            firstPreferLanguage: 'KOREA', secondPreferLanguage: 'ENGLISH')),
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
    id: '2',
    type: 'NORMAL',
    content: "h",
    roomId: 1,
    senderId: 955,
    receiverId: 712,
    sendTime: "2023-07-17 13:56:33.583170",
    isRead: false, // (0)
  );
  //await SqlMessageRepository.create(chat);
  //updateUi();
}
