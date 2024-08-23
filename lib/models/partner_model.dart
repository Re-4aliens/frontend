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
      {this.roomState,
      this.roomId,
      this.memberId,
      this.name,
      this.mbti,
      this.gender,
      this.nationality,
      this.profileImage,
      this.selfIntroduction,
      this.firstPreferLanguage,
      this.secondPreferLanguage});

  Partner.fromJson(Map<String, dynamic> json) {
    roomState = json['roomState'];
    roomId = json['roomId'];
    memberId = json['memberId'];
    name = json['name'];
    mbti = json['mbti'];
    gender = json['gender'];
    nationality = json['nationality'];
    profileImage = json['profileImage'];
    selfIntroduction = json['selfIntroduction'];
    firstPreferLanguage = json['firstPreferLanguage'];
    secondPreferLanguage = json['secondPreferLanguage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['roomState'] = roomState;
    data['roomId'] = roomId;
    data['name'] = name;
    data['mbti'] = mbti;
    data['gender'] = gender;
    data['nationality'] = nationality;
    data['profileImage'] = profileImage;
    data['selfIntroduction'] = selfIntroduction;
    data['firstPreferLanguage'] = firstPreferLanguage;
    data['secondPreferLanguage'] = secondPreferLanguage;
    return data;
  }
}
