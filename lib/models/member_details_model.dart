class MemberDetails {
  final String name;
  final String mbti;
  final String gender;
  final String nationality;
  final String birthday;
  final String selfIntroduction;
  final String profileImageUrl;

  MemberDetails({
    required this.name,
    required this.mbti,
    required this.gender,
    required this.nationality,
    required this.birthday,
    required this.selfIntroduction,
    required this.profileImageUrl,
  });

  factory MemberDetails.fromJson(Map<String, dynamic> json) {
    return MemberDetails(
      name: json['name'],
      mbti: json['mbti'],
      gender: json['gender'],
      nationality: json['nationality'],
      birthday: json['birthday'],
      selfIntroduction: json['selfIntroduction'],
      profileImageUrl: json['profileImageURL'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'mbti': mbti,
      'gender': gender,
      'nationality': nationality,
      'birthday': birthday,
      'selfIntroduction': selfIntroduction,
      'profileImageURL': profileImageUrl,
    };
  }
}
