import 'package:aplikasi_rw/controller/user_login_controller.dart';
import 'package:get/get.dart';

class SplashViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(() => UserLoginController());
  }
}
