class Board {
  int? articleId;
  String? category;
  String? title;
  String? content;
  int? likeCount;
  int? commentsCount; // commentsCount 추가
  List<String>? images; // images 추가
  DateTime? createdAt;
  Member? member;

  Board({
    this.articleId,
    this.category,
    this.title,
    this.content,
    this.likeCount,
    this.commentsCount,
    this.images,
    this.createdAt,
    this.member,
  });

  Board.fromJson(Map<String, dynamic> json) {
    articleId = json['articleId'];
    category = json['category'];
    title = json['title'];
    content = json['content'];
    likeCount = json['likeCount'];
    commentsCount = json['commentsCount'];
    images = List<String>.from(json['images']);
    createdAt = DateTime.parse(json['createdAt']);
    member = Member.fromJson(json['member']);
  }
}

class Member {
  int? memberId;
  String? email;
  String? name;
  String? profileImageUrl;
  String? nationality;

  Member({
    this.memberId,
    this.email,
    this.name,
    this.profileImageUrl,
    this.nationality,
  });

  Member.fromJson(Map<String, dynamic> json) {
    memberId = json['memberId'];
    email = json['email'];
    name = json['name'];
    profileImageUrl = json['profileImageUrl'];
    nationality = json['nationality'];
  }
}
