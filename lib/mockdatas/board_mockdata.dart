import 'package:aliens/models/board_model.dart';

List<Board> totalBoardList = [

];

List<Board> freePostingBoardList = [
  freePostingBoard1,
  freePostingBoard2,
  freePostingBoard3,
  freePostingBoard4
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