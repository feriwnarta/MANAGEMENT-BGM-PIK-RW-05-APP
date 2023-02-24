import 'package:aplikasi_rw/controller/user_login_controller.dart';
import 'package:aplikasi_rw/modules/manager_contractor/models/manager_contractor_model.dart';
import 'package:aplikasi_rw/modules/manager_contractor/services/manager_con_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class ManagerController extends GetxController {
  List<ManagerContractorModel> listReport = <ManagerContractorModel>[].obs;
  var isLoading = true.obs;
  var isMaxReached = false.obs;

  List<ManagerContractorModel> listReportNew = <ManagerContractorModel>[].obs;
  final ScrollController scrollcontroller = ScrollController();
  final controller = Get.put(UserLoginController());
  final logger = Logger();

  void realTimeComplaintDiterimaDanProses() async {
    List<ManagerContractorModel> listBaru;

    if (listReport.length <= 10) {
      listBaru =
          await ManagerConServices.getComplaintDiterimaDanProsesContractor(
              0, 10, controller.status.value);
    } else {
      listBaru =
          await ManagerConServices.getComplaintDiterimaDanProsesContractor(
              0, listReport.length, controller.status.value);
    }

    listReport.assignAll(listBaru);
  }

  void realTimeComplaintDiproses() async {
    List<ManagerContractorModel> listBaru;

    if (listReport.length <= 0) {
      listBaru = await ManagerConServices.getComplaintContractorProcess(
          0, 10, controller.status.value);
    } else {
      listBaru = await ManagerConServices.getComplaintContractorProcess(
          0, listReport.length, controller.status.value);
    }

    listReport.assignAll(listBaru);

    logger.i(listReport);
  }

  void realTimeComplaintSelesai() async {
    List<ManagerContractorModel> listBaru;

    if (listReport.length <= 0) {
      listBaru = await ManagerConServices.getComplaintContractorFinish(
          0, 10, controller.status.value);
    } else {
      listBaru = await ManagerConServices.getComplaintContractorFinish(
          0, listReport.length, controller.status.value);
    }

    listReport.assignAll(listBaru);
  }

  void getComplaintDiterimaDanProses() async {
    if (isLoading.value) {
      listReport.assignAll(
          await ManagerConServices.getComplaintDiterimaDanProsesContractor(
              0, 10, controller.status.value));
      if (listReport.isNotEmpty) {
        isLoading.value = false;
      } else {
        isLoading.value = false;
      }
    } else {
      listReportNew.assignAll(
          await ManagerConServices.getComplaintDiterimaDanProsesContractor(
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
          await ManagerConServices.getComplaintContractorProcess(
              0, 10, controller.status.value));
      if (listReport.isNotEmpty) {
        isLoading.value = false;
      } else {
        isLoading.value = false;
      }
    } else {
      listReportNew.assignAll(
          await ManagerConServices.getComplaintContractorProcess(
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
          await ManagerConServices.getComplaintContractorFinish(
              0, 10, controller.status.value));
      if (listReport.isNotEmpty) {
        isLoading.value = false;
      } else {
        isLoading.value = false;
      }
    } else {
      listReportNew.assignAll(
          await ManagerConServices.getComplaintContractorFinish(
              listReport.length, 10, controller.status.value));

      if (listReportNew.isEmpty) {
        isMaxReached.value = true;
      } else {
        listReport.addAll(listReportNew);
      }
    }
  }
}
