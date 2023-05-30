class Applicant {
  Member? member;
  PreferLanguages? preferLanguages;

  Applicant({this.member, this.preferLanguages});

  Applicant.fromJson(Map<String, dynamic> json) {
    member =
    json['member'] != null ? new Member.fromJson(json['member']) : null;
    preferLanguages = json['preferLanguages'] != null
        ? new PreferLanguages.fromJson(json['preferLanguages'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.member != null) {
      data['member'] = this.member!.toJson();
    }
    if (this.preferLanguages != null) {
      data['preferLanguages'] = this.preferLanguages!.toJson();
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

  Member(
      {this.name,
        this.gender,
        this.mbti,
        this.nationality,
        this.age,
        this.profileImage,
        this.countryImage});

  Member.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    gender = json['gender'];
    mbti = json['mbti'];
    nationality = json['nationality'];
    age = json['age'];
    profileImage = json['profileImage'];
    countryImage = json['countryImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['gender'] = this.gender;
    data['mbti'] = this.mbti;
    data['nationality'] = this.nationality;
    data['age'] = this.age;
    data['profileImage'] = this.profileImage;
    data['countryImage'] = this.countryImage;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstPreferLanguage'] = this.firstPreferLanguage;
    data['secondPreferLanguage'] = this.secondPreferLanguage;
    return data;
  }
}

