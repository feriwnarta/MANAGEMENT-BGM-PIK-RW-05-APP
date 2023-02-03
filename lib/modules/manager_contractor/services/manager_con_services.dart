import 'dart:convert';
import 'package:aplikasi_rw/modules/manager_contractor/models/manager_contractor_model.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:logger/logger.dart';
import '../../../server-app.dart';
import '../../../utils/UserSecureStorage.dart';

class ManagerConServices {
  static Future<List<ManagerContractorModel>>
      getComplaintDiterimaDanProsesContractor(
          int start, int limit, String type) async {
    String url = '${ServerApp.url}src/contractor/report_pull/report_pull.php';
    String idCordinator = await UserSecureStorage.getIdUser();
    var data = {
      'id_contractor': idCordinator,
      'start': start,
      'limit': limit,
      'status': type,
    };
    final logger = Logger();
    logger.e(data);

    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));

    List<ManagerContractorModel> model = [];

    var response = await dio.post(url, data: jsonEncode(data));
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      if (response.data.isNotEmpty) {
        logger.i(response.data);
        var message = jsonDecode(response.data) as List;

        logger.i(message);
        logger.e(response.data);

        List<ManagerContractorModel> model;
        List<Map<String, dynamic>> phone;

        model = message.map((item) {
          var kepalaContractor = item['kepala_contractor'] as List;

          phone = kepalaContractor.map<Map<String, dynamic>>((e) => e).toList();

          return ManagerContractorModel(
            description: item['description'],
            idReport: item['id_report'],
            latitude: item['latitude'],
            longitude: item['longitude'],
            urlImage: item['url_image'],
            time: item['time_post'],
            title: item['category'],
            address: item['address'],
            statusComplaint: item['status'],
            kepalaContratorPhone: phone,
          );
        }).toList();
        return model;
      } else {
        return model;
      }
    } else {
      return model;
    }
  }

  static Future<List<ManagerContractorModel>> getComplaintContractorProcess(
      int start, int limit, status) async {
    String idCordinator = await UserSecureStorage.getIdUser();
    String url =
        '${ServerApp.url}src/contractor/report_pull/report_pull_process.php';
    var data = {
      'id_contractor': idCordinator,
      'start': start,
      'limit': limit,
      'id_user': idCordinator,
      'status': status,
    };

    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));
    var response = await dio.post(url, data: jsonEncode(data));
    List<ManagerContractorModel> model = [];

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      if (response.data.isNotEmpty) {
        var message = jsonDecode(response.data) as List;

        List<Map<String, dynamic>> phone;

        model = message.map((item) {
          var kepalaContractor = item['kepala_contractor'] as List;

          phone = kepalaContractor.map<Map<String, dynamic>>((e) => e).toList();

          return ManagerContractorModel(
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
            kepalaContratorPhone: phone,
          );
        }).toList();
        return model;
      } else {
        return [];
      }
    } else {
      return model;
    }
  }

  static Future<List<ManagerContractorModel>> getComplaintContractorFinish(
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
    List<ManagerContractorModel> model = [];

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      if (response.data.isNotEmpty) {
        var message = jsonDecode(response.data) as List;

        List<Map<String, dynamic>> phone;

        model = message.map((item) {
          var kepalaContractor = item['kepala_contractor'] as List;

          phone = kepalaContractor.map<Map<String, dynamic>>((e) => e).toList();

          return ManagerContractorModel(
            description: item['description'],
            idReport: item['id_report'],
            latitude: item['latitude'],
            longitude: item['longitude'],
            urlImage: item['url_image'],
            time: item['time_post'],
            title: item['category'],
            address: item['address'],
            statusComplaint: item['status'],
            kepalaContratorPhone: phone,
          );
        }).toList();
        return model;
      } else {
        return [];
      }
    } else {
      return model;
    }
  }
}
