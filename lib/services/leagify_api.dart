import 'package:dio/dio.dart';

class LeagifyAPI{
  String _url = 'http://localhost:8000/api/register';
  Dio _dio = Dio();

  var formData = FormData.fromMap({
    "name": "e",
    "email": "e@e.com",
    "password": "e"
  });
  LeagifyAPI(){
    _dio = Dio();
  }

  Future fetchUserToken() async {
    try{
      Response response = await _dio.post(_url,data: formData);
      print(response);
    } on DioError catch (e) {
      print(e);
    }
  }

}
