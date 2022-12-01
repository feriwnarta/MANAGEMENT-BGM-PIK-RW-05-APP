import 'package:get/get.dart';

class ReportController extends GetxController {
  var selectedIndex = <int>[].obs;
  var klasifikasiPicked = <String>[].obs;
  var nameKlasifikasi = <String>[].obs;
  var isVisibility = false.obs;
  int activeStep = 0.obs.value;
}
