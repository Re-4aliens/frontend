//

class Applicant {
  Member? member;
  PreferLanguages? preferLanguages;

  Applicant({this.member, this.preferLanguages});

  Applicant.fromJson(Map<String, dynamic> json) {
    member = json['member'] != null ? Member.fromJson(json['member']) : null;
    preferLanguages = json['preferLanguages'] != null
        ? PreferLanguages.fromJson(json['preferLanguages'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (member != null) {
      data['member'] = member!.toJson();
    }
    if (preferLanguages != null) {
      data['preferLanguages'] = preferLanguages!.toJson();
    }
    return data;
  }
}

class Member {
  String? name;
  String? gender;
  String? mbti;
  String? nationality;
  int? age;
  String? profileImage;
  String? countryImage;
  String? selfIntroduction;

  Member(
      {this.name,
      this.gender,
      this.mbti,
      this.nationality,
      this.age,
      this.profileImage,
      this.countryImage,
      this.selfIntroduction});

  Member.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    gender = json['gender'];
    mbti = json['mbti'];
    nationality = json['nationality'];
    age = json['age'];
    profileImage = json['profileImage'];
    countryImage = json['countryImage'];
    selfIntroduction = json['selfIntroduction'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['gender'] = gender;
    data['mbti'] = mbti;
    data['nationality'] = nationality;
    data['age'] = age;
    data['profileImage'] = profileImage;
    data['countryImage'] = countryImage;
    data['selfIntroduction'] = selfIntroduction;
    return data;
  }
}

class PreferLanguages {
  String? firstPreferLanguage;
  String? secondPreferLanguage;

  PreferLanguages({this.firstPreferLanguage, this.secondPreferLanguage});

  PreferLanguages.fromJson(Map<String, dynamic> json) {
    firstPreferLanguage = json['firstPreferLanguage'];
    secondPreferLanguage = json['secondPreferLanguage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firstPreferLanguage'] = firstPreferLanguage;
    data['secondPreferLanguage'] = secondPreferLanguage;
    return data;
  }
}
