import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class EstateManagerController extends GetxController {
  TextEditingController username = TextEditingController();
  TextEditingController nama = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController noTelp = TextEditingController();
  TextEditingController bagian = TextEditingController();
  TextEditingController password = TextEditingController();

  void reset() {
    username.clear();
    nama.clear();
    email.clear();
    noTelp.clear();
    bagian.clear();
    password.clear();
  }
}
