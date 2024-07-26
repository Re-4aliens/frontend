class MarketBoard {
  final int? id;
  final String title;
  final String saleStatus;
  final String price;
  final String productQuality;
  final String content;
  final int? greatCount;
  final int? commentCount;
  final List<String> imageUrls;
  final String? createdAt;
  final MemberProfileDto? memberProfileDto;

  MarketBoard({
    this.id,
    required this.title,
    required this.saleStatus,
    required this.price,
    required this.productQuality,
    required this.content,
    this.greatCount,
    this.commentCount,
    required this.imageUrls,
    this.createdAt,
    this.memberProfileDto,
  });

  factory MarketBoard.fromJson(Map<String, dynamic> json) {
    return MarketBoard(
      id: json['id'],
      title: json['title'],
      saleStatus: json['saleStatus'],
      price: json['price'],
      productQuality: json['productQuality'],
      content: json['content'],
      greatCount: json['greatCount'],
      commentCount: json['commentCount'],
      imageUrls: List<String>.from(json['imageUrls']),
      createdAt: json['createdAt'],
      memberProfileDto: MemberProfileDto.fromJson(json['memberProfileDto']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'saleStatus': saleStatus,
      'price': price,
      'productQuality': productQuality,
      'content': content,
      'greatCount': greatCount,
      'commentCount': commentCount,
      'imageUrls': imageUrls,
      'createdAt': createdAt,
      'memberProfileDto': memberProfileDto?.toJson(),
    };
  }
}

class MemberProfileDto {
  final String name;
  final String profileImageUrl;
  final String nationality;

  MemberProfileDto({
    required this.name,
    required this.profileImageUrl,
    required this.nationality,
  });

  factory MemberProfileDto.fromJson(Map<String, dynamic> json) {
    return MemberProfileDto(
      name: json['name'],
      profileImageUrl: json['profileImageUrl'],
      nationality: json['nationality'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'profileImageUrl': profileImageUrl,
      'nationality': nationality,
    };
  }
}
