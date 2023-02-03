import 'package:aplikasi_rw/controller/user_login_controller.dart';
import 'package:aplikasi_rw/modules/cordinator/models/cordinator_model.dart';
import 'package:aplikasi_rw/modules/cordinator/services/cordinator_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class CordinatorController extends GetxController {
  List<CordinatorModel> listReport = <CordinatorModel>[].obs;
  var isLoading = true.obs;
  var isMaxReached = false.obs;

  List<CordinatorModel> listReportNew = <CordinatorModel>[].obs;
  final ScrollController scrollcontroller = ScrollController();
  final controller = Get.put(UserLoginController());
  final logger = Logger();

  void realTimeComplaintDiterimaDanProses() async {
    List<CordinatorModel> listBaru;

    if (listReport.length <= 0) {
      listBaru =
          await CordinatorServices.getComplaintDiterimaDanProsesContractor(
              0, 10, controller.status.value);
    } else {
      listBaru =
          await CordinatorServices.getComplaintDiterimaDanProsesContractor(
              0, listReport.length, controller.status.value);
    }

    listReport.assignAll(listBaru);

    logger.i(listReport);
  }

  void realTimeComplaintDiproses() async {
    List<CordinatorModel> listBaru;

    if (listReport.length <= 0) {
      listBaru = await CordinatorServices.getComplaintContractorProcess(
          0, 10, controller.status.value);
    } else {
      listBaru = await CordinatorServices.getComplaintContractorProcess(
          0, listReport.length, controller.status.value);
    }

    listReport.assignAll(listBaru);

    logger.i(listReport);
  }

  void realTimeComplaintSelesai() async {
    List<CordinatorModel> listBaru;

    if (listReport.length <= 0) {
      listBaru = await CordinatorServices.getComplaintContractorFinish(
          0, 10, controller.status.value);
    } else {
      listBaru = await CordinatorServices.getComplaintContractorFinish(
          0, listReport.length, controller.status.value);
    }

    listReport.assignAll(listBaru);
  }

  void getComplaintDiterimaDanProses() async {
    if (isLoading.value) {
      listReport.assignAll(
          await CordinatorServices.getComplaintDiterimaDanProsesContractor(
              0, 10, controller.status.value));
      if (listReport.isNotEmpty) {
        isLoading.value = false;
      } else {
        isLoading.value = false;
      }
    } else {
      listReportNew.assignAll(
          await CordinatorServices.getComplaintDiterimaDanProsesContractor(
              listReport.length, 10, controller.status.value));

      if (listReportNew.isEmpty) {
        isMaxReached.value = true;
      } else {
        listReport.addAll(listReportNew);
      }
    }
  }

  void getComplaintDiproses() async {
    if (isLoading.value) {
      listReport.assignAll(
          await CordinatorServices.getComplaintContractorProcess(
              0, 10, controller.status.value));
      if (listReport.isNotEmpty) {
        isLoading.value = false;
      } else {
        isLoading.value = false;
      }
    } else {
      listReportNew.assignAll(
          await CordinatorServices.getComplaintContractorProcess(
              listReport.length, 10, controller.status.value));

      if (listReportNew.isEmpty) {
        isMaxReached.value = true;
      } else {
        listReport.addAll(listReportNew);
      }
    }
  }

  void getComplaintFinish() async {
    if (isLoading.value) {
      listReport.assignAll(
          await CordinatorServices.getComplaintContractorFinish(
              0, 10, controller.status.value));
      if (listReport.isNotEmpty) {
        isLoading.value = false;
      } else {
        isLoading.value = false;
      }
    } else {
      listReportNew.assignAll(
          await CordinatorServices.getComplaintContractorFinish(
              listReport.length, 10, controller.status.value));

      if (listReportNew.isEmpty) {
        isMaxReached.value = true;
      } else {
        listReport.addAll(listReportNew);
      }
    }
  }
}
