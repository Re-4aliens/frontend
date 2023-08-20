class MarketArticle {
  int? marketArticleId;
  String? title;
  String? status;
  int? price;
  int? likeCount;
  int? commentCount;
  String? thumbnailImageUrl;
  String? createdAt;

  MarketArticle({
    this.marketArticleId,
    this.title,
    this.status,
    this.price,
    this.likeCount,
    this.commentCount,
    this.thumbnailImageUrl,
    this.createdAt,
  });

  factory MarketArticle.fromJson(Map<String, dynamic> json) => MarketArticle(
    marketArticleId: json['marketArticleId'],
    title: json['title'],
    status: json['status'],
    price: json['price'],
    likeCount: json['likeCount'],
    commentCount: json['commentCount'],
    thumbnailImageUrl: json['thumbnailImageUrl'],
    createdAt: json['createdAt'],
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['title'] = this.title;
    data['status'] = this.status;
    data['price'] = this.price;
    data['likeCount'] = this.likeCount;
    data['commentCount'] = this.commentCount;
    data['thumbnailImageUrl'] = this.thumbnailImageUrl;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
