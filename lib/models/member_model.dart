class Member {
  String? email;
  String? password;
  String? mbti;
  String? gender;
  String? nationality;
  String? birthday;
  String? name;
  String? profileImage;

  Member(
      {this.email,
        this.password,
        this.mbti,
        this.gender,
        this.nationality,
        this.birthday,
        this.name,
        this.profileImage,});

  factory Member.fromJson(Map<String, dynamic> json) => Member(
    email: json['email'],
    password: json['password'],
    mbti: json['mbti'],
    gender: json['gender'],
    nationality: json['nationality'],
    birthday: json['birthday'],
    name: json['name'],
    profileImage: json['profileImage'],
    );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['password'] = this.password;
    data['mbti'] = this.mbti;
    data['gender'] = this.gender;
    data['nationality'] = this.nationality;
    data['birthday'] = this.birthday;
    data['name'] = this.name;
    data['profileImage'] = this.profileImage;
    return data;
  }
}