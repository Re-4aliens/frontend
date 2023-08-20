
import '../models/comment_model.dart';


List<Comment> commentListMock = [
  comment1,
  comment2,
  comment3,
  comment4
];

Comment comment1 = Comment(
    boardArticleCommentId: 1,
    content: "그러니까요 ㅠㅠㅠ 진짜 너무 더워요...",
    member: CommentMember(
        memberId: 1,
        name: "누군가",
        nationality: "South Korea",
        email: "ex@email.com",
        profileImageUrl: ""
    ),
  childs: [
    Comment(
      boardArticleCommentId: 1,
      content: "hot summer hot hot summer hot summer hot hot summer hot summer hot hot summer hot summer hot hot summer",
      member: CommentMember(
        memberId: 1,
        name: "f(x)",
        nationality: "South Korea",
        email: "ex@email.com",
        profileImageUrl: ""
      ),
      createdAt: "2023-08-06 14:30:33",
    ),
    Comment(
        boardArticleCommentId: 1,
        content: "겨울 언제와...",
        member: CommentMember(
            memberId: 1,
            name: "Daisy",
            nationality: "South Korea",
            email: "ex@email.com",
            profileImageUrl: ""
        ),
      createdAt: "2023-08-06 14:30:33",
    )
  ],
  createdAt: "2023-08-06 14:30:33",
);

Comment comment2 = Comment(
    boardArticleCommentId: 1,
    content: "そうなんですよTT 本当に暑いです···",
    member: CommentMember(
        memberId: 1,
        name: "ゆうき",
        nationality: "Japan",
        email: "ex@email.com",
        profileImageUrl: ""
    ),
  childs: [],
  createdAt: "2023-08-06 14:30:33",
);

Comment comment3 = Comment(
    boardArticleCommentId: 1,
    content: "That's what I'm saying It's really hot...",
    member: CommentMember(
        memberId: 1,
        name: "indigo",
        nationality: "Australia",
        email: "ex@email.com",
        profileImageUrl: ""
    ),
  childs: [],
  createdAt: "2023-08-06 14:30:33",
);

Comment comment4 = Comment(
    boardArticleCommentId: 1,
    content: "就是啊 呜呜呜 真的太热了...",
    member: CommentMember(
        memberId: 1,
        name: "釜庆大学生",
        nationality: "China",
        email: "ex@email.com",
        profileImageUrl: ""
    ),
  childs: [],
  createdAt: "2023-08-06 14:30:33",
);