import 'dart:convert';

import 'package:aplikasi_rw/server-app.dart';
import 'package:aplikasi_rw/utils/UserSecureStorage.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';

class StatisticServices {
  static Future<Map<String, dynamic>> getStatistic() async {
    String idUser = await UserSecureStorage.getIdUser();

    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));

    var data = {'id_user': idUser};

    var response = await dio.post(
        '${ServerApp.url}src/profile/statistik_peduli_lingkungan.php',
        data: jsonEncode(data));

    var result = jsonDecode(response.data);

    return result;
  }
}
