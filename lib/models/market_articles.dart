class MarketBoard {
  int? articleId;
  String? title;
  String? saleStatus;
  String? price;
  String? productQuality;
  String? content;
  int? marketArticleBookmarkCount;
  int? commentsCount;
  List<String>? imageUrls;
  Member? member;
  String? createdAt;

  @override
  String toString() {
    return 'MarketBoard{'
        'articleId: $articleId, '
        'title: $title, '
        'saleStatus: $saleStatus, '
        'price: $price, '
        'productQuality: $productQuality, '
        'content: $content, '
        'marketArticleBookmarkCount: $marketArticleBookmarkCount, '
        'commentsCount: $commentsCount, '
        'imageUrls: $imageUrls, '
        'member: $member, '
        'createdAt: $createdAt'
        '}';
  }

  MarketBoard({
    this.articleId,
    this.title,
    this.saleStatus,
    this.price,
    this.productQuality,
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
    saleStatus = json['saleStatus'];
    price = json['price'];
    productQuality = json['productQuality'];
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
    data['saleStatus'] = saleStatus;
    data['price'] = price;
    data['productQuality'] = productQuality;
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
