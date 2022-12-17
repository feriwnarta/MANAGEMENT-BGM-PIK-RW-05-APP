import 'package:aplikasi_rw/controller/user_login_controller.dart';
import 'package:aplikasi_rw/modules/authentication/bindings/auth_binding.dart';
import 'package:aplikasi_rw/modules/authentication/screens/login_screen.dart';
import 'package:aplikasi_rw/modules/splash_view/binding/splash_view_binding.dart';
import 'package:aplikasi_rw/modules/splash_view/screens/splash_view.dart';
import 'package:aplikasi_rw/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppPage {
  static const INITIAL_ROUTE = '/splashview';

  static UserLoginController controller = Get.put(UserLoginController());

  static final pages = [
    GetPage(
      name: RouteName.home,
      page: () => SplashView(),
      binding: SplashViewBinding(),
    ),
    GetPage(
      name: RouteName.auth,
      page: () => LoginScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: RouteName.authExist,
      page: () => LoginScreen(
        email: controller.email.value,
        noTelp: controller.noTelp.value,
        controllerIpl: TextEditingController(text: controller.noIpl.value),
      ),
      binding: AuthBinding(),
    ),
  ];
}
