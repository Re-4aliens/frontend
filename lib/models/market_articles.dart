class MarketBoard {
  int? articleId;
  String? title;
  String? status;
  int? price;
  String? productStatus;
  String? content;
  int? marketArticleBookmarkCount;
  int? commentsCount;
  List<String>? imageUrls;
  Member? member;
  String? createdAt;

  MarketBoard({
    this.articleId,
    this.title,
    this.status,
    this.price,
    this.productStatus,
    this.content,
    this.marketArticleBookmarkCount,
    this.commentsCount,
    this.imageUrls,
    this.member,
    this.createdAt,
  });

  MarketBoard.fromJson(Map<String, dynamic> json) {
    articleId = json['articleId'];
    title = json['title'];
    status = json['status'];
    price = json['price'];
    productStatus = json['productStatus'];
    content = json['content'];
    marketArticleBookmarkCount = json['marketArticleBookmarkCount'];
    commentsCount = json['commentsCount'];
    imageUrls = json['imageUrls'].cast<String>();
    member = json['member'] != null ? Member.fromJson(json['member']) : null;
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['articleId'] = articleId;
    data['title'] = title;
    data['status'] = status;
    data['price'] = price;
    data['productStatus'] = productStatus;
    data['content'] = content;
    data['marketArticleBookmarkCount'] = marketArticleBookmarkCount;
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

  Member({
    this.memberId,
    this.email,
    this.name,
    this.nationality,
    this.profileImageUrl,
  });

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
