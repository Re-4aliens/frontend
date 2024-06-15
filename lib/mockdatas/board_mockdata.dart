import 'package:aliens/models/board_model.dart';

import '../models/noticeArticle.dart';



List<Board> totalBoardList = [
  infoBoard1,
  freePostingBoard1,
  freePostingBoard2,
  gameBoard1,
  foodBoard1,
  musicBoard1,
  musicBoard2,
  infoBoard2,
  infoBoard3,
  musicBoard3,
  gameBoard2,
  freePostingBoard3,
  fashionBoard1,
  fashionBoard2,
  freePostingBoard4
];

List<Board> freePostingBoardList = [
  freePostingBoard1,
  freePostingBoard2,
  freePostingBoard3,
  freePostingBoard4
];

List<Board> gameBoardList = [
  gameBoard1,
  gameBoard2
];

List<Board> fashionBoardList = [
  fashionBoard1,
  fashionBoard2
];

List<Board> foodBoardList = [
  foodBoard1
];

List<Board> musicBoardList = [
  musicBoard1,
  musicBoard2,
  musicBoard3
];

List<Board> infoBoardList = [
  infoBoard1,
  infoBoard2,
  infoBoard3
];


List<Board> MyPostingBoardList = [
  MyPostingBoard1,

];

List<Board> NotificationList=[
  Notification1,
  Notification2
];

List<NoticeArticle> NotiList = [
  Notice1,
  Notice2,
  Notice3,
];

Board freePostingBoard1 = Board(
    articleId: 1,
    category: "자유게시판",
    title: "아니 왜 이렇게 덥냐고용",
    content: "가을은 언제 올까요...ㅜㅜ 입추 매직은 거짓말입니다.",
    likeCount: 109,
    commentsCount: 4,
    createdAt: "2023-08-17 23:53:00",
    imageUrls: [],
    member: Member(
      memberId: 1,
      name: "아이폰",
      nationality: 'South Korea',
      profileImageUrl: "",
    )
);

Board freePostingBoard2 = Board(
    articleId: 2,
    category: "자유게시판",
    title: "なぜだろう",
    content: "ご飯を食べてもお腹が空いた",
    likeCount: 0,
    commentsCount: 4,
    createdAt: "2023-08-17 23:00:33",
    imageUrls: [],
    member: Member(
      memberId: 1,
      name: "ゆうき",
      nationality: 'Japan',
      profileImageUrl: "",
    )
);

Board freePostingBoard3 = Board(
    articleId: 3,
    title: "이거 누가 만든거임?",
    category: "자유게시판",
    content: "잘만들었네",
    likeCount: 10,
    commentsCount: 4,
    createdAt: "2023-08-17 14:30:33",
    imageUrls: [
      "Url",
      "Url",
      "Url"
    ],
    member: Member(
      memberId: 1,
      name: "배고파",
      nationality: 'South Korea',
      profileImageUrl: "",
    )
);

Board freePostingBoard4 = Board(
    articleId: 4,
    title: "맛있겠다 냠냠",
    content: "마라로제찜닭이 너무 먹고 싶다.",
    category: "자유게시판",
    likeCount: 109,
    commentsCount: 4,
    createdAt: "2023-08-06 14:30:33",
    imageUrls: [],
    member: Member(
      memberId: 1,
      name: "햄버거",
      nationality: 'China',
      profileImageUrl: "",
    )
);

Board fashionBoard1 = Board(
    articleId: 5,
    category: "패션게시판",
    title: "패션 평가 좀",
    content: "패평패평~",
    likeCount: 109,
    commentsCount: 4,
    createdAt: "2023-08-06 14:30:33",
    imageUrls: [
      "Url",
      "Url"
    ],
    member: Member(
      memberId: 1,
      name: "햄버거",
      nationality: 'South Korea',
      profileImageUrl: "",
    )
);

Board fashionBoard2 = Board(
    articleId: 4,
    category: "패션게시판",
    title: "오늘 뭐 입지",
    content: "이제 가을이야 ㅜ",
    likeCount: 9,
    commentsCount: 4,
    createdAt: "2023-08-06 14:30:33",
    imageUrls: [],
    member: Member(
      memberId: 1,
      name: "윤정하",
      nationality: 'Australia',
      profileImageUrl: "",
    )
);

Board gameBoard1 = Board(
    articleId: 4,
    category: "게임게시판",
    title: "게임 추천",
    content: "요즘 머가 핫하나요",
    likeCount: 9,
    commentsCount: 4,
    createdAt: "2023-08-06 14:30:33",
    imageUrls: [],
    member: Member(
      memberId: 1,
      name: "윤정하",
      nationality: 'South Korea',
      profileImageUrl: "",
    )
);

Board gameBoard2 = Board(
    articleId: 4,
    category: "게임게시판",
    title: "크아할 사람",
    content: "자유5 접속 하십쇼",
    likeCount: 9,
    commentsCount: 4,
    createdAt: "2023-08-06 14:30:33",
    imageUrls: [],
    member: Member(
      memberId: 1,
      name: "치킨보이",
      nationality: 'Australia',
      profileImageUrl: "",
    )
);

Board foodBoard1 = Board(
    articleId: 4,
    category: "음식게시판",
    title: "오늘 뭐먹지",
    content: "마라로제찜닭",
    likeCount: 2,
    commentsCount: 10,
    createdAt: "2023-08-06 14:30:33",
    imageUrls: [],
    member: Member(
      memberId: 1,
      name: "찜닭",
      nationality: 'South Korea',
      profileImageUrl: "",
    )
);


Board musicBoard1 = Board(
    articleId: 4,
    category: "음악게시판",
    title: "오 노 추",
    content: "이 노래 좋습니다.",
    likeCount: 2,
    commentsCount: 15,
    createdAt: "2023-08-06 14:30:33",
    imageUrls: [
      "Url"
    ],
    member: Member(
      memberId: 1,
      name: "햄버거",
      nationality: 'Japan',
      profileImageUrl: "",
    )
);


Board musicBoard2 = Board(
    articleId: 4,
    category: "음악게시판",
    title: "뉴진스 노래 좋아",
    content: "누가 최애임",
    likeCount: 2,
    commentsCount: 10,
    createdAt: "2023-08-06 14:30:33",
    imageUrls: [],
    member: Member(
      memberId: 1,
      name: "Daisy",
      nationality: 'Australia',
      profileImageUrl: "",
    )
);


Board musicBoard3 = Board(
    articleId: 4,
    title: "노래 내용",
    category: "음악게시판",
    content: "노래노래노래",
    likeCount: 2,
    commentsCount: 10,
    createdAt: "2023-08-06 14:30:33",
    imageUrls: [],
    member: Member(
      memberId: 1,
      name: "윤정하",
      nationality: 'South Korea',
      profileImageUrl: "",
    )
);

Board infoBoard1 = Board(
    articleId: 4,
    title: "2023년 부산 내 거주하는 외국인 비자 지원",
    category: "정보게시판",
    content: "안녕하세요.\n\n부경대학교 외국인 유학생 지원팀\nOOO입니다.\n\n2023년도 부산 내 거주하는 외국인 유학생\n비자 비용 지원 안내에 대해서 공유합니다.",
    likeCount: 2,
    commentsCount: 10,
    createdAt: "2023-08-06 14:30:33",
    imageUrls: [],
    member: Member(
      memberId: 1,
      name: "윤정하",
      nationality: 'South Korea',
      profileImageUrl: "",
    )
);

Board infoBoard2 = Board(
    articleId: 4,
    title: "외국인학생 수강신청 방법 공유",
    category: "정보게시판",
    content: "안녕하세요.\n\n부경대학교 외국인 유학생 지원팀\nOOO입니다.\n\n2023년도 부산 내 거주하는 외국인 유학생\n비자 비용 지원 안내에 대해서 공유합니다.",
    likeCount: 2,
    commentsCount: 10,
    createdAt: "2023-08-06 14:30:33",
    imageUrls: ["url"],
    member: Member(
      memberId: 1,
      name: "윤정하",
      nationality: 'South Korea',
      profileImageUrl: "",
    )
);

Board infoBoard3 = Board(
    articleId: 4,
    title: "가을학기 외국인 한정 교류회 실시",
    category: "정보게시판",
    content: "안녕하세요.\n\n부경대학교 외국인 유학생 지원팀\nOOO입니다.\n\n2023년도 부산 내 거주하는 외국인 유학생\n비자 비용 지원 안내에 대해서 공유합니다.",
    likeCount: 2,
    commentsCount: 10,
    createdAt: "2023-08-06 14:30:33",
    imageUrls: [],
    member: Member(
      memberId: 1,
      name: "윤정하",
      nationality: 'South Korea',
      profileImageUrl: "",
    )
);

Board MyPostingBoard1 = Board(
    articleId: 1,
    title: "낼 점심은 닭가슴살. 신난다.",
    createdAt: "2023-08-17 23:53:00",
    category: "음악게시판",
    imageUrls: [],
    member: Member(
      memberId: 1,
      name: "MM",
      nationality: 'South Korea',
      profileImageUrl: "",
    )
);

Board Notification1= Board(
    articleId: 1,
    title: "낼 점심은 닭가슴살. 신난다.",
    likeCount: 2,
    commentsCount: 10,
    content: "낼 점심은 닭가슴살. 신난다.",
    createdAt: "2023-08-17 23:53:00",
    category: "음악게시판",
    imageUrls: [],
    member: Member(
      memberId: 1,
      name: "Jenny",
      nationality: 'South Korea',
      profileImageUrl: "",
    )
);

Board Notification2= Board(
    articleId: 1,
    title: "요기가 알림기능인가....",
    likeCount: 2,
    commentsCount: 10,
    content: "요기가 알림기능인가....",
    createdAt: "2023-08-31 23:53:00",
    category: "정보게시판",
    imageUrls: [],
    member: Member(
      memberId: 1,
      name: "MM",
      nationality: 'South Korea',
      profileImageUrl: "",
    )
);


NoticeArticle Notice1= NoticeArticle (
  noticeId: 1,
    title: '[Friend Ship 이용시 규칙사항]',
    content: "안녕하세요!! \n Friendship 관리자 ㅇㅇㅇ입니다. ~~~~",
    createdAt: "2023-01-31 23:53:00",


);

NoticeArticle Notice2= NoticeArticle (
  noticeId: 1,
  title: '베타버전 안내&베타테스터 모집 ',
  content: "베타테스터 하실분~~~ 추첨을 통해 맥북드림",
  createdAt: "2023-01-31 23:53:00",

);

NoticeArticle Notice3= NoticeArticle (
  noticeId: 1,
  title: '3.1ver 업데이트 안내',
  content: "업데이트 되었으니 업데이트 하시오",
  createdAt: "2023-01-31 23:53:00",

);