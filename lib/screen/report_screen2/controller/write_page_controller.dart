import 'package:get/get.dart';
import 'package:flutter/material.dart';

class WritePageController extends GetxController {
  TextEditingController controllerTitleReport = TextEditingController();
  TextEditingController controllerContentReport =
      TextEditingController(text: '');
  RxString date = ''.obs;
  RxString address = ''.obs;
  RxString latitude = ''.obs;
  RxString longitude = ''.obs;
  RxString type = 'Anonim'.obs;
}
