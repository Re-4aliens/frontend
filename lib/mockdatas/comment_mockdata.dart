import '../models/comment_model.dart';

List<Comment> commentListMock = [comment1, comment2, comment3, comment4];

Comment comment1 = Comment(
  status: "ACTIVE",
  id: 1,
  content: "그러니까요 ㅠㅠㅠ 진짜 너무 더워요...",
  memberProfileDto: MemberProfileDto(
    name: "누군가",
    profileImageUrl: "",
    nationality: "South Korea",
  ),
  children: [
    Comment(
      status: "ACTIVE",
      id: 2,
      content:
          "hot summer hot hot summer hot summer hot hot summer hot summer hot hot summer hot summer hot hot summer",
      memberProfileDto: MemberProfileDto(
        name: "f(x)",
        profileImageUrl: "",
        nationality: "South Korea",
      ),
      createdAt: "2023-08-06 14:30:33",
      children: [],
    ),
    Comment(
      status: "ACTIVE",
      id: 3,
      content: "겨울 언제와...",
      memberProfileDto: MemberProfileDto(
        name: "Daisy",
        profileImageUrl: "",
        nationality: "South Korea",
      ),
      createdAt: "2023-08-06 14:30:33",
      children: [],
    ),
  ],
  createdAt: "2023-08-06 14:30:33",
);

Comment comment2 = Comment(
  status: "ACTIVE",
  id: 4,
  content: "そうなんですよTT 本当に暑いです···",
  memberProfileDto: MemberProfileDto(
    name: "ゆうき",
    profileImageUrl: "",
    nationality: "Japan",
  ),
  children: [],
  createdAt: "2023-08-06 14:30:33",
);

Comment comment3 = Comment(
  status: "ACTIVE",
  id: 5,
  content: "That's what I'm saying It's really hot...",
  memberProfileDto: MemberProfileDto(
    name: "indigo",
    profileImageUrl: "",
    nationality: "Australia",
  ),
  children: [],
  createdAt: "2023-08-06 14:30:33",
);

Comment comment4 = Comment(
  status: "ACTIVE",
  id: 6,
  content: "就是啊 呜呜呜 真的太热了...",
  memberProfileDto: MemberProfileDto(
    name: "釜庆大学生",
    profileImageUrl: "",
    nationality: "China",
  ),
  children: [],
  createdAt: "2023-08-06 14:30:33",
);
