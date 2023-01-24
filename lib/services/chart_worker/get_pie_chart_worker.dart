import 'dart:convert';

import 'package:aplikasi_rw/server-app.dart';
import 'package:aplikasi_rw/utils/UserSecureStorage.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';

class PieChartServices {
  static Future<Map<String, dynamic>> getPie() async {
    String idUser = await UserSecureStorage.getIdUser();
    String typeWorker = await UserSecureStorage.getStatus();

    String url = '${ServerApp.url}src/chart_worker/get_pie_chart_worker.php';
    var data = {'id_user': idUser, 'type_worker': typeWorker};
    Map<String, dynamic> response;

    Dio dio = Dio();
    dio.interceptors.add(
      RetryInterceptor(dio: dio, retries: 100),
    );

    var request = await dio.post(url, data: jsonEncode(data));
    if (request.statusCode >= 200 && request.statusCode <= 399) {
      response = jsonDecode(request.data);
      return response;
    }

    return response;
  }
}
