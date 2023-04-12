class Member {
  String? memberID;
  String? email;
  String? password;
  String? mbti;
  String? gender;
  String? nationality;
  int? nationalityID;
  String? birthday;
  String? name;
  String? profileImage;
  String? countryImage;
  int? age;

  Member(
      {this.memberID,
        this.email,
        this.password,
        this.mbti,
        this.gender,
        this.nationality,
        this.nationalityID,
        this.birthday,
        this.name,
        this.profileImage,
        this.countryImage,
      this.age});

  factory Member.fromJson(Map<String, dynamic> json) => Member(
    memberID: json['memberID'],
    email: json['email'],
    password: json['password'],
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