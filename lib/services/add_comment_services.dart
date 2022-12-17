import 'package:aplikasi_rw/server-app.dart';
import 'package:aplikasi_rw/utils/UserSecureStorage.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:dio/dio.dart';

class AddCommentServices {
  static Future<String> addComment(
      String idStatus, String comment, BuildContext context) async {
    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));
    String idUser = await UserSecureStorage.getIdUser();
    String url = '${ServerApp.url}src/status/comment/add_comment.php';
    var data = {'id_user': idUser, 'id_status': idStatus, 'comment': comment};

    // showLoading(context);
    // EasyLoading.show(status: 'loading');
    var response = await dio.post(url, data: jsonEncode(data));
    if (response.statusCode == 200) {
      String m = jsonDecode(response.data);
      if (m.isNotEmpty) {
        return Future.value('SUCCESS');
      } else {
        return Future.value('FAIL');
      }
    }
    return 'FAIL';
  }
}
