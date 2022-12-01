import 'package:get/get.dart';

class WriteStatusController extends GetxController {
  RxBool isVisibility = false.obs;
  RxString pickedFile = ''.obs;

  void addImage(RxBool isVisibility, RxString pickedFile) {
    if (isVisibility.value && pickedFile != null) {
      this.isVisibility = isVisibility;
      this.pickedFile = pickedFile;
    }
  }

  void deleteImage() {
    this.isVisibility = false.obs;
    this.pickedFile = ''.obs;
  }
}
