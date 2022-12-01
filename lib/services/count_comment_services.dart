import 'package:aplikasi_rw/server-app.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CountCommentServices {
  static Future<String> getCountComment(
      {String idUser, String idStatus}) async {
    String url = '${ServerApp.url}/src/status/comment/count_comment.php';
    var data = {'id_user': idUser, 'id_status': idStatus};
    http.Response response = await http.post(Uri.parse(url), body: json.encode(data));
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      String message = json.decode(response.body);
      if (message != null) {
        return message;
      }
    }
  }
}
