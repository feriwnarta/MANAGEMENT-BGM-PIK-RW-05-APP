import 'package:aplikasi_rw/services/contractor/contractor_report_services.dart';
import 'package:aplikasi_rw/services/cordinator/cordinator_report_services.dart';
import 'package:aplikasi_rw/utils/UserSecureStorage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class ReportCordinatorComplaint extends GetxController {
  // data cordinator
  List<CordinatorReportModel> listReport = <CordinatorReportModel>[].obs;
  var isLoading = true.obs;
  var isMaxReached = false.obs;
  var data = 0.obs;
  List<CordinatorReportModel> listReportNew = <CordinatorReportModel>[].obs;
  final ScrollController scrollController = ScrollController();

  void increment() {
    data++;
  }

  void realtimeData() async {
    String idUser = await UserSecureStorage.getIdUser();
    List<CordinatorReportModel> listBaru = <CordinatorReportModel>[].obs;

    if (listReport.length <= 10) {
      listBaru = await CordinatorReportServices.getReportCordinator(
          idUser, 0, 10, 'cordinator');
    } else {
      listBaru = await CordinatorReportServices.getReportCordinator(
          idUser, 0, listReport.length, 'cordinator');
    }
    // } else if (user.isCaseInsensitiveContainsAny('contractor')) {
    //   if (listReport.length <= 10) {
    //     listBaru =
    //         await ContractorReportServices.getReportContractor(idUser, 0, 10);
    //   } else {
    //     listBaru = await ContractorReportServices.getReportContractor(
    //         idUser, 0, listReport.length);
    //   }
    // } else {
    //   if (listReport.length <= 10) {
    //     listBaru = await CordinatorReportServices.getReportCordinator(
    //         idUser, 0, 10, 'user');
    //   } else {
    //     listBaru = await CordinatorReportServices.getReportCordinator(
    //         idUser, 0, listReport.length, 'user');
    //   }
    // }

    listReport.assignAll(listBaru);
    listBaru.clear();
  }

  void addReport(String status) async {
    String idUser = await UserSecureStorage.getIdUser();
    List<CordinatorReportModel> lisStatusBru;
    if (status == 'cordinator') {
      lisStatusBru = await CordinatorReportServices.getReportCordinator(
          idUser, 0, 10, 'cordinator');
    } else {
      lisStatusBru =
          await ContractorReportServices.getReportContractor(idUser, 0, 10);
    }
    lisStatusBru.addAll(listReport);
    listReport.assignAll(lisStatusBru);
  }

  void getDataFromDb(String status) async {
    String idUser = await UserSecureStorage.getIdUser();

    if (isLoading.value) {
      listReport.assignAll(await CordinatorReportServices.getReportCordinator(
          idUser, 0, 10, 'CORDINATOR'));

      final logger = Logger();
      logger.i(listReport);

      if (listReport.isNotEmpty) {
        isLoading.value = false;
      } else {
        isLoading.value = false;
      }
    } else {
      listReportNew.assignAll(
          await CordinatorReportServices.getReportCordinator(
              idUser, listReport.length, 10, 'cordinator'));

      if (listReportNew.isEmpty) {
        isMaxReached.value = true;
      } else {
        listReport.addAll(listReportNew);
      }
    }
  }
}
