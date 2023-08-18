import 'package:aliens/models/board_model.dart';

List<Board> totalBoardList = [
  freePostingBoard1,
  freePostingBoard2,
  gameBoard1,
  foodBoard1,
  musicBoard1,
  musicBoard2,
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


Board freePostingBoard1 = Board(
  boardArticleId: 1,
    category: "자유게시판",
  title: "아니 왜 이렇게 덥냐고용",
  content: "가을은 언제 올까요...ㅜㅜ 입추 매직은 거짓말입니다.",
  likeCount: 109,
  commentCount: 4,
  createdAt: "2023-08-17 23:53:00",
  imageUrls: null,
  member: Member(
    memberId: 1,
    name: "아이폰",
    nationality: 'South Korea',
    profileImageUrl: "",
  )
);

Board freePostingBoard2 = Board(
    boardArticleId: 2,
    category: "자유게시판",
    title: "なぜだろう",
    content: "ご飯を食べてもお腹が空いた",
    likeCount: 0,
    commentCount: 4,
    createdAt: "2023-08-17 23:00:33",
    imageUrls: null,
    member: Member(
      memberId: 1,
      name: "ゆうき",
      nationality: 'South Korea',
      profileImageUrl: "",
    )
);

Board freePostingBoard3 = Board(
    boardArticleId: 3,
    title: "이거 누가 만든거임?",
    category: "자유게시판",
    content: "잘만들었네",
    likeCount: 10,
    commentCount: 4,
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
    boardArticleId: 4,
    title: "맛있겠다 냠냠",
    content: "마라로제찜닭이 너무 먹고 싶다.",
    category: "자유게시판",
    likeCount: 109,
    commentCount: 4,
    createdAt: "2023-08-06 14:30:33",
    imageUrls: null,
    member: Member(
      memberId: 1,
      name: "햄버거",
      nationality: 'South Korea',
      profileImageUrl: "",
    )
);

Board fashionBoard1 = Board(
    boardArticleId: 5,
    category: "패션게시판",
    title: "패션 평가 좀",
    content: "패평패평~",
    likeCount: 109,
    commentCount: 4,
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
    boardArticleId: 4,
    category: "패션게시판",
    title: "오늘 뭐 입지",
    content: "이제 가을이야 ㅜ",
    likeCount: 9,
    commentCount: 4,
    createdAt: "2023-08-06 14:30:33",
    imageUrls: null,
    member: Member(
      memberId: 1,
      name: "윤정하",
      nationality: 'South Korea',
      profileImageUrl: "",
    )
);

Board gameBoard1 = Board(
    boardArticleId: 4,
    category: "게임게시판",
    title: "게임 추천",
    content: "요즘 머가 핫하나요",
    likeCount: 9,
    commentCount: 4,
    createdAt: "2023-08-06 14:30:33",
    imageUrls: null,
    member: Member(
      memberId: 1,
      name: "윤정하",
      nationality: 'South Korea',
      profileImageUrl: "",
    )
);

Board gameBoard2 = Board(
    boardArticleId: 4,
    category: "게임게시판",
    title: "크아할 사람",
    content: "자유5 접속 하십쇼",
    likeCount: 9,
    commentCount: 4,
    createdAt: "2023-08-06 14:30:33",
    imageUrls: null,
    member: Member(
      memberId: 1,
      name: "치킨보이",
      nationality: 'South Korea',
      profileImageUrl: "",
    )
);

Board foodBoard1 = Board(
    boardArticleId: 4,
    category: "음식게시판",
    title: "오늘 뭐먹지",
    content: "마라로제찜닭",
    likeCount: 2,
    commentCount: 10,
    createdAt: "2023-08-06 14:30:33",
    imageUrls: null,
    member: Member(
      memberId: 1,
      name: "찜닭",
      nationality: 'South Korea',
      profileImageUrl: "",
    )
);


Board musicBoard1 = Board(
    boardArticleId: 4,
    category: "음악게시판",
    title: "오 노 추",
    content: "이 노래 좋습니다.",
    likeCount: 2,
    commentCount: 15,
    createdAt: "2023-08-06 14:30:33",
    imageUrls: [
      "Url"
    ],
    member: Member(
      memberId: 1,
      name: "햄버거",
      nationality: 'South Korea',
      profileImageUrl: "",
    )
);


Board musicBoard2 = Board(
    boardArticleId: 4,
    category: "음악게시판",
    title: "뉴진스 노래 좋아",
    content: "누가 최애임",
    likeCount: 2,
    commentCount: 10,
    createdAt: "2023-08-06 14:30:33",
    imageUrls: null,
    member: Member(
      memberId: 1,
      name: "Daisy",
      nationality: 'South Korea',
      profileImageUrl: "",
    )
);


Board musicBoard3 = Board(
    boardArticleId: 4,
    title: "노래 내용",
    category: "음악게시판",
    content: "노래노래노래",
    likeCount: 2,
    commentCount: 10,
    createdAt: "2023-08-06 14:30:33",
    imageUrls: null,
    member: Member(
      memberId: 1,
      name: "윤정하",
      nationality: 'South Korea',
      profileImageUrl: "",
    )
);


