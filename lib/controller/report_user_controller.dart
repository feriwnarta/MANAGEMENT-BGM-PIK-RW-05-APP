import 'dart:io';

import 'package:aplikasi_rw/model/ReportModel.dart';
import 'package:aplikasi_rw/services/report_services.dart';
import 'package:aplikasi_rw/utils/UserSecureStorage.dart';
import 'package:get/get.dart';

class ReportUserController extends GetxController {
  List<ReportModel> listReport = <ReportModel>[].obs;
  var isLoading = true.obs;
  var isMaxReached = false.obs;
  var data = 0.obs;
  List<ReportModel> listReportNew = <ReportModel>[].obs;
  List<ReportModel> searchReport;

  void increment() {
    data++;
  }

  void realtimeData() async {
    try {
      String idUser = await UserSecureStorage.getIdUser();
      List<ReportModel> listBaru =
          await ReportServices.getDataApi(idUser, 0, 10);

      if (listReport.length <= 10) {
        listReport.assignAll(listBaru);
      } else {
        var getLength10 = listReport.getRange(0, 10);
        List<ReportModel> convert = getLength10.toList();

        bool el;
        int dt = 0;
        convert.forEach((element) {
          if (listBaru[dt].idReport == element.idReport) {
            el = true;
          } else {
            el = false;
          }
          dt++;
        });
        print(el);
      }
    } on SocketException {} on HttpException {}
  }

  Future<void> addReport() async {
    String idUser = await UserSecureStorage.getIdUser();
    List<ReportModel> listReportBaru = <ReportModel>[].obs;
    listReportBaru = await ReportServices.getDataApi(idUser, 0, 5);
    listReport.assignAll(listReportBaru);
    update();
  }

  Future<void> refresReport() async {
    isLoading = true.obs;
    String idUser = await UserSecureStorage.getIdUser();
    List<ReportModel> listReportBaru = <ReportModel>[].obs;
    if (listReport.length <= 10) {
      listReportBaru = await ReportServices.getDataApi(idUser, 0, 10);
    } else {
      print('oke');
      listReportBaru =
          await ReportServices.getDataApi(idUser, 0, listReport.length);
    }
    if (listReport != null) {
      listReport.assignAll(listReportBaru);
      isLoading = false.obs;
      update();
    }
  }

  Future<void> getDataFromDb() async {
    String idUser = await UserSecureStorage.getIdUser();

    if (isLoading.value) {
      listReport.assignAll(await ReportServices.getDataApi(idUser, 0, 10));
      update();
      if (listReport.isNotEmpty) {
        isLoading.value = false;
        update();
      } else {
        isLoading.value = false;
        update();
      }
    } else {
      listReportNew.assignAll(
          await ReportServices.getDataApi(idUser, listReport.length, 10));
      if (listReportNew.isEmpty) {
        isMaxReached.value = true;
        update();
      } else {
        listReport.addAll(listReportNew);
        update();
      }
    }
    update();
  }
}
