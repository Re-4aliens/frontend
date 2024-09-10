class Partner {
  String? roomStatus;
  int? chatRoomId;
  int? partnerMemberId;
  String? name;
  String? mbti;
  String? gender;
  String? nationality;
  String? profileImageUrl;
  String? aboutMe;
  String? firstPreferLanguage;
  String? secondPreferLanguage;

  Partner({
    this.roomStatus,
    this.chatRoomId,
    this.partnerMemberId,
    this.name,
    this.mbti,
    this.gender,
    this.nationality,
    this.profileImageUrl,
    this.aboutMe,
    this.firstPreferLanguage,
    this.secondPreferLanguage,
  });

  // JSON 데이터를 객체로 변환하는 생성자
  Partner.fromJson(Map<String, dynamic> json) {
    roomStatus = json['roomStatus'];
    chatRoomId = json['chatRoomId'];
    partnerMemberId = json['partnerMemberId'];
    name = json['name'];
    mbti = json['mbti'];
    gender = json['gender'];
    nationality = json['nationality'];
    profileImageUrl = json['profileImageUrl'];
    aboutMe = json['aboutMe'];
    firstPreferLanguage = json['firstPreferLanguage'];
    secondPreferLanguage = json['secondPreferLanguage'];
  }

  // 객체를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['roomStatus'] = roomStatus;
    data['chatRoomId'] = chatRoomId;
    data['partnerMemberId'] = partnerMemberId;
    data['name'] = name;
    data['mbti'] = mbti;
    data['gender'] = gender;
    data['nationality'] = nationality;
    data['profileImageUrl'] = profileImageUrl;
    data['aboutMe'] = aboutMe;
    data['firstPreferLanguage'] = firstPreferLanguage;
    data['secondPreferLanguage'] = secondPreferLanguage;
    return data;
  }
}
