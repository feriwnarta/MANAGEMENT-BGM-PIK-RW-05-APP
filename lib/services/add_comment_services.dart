import 'package:aplikasi_rw/screen/loading_send_screen.dart';
import 'package:aplikasi_rw/server-app.dart';
import 'package:aplikasi_rw/utils/UserSecureStorage.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AddCommentServices {
  static Future<String> addComment(
      String idStatus, String comment, BuildContext context) async {
    // Dio dio = Dio();
    // dio.interceptors.add(RetryOnConnectionChangeInterceptor(
    //   requestRetrier: DioConnectivityRequestRetrier(
    //     dio: dio,
    //     connectivity: Connectivity(),
    //   ),
    // ));
    String idUser = await UserSecureStorage.getIdUser();
    String url = '${ServerApp.url}src/status/comment/add_comment.php';
    var data = {'id_user': idUser, 'id_status': idStatus, 'comment': comment};

    showLoading(context);
    var response = await http.post(Uri.parse(url), body: jsonEncode(data));
    if (response.statusCode == 200) {
      String m = jsonDecode(response.body);
      if (m.isNotEmpty) {
        return Future.value('SUCCESS');
      } else {
        return Future.value('FAIL');
      }
    }
    return 'FAIL';
  }
}
