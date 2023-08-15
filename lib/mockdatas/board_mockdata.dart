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
  title: "아니 왜 이렇게 덥냐고용",
  likeCount: 109,
  commentCount: 4,
  createdAt: "2023-08-06-14:30:33",
  imageUrls: null,
  member: Member(
    memberId: 1,
    nickname: "아이폰",
    profileImageUrl: "",
  )
);

Board freePostingBoard2 = Board(
    boardArticleId: 2,
    title: "なぜだろう",
    likeCount: 0,
    commentCount: 4,
    createdAt: "2023-08-06-14:30:33",
    imageUrls: null,
    member: Member(
      memberId: 1,
      nickname: "ゆうき",
      profileImageUrl: "",
    )
);

Board freePostingBoard3 = Board(
    boardArticleId: 3,
    title: "이거 누가 만든거임?",
    likeCount: 10,
    commentCount: 4,
    createdAt: "2023-08-06-14:30:33",
    imageUrls: [
      "Url",
      "Url",
      "Url"
    ],
    member: Member(
      memberId: 1,
      nickname: "배고파",
      profileImageUrl: "",
    )
);

Board freePostingBoard4 = Board(
    boardArticleId: 4,
    title: "맛있겠다 냠냠",
    likeCount: 109,
    commentCount: 4,
    createdAt: "2023-08-06-14:30:33",
    imageUrls: null,
    member: Member(
      memberId: 1,
      nickname: "햄버거",
      profileImageUrl: "",
    )
);

Board fashionBoard1 = Board(
    boardArticleId: 5,
    title: "패션 평가 좀",
    likeCount: 109,
    commentCount: 4,
    createdAt: "2023-08-06-14:30:33",
    imageUrls: [
      "Url",
      "Url"
    ],
    member: Member(
      memberId: 1,
      nickname: "햄버거",
      profileImageUrl: "",
    )
);

Board fashionBoard2 = Board(
    boardArticleId: 4,
    title: "오늘 뭐 입지",
    likeCount: 9,
    commentCount: 4,
    createdAt: "2023-08-06-14:30:33",
    imageUrls: null,
    member: Member(
      memberId: 1,
      nickname: "윤정하",
      profileImageUrl: "",
    )
);

Board gameBoard1 = Board(
    boardArticleId: 4,
    title: "게임 추천",
    likeCount: 9,
    commentCount: 4,
    createdAt: "2023-08-06-14:30:33",
    imageUrls: null,
    member: Member(
      memberId: 1,
      nickname: "윤정하",
      profileImageUrl: "",
    )
);

Board gameBoard2 = Board(
    boardArticleId: 4,
    title: "게임 하자",
    likeCount: 9,
    commentCount: 4,
    createdAt: "2023-08-06-14:30:33",
    imageUrls: null,
    member: Member(
      memberId: 1,
      nickname: "치킨보이",
      profileImageUrl: "",
    )
);

Board foodBoard1 = Board(
    boardArticleId: 4,
    title: "오늘 뭐먹지",
    likeCount: 2,
    commentCount: 10,
    createdAt: "2023-08-06-14:30:33",
    imageUrls: null,
    member: Member(
      memberId: 1,
      nickname: "찜닭",
      profileImageUrl: "",
    )
);


Board musicBoard1 = Board(
    boardArticleId: 4,
    title: "오 노 추",
    likeCount: 2,
    commentCount: 15,
    createdAt: "2023-08-06-14:30:33",
    imageUrls: [
      "Url"
    ],
    member: Member(
      memberId: 1,
      nickname: "햄버거",
      profileImageUrl: "",
    )
);


Board musicBoard2 = Board(
    boardArticleId: 4,
    title: "뉴진스 노래 좋아",
    likeCount: 2,
    commentCount: 10,
    createdAt: "2023-08-06-14:30:33",
    imageUrls: null,
    member: Member(
      memberId: 1,
      nickname: "Daisy",
      profileImageUrl: "",
    )
);


Board musicBoard3 = Board(
    boardArticleId: 4,
    title: "노래 내용",
    likeCount: 2,
    commentCount: 10,
    createdAt: "2023-08-06-14:30:33",
    imageUrls: null,
    member: Member(
      memberId: 1,
      nickname: "윤정하",
      profileImageUrl: "",
    )
);


