import 'package:aplikasi_rw/model/user_model.dart';
import 'package:aplikasi_rw/server-app.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GetDataUserServices {
  static Future<UserModel> getDataUser(String idUser) async {
    String url = '${ServerApp.url}src/user/user.php';
    var data = {"id_user": idUser};
    var response = await http.post(Uri.parse(url), body: jsonEncode(data));
    if (response.statusCode >= 200 && response.body.isNotEmpty) {
      var result = jsonDecode(response.body);
      print(result['username']);
      UserModel model = UserModel(
          urlProfile: result['profile_image'], username: result['username']);
      return model;
    }
  }
}
