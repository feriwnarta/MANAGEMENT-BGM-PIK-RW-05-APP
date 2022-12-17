import 'dart:convert';
import 'package:aplikasi_rw/model/contractor_model.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import '../server-app.dart';
import 'package:dio/dio.dart';

class GetDataContractor {
  static Future<ContractorModel> getDataContractor(String idContractor) async {
    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));
    String url = '${ServerApp.url}src/contractor/contractor.php';
    var data = {"id_contractor": idContractor};
    var response = await dio.post(url, data: jsonEncode(data));

    if (response.statusCode >= 200 && response.data.isNotEmpty) {
      var result = jsonDecode(response.data);
      var list = result['job_complaint'] as List;
      List<String> job;
      job = list.map((e) => e as String).toList();
      ContractorModel model = ContractorModel(
          idContractor: result['id_contractor'],
          nameContractor: result['name_contractor'],
          job: job);
      return model;
    }
  }
}
