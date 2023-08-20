class Comment {
  int? boardArticleCommentId;
  String? content;
  CommentMember? member;
  String? createdAt;
  List<Comment>? childs;

  Comment({this.boardArticleCommentId, this.content, this.member, this.childs, this.createdAt});

  Comment.fromJson(Map<String, dynamic> json) {
    boardArticleCommentId = json['boardArticleCommentId'];
    content = json['content'];
    createdAt = json['createdAt'];
    member =
    json['member'] != null ? new CommentMember.fromJson(json['member']) : null;
    childs = json['child'].cast<Comment>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['boardArticleCommentId'] = this.boardArticleCommentId;
    data['content'] = this.content;
    data['childs'] = this.childs;
    data['createdAt'] = this.createdAt;
    if (this.member != null) {
      data['member'] = this.member!.toJson();
    }
    return data;
  }
}

class CommentMember {
  int? memberId;
  String? email;
  String? name;
  String? profileImageUrl;
  String? nationality;

  CommentMember(
      {this.memberId,
        this.email,
        this.name,
        this.profileImageUrl,
        this.nationality});

  CommentMember.fromJson(Map<String, dynamic> json) {
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
