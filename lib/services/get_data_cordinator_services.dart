import 'package:aplikasi_rw/model/contractor_model.dart';
import 'package:aplikasi_rw/server-app.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:logger/logger.dart';

class GetDataCordinatorServices {
  static Future<CordinatorModel> getDataCordinator(String idContractor) async {
    final logger = Logger();
    String url = '${ServerApp.url}src/cordinator/cordinator.php';
    var data = {"id_estate_cordinator": idContractor};
    var response = await http.post(Uri.parse(url), body: jsonEncode(data));

    if (response.statusCode >= 200 && response.body.isNotEmpty) {
      var result = jsonDecode(response.body);
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
