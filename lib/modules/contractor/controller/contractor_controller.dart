import 'package:aplikasi_rw/controller/user_login_controller.dart';
import 'package:aplikasi_rw/modules/contractor/models/contractor_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../services/contractor_services.dart';

class ContractorController extends GetxController {
  List<ContractorModel> listReport = <ContractorModel>[].obs;
  var isLoading = true.obs;
  var isMaxReached = false.obs;

  List<ContractorModel> listReportNew = <ContractorModel>[].obs;
  final ScrollController scrollcontroller = ScrollController();
  final controller = Get.put(UserLoginController());
  final logger = Logger();

  void realTimeComplaintDiterimaDanProses() async {
    List<ContractorModel> listBaru;

    if (listReport.length <= 0) {
      listBaru =
          await ContractorServices.getComplaintDiterimaDanProsesContractor(
              0, 10, controller.status.value);
    } else {
      listBaru =
          await ContractorServices.getComplaintDiterimaDanProsesContractor(
              0, listReport.length, controller.status.value);
    }

    listReport.assignAll(listBaru);

    logger.i(listReport);
  }

  void realTimeComplaintDiproses() async {
    List<ContractorModel> listBaru;

    if (listReport.length <= 10) {
      listBaru = await ContractorServices.getComplaintContractorProcess(
          0, 10, controller.status.value);
    } else {
      listBaru = await ContractorServices.getComplaintContractorProcess(
          0, listReport.length, controller.status.value);
    }

    listReport.assignAll(listBaru);

    logger.i(listReport.length);
  }

  void realTimeComplaintSelesai() async {
    List<ContractorModel> listBaru;

    if (listReport.length <= 10) {
      listBaru = await ContractorServices.getComplaintContractorFinish(
          0, 10, controller.status.value);
    } else {
      listBaru = await ContractorServices.getComplaintContractorFinish(
          0, listReport.length, controller.status.value);
    }

    listReport.assignAll(listBaru);
  }

  void getComplaintDiterimaDanProses() async {
    if (isLoading.value) {
      listReport.assignAll(
          await ContractorServices.getComplaintDiterimaDanProsesContractor(
              0, 10, controller.status.value));
      if (listReport.isNotEmpty) {
        isLoading.value = false;
      } else {
        isLoading.value = false;
      }
    } else {
      listReportNew.assignAll(
          await ContractorServices.getComplaintDiterimaDanProsesContractor(
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
          await ContractorServices.getComplaintContractorProcess(
              0, 10, controller.status.value));
      if (listReport.isNotEmpty) {
        isLoading.value = false;
      } else {
        isLoading.value = false;
      }
    } else {
      listReportNew.assignAll(
          await ContractorServices.getComplaintContractorProcess(
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
          await ContractorServices.getComplaintContractorFinish(
              0, 10, controller.status.value));
      if (listReport.isNotEmpty) {
        isLoading.value = false;
      } else {
        isLoading.value = false;
      }
    } else {
      listReportNew.assignAll(
          await ContractorServices.getComplaintContractorFinish(
              listReport.length, 10, controller.status.value));

      if (listReportNew.isEmpty) {
        isMaxReached.value = true;
      } else {
        listReport.addAll(listReportNew);
      }
    }
  }
}
