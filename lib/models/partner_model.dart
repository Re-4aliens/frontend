class Partner {
  final String roomStatus;
  final int chatRoomId;
  final int partnerMemberId;
  final String name;
  final String mbti;
  final String gender;
  final String nationality;
  final String profileImageUrl;
  final String aboutMe;
  final String firstPreferLanguage;
  final String secondPreferLanguage;
  final String relation;

  Partner({
    required this.roomStatus,
    required this.chatRoomId,
    required this.partnerMemberId,
    required this.name,
    required this.mbti,
    required this.gender,
    required this.nationality,
    required this.profileImageUrl,
    required this.aboutMe,
    required this.firstPreferLanguage,
    required this.secondPreferLanguage,
    required this.relation,
  });

  factory Partner.fromJson(Map<String, dynamic> json) {
    return Partner(
      roomStatus: json['roomStatus'],
      chatRoomId: json['chatRoomId'],
      partnerMemberId: json['partnerMemberId'],
      name: json['name'],
      mbti: json['mbti'],
      gender: json['gender'],
      nationality: json['nationality'],
      profileImageUrl: json['profileImageUrl'],
      aboutMe: json['aboutMe'],
      firstPreferLanguage: json['firstPreferLanguage'],
      secondPreferLanguage: json['secondPreferLanguage'],
      relation: json['relation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomStatus': roomStatus,
      'chatRoomId': chatRoomId,
      'partnerMemberId': partnerMemberId,
      'name': name,
      'mbti': mbti,
      'gender': gender,
      'nationality': nationality,
      'profileImageUrl': profileImageUrl,
      'aboutMe': aboutMe,
      'firstPreferLanguage': firstPreferLanguage,
      'secondPreferLanguage': secondPreferLanguage,
      'relation': relation,
    };
  }
}
