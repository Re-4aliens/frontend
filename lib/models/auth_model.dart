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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['password'] = this.password;
    return data;
  }
}
