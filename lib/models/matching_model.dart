class PreferLanguages {
  String? firstPreferLanguage;
  String? secondPreferLanguage;

  PreferLanguages({this.firstPreferLanguage, this.secondPreferLanguage});

  factory PreferLanguages.fromJson(Map<String, dynamic> json) =>
      PreferLanguages(
        firstPreferLanguage: json['firstPreferLanguage'],
        secondPreferLanguage: json['secondPreferLanguage'],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firstPreferLanguage'] = firstPreferLanguage;
    data['secondPreferLanguage'] = secondPreferLanguage;
    return data;
  }
}
