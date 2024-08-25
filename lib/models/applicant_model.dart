class Applicant {
  int? matchingRound;
  int? memberId;
  String? firstPreferLanguage;
  String? secondPreferLanguage;

  Applicant({
    this.matchingRound,
    this.memberId,
    this.firstPreferLanguage,
    this.secondPreferLanguage,
  });

  Applicant.fromJson(Map<String, dynamic> json) {
    matchingRound = json['matchingRound'];
    memberId = json['memberId'];
    firstPreferLanguage = json['firstPreferLanguage'];
    secondPreferLanguage = json['secondPreferLanguage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['matchingRound'] = matchingRound;
    data['memberId'] = memberId;
    data['firstPreferLanguage'] = firstPreferLanguage;
    data['secondPreferLanguage'] = secondPreferLanguage;
    return data;
  }
}
