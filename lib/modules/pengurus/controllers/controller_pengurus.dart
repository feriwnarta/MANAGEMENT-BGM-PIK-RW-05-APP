import 'package:aplikasi_rw/modules/estate_manager/models/card_status_peduli_em_model.dart';
import 'package:aplikasi_rw/modules/pengurus/services/StatusPeduliPengurusServices.dart';
import 'package:get/get.dart';

class ListStatusPeduliPengurusController extends GetxController {
  List<StatusPeduliEmModel> listStatusPeduli = <StatusPeduliEmModel>[].obs;
  List<StatusPeduliEmModel> listStatusNew = <StatusPeduliEmModel>[].obs;
  var isLoading = true.obs;
  var isMaxReached = false.obs;

  Future<void> changeDataRequest({String status}) async {
    listStatusPeduli.clear();
    listStatusNew.clear();
    isLoading = true.obs;
    isMaxReached = false.obs;

    if (isLoading.value) {
      listStatusPeduli.assignAll(
          await StatusPeduliPengurusServices.getListReport(
              status: status, start: 0, limit: 10));

      // update();
      if (listStatusPeduli.isNotEmpty) {
        isLoading.value = false;
        update();
      } else {
        isLoading.value = false;
        update();
      }
    } else {
      listStatusNew.assignAll(
        await StatusPeduliPengurusServices.getListReport(
            start: listStatusPeduli.length, limit: 10, status: status),
      );
      if (listStatusNew.isEmpty) {
        isMaxReached.value = true;
        update();
      } else {
        listStatusPeduli.addAll(listStatusNew);
        update();
      }
    }
    update();
  }

  void realTime({String status}) async {
    List<StatusPeduliEmModel> listBaru;

    if (listStatusPeduli.length <= 10) {
      listBaru = await StatusPeduliPengurusServices.getListReport(
          limit: 10, start: 0, status: status);
    } else {
      listBaru = await StatusPeduliPengurusServices.getListReport(
          start: 0, limit: listStatusPeduli.length, status: status);
    }

    listStatusPeduli.assignAll(listBaru);
  }

  Future<void> getDataFromDb({String status}) async {
    if (isLoading.value) {
      listStatusPeduli.assignAll(
          await StatusPeduliPengurusServices.getListReport(
              status: status, start: 0, limit: 10));

      // update();
      if (listStatusPeduli.isNotEmpty) {
        isLoading.value = false;
        update();
      } else {
        isLoading.value = false;
        update();
      }
    } else {
      listStatusNew.assignAll(
        await StatusPeduliPengurusServices.getListReport(
            start: listStatusPeduli.length, limit: 10, status: status),
      );
      if (listStatusNew.isEmpty) {
        isMaxReached.value = true;
        update();
      } else {
        listStatusPeduli.addAll(listStatusNew);
        update();
      }
    }
    update();
  }
}
