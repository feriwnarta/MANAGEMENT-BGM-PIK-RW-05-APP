import 'package:get/get.dart';

class RegisterController extends GetxController {
  RxBool toOtpVerif = false.obs;
  RxBool toOtp = false.obs;
  RxBool toOtp2 = false.obs;
  RxBool isWrong = false.obs;
  RxBool isEmpty = false.obs;
  RxBool toPassword = false.obs;
  RxBool toSucces = false.obs;
  RxBool toResetPassword = false.obs;
  RxBool iplOrEmailValid = false.obs;
  RxBool iplOrEmailSucces = false.obs;
  RxBool otpWhenExit = false.obs;
  RxString methodVerifChose = ''.obs;
  RxBool fromLogin = false.obs;

  void resetController() {
    toOtpVerif = false.obs;
    toOtp = false.obs;
    toOtp2 = false.obs;
    isWrong = false.obs;
    isEmpty = false.obs;
    toPassword = false.obs;
    toSucces = false.obs;
    toResetPassword = false.obs;
    iplOrEmailValid = false.obs;
    iplOrEmailSucces = false.obs;
    otpWhenExit = false.obs;
    methodVerifChose = ''.obs;
    fromLogin = false.obs;
  }

  void toOtpverification(RxString method) {
    toOtpVerif = false.obs;
    toOtp = true.obs;
    methodVerifChose = method;
    // update();
  }
}
