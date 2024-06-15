class NotificationArticle {
  int? personalNoticeId;
  String? noticeType;
  String? articleCategory;
  String? comment;
  String? profileImage;
  String? name;
  String? nationality;
  String? createdAt;
  String? articleUrl;
  bool? isRead;

  NotificationArticle(
      {this.personalNoticeId,
        this.noticeType,
        this.articleCategory,
        this.comment,
        this.profileImage,
        this.name,
        this.nationality,
        this.createdAt,
        this.articleUrl,
        this.isRead});

  NotificationArticle.fromJson(Map<String, dynamic> json) {
    personalNoticeId = json['personalNoticeId'];
    noticeType = json['noticeType'];
    articleCategory = json['articleCategory'];
    comment = json['comment'];
    profileImage = json['profileImage'];
    name = json['name'];
    nationality = json['nationality'];
    createdAt = json['createdAt'];
    articleUrl = json['articleUrl'];
    isRead = json['isRead'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['personalNoticeId'] = this.personalNoticeId;
    data['noticeType'] = this.noticeType;
    data['articleCategory'] = this.articleCategory;
    data['comment'] = this.comment;
    data['profileImage'] = this.profileImage;
    data['name'] = this.name;
    data['nationality'] = this.nationality;
    data['createdAt'] = this.createdAt;
    data['articleUrl'] = this.articleUrl;
    data['isRead'] = this.isRead;
    return data;
  }
}
