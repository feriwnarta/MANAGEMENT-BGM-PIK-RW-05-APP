import 'dart:convert';
import 'package:aplikasi_rw/services/cordinator/cordinator_report_services.dart';
import '../../server-app.dart';
import 'package:http/http.dart' as http;

class ContractorReportServices {
  static Future<List<CordinatorReportModel>> getReportContractor(
      String idContractor, int start, int limit) async {
    String url = '${ServerApp.url}src/contractor/report_pull/report_pull.php';
    var data = {'id_contractor': idContractor, 'start': start, 'limit': limit};
    http.Response response =
        await http.post(Uri.parse(url), body: jsonEncode(data));
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      if (response.body.isNotEmpty) {
        var message = jsonDecode(response.body) as List;
        return message
            .map((item) => CordinatorReportModel(
                description: item['description'],
                idReport: item['id_report'],
                latitude: item['latitude'],
                longitude: item['longitude'],
                urlImage: item['url_image'],
                time: item['time_post'],
                title: item['category_detail'],
                address: item['address']))
            .toList();
      } else {
        return [];
      }
    }
    return [];
  }

  static Future<List<CordinatorReportModel>> getReportContractorFinish(
      String idCordinator, int start, int limit) async {
    String url =
        '${ServerApp.url}src/contractor/report_pull/report_pull_finish.php';
    var data = {'id_contractor': idCordinator, 'start': start, 'limit': limit};
    http.Response response =
        await http.post(Uri.parse(url), body: jsonEncode(data));
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      if (response.body.isNotEmpty) {
        var message = jsonDecode(response.body) as List;
        return message
            .map((item) => CordinatorReportModel(
                description: item['description'],
                idReport: item['id_report'],
                latitude: item['latitude'],
                longitude: item['longitude'],
                urlImage: item['url_image'],
                time: item['time_post'],
                title: item['category_detail'],
                address: item['address']))
            .toList();
      }
    }
    return [];
  }

  static Future<List<CordinatorReportModel>> getReportContractorProcess(
      String idCordinator, int start, int limit) async {
    String url =
        '${ServerApp.url}src/contractor/report_pull/report_pull_process.php';
    var data = {'id_contractor': idCordinator, 'start': start, 'limit': limit};
    http.Response response =
        await http.post(Uri.parse(url), body: jsonEncode(data));
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      if (response.body.isNotEmpty) {
        var message = jsonDecode(response.body) as List;
        return message
            .map((item) => CordinatorReportModel(
                description: item['description'],
                idReport: item['id_report'],
                latitude: item['latitude'],
                longitude: item['longitude'],
                urlImage: item['url_image'],
                time: item['time_post'],
                title: item['category_detail'],
                address: item['address']))
            .toList();
      }
    }
    return [];
  }
}
