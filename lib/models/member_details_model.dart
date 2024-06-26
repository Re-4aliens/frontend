class MemberDetails {
  int? memberId;
  String? email;
  String? mbti;
  String? gender;
  String? nationality;
  String? birthday;
  String? name;
  String? profileImageURL;
  int? age;
  String? selfIntroduction;

  MemberDetails(
      {this.memberId,
      this.email,
      this.mbti,
      this.gender,
      this.nationality,
      this.birthday,
      this.name,
      this.profileImageURL,
      this.age,
      this.selfIntroduction});

  factory MemberDetails.fromJson(Map<String, dynamic> json) => MemberDetails(
      memberId: json['memberId'],
      email: json['email'],
      mbti: json['mbti'],
      gender: json['gender'],
      nationality: json['nationality'],
      birthday: json['birthday'],
      name: json['name'],
      profileImageURL: json['profileImageURL'],
      age: json['age'],
      selfIntroduction: json['selfIntroduction']);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['mbti'] = mbti;
    data['gender'] = gender;
    data['nationality'] = nationality;
    data['birthday'] = birthday;
    data['name'] = name;
    data['profileImageURL'] = profileImageURL;
    data['selfIntroduction'] = selfIntroduction;
    return data;
  }
}
