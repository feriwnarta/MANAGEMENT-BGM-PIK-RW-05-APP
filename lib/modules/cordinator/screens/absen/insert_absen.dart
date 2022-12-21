import 'dart:io';

import 'package:aplikasi_rw/controller/user_login_controller.dart';
import 'package:aplikasi_rw/services/absen_worker_services.dart';
import 'package:aplikasi_rw/services/location_services.dart';
import 'package:aplikasi_rw/utils/UserSecureStorage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoder/geocoder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';

import '../home_screen_cordinator.dart';

class AbsenController extends GetxController {
  RxString locationNow = 'Lokasi Sekarang'.obs;
  RxString imagePath = ''.obs;
  RxString date = ''.obs;
  RxString day = ''.obs;
  RxString jamMasuk = ''.obs;
  RxString jamKeluar = ''.obs;
  RxString status = 'false'.obs;
}

class InsertAbsen extends StatefulWidget {
  InsertAbsen({Key key}) : super(key: key);

  @override
  _InsertAbsenState createState() => _InsertAbsenState();
}

class _InsertAbsenState extends State<InsertAbsen> {
  final logger = Logger();
  AbsenController _absenController = Get.put(AbsenController());
  PickedFile pickedFile;
  final _picker = ImagePicker();
  final UserLoginController controller = Get.put(UserLoginController());

  String getFomatDay() {
    DateTime dateTime = DateTime.now();
    String day;

    switch (dateTime.weekday) {
      case DateTime.monday:
        day = 'Senin, ';
        break;
      case DateTime.tuesday:
        day = 'Selasa, ';
        break;
      case DateTime.wednesday:
        day = 'Rabu, ';
        break;
      case DateTime.thursday:
        day = 'Kamis, ';
        break;
      case DateTime.friday:
        day = 'Jumat, ';
        break;
      case DateTime.saturday:
        day = 'Sabtu, ';
        break;
      case DateTime.sunday:
        day = 'Minggu, ';
        break;
    }

    if (dateTime.day < 10) {
      day += '0' + dateTime.day.toString();
    } else {
      day += dateTime.day.toString();
    }

    switch (dateTime.month) {
      case DateTime.january:
        {
          day += ' Januari';
        }
        break;
      case DateTime.february:
        {
          day += ' Febuari';
        }
        break;
      case DateTime.march:
        {
          day += ' Maret';
        }
        break;
      case DateTime.april:
        {
          day += ' April';
        }
        break;
      case DateTime.may:
        {
          day += ' Mei';
        }
        break;
      case DateTime.june:
        {
          day += ' juni';
        }
        break;
      case DateTime.july:
        {
          day += ' Juli';
        }
        break;
      case DateTime.august:
        {
          day += ' Agustus';
        }
        break;
      case DateTime.september:
        {
          day += ' September';
        }
        break;
      case DateTime.october:
        {
          day += ' Oktober';
        }
        break;
      case DateTime.november:
        {
          day += ' November';
        }
        break;
      case DateTime.december:
        {
          day += ' Desember';
        }
        break;
    }

    day += ' ${dateTime.year}';
    return day;
  }

  String getFormatDate() {
    DateTime dateTime = DateTime.now();
    final logger = Logger();
    logger.i(dateTime);
    if (dateTime.hour < 10) {
      if (dateTime.minute < 10) {
        return '0${dateTime.hour} : 0${dateTime.minute}';
      } else {
        return '0${dateTime.hour} : ${dateTime.minute}';
      }
    } else {
      if (dateTime.minute < 10) {
        return '${dateTime.hour} : 0${dateTime.minute}';
      } else {
        return '${dateTime.hour} : ${dateTime.minute}';
      }
    }
  }

  @override
  initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    await absenMasukDanKeluar();
  }

  String formatDateTime() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    final String formatted = formatter.format(now);
    return formatted;
  }

  Future<void> absenMasukDanKeluar() async {
    try {
      await getImage(ImageSource.camera);
      final location = LocationServices();
      _showDialogLocation();
      location.locationStream.listen((event) async {
        Geocoder.local
            .findAddressesFromCoordinates(
                Coordinates(event.latitude, event.longitude))
            .then((value) async {
          _absenController.locationNow = value.first.addressLine.obs;
          _absenController.update();
          _absenController.date = getFormatDate().obs;
          _absenController.day = getFomatDay().obs;
          _absenController.jamMasuk = getFormatDate().obs;
          _absenController.update();
          await sendAbsen();
          _absenController.status.value = 'true';
          _absenController.update();
          final logger = Logger();
          logger.e(_absenController.status.value);
        });
        await Future.delayed(Duration(seconds: 1));
        Navigator.of(context).pop();
      });
    } on PlatformException {
      Get.off(HomeScreenCordinator());
    }
  }

  Future<void> sendAbsen() async {
    String idUser = await UserSecureStorage.getIdUser();
    String status = controller.status.value;

    if (status == 'cordinator') {
      Map<String, dynamic> message = await AbsenServices.sendAbsen(
          idUser: idUser,
          status: status,
          location: _absenController.locationNow.value,
          image: _absenController.imagePath.value,
          hour: formatDateTime());

      if (message['status'] == 'SUCCESS MASUK') {
        EasyLoading.showSuccess('Absen masuk berhasil');
      }

      if (message['status'] == 'SUCCESS PULANG') {
        _absenController.jamMasuk = message['jam_masuk'].toString().obs;
        _absenController.jamKeluar = message['jam_pulang'].toString().obs;
        EasyLoading.showSuccess('Absen pulang berhasil');
        _absenController.update();
      }

      if (message['status'] == 'SUDAH PULANG') {
        // await Future.delayed(Duration(milliseconds: 500));
        Navigator.of(context).pop();
        EasyLoading.showInfo('Anda sudah melakukan absen pulang hari ini');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return
        // AnnotatedRegion<SystemUiOverlayStyle>(
        //   value: SystemUiOverlayStyle(
        //       statusBarColor: Colors.blue, statusBarBrightness: Brightness.dark),
        //   child:
        Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: GetBuilder<AbsenController>(
              builder: (controller) => (controller.status.value == 'true')
                  ? Column(
                      children: [
                        Center(
                            child: Column(
                          children: [
                            SizedBox(
                              height: 64.h,
                            ),
                            Text(
                              '${controller.date.value}',
                              style: TextStyle(
                                fontSize: 40.sp,
                              ),
                            ),
                            Text(
                              '${controller.day.value}',
                              style: TextStyle(
                                  fontSize: 16.sp, color: Colors.grey),
                            ),
                          ],
                        )),
                        SizedBox(
                          height: 48.h,
                        ),
                        (controller.jamKeluar.value.isEmpty)
                            ? SvgPicture.asset(
                                'assets/img/image-svg/absen_masuk.svg')
                            : SvgPicture.asset(
                                'assets/img/image-svg/absen_keluar.svg'),
                        SizedBox(height: 32.h),
                        SizedBox(
                          width: 279.w,
                          child: Center(
                            child: TextButton.icon(
                              onPressed: null,
                              icon: SvgPicture.asset(
                                  'assets/img/image-svg/location-2.svg'),
                              label: GetBuilder<AbsenController>(
                                builder: (controller) => Text(
                                  controller.locationNow.value,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        (controller.imagePath.value.isEmpty)
                            ? TextButton.icon(
                                onPressed: () async {
                                  await getImage(ImageSource.camera);
                                },
                                icon: SvgPicture.asset(
                                    'assets/img/image-svg/camera.svg'),
                                label: Text(
                                  'Foto Lokasi',
                                  style: TextStyle(
                                      fontSize: 14.sp, color: Colors.grey),
                                ),
                              )
                            : Container(
                                width: 156.w,
                                height: 156.h,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    image: DecorationImage(
                                        image: FileImage(
                                            File(controller.imagePath.value)),
                                        fit: BoxFit.cover,
                                        repeat: ImageRepeat.noRepeat)),
                              ),
                        GetBuilder<AbsenController>(
                          builder: (controller) =>
                              (controller.imagePath.isEmpty)
                                  ? SizedBox(height: 149.h)
                                  : SizedBox(height: 25.h),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                SvgPicture.asset(
                                    'assets/img/image-svg/clock_in.svg'),
                                (controller.jamMasuk.isEmpty)
                                    ? Text(
                                        '-- : --',
                                        style: TextStyle(fontSize: 12.sp),
                                      )
                                    : Text(
                                        '${controller.jamMasuk.value}',
                                        style: TextStyle(fontSize: 12.sp),
                                      ),
                                Text(
                                  'Jam masuk',
                                  style: TextStyle(fontSize: 10.sp),
                                )
                              ],
                            ),
                            SizedBox(
                              width: 108.w,
                            ),
                            Column(
                              children: [
                                SvgPicture.asset(
                                    'assets/img/image-svg/clock_out.svg'),
                                (controller.jamKeluar.value.isEmpty)
                                    ? Text(
                                        '-- : --',
                                        style: TextStyle(fontSize: 12.sp),
                                      )
                                    : Text(
                                        '${controller.jamKeluar.value}',
                                        style: TextStyle(fontSize: 12.sp),
                                      ),
                                Text(
                                  'Jam keluar',
                                  style: TextStyle(fontSize: 10.sp),
                                )
                              ],
                            )
                          ],
                        )
                      ],
                    )
                  : Center(child: CircularProgressIndicator())),
        ),
      ),
    );
  }

  Future<void> _showDialogLocation() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text(
              'Mendapatkan lokasi sekarang',
              style: TextStyle(fontSize: 14.sp),
            ),
            content: LottieBuilder.asset(
              'assets/animation/get_location.json',
              width: 100.w,
              height: 100.h,
            ));
      },
    );
  }

  Future getImage(ImageSource source) async {
    // pickedFile
    var pickedFile = await _picker.pickImage(source: source, imageQuality: 50);
    if (pickedFile != null) {
      _absenController.imagePath = pickedFile.path.obs;
      _absenController.update();
    }
  }
}
