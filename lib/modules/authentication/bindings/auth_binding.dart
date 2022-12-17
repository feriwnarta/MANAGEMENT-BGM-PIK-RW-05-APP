import 'package:aplikasi_rw/controller/register_controller.dart';
import 'package:aplikasi_rw/controller/resend_otp_countdown_controller.dart';
import 'package:aplikasi_rw/controller/user_login_controller.dart';
import 'package:aplikasi_rw/modules/authentication/controllers/auth_controller.dart';
import 'package:get/get.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RegisterController());
    Get.lazyPut(() => UserLoginController());
    Get.lazyPut(() => CountDownController());
    Get.lazyPut(() => AuthController());
  }
}
