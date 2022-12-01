import 'package:aplikasi_rw/controller/user_login_controller.dart';
import 'package:aplikasi_rw/services/contractor/contractor_report_services.dart';
import 'package:aplikasi_rw/services/cordinator/cordinator_report_services.dart';
import 'package:aplikasi_rw/utils/UserSecureStorage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class ReportCordinatorProcess extends GetxController {
  List<CordinatorReportModel> listReport = <CordinatorReportModel>[].obs;
  var isLoading = true.obs;
  var isMaxReached = false.obs;
  var data = 0.obs;
  List<CordinatorReportModel> listReportNew = <CordinatorReportModel>[].obs;
  final ScrollController scrollcontroller = ScrollController();
  final controller = Get.put(UserLoginController());

  void increment() {
    data++;
  }

  void realtimeData() async {
    final logger = Logger();

    String idCordinator = await UserSecureStorage.getIdUser();

    List<CordinatorReportModel> listBaru;

    if (controller.status.value == 'cordinator') {
      if (listReport.length <= 0) {
        listBaru = await CordinatorReportServices.getReportCordinatorProcess(
            idCordinator, 0, 10, 'cordinator');
      } else {
        listBaru = await CordinatorReportServices.getReportCordinatorProcess(
            idCordinator, 0, listReport.length, 'cordinator');
      }
    } else if (controller.status.value == 'contractor') {
      if (listReport.length <= 0) {
        listBaru = await ContractorReportServices.getReportContractorProcess(
            idCordinator, 0, 10);
      } else {
        listBaru = await ContractorReportServices.getReportContractorProcess(
            idCordinator, 0, listReport.length);
      }
    } else {
      if (listReport.length <= 0) {
        listBaru = await CordinatorReportServices.getReportCordinatorProcess(
            idCordinator, 0, 10, 'user');
        logger.i(listBaru.length);
      } else {
        listBaru = await CordinatorReportServices.getReportCordinatorProcess(
            idCordinator, 0, listReport.length, 'user');
      }
    }

    listReport.assignAll(listBaru);
  }

  void addReport() async {
    String idCordinator = await UserSecureStorage.getIdUser();
    List<CordinatorReportModel> lisStatusBru =
        await CordinatorReportServices.getReportCordinatorProcess(
            idCordinator, 0, 10, 'cordinator');
    lisStatusBru.addAll(listReport);
    listReport.assignAll(lisStatusBru);
  }

  void getDataFromDb() async {
    String idCordinator = await UserSecureStorage.getIdUser();

    if (isLoading.value) {
      if (controller.status.value == 'cordinator') {
        listReport.assignAll(
            await CordinatorReportServices.getReportCordinatorProcess(
                idCordinator, 0, 10, 'cordinator'));
      } else if (controller.status.value == 'contractor') {
        listReport.assignAll(
            await ContractorReportServices.getReportContractorProcess(
                idCordinator, 0, 10));
      } else {
        listReport.assignAll(
            await CordinatorReportServices.getReportCordinatorProcess(
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
            await CordinatorReportServices.getReportCordinatorProcess(
                idCordinator, listReport.length, 10, 'cordinator'));
      } else if (controller.status.value == 'contractor') {
        listReportNew.assignAll(
            await ContractorReportServices.getReportContractorProcess(
                idCordinator, listReport.length, 10));
      } else {
        listReportNew.assignAll(
            await CordinatorReportServices.getReportCordinatorProcess(
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
