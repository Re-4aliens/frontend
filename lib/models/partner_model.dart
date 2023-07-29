import 'dart:io';

class Partner {
  int? memberId;
  String? name;
  String? mbti;
  String? gender;
  String? nationality;
  String? profileImage;
  String? countryImage;
  String? selfIntroduction;

  Partner(
      {this.memberId,
        this.name,
        this.mbti,
        this.gender,
        this.nationality,
        this.profileImage,
        this.countryImage,
        this.selfIntroduction
      });

  Partner.fromJson(Map<String, dynamic> json) {
    memberId = json['memberId'];
    name = json['name'];
    mbti = json['mbti'];
    gender = json['gender'];
    nationality = json['nationality'];
    profileImage = json['profileImage'];
    countryImage = json['countryImage'];
    selfIntroduction = json['selfIntrodcution'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['memberId'] = this.memberId;
    data['name'] = this.name;
    data['mbti'] = this.mbti;
    data['gender'] = this.gender;
    data['nationality'] = this.nationality;
    data['profileImage'] = this.profileImage;
    data['countryImage'] = this.countryImage;
    data['selfIntroduction'] = this.selfIntroduction;
    return data;
  }
}
