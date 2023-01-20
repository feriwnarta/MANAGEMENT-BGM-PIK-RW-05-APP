import 'package:get/get.dart';

class AccessController extends GetxController {
  // access warga
  RxBool statistikPeduliLindungi = true.obs;
  RxBool peduliLingkungan = true.obs;
  RxBool statusPeduliLingkungan = true.obs;
  RxBool statusIpl = true.obs;
  RxBool informasiWarga = true.obs;
  RxBool informasiUmum = true.obs;
  RxBool sosialMedia = true.obs;

  // access estate manager
  RxBool dashboardEm = false.obs;
  RxBool tambahAkunEm = false.obs;
  RxBool statusPeduliLingkunganEm = false.obs;

  void accessAsEm() {
    statistikPeduliLindungi = false.obs;
    peduliLingkungan = false.obs;
    statusPeduliLingkungan = false.obs;
    statusIpl = false.obs;
    informasiWarga = false.obs;
    informasiUmum = false.obs;
    sosialMedia = false.obs;

    dashboardEm = true.obs;
    tambahAkunEm = true.obs;
    statusPeduliLingkunganEm = true.obs;
  }

  void accessAsCitizen() {}

  void accessAsCordinator() {}

  void accessAsContractor() {}

  void accessAsPengelola() {}
}
