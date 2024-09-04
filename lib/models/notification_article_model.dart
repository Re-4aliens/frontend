class NotificationArticle {
  int? id;
  String? content;
  int? boardId;
  String? noticeType;
  String? category;
  String? createdAt;
  bool? isRead;

  NotificationArticle({
    this.id,
    this.content,
    this.boardId,
    this.noticeType,
    this.category,
    this.createdAt,
    this.isRead,
  });

  NotificationArticle.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    boardId = json['boardId'];
    noticeType = json['noticeType'];
    category = json['category'];
    createdAt = json['createdAt'];
    isRead = json['isRead'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['content'] = content;
    data['boardId'] = boardId;
    data['noticeType'] = noticeType;
    data['category'] = category;
    data['createdAt'] = createdAt;
    data['isRead'] = isRead;
    return data;
  }
}
