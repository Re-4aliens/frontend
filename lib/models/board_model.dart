class Board {
  int? articleId;
  String? category;
  String? title;
  String? content;
  int? likeCount;
  int? commentsCount;
  List<String>? imageUrls;
  Member? member;
  String? createdAt;

  Board(
      {this.articleId,
      this.category,
      this.title,
      this.content,
      this.likeCount,
      this.commentsCount,
      this.imageUrls,
      this.member,
      this.createdAt});

  Board.fromJson(Map<String, dynamic> json) {
    articleId = json['articleId'];
    category = json['category'];
    title = json['title'];
    likeCount = json['likeCount'];
    content = json['content'];
    imageUrls = json['imageUrls'].cast<String>();
    member = json['member'] != null ? Member.fromJson(json['member']) : null;
    commentsCount = json['commentsCount'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['articleId'] = articleId;
    data['category'] = category;
    data['title'] = title;
    data['content'] = content;
    data['likeCount'] = likeCount;
    data['commentsCount'] = commentsCount;
    data['imageUrls'] = imageUrls;
    if (member != null) {
      data['member'] = member!.toJson();
    }
    data['createdAt'] = createdAt;
    return data;
  }
}

class Member {
  int? memberId;
  String? email;
  String? name;
  String? nationality;
  String? profileImageUrl;

  Member(
      {this.memberId,
      this.email,
      this.name,
      this.nationality,
      this.profileImageUrl});

  Member.fromJson(Map<String, dynamic> json) {
    memberId = json['memberId'];
    email = json['email'];
    name = json['name'];
    nationality = json['nationality'];
    profileImageUrl = json['profileImageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['memberId'] = memberId;
    data['email'] = email;
    data['name'] = name;
    data['nationality'] = nationality;
    data['profileImageUrl'] = profileImageUrl;
    return data;
  }
}
