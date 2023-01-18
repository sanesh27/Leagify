class LoginRequestModel {

  LoginRequestModel({required this.username,required this.password,required this.email,required this.image});
  late String username;
  late String password;
  late String email;
  late String image;


  LoginRequestModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    password = json['password'];
    email = json['email'];
    email = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['password'] = password;
    data['email'] = email;
    data['image'] = image;
    return data;
  }
}
