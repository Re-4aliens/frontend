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
      name: json['name'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
      nationality: json['nationality'] ?? '',
    );
  }
}

class Board {
  final int? id;
  final String category;
  final String title;
  final String content;
  final int? greatCount;
  final int? commentCount;
  final List<String> imageUrls;
  final String? createdAt;
  final MemberProfileDto? memberProfileDto;

  Board({
    this.id,
    required this.category,
    required this.title,
    required this.content,
    this.greatCount,
    this.commentCount,
    required this.imageUrls,
    this.createdAt,
    this.memberProfileDto,
  });

  factory Board.fromJson(Map<String, dynamic> json) {
    return Board(
      id: json['id'] ?? 0,
      category: json['category'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      greatCount: json['greatCount'] ?? 0,
      commentCount: json['commentCount'] ?? 0,
      imageUrls: List<String>.from(json['imageUrls'] ?? []),
      createdAt: json['createdAt'] ?? '',
      memberProfileDto:
          MemberProfileDto.fromJson(json['memberProfileDto'] ?? {}),
    );
  }
}
