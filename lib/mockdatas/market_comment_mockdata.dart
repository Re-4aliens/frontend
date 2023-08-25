
import '../models/comment_model.dart';


List<Comment> MarketcommentListMock = [
  comment1,
];

Comment comment1 = Comment(
  boardArticleCommentId: 1,
  content: "새거 맞나요? 아닌 거 같은데...",
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
      content: "아맞다구요ㅡㅡ",
      member: CommentMember(
          memberId: 1,
          name: "좀믿어",
          nationality: "South Korea",
          email: "ex@email.com",
          profileImageUrl: ""
      ),
      createdAt: "2023-08-06 14:30:33",
    ),
    Comment(
      boardArticleCommentId: 1,
      content: "더워죽는중",
      member: CommentMember(
          memberId: 1,
          name: "Jenny",
          nationality: "South Korea",
          email: "ex@email.com",
          profileImageUrl: ""
      ),
      createdAt: "2023-08-06 14:30:33",
    )
  ],
  createdAt: "2023-08-06 14:30:33",
);

