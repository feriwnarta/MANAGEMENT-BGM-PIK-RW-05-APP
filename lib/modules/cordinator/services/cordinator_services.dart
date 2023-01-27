import 'dart:convert';
import '../models/cordinator_model.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:logger/logger.dart';
import '../../../server-app.dart';
import '../../../utils/UserSecureStorage.dart';

class CordinatorServices {
  static Future<List<CordinatorModel>> getComplaintDiterimaDanProsesContractor(
      int start, int limit) async {
    String url = '${ServerApp.url}src/contractor/report_pull/report_pull.php';
    String idCordinator = await UserSecureStorage.getIdUser();
    var data = {
      'id_contractor': idCordinator,
      'start': start,
      'limit': limit,
      'id_user': idCordinator
    };

    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));

    List<CordinatorModel> model = [];

    var response = await dio.post(url, data: jsonEncode(data));
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      if (response.data.isNotEmpty) {
        var message = jsonDecode(response.data) as List;

        final logger = Logger();
        logger.i(message);

        List<CordinatorModel> model;
        List<Map<String, dynamic>> phone;

        model = message.map((item) {
          var kepalaContractor = item['manager_contractor'] as List;

          phone = kepalaContractor.map<Map<String, dynamic>>((e) => e).toList();

          return CordinatorModel(
            description: item['description'],
            idReport: item['id_report'],
            latitude: item['latitude'],
            longitude: item['longitude'],
            urlImage: item['url_image'],
            time: item['time_post'],
            title: item['category'],
            address: item['address'],
            statusComplaint: item['status'],
            managerContractor: phone,
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

  static Future<List<CordinatorModel>> getComplaintContractorProcess(
      int start, int limit) async {
    String idCordinator = await UserSecureStorage.getIdUser();
    String url =
        '${ServerApp.url}src/contractor/report_pull/report_pull_process.php';
    var data = {
      'id_contractor': idCordinator,
      'start': start,
      'limit': limit,
      'id_user': idCordinator
    };

    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));
    var response = await dio.post(url, data: jsonEncode(data));
    List<CordinatorModel> model = [];

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      if (response.data.isNotEmpty) {
        var message = jsonDecode(response.data) as List;

        List<Map<String, dynamic>> phone;

        model = message.map((item) {
          var kepalaContractor = item['manager_contractor'] as List;

          phone = kepalaContractor.map<Map<String, dynamic>>((e) => e).toList();

          return CordinatorModel(
            description: item['description'],
            idReport: item['id_report'],
            latitude: item['latitude'],
            longitude: item['longitude'],
            urlImage: item['url_image'],
            time: item['time_post'],
            title: item['category'],
            address: item['address'],
            statusComplaint: item['status'],
            managerContractor: phone,
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

  static Future<List<CordinatorModel>> getComplaintContractorFinish(
      int start, int limit) async {
    String idCordinator = await UserSecureStorage.getIdUser();
    String url =
        '${ServerApp.url}src/contractor/report_pull/report_pull_finish.php';

    var data = {
      'id_contractor': idCordinator,
      'start': start,
      'limit': limit,
      'id_user': idCordinator
    };

    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));
    var response = await dio.post(url, data: jsonEncode(data));
    List<CordinatorModel> model = [];

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      if (response.data.isNotEmpty) {
        var message = jsonDecode(response.data) as List;

        List<Map<String, dynamic>> phone;

        model = message.map((item) {
          var kepalaContractor = item['manager_contractor'] as List;

          phone = kepalaContractor.map<Map<String, dynamic>>((e) => e).toList();

          return CordinatorModel(
            description: item['description'],
            idReport: item['id_report'],
            latitude: item['latitude'],
            longitude: item['longitude'],
            urlImage: item['url_image'],
            time: item['time_post'],
            title: item['category'],
            address: item['address'],
            statusComplaint: item['status'],
            managerContractor: phone,
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
