import 'dart:convert';
import 'dart:developer';

import 'package:aplikasi_rw/server-app.dart';
import 'package:aplikasi_rw/utils/UserSecureStorage.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:logger/logger.dart';

class GetChartWorkerServices {
  static Future<List<Map<String, dynamic>>> getChart() async {
    String idUser = await UserSecureStorage.getIdUser();
    String status = await UserSecureStorage.getStatus();

    String url = '${ServerApp.url}/src/chart_worker/get_chart_worker.php';

    Dio dio = Dio();
    dio.interceptors.add(
      RetryInterceptor(dio: dio, retries: 100),
    );

    var data = {'id_user': idUser, 'type_worker': status};
    List<Map<String, dynamic>> response = [];

    try {
      var result = await dio.post(url, data: jsonEncode(data));

      if (result.statusCode >= 200 && result.statusCode <= 399) {
        final logger = Logger();

        // logger.i(jsonDecode(result.data));

        var dataResponse = jsonDecode(result.data) as List;

        response = dataResponse.map<Map<String, dynamic>>((e) => e).toList();

        logger.d(result.data);

        return response;
      } else {
        print('error server');
      }
    } on Exception catch (e) {
      print(e);
    }

    return response;
  }
}
