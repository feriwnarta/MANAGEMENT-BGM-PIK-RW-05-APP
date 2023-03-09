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

  // access pengelola
  RxBool dashboardPengelola = false.obs;
  RxBool statusPeduliLingkunganPengelola = false.obs;

  void accessManagerCon() {
    dashboardManagerCon = true.obs;
    statusPeduliLingkunganManagerCord = true.obs;
  }

  void accessAsEm() {
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
    dashboardCord = true.obs;
    statusPeduliLingkunganCord = true.obs;
    absensiCord = true.obs;
  }

  void accessAsKepalaContractor() {
    dashboardKepalaCon = true.obs;
    statusPeduliLingkunganKepalaCon = true.obs;
    absensiKepalaCon = true.obs;
  }

  void accessAsPengelola() {
    statistikPeduliLindungi = true.obs;
    peduliLingkungan = true.obs;
    statusPeduliLingkungan = true.obs;
    statusIpl = true.obs;
    informasiWarga = true.obs;
    informasiUmum = true.obs;
    sosialMedia = true.obs;

    dashboardPengelola = true.obs;
    statusPeduliLingkunganPengelola = true.obs;
  }
}
