import 'package:get/get.dart';

class AccessController extends GetxController {
  RxBool statistikPeduliLindungi = true.obs;

  void accessAsEm() {
    statistikPeduliLindungi = false.obs;
  }

  void accessAsCitizen() {}

  void accessAsCordinator() {}

  void accessAsContractor() {}

  void accessAsPengelola() {}
}
