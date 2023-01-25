import 'package:aplikasi_rw/server-app.dart';
import 'package:aplikasi_rw/utils/UserSecureStorage.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:logger/logger.dart';

class CordinatorReportModel {
  String idReport,
      urlImage,
      title,
      description,
      time,
      address,
      latitude,
      longitude;
  List<String> categoryDetail;

  CordinatorReportModel(
      {this.idReport,
      this.urlImage,
      this.title,
      this.description,
      this.time,
      this.address,
      this.latitude,
      this.categoryDetail,
      this.longitude});
}

class ManagementServices {
  static Future<List<CordinatorReportModel>> getComplaint(
      String idUser, int start, int limit) async {
    String url =
        '${ServerApp.url}src/cordinator/report_pull/report_pull_complaint.php';
    var data = {'id_user': idUser, 'start': start, 'limit': limit};
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
  }
}

class CordinatorReportServices {
  static Future<List<CordinatorReportModel>> getReportCordinator(
      String idCordinator, int start, int limit, String status) async {
    String url = '${ServerApp.url}src/cordinator/report_pull/report_pull.php';
    String idUser = await UserSecureStorage.getIdUser();
    var data = {
      'id_cordinator': idCordinator,
      'start': start,
      'limit': limit,
      'status': status,
      'id_user': idUser
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
  }

  static Future<List<CordinatorReportModel>> getReportCordinatorProcess(
      String idCordinator, int start, int limit, String status) async {
    String url =
        '${ServerApp.url}src/cordinator/report_pull/report_pull_process.php';
    var data = {
      'id_cordinator': idCordinator,
      'start': start,
      'limit': limit,
      'status': status,
      'id_user': idCordinator
    };

    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));
    var response = await dio.post(url, data: jsonEncode(data));
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      if (response.data.isNotEmpty) {
        var message = jsonDecode(response.data) as List;
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
  }

  static Future<List<CordinatorReportModel>> getReportCordinatorFinish(
      String idCordinator, int start, int limit, String status) async {
    String url =
        '${ServerApp.url}src/cordinator/report_pull/report_pull_finish.php';

    var data = {
      'id_cordinator': idCordinator,
      'start': start,
      'limit': limit,
      'status': status,
      'id_user': idCordinator
    };

    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));

    var response = await dio.post(url, data: jsonEncode(data));
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      if (response.data.isNotEmpty) {
        print(response.data);
        var message = jsonDecode(response.data) as List;
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
  }
}
