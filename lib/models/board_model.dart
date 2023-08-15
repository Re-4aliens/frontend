class Board {
  int? boardArticleId;
  String? title;
  int? likeCount;
  int? commentCount;
  List<String>? imageUrls;
  Member? member;
  String? createdAt;

  Board(
      {this.boardArticleId,
        this.title,
        this.likeCount,
        this.commentCount,
        this.imageUrls,
        this.member,
        this.createdAt});

  Board.fromJson(Map<String, dynamic> json) {
    boardArticleId = json['boardArticleId'];
    title = json['title'];
    likeCount = json['likeCount'];
    commentCount = json['commentCount'];
    imageUrls = json['imageUrls'].cast<String>();
    member =
    json['member'] != null ? new Member.fromJson(json['member']) : null;
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['boardArticleId'] = this.boardArticleId;
    data['title'] = this.title;
    data['likeCount'] = this.likeCount;
    data['commentCount'] = this.commentCount;
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
  String? nickname;
  String? profileImageUrl;

  Member({this.memberId, this.nickname, this.profileImageUrl});

  Member.fromJson(Map<String, dynamic> json) {
    memberId = json['memberId'];
    nickname = json['nickname'];
    profileImageUrl = json['profileImageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['memberId'] = this.memberId;
    data['nickname'] = this.nickname;
    data['profileImageUrl'] = this.profileImageUrl;
    return data;
  }
}
