import 'dart:convert';
LoginResponseModel loginResponsejson(String str) => LoginResponseModel.fromJson(json.decode(str));

class LoginResponseModel {

  LoginResponseModel({required this.id, required this.email, required this.jwt});
  late int id;
  late String email;
  late String jwt;
  late String name;

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    jwt = json['jwt'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['jwt'] = this.jwt;
    data['name'] = this.name;
    return data;
  }
}