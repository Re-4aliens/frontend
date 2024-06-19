class Auth {
  String? email;
  String? password;
  String? accessToken;
  String? refreshToken;

  Auth({this.email, this.password});

  Auth.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
    accessToken = json['accessToken'];
    refreshToken = json['refreshToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['password'] = password;
    return data;
  }
}
