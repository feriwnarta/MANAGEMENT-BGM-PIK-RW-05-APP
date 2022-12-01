import 'dart:convert';
import 'package:aplikasi_rw/model/contractor_model.dart';
import '../server-app.dart';
import 'package:http/http.dart' as http;

class GetDataContractor {
  static Future<ContractorModel> getDataContractor(String idContractor) async {
    String url = '${ServerApp.url}src/contractor/contractor.php';
    var data = {"id_contractor": idContractor};
    var response = await http.post(Uri.parse(url), body: jsonEncode(data));

    if (response.statusCode >= 200 && response.body.isNotEmpty) {
      var result = jsonDecode(response.body);
      var list = result['job_complaint'] as List;
      List<String> job;
      list.map((e) => job.add(e));
      ContractorModel model = ContractorModel(
          idContractor: result['id_contractor'],
          nameContractor: result['name_contractor'],
          job: job);
      return model;
    }
  }
}
