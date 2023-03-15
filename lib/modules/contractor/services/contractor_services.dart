import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:logger/logger.dart';
import '../../../server-app.dart';
import '../../../utils/UserSecureStorage.dart';
import '../models/contractor_model.dart';

class ContractorServices {
  static Future<List<ContractorModel>> getComplaintDiterimaDanProsesContractor(
      int start, int limit, status) async {
    String url = '${ServerApp.url}src/contractor/report_pull/report_pull.php';
    String idCordinator = await UserSecureStorage.getIdUser();
    var data = {
      'id_contractor': idCordinator,
      'start': start,
      'limit': limit,
      'id_user': idCordinator,
      'status': status
    };

    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));

    var response = await dio.post(url, data: jsonEncode(data));
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      if (response.data.isNotEmpty) {
        var message = jsonDecode(response.data) as List;

        final logger = Logger();
        logger.i(message);

        return message
            .map(
              (item) => ContractorModel(
                description: item['description'],
                idReport: item['id_report'],
                latitude: item['latitude'],
                longitude: item['longitude'],
                urlImage: item['url_image'],
                time: item['time_post'],
                title: item['category'],
                address: item['address'],
                statusComplaint: item['status'],
                processTime: item['process_time'],
              ),
            )
            .toList();
      }
    }
    return [];
  }

  static Future<List<ContractorModel>> getComplaintContractorProcess(
      int start, int limit, String status) async {
    String idCordinator = await UserSecureStorage.getIdUser();
    String url =
        '${ServerApp.url}src/contractor/report_pull/report_pull_process.php';
    var data = {
      'id_contractor': idCordinator,
      'start': start,
      'limit': limit,
      'id_user': idCordinator,
      'status': status
    };

    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));
    var response = await dio.post(url, data: jsonEncode(data));
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      if (response.data.isNotEmpty) {
        var message = jsonDecode(response.data) as List;
        return message
            .map(
              (item) => ContractorModel(
                description: item['description'],
                idReport: item['id_report'],
                latitude: item['latitude'],
                longitude: item['longitude'],
                urlImage: item['url_image'],
                time: item['time_post'],
                title: item['category'],
                address: item['address'],
                statusComplaint: item['status'],
                processTime: item['process_time'],
              ),
            )
            .toList();
      }
    }
    return [];
  }

  static Future<List<ContractorModel>> getComplaintContractorFinish(
      int start, int limit, String status) async {
    String idCordinator = await UserSecureStorage.getIdUser();
    String url =
        '${ServerApp.url}src/contractor/report_pull/report_pull_finish.php';

    var data = {
      'id_contractor': idCordinator,
      'start': start,
      'limit': limit,
      'id_user': idCordinator,
      'status': status
    };

    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));

    var response = await dio.post(url, data: jsonEncode(data));
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      if (response.data.isNotEmpty) {
        var message = jsonDecode(response.data) as List;
        return message
            .map(
              (item) => ContractorModel(
                description: item['description'],
                idReport: item['id_report'],
                latitude: item['latitude'],
                longitude: item['longitude'],
                urlImage: item['url_image'],
                time: item['time_post'],
                title: item['category'],
                address: item['address'],
                statusComplaint: item['status'],
              ),
            )
            .toList();
      }
    }
    return [];
  }
}
