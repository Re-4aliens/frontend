class NoticeArticle {
  int? noticeId;
  String? title;
  String? content;
  String? createdAt;
  MemberDto? memberDto;

  NoticeArticle({
    this.noticeId,
    this.title,
    this.content,
    this.createdAt,
    this.memberDto,
  });

  factory NoticeArticle.fromJson(Map<String, dynamic> json) {
    return NoticeArticle(
      noticeId: json['noticeId'],
      title: json['title'],
      content: json['content'],
      createdAt: json['createdAt'],
      memberDto: json['memberDto'] != null
          ? MemberDto.fromJson(json['memberDto'])
          : null,
    );
  }
}

class MemberDto {
  int? memberId;
  String? email;
  String? name;
  String? profileImageUrl;
  String? nationality;

  MemberDto({
    this.memberId,
    this.email,
    this.name,
    this.profileImageUrl,
    this.nationality,
  });

  factory MemberDto.fromJson(Map<String, dynamic> json) {
    return MemberDto(
      memberId: json['memberId'],
      email: json['email'],
      name: json['name'],
      profileImageUrl: json['profileImageUrl'],
      nationality: json['nationality'],
    );
  }
}
