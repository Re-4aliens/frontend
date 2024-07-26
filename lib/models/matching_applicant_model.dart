class MatchingApplicant {
  final int matchingRound;
  final int memberId;
  final String firstPreferLanguage;
  final String secondPreferLanguage;

  MatchingApplicant({
    required this.matchingRound,
    required this.memberId,
    required this.firstPreferLanguage,
    required this.secondPreferLanguage,
  });

  factory MatchingApplicant.fromJson(Map<String, dynamic> json) {
    return MatchingApplicant(
      matchingRound: json['matchingRound'],
      memberId: json['memberId'],
      firstPreferLanguage: json['firstPreferLanguage'],
      secondPreferLanguage: json['secondPreferLanguage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'matchingRound': matchingRound,
      'memberId': memberId,
      'firstPreferLanguage': firstPreferLanguage,
      'secondPreferLanguage': secondPreferLanguage,
    };
  }
}
