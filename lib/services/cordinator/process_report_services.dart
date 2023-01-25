import 'dart:convert';

import 'package:aplikasi_rw/server-app.dart';
import 'package:aplikasi_rw/utils/UserSecureStorage.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:http_parser/http_parser.dart';
import 'package:logger/logger.dart';
// import 'package:http/http.dart' as http;

class ProcessReportServices {
  static Future<String> insertProcessReport(
      {String idReport, String message}) async {
    String url = '${ServerApp.url}src/cordinator/process_report.php';
    String idCordinator = await UserSecureStorage.getIdUser();
    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));

    var data = {
      "id_estate_cordinator": idCordinator,
      "message": message,
      "id_report": idReport,
    };

    var response = await dio.post(url, data: jsonEncode(data));
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      String rs = jsonDecode(response.data);
      if (rs == 'success') {
        return 'OKE';
      } else {
        return 'FALSE';
      }
    } else {
      print('error insert proses');
    }
  }

  static Future<Map<String, dynamic>> checkExistProcess(String idReport) async {
    String url = '${ServerApp.url}src/cordinator/check_process_exist.php';
    String idCordinator = await UserSecureStorage.getIdUser();
    var data = {'id_report': idReport, 'id_estate_cordinator': idCordinator};
    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));

    var response = await dio.post(url, data: jsonEncode(data));
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      Map<String, dynamic> rs = jsonDecode(response.data);
      return rs;
    } else {
      print('error chek xsist');
    }
  }

  static Future<Map<String, dynamic>> insertProcessWork(
      {String idReport, String message, String img1, String img2}) async {
    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));

    String idCordinator = await UserSecureStorage.getIdUser();

    // var request = http.MultipartRequest('POST', Uri.parse(url));
    Map<String, dynamic> data = {};

    if (img1.isNotEmpty && img2.isNotEmpty) {
      data.addEntries({
        'image1': await MultipartFile.fromFile(img1,
            filename: img1, contentType: MediaType('image', 'png'))
      }.entries);
      data.addEntries({
        'image2': await MultipartFile.fromFile(img2,
            filename: img2, contentType: MediaType('image', 'png'))
      }.entries);
      // var pic1 = await http.MultipartFile.fromPath('image1', img1);
      // var pic2 = await http.MultipartFile.fromPath('image2', img2);
      // request.files.add(pic1);
      // request.files.add(pic2);
    } else if (img2.isEmpty && img1.isNotEmpty) {
      // var pic1 = await http.MultipartFile.fromPath('image1', img1);
      // request.files.add(pic1);
      data.addEntries({
        'image1': await MultipartFile.fromFile(img1,
            filename: img1, contentType: MediaType('image', 'png'))
      }.entries);
    } else if (img1.isEmpty && img2.isNotEmpty) {
      // var pic2 = await http.MultipartFile.fromPath('image2', img2);
      // request.files.add(pic2);
      data.addEntries({
        'image2': await MultipartFile.fromFile(img2,
            filename: img2, contentType: MediaType('image', 'png'))
      }.entries);
    }
    data.addAll({
      'id_report': idReport,
      'id_estate_cordinator': idCordinator,
      'message': message
    });
    FormData formData = FormData.fromMap(data);
    final logger = Logger();

    // logger.d(request.data);
    String url = '${ServerApp.url}src/cordinator/process_work_cordinator.php';
    var request = await dio.post(url, data: formData);

    logger.e(request.data);
    logger.i('message');
    return jsonDecode(request.data);

    // request.fields['id_report'] = idReport;
    // request.fields['id_estate_cordinator'] = idCordinator;
    // request.fields['message'] = message;
    // return request;
  }

  static Future<FinishWorkCordinator> getDataFinish({String idReport}) async {
    String url = '${ServerApp.url}src/cordinator/finish_work_report.php';
    String idCordinator = await UserSecureStorage.getIdUser();

    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));

    var data = {
      "id_estate_cordinator": idCordinator,
      "id_report": idReport,
    };

    var response = await dio.post(url, data: jsonEncode(data));
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var rs = jsonDecode(response.data);
      if (rs != null) {
        return FinishWorkCordinator(
          currentTimeWork: rs['current_time_work'],
          idEstateCordinator: rs['id_estate_cordinator'],
          idProcessWork: rs['id_process_work'],
          idReport: rs['id_report'],
          photo1: rs['photo_work_1'],
          photo2: rs['photo_work_2'],
        );
      }
    } else {
      print('error insert proses');
    }
  }

  static Future<String> completeWorks(
      {String idReport,
      String message,
      String img1,
      String img2,
      String duration,
      String finishTime}) async {
    String idCordinator = await UserSecureStorage.getIdUser();
    String url = '${ServerApp.url}src/cordinator/report_pull/complete_work.php';

    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));

    // var request = http.MultipartRequest('POST', Uri.parse(url));
    Map<String, dynamic> data = {};
    if (img1.isNotEmpty && img2.isNotEmpty) {
      data.addEntries(
          {'image1': MultipartFile.fromFileSync(img1, filename: img1)}.entries);
      data.addEntries(
          {'image2': MultipartFile.fromFileSync(img2, filename: img2)}.entries);
      // var pic1 = await http.MultipartFile.fromPath('image1', img1);
      // var pic2 = await http.MultipartFile.fromPath('image2', img2);
      // request.files.add(pic1);
      // request.files.add(pic2);
    } else if (img2.isEmpty && img1.isNotEmpty) {
      // var pic1 = await http.MultipartFile.fromPath('image1', img1);
      // request.files.add(pic1);
      data.addEntries(
          {'image1': MultipartFile.fromFileSync(img1, filename: img1)}.entries);
    } else if (img1.isEmpty && img2.isNotEmpty) {
      data.addEntries(
          {'image2': MultipartFile.fromFileSync(img2, filename: img2)}.entries);
    }
    data.addAll({
      'id_report': idReport,
      'id_estate_cordinator': idCordinator,
      'message': message,
      'finish_time': finishTime,
      'duration': duration,
    });

    FormData formData = FormData.fromMap(data);

    var req = await dio.post(url, data: formData);
    return jsonDecode(req.data);
    // request.fields['id_report'] = idReport;
    // request.fields['id_estate_cordinator'] = idCordinator;
    // request.fields['message'] = message;
    // request.fields['finish_time'] = finishTime;
    // request.fields['duration'] = duration;
    // return request;
  }
}

class FinishWorkCordinator {
  String idProcessWork,
      idReport,
      idEstateCordinator,
      photo1,
      photo2,
      currentTimeWork,
      finishTime;

  FinishWorkCordinator(
      {this.idEstateCordinator,
      this.currentTimeWork,
      this.finishTime,
      this.idProcessWork,
      this.idReport,
      this.photo1,
      this.photo2});
}
