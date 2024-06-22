class SignUpModel {
  String? email;
  String? password;
  String? mbti;
  String? gender;
  String? nationality;
  String? birthday;
  String? name;
  String? profileImage;
  String? selfIntroduction;

  SignUpModel(
      {this.email,
      this.password,
      this.mbti,
      this.gender,
      this.nationality,
      this.birthday,
      this.name,
      this.profileImage,
      this.selfIntroduction});

  factory SignUpModel.fromJson(Map<String, dynamic> json) => SignUpModel(
        email: json['email'],
        password: json['password'],
        mbti: json['mbti'],
        gender: json['gender'],
        nationality: json['nationality'],
        birthday: json['birthday'],
        name: json['name'],
        profileImage: json['profileImage'],
        selfIntroduction: json['selfIntroduction'],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['password'] = password;
    data['mbti'] = mbti;
    data['gender'] = gender;
    data['nationality'] = nationality;
    data['birthday'] = birthday;
    data['name'] = name;
    data['profileImage'] = profileImage;
    data['selfIntroduction'] = selfIntroduction;
    return data;
  }
}
