import 'dart:convert';

List<TokenModel> tokenModelFromJson(String str) => List<TokenModel>.from(json.decode(str).map((x) => TokenModel.fromJson(x)));

String tokenModelToJson(List<TokenModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TokenModel {
  String idToken;
  String token;

  TokenModel({
    this.idToken,
    this.token,
  });

  factory TokenModel.fromJson(Map<String, dynamic> json) => TokenModel(
    idToken: json["id_token"],
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "id_token": idToken,
    "token": token,
  };
}
