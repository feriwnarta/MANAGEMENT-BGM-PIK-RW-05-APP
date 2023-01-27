import 'package:get/get.dart';

class AccessController extends GetxController {
  // access warga
  RxBool statistikPeduliLindungi = false.obs;
  RxBool peduliLingkungan = false.obs;
  RxBool statusPeduliLingkungan = false.obs;
  RxBool statusIpl = false.obs;
  RxBool informasiWarga = false.obs;
  RxBool informasiUmum = false.obs;
  RxBool sosialMedia = false.obs;

  // access estate manager
  RxBool dashboardEm = false.obs;
  RxBool tambahAkunEm = false.obs;
  RxBool statusPeduliLingkunganEm = false.obs;

  // access cordinator
  RxBool dashboardCord = false.obs;
  RxBool statusPeduliLingkunganCord = false.obs;
  RxBool absensiCord = false.obs;

  // access manager contractor
  RxBool dashboardManagerCon = false.obs;
  RxBool statusPeduliLingkunganManagerCord = false.obs;

  // access Kepala Kontraktor
  RxBool dashboardKepalaCon = false.obs;
  RxBool statusPeduliLingkunganKepalaCon = false.obs;
  RxBool absensiKepalaCon = false.obs;

  void accessManagerCon() {
    statistikPeduliLindungi = false.obs;
    peduliLingkungan = false.obs;
    statusPeduliLingkungan = false.obs;
    statusIpl = false.obs;
    informasiWarga = false.obs;
    informasiUmum = false.obs;
    sosialMedia = false.obs;

    dashboardManagerCon = true.obs;
    statusPeduliLingkunganManagerCord = true.obs;
  }

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

  void accessAsCitizen() {
    statistikPeduliLindungi = true.obs;
    peduliLingkungan = true.obs;
    statusPeduliLingkungan = true.obs;
    statusIpl = true.obs;
    informasiWarga = true.obs;
    informasiUmum = true.obs;
    sosialMedia = true.obs;
  }

  void accessAsCordinator() {
    statistikPeduliLindungi = false.obs;
    peduliLingkungan = false.obs;
    statusPeduliLingkungan = false.obs;
    statusIpl = false.obs;
    informasiWarga = false.obs;
    informasiUmum = false.obs;
    sosialMedia = false.obs;

    dashboardCord = true.obs;
    statusPeduliLingkunganCord = true.obs;
    absensiCord = true.obs;
  }

  void accessAsKepalaContractor() {
    statistikPeduliLindungi = false.obs;
    peduliLingkungan = false.obs;
    statusPeduliLingkungan = false.obs;
    statusIpl = false.obs;
    informasiWarga = false.obs;
    informasiUmum = false.obs;
    sosialMedia = false.obs;

    dashboardKepalaCon = true.obs;
    statusPeduliLingkunganKepalaCon = true.obs;
    absensiKepalaCon = true.obs;
  }

  void accessAsPengelola() {}
}
