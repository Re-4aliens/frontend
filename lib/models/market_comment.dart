class MarketComment {
  int? articleCommentId;
  String? content;
  MarketCommentMember? member;
  String? createdAt;
  List<MarketComment>? childs;

  MarketComment({this.articleCommentId, this.content, this.member, this.childs, this.createdAt});

  MarketComment.fromJson(Map<String, dynamic> json) {
    List<MarketComment> childComments = [];
    if (json['childs'] != null) {
      var childJsonList = json['childs'] as List<dynamic>;
      childComments = childJsonList
          .map((childJson) => MarketComment.fromJson(childJson))
          .toList();
    }

    articleCommentId = json['articleCommentId'];
    content = json['content'];
    createdAt = json['createdAt'];
    member = json['member'] != null ? new MarketCommentMember.fromJson(json['member']) : null;
    childs = childComments;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['articleCommentId'] = this.articleCommentId;
    data['content'] = this.content;
    data['childs'] = this.childs;
    data['createdAt'] = this.createdAt;
    if (this.member != null) {
      data['member'] = this.member!.toJson();
    }
    return data;
  }
}

class MarketCommentMember {
  int? memberId;
  String? email;
  String? name;
  String? profileImageUrl;
  String? nationality;

  MarketCommentMember(
      {this.memberId,
        this.email,
        this.name,
        this.profileImageUrl,
        this.nationality});

  MarketCommentMember.fromJson(Map<String, dynamic> json) {
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
