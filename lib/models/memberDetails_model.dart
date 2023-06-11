class MemberDetails {
  int? memberId;
  String? email;
  String? mbti;
  String? gender;
  String? nationality;
  String? birthday;
  String? name;
  String? profileImage;
  int? age;

  MemberDetails(
      {
        this.memberId,
        this.email,
        this.mbti,
        this.gender,
        this.nationality,
        this.birthday,
        this.name,
        this.profileImage,
        this.age,});

  factory MemberDetails.fromJson(Map<String, dynamic> json) => MemberDetails(
    memberId: json['memberId'],
    email: json['email'],
    mbti: json['mbti'],
    gender: json['gender'],
    nationality: json['nationality'],
    birthday: json['birthday'],
    name: json['name'],
    profileImage: json['profileImage'],
    age: json['age'],
    );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['mbti'] = this.mbti;
    data['gender'] = this.gender;
    data['nationality'] = this.nationality;
    data['birthday'] = this.birthday;
    data['name'] = this.name;
    data['profileImage'] = this.profileImage;
    return data;
  }
}