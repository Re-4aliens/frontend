class Comment {
  final String status;
  final int id;
  final String content;
  final String createdAt;
  final MemberProfileDto memberProfileDto;
  final List<Comment>? children;

  Comment({
    required this.status,
    required this.id,
    required this.content,
    required this.createdAt,
    required this.memberProfileDto,
    this.children,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      status: json['status'],
      id: json['id'],
      content: json['content'],
      createdAt: json['createdAt'],
      memberProfileDto: MemberProfileDto.fromJson(json['memberProfileDto']),
      children: json['children'] != null
          ? (json['children'] as List).map((i) => Comment.fromJson(i)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'id': id,
      'content': content,
      'createdAt': createdAt,
      'memberProfileDto': memberProfileDto.toJson(),
      'children': children?.map((child) => child.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'Comment{status: $status, id: $id, content: $content, createdAt: $createdAt, memberProfileDto: $memberProfileDto, children: $children}';
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

  @override
  String toString() {
    return 'MemberProfileDto{name: $name, profileImageUrl: $profileImageUrl, nationality: $nationality}';
  }
}
