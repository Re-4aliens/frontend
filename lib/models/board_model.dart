class Board {
  int? boardArticleId;
  String? category;
  String? title;
  String? content;
  int? likeCount;
  int? commentCount;
  List<String>? imageUrls;
  Member? member;
  String? createdAt;

  Board(
      {this.boardArticleId,
        this.category,
        this.title,
        this.content,
        this.likeCount,
        this.commentCount,
        this.imageUrls,
        this.member,
        this.createdAt});

  Board.fromJson(Map<String, dynamic> json) {
    boardArticleId = json['boardArticleId'];
    category = json['category'];
    title = json['title'];
    likeCount = json['likeCount'];
    content = json['content'];
    imageUrls = json['imageUrls'].cast<String>();
    member =
    json['member'] != null ? new Member.fromJson(json['member']) : null;
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['boardArticleId'] = this.boardArticleId;
    data['category'] = this.category;
    data['title'] = this.title;
    data['content'] = this.content;
    data['likeCount'] = this.likeCount;
    data['imageUrls'] = this.imageUrls;
    if (this.member != null) {
      data['member'] = this.member!.toJson();
    }
    data['createdAt'] = this.createdAt;
    return data;
  }
}

class Member {
  int? memberId;
  String? email;
  String? name;
  String? nationality;
  String? profileImageUrl;

  Member({this.memberId, this.email, this.name, this.nationality, this.profileImageUrl});

  Member.fromJson(Map<String, dynamic> json) {
    memberId = json['memberId'];
    email = json['email'];
    name = json['name'];
    nationality = json['nationality'];
    profileImageUrl = json['profileImageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['memberId'] = this.memberId;
    data['email'] = this.email;
    data['name'] = this.name;
    data['nationality'] = this.nationality;
    data['profileImageUrl'] = this.profileImageUrl;
    return data;
  }
}