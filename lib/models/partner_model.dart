import 'dart:io';

class Partner {
  String? roomState;
  int? roomId;
  int? memberId;
  String? name;
  String? mbti;
  String? gender;
  String? nationality;
  String? profileImage;
  String? selfIntroduction;

  String? firstPreferLanguage;
  String? secondPreferLanguage;

  Partner(
      {
        this.roomState,
        this.roomId,
        this.memberId,
        this.name,
        this.mbti,
        this.gender,
        this.nationality,
        this.profileImage,
        this.selfIntroduction,

        this.firstPreferLanguage,
        this.secondPreferLanguage
      });

  Partner.fromJson(Map<String, dynamic> json) {
    roomState = json['roomState'];
    roomId = json['roomId'];
    memberId = json['memberId'];
    name = json['name'];
    mbti = json['mbti'];
    gender = json['gender'];
    nationality = json['nationality'];
    profileImage = json['profileImage'];
    selfIntroduction = json['selfIntrodcution'];
    firstPreferLanguage = json['firstPreferLanguage'];
    secondPreferLanguage = json['secondPreferLanguage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['roomState'] = this.roomState;
    data['roomId'] = this.roomId;
    data['name'] = this.name;
    data['mbti'] = this.mbti;
    data['gender'] = this.gender;
    data['nationality'] = this.nationality;
    data['profileImage'] = this.profileImage;
    data['selfIntroduction'] = this.selfIntroduction;
    data['firstPreferLanguage'] = this.firstPreferLanguage;
    data['secondPreferLanguage'] = this.secondPreferLanguage;
    return data;
  }
}
