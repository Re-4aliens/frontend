class Comment {
  int? boardArticleCommentId;
  String? content;
  Member? member;
  List<Comment>? childs;

  Comment({this.boardArticleCommentId, this.content, this.member, this.childs});

  Comment.fromJson(Map<String, dynamic> json) {
    boardArticleCommentId = json['boardArticleCommentId'];
    content = json['content'];
    member =
    json['member'] != null ? new Member.fromJson(json['member']) : null;
    childs = json['child'].cast<Comment>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['boardArticleCommentId'] = this.boardArticleCommentId;
    data['content'] = this.content;
    data['childs'] = this.childs;
    if (this.member != null) {
      data['member'] = this.member!.toJson();
    }
    return data;
  }
}

class Member {
  int? memberId;
  String? email;
  String? name;
  String? profileImageUrl;
  String? nationality;

  Member(
      {this.memberId,
        this.email,
        this.name,
        this.profileImageUrl,
        this.nationality});

  Member.fromJson(Map<String, dynamic> json) {
    memberId = json['memberId'];
    email = json['email'];
    name = json['name'];
    profileImageUrl = json['profileImageUrl'];
    nationality = json['nationality'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['memberId'] = this.memberId;
    data['email'] = this.email;
    data['name'] = this.name;
    data['profileImageUrl'] = this.profileImageUrl;
    data['nationality'] = this.nationality;
    return data;
  }
}
