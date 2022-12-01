import 'package:aplikasi_rw/model/contractor_model.dart';
import 'package:aplikasi_rw/server-app.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GetDataCordinatorServices {
  static Future<CordinatorModel> getDataCordinator(String idContractor) async {
    String url = '${ServerApp.url}src/cordinator/cordinator.php';
    var data = {"id_estate_cordinator": idContractor};
    var response = await http.post(Uri.parse(url), body: jsonEncode(data));
    if (response.statusCode >= 200 && response.body.isNotEmpty) {
      var result = jsonDecode(response.body);
      var list = result['job_complaint'] as List;
      List<String> job;
      list.map((e) => job.add(e));
      CordinatorModel model = CordinatorModel(
          idCordinator: result['id_estate_cordinator'],
          nameCordinator: result['name_estate_cordinator'],
          job: job);
      return model;
    }
  }
}
