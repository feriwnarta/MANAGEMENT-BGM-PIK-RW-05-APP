import 'dart:async';

import 'package:aplikasi_rw/modules/home/models/notification_model.dart';
import 'package:aplikasi_rw/modules/home/services/list_notification.dart';

import 'package:get/get.dart';

class NotificationController extends GetxController {
  var listNotif = <NotificationModel>[].obs;
  Rx<Timer> timer = Timer(
    Duration(minutes: 1),
    () {},
  ).obs;

  RxString count = ''.obs;

  void getNotif() async {
    listNotif.value = await NotificationServices.getListNotification();
  }

  void getCountNotif() async {
    count.value = await NotificationServices.countNotif();
  }
}
