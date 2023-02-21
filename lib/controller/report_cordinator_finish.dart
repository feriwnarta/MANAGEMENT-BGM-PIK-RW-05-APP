import 'package:aplikasi_rw/services/cordinator/cordinator_report_services.dart';
import 'package:aplikasi_rw/utils/UserSecureStorage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/user_login_controller.dart';
import '../services/contractor/contractor_report_services.dart';
import 'package:logger/logger.dart';

class ReportCordinatorFinish extends GetxController {
  List<CordinatorReportModel> listReport = <CordinatorReportModel>[].obs;
  var isLoading = true.obs;
  var isMaxReached = false.obs;
  var data = 0.obs;
  List<CordinatorReportModel> listReportNew = <CordinatorReportModel>[].obs;
  final ScrollController scrollcontroller = ScrollController();
  final UserLoginController controller = Get.put(UserLoginController());

  void increment() {
    data++;
  }

  void realtimeData() async {
    String idCordinator = await UserSecureStorage.getIdUser();
    List<CordinatorReportModel> listBaru;

    if (controller.status.value == 'cordinator') {
      if (listReport.length <= 10) {
        listBaru = await CordinatorReportServices.getReportCordinatorFinish(
            idCordinator, 0, 10, 'cordinator');
      } else {
        listBaru = await CordinatorReportServices.getReportCordinatorFinish(
            idCordinator, 0, listReport.length, 'cordinator');
      }
    } else if (controller.status.value == 'contractor') {
      if (listReport.length <= 10) {
        listBaru = await ContractorReportServices.getReportContractorFinish(
            idCordinator, 0, 10);
      } else {
        listBaru = await ContractorReportServices.getReportContractorFinish(
            idCordinator, 0, listReport.length);
      }
    } else {
      if (listReport.length <= 10) {
        listBaru = await CordinatorReportServices.getReportCordinatorFinish(
            idCordinator, 0, 10, 'user');
      } else {
        listBaru = await CordinatorReportServices.getReportCordinatorFinish(
            idCordinator, 0, listReport.length, 'user');
      }
    }

    listReport.assignAll(listBaru);
  }

  void addReport() async {
    String idCordinator = await UserSecureStorage.getIdUser();
    List<CordinatorReportModel> lisStatusBru =
        await CordinatorReportServices.getReportCordinatorFinish(
            idCordinator, 0, 10, 'cordinator');
    lisStatusBru.addAll(listReport);
    listReport.assignAll(lisStatusBru);
  }

  void getDataFromDb() async {
    String idCordinator = await UserSecureStorage.getIdUser();
    if (isLoading.value) {
      if (controller.status.value == 'cordinator') {
        listReport.assignAll(
            await CordinatorReportServices.getReportCordinatorFinish(
                idCordinator, 0, 10, 'cordinator'));
      } else if (controller.status.value == 'contractor') {
        listReport.assignAll(
            await ContractorReportServices.getReportContractorFinish(
                idCordinator, 0, 10));
      } else {
        print(controller.status.value);
        listReport.assignAll(
            await CordinatorReportServices.getReportCordinatorFinish(
                idCordinator, 0, 10, 'user'));
      }

      if (listReport.isNotEmpty) {
        isLoading.value = false;
      } else {
        isLoading.value = false;
      }
    } else {
      if (controller.status.value == 'cordinator') {
        listReportNew.assignAll(
            await CordinatorReportServices.getReportCordinatorFinish(
                idCordinator, listReport.length, 10, 'cordinator'));
      } else if (controller.status.value == 'contractor') {
        listReportNew.assignAll(
            await CordinatorReportServices.getReportCordinatorFinish(
                idCordinator, listReport.length, 10, 'contractor'));
      } else {
        listReportNew.assignAll(
            await CordinatorReportServices.getReportCordinatorFinish(
                idCordinator, listReport.length, 10, 'user'));
      }

      if (listReportNew.isEmpty) {
        isMaxReached.value = true;
      } else {
        listReport.addAll(listReportNew);
      }
    }
  }
}
