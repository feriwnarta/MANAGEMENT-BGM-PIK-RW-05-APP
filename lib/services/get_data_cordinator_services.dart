import 'package:aplikasi_rw/model/contractor_model.dart';
import 'package:aplikasi_rw/server-app.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class GetDataCordinatorServices {
  static Future<CordinatorModel> getDataCordinator(String idContractor) async {
    final logger = Logger();
    String url = '${ServerApp.url}src/cordinator/cordinator.php';
    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));
    var data = {"id_estate_cordinator": idContractor};

    var response = await dio.post(url, data: jsonEncode(data));

    if (response.statusCode >= 200 && response.data.isNotEmpty) {
      var result = jsonDecode(response.data);
      var list = result['job_complaint'] as List;
      List<String> job;
      job = list.map((e) => e as String).toList();
      logger.e(list);
      CordinatorModel model = CordinatorModel(
          idCordinator: result['id_estate_cordinator'],
          nameCordinator: result['name_estate_cordinator'],
          job: job);
      return model;
    }
  }
}
