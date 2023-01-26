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

  void accessAsCitizen() {}

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
