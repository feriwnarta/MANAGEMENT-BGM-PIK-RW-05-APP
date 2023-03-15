import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

class AdminController extends GetxController {
  RxString imagePath = ''.obs;

  TextEditingController _controllerTitle = TextEditingController();
  TextEditingController get controllerTitle => _controllerTitle;

  TextEditingController _controllerContent = TextEditingController();
  TextEditingController get controllerContent => _controllerContent;

  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  GlobalKey<RefreshIndicatorState> get refreshIndicatorKey =>
      _refreshIndicatorKey;

  void refreshShow() {
    refreshIndicatorKey.currentState.show();
  }
}
