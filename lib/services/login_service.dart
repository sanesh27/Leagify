import 'package:leagify/login_interface.dart';
import 'package:leagify/models/users.dart';
import 'package:dio/dio.dart';


class LoginService extends ILogin{
  @override
  Future<Users> login(String email, String password) async {
    final api = 'http://localhost:8000/api/login';
    final data = {"email": email, "password": password};
    final dio = Dio();
    Response response;
    response = await dio.post(api, data: data);
    if (response.statusCode == 200) {
      final body = response.data;
      print(response.data);
      // print(email);
      return Users(name: email, token: body['jwt']);
    } else {
      final body = response.data;
      return Users(name: email, token: body['token']);
    }
  }
}