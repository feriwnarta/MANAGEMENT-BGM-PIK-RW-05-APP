import 'dart:convert';

import 'package:aplikasi_rw/server-app.dart';
import 'package:aplikasi_rw/utils/UserSecureStorage.dart';
import 'package:http/http.dart' as http;

class ProcessReportServices {
  static Future<String> insertProcessReport(
      {String idReport, String message}) async {
    String url = '${ServerApp.url}src/cordinator/process_report.php';
    String idCordinator = await UserSecureStorage.getIdUser();

    var data = {
      "id_estate_cordinator": idCordinator,
      "message": message,
      "id_report": idReport,
    };

    http.Response response =
        await http.post(Uri.parse(url), body: jsonEncode(data));
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      String rs = jsonDecode(response.body);
      if (rs == 'OK') {
        return 'OKE';
      } else {
        return 'FALSE';
      }
    } else {
      print('error insert proses');
    }
  }

  static Future<String> checkExistProcess(String idReport) async {
    String url = '${ServerApp.url}src/cordinator/check_process_exist.php';
    String idCordinator = await UserSecureStorage.getIdUser();
    var data = {'id_report': idReport, 'id_estate_cordinator': idCordinator};
    http.Response response =
        await http.post(Uri.parse(url), body: jsonEncode(data));
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      String rs = jsonDecode(response.body);
      if (rs == 'EXIST') {
        return 'FALSE';
      } else {
        return 'OKE';
      }
    } else {
      print('error chek xsist');
    }
  }

  static Future<http.MultipartRequest> insertProcessWork(
      {String idReport, String message, String img1, String img2}) async {
    String idCordinator = await UserSecureStorage.getIdUser();
    String url = '${ServerApp.url}src/cordinator/process_work_cordinator.php';
    var request = http.MultipartRequest('POST', Uri.parse(url));
    if (img1.isNotEmpty && img2.isNotEmpty) {
      var pic1 = await http.MultipartFile.fromPath('image1', img1);
      var pic2 = await http.MultipartFile.fromPath('image2', img2);
      request.files.add(pic1);
      request.files.add(pic2);
    } else if (img2.isEmpty && img1.isNotEmpty) {
      var pic1 = await http.MultipartFile.fromPath('image1', img1);
      request.files.add(pic1);
    } else if (img1.isEmpty && img2.isNotEmpty) {
      var pic2 = await http.MultipartFile.fromPath('image2', img2);
      request.files.add(pic2);
    }
    request.fields['id_report'] = idReport;
    request.fields['id_estate_cordinator'] = idCordinator;
    request.fields['message'] = message;
    return request;
  }

  static Future<FinishWorkCordinator> getDataFinish({String idReport}) async {
    String url = '${ServerApp.url}src/cordinator/finish_work_report.php';
    String idCordinator = await UserSecureStorage.getIdUser();

    var data = {
      "id_estate_cordinator": idCordinator,
      "id_report": idReport,
    };
    http.Response response =
        await http.post(Uri.parse(url), body: jsonEncode(data));
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var rs = jsonDecode(response.body);
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

  static Future<http.MultipartRequest> completeWork(
      {String idReport,
      String message,
      String img1,
      String img2,
      String duration,
      String finishTime}) async {
    String idCordinator = await UserSecureStorage.getIdUser();
    String url = '${ServerApp.url}src/cordinator/report_pull/complete_work.php';
    var request = http.MultipartRequest('POST', Uri.parse(url));
    if (img1.isNotEmpty && img2.isNotEmpty) {
      var pic1 = await http.MultipartFile.fromPath('image1', img1);
      var pic2 = await http.MultipartFile.fromPath('image2', img2);
      request.files.add(pic1);
      request.files.add(pic2);
    } else if (img2.isEmpty && img1.isNotEmpty) {
      var pic1 = await http.MultipartFile.fromPath('image1', img1);
      request.files.add(pic1);
    } else if (img1.isEmpty && img2.isNotEmpty) {
      var pic2 = await http.MultipartFile.fromPath('image2', img2);
      request.files.add(pic2);
    }
    request.fields['id_report'] = idReport;
    request.fields['id_estate_cordinator'] = idCordinator;
    request.fields['message'] = message;
    request.fields['finish_time'] = finishTime;
    request.fields['duration'] = duration;
    return request;
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
