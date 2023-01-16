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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['password'] = this.password;
    data['email'] = this.email;
    data['image'] = this.image;
    return data;
  }
}
