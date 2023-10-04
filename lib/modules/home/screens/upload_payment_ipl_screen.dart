import 'dart:io';
import 'package:aplikasi_rw/modules/home/screens/success_upload_payment_screen.dart';
import 'package:aplikasi_rw/modules/home/services/upload_ipl_services.dart';
import 'package:aplikasi_rw/modules/report_screen/screens/new_google_maps_screen.dart';
import 'package:aplikasi_rw/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class UploadPaymentIplScreen extends StatelessWidget {
  UploadPaymentIplScreen({Key key}) : super(key: key);

  final RxString imgPath = ''.obs;

  RxString address = ''.obs, latitude = ''.obs, longitude = ''.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Pembayaran IPL'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Obx(
            () => Container(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.width(16)),
              height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    height: SizeConfig.height(40),
                  ),
                  Text(
                    'Masukan Gambar Untuk Thumbnail',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: SizeConfig.text(16),
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.height(16),
                  ),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isDismissible: true,
                        elevation: 0,
                        builder: (context) => bottomImagePicker(context),
                      );
                    },
                    child: (imgPath.value == '')
                        ? Image(
                            height: SizeConfig.height(420),
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                            image: AssetImage(
                              'assets/img/citizen_menu/shimmer_upload.png',
                            ))
                        : Container(
                            height: SizeConfig.height(420),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                repeat: ImageRepeat.noRepeat,
                                fit: BoxFit.cover,
                                image: FileImage(File(imgPath.value)),
                              ),
                            ),
                          ),
                  ),
                  SizedBox(
                    height: SizeConfig.height(16),
                  ),
                  Center(
                    child: (imgPath.value == '')
                        ? Column(
                            children: [
                              Text(
                                'Ukuran gambar : maks. 5 MB',
                                style: TextStyle(
                                  fontSize: SizeConfig.text(14),
                                  color: Color(0xff9E9E9E),
                                ),
                              ),
                              Text(
                                'Format gambar : .JPG, .PNG',
                                style: TextStyle(
                                  fontSize: SizeConfig.text(14),
                                  color: Color(0xff9E9E9E),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/img/image-svg/information-circle.svg',
                                    color: Color(0xffF7C36A),
                                  ),
                                  SizedBox(
                                    width: SizeConfig.width(8),
                                  ),
                                  Text(
                                    'Sentuh foto untuk mengganti foto yang lain.',
                                    style: TextStyle(
                                      fontSize: SizeConfig.text(12),
                                      color: Color(0xff757575),
                                    ),
                                  )
                                ],
                              ),
                              TextButton.icon(
                                onPressed: () async {
                                  // ijin akses lokasi
                                  bool permissionLocation = await Permission
                                      .location.status.isPermanentlyDenied;

                                  if (permissionLocation) {
                                    await _dialogRequirePermissionsOpenSettings(
                                      title: 'Berikan Akses Lokasi',
                                      content:
                                          'Untuk menggunakan fitur yang membutuhkan lokasi, kami memerlukan izin akses lokasi Anda. Kami akan membuka pengaturan sekarang. Apakah Anda ingin memberikan izin akses sekarang?',
                                      no: () async {
                                        await Get.back();

                                        await _dialogMessage(
                                            title: 'Berikan Akses Lokasi',
                                            content:
                                                'Anda tidak bisa melanjutkan penggunaan fitur ini tanpa ijin akses lokasi. Kami mengerti bahwa Anda ingin mengatur izin secara manual. Jika Anda berubah pikiran atau ingin memberikan izin nanti, Anda dapat membuka pengaturan aplikasi di perangkat Anda dan mengatur izin dengan mudah.',
                                            yes: () {
                                              Get
                                                ..back()
                                                ..back();
                                            },
                                            context: context);
                                        return;
                                      },
                                      yes: () async {
                                        await openAppSettings();
                                        Get.back();
                                      },
                                      context: context,
                                    );
                                    return;
                                  }

                                  Get.to<Map<String, dynamic>>(
                                      () => NewGoogleMaps()).then((value) {
                                    if (value != null) {
                                      // dapatkan google data alamat dari  maps
                                      address.value = value['data'];
                                      latitude.value =
                                          value['latitude'].toString();
                                      longitude.value =
                                          value['longitude'].toString();
                                    }
                                  });
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: Color(0xff404040),
                                  padding: EdgeInsets.zero,
                                ),
                                icon: Icon(Icons.location_on),
                                label: Text(
                                  (address.value == '')
                                      ? 'Pilih lokasi pengiriman'
                                      : '${address.value}',
                                  style: TextStyle(
                                    fontSize: SizeConfig.text(14),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                  SizedBox(
                    height: SizeConfig.height(64),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (imgPath.value == '') {
                          EasyLoading.showError(
                              'Bukti pembayaran belum diupload');
                          return;
                        }

                        if (address == '' ||
                            longitude == '' ||
                            latitude == '') {
                          EasyLoading.showError(
                              'Lokasi pengiriman belum ditentukan / gagal mengambil lokasi');
                          return;
                        }

                        // proses upload ipl
                        var result = await UploadIplServices.uploadIpl(
                            imgPath.value,
                            address.value,
                            latitude.value,
                            longitude.value);

                        if (result == 'bukti pembayaran sudah terupload') {
                          EasyLoading.showInfo(
                              'Sudah ada pembayaran pada bulan ini');
                          return;
                        }

                        if (result == 'gagal simpan data') {
                          EasyLoading.showError(
                              'Gagal menyimpan upload. hubungi administrator');
                          return;
                        }

                        if (result == 'failed') {
                          EasyLoading.showError(
                              'Ada sesuatu yang salah. hubungi administrator');
                          return;
                        }

                        // jika sudah upload
                        Get.to(() => SuccessUploadPaymentScreen(),
                            transition: Transition.rightToLeft);
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      )),
                      child: Text(
                        'Kirim Bukti Pembayaran IPL',
                        style: TextStyle(fontSize: SizeConfig.text(16)),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget bottomImagePicker(BuildContext context) => Container(
        margin: EdgeInsets.only(top: SizeConfig.height(20)),
        // width: MediaQuery.of(context).size.width,
        height: SizeConfig.height(90),
        child: Column(
          children: [
            Text(
              'Pilih gambar',
              style: TextStyle(
                  fontSize: SizeConfig.text(13), fontFamily: 'Pt Sans Narrow'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                    icon: Icon(Icons.camera_alt),
                    label: Text(
                      'Kamera',
                      style: TextStyle(
                        fontSize: SizeConfig.text(13),
                      ),
                    ),
                    onPressed: () async {
                      await getImage(ImageSource.camera, context);
                    }),
                TextButton.icon(
                  icon: Icon(Icons.image),
                  label: Text(
                    'Gallery',
                    style: TextStyle(
                      fontSize: SizeConfig.text(13),
                    ),
                  ),
                  onPressed: () async {
                    await getImage(ImageSource.gallery, context);
                  },
                )
              ],
            )
          ],
        ),
      );

  Future<dynamic> _dialogMessage(
      {String title, String content, Function yes, BuildContext context}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      useSafeArea: true,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(
              fontSize: SizeConfig.text(16),
            ),
          ),
          content: Text(
            content,
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: SizeConfig.text(12), color: Colors.grey),
          ),
          titlePadding: EdgeInsets.symmetric(
            horizontal: SizeConfig.width(16),
            vertical: SizeConfig.height(8),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: SizeConfig.width(16),
            vertical: SizeConfig.height(8),
          ),
          actions: [
            TextButton(
              onPressed: yes,
              child: Text(
                'OKE',
                style: TextStyle(fontSize: SizeConfig.text(14)),
              ),
            ),
          ],
          actionsPadding: EdgeInsets.symmetric(
            horizontal: SizeConfig.width(16),
            vertical: 0,
          ),
        );
      },
    );
  }

  Future getImage(ImageSource source, BuildContext context) async {
    if (Platform.isIOS) {
      if (source == ImageSource.camera) {
        if (Navigator.canPop(context)) {
          Navigator.of(context).pop();
          if (await Permission.camera.status.isDenied) {
            await _showDialogReqCamera(context, source);
          } else if (await Permission.camera.status.isPermanentlyDenied) {
            await _showDialogReqCameraOpenSetting(context, source);
          } else if (await Permission.camera.status.isGranted) {
            requestImageOrPhoto(source);
          }
        }
      } else if (source == ImageSource.gallery) {
        if (Navigator.canPop(context)) {
          Navigator.of(context).pop();
          if (await Permission.photos.status.isDenied) {
            await _showDialogReqGallery(context, source);
          } else if (await Permission.photos.status.isPermanentlyDenied) {
            await _showDialogReqGalleryOpenSetting(context, source);
          } else if (await Permission.photos.status.isGranted) {
            requestImageOrPhoto(source);
          } else if (await Permission.photos.status.isLimited) {
            await _showDialogReqGalleryOpenSetting(context, source);
          }
        }
      }
    }
    requestImageOrPhoto(source);
  }

  Future<dynamic> _dialogRequirePermissionsOpenSettings(
      {String title,
      String content,
      Function yes,
      Function no,
      BuildContext context}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      useSafeArea: true,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(
              fontSize: SizeConfig.text(16),
            ),
          ),
          content: Text(
            content,
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: SizeConfig.text(12), color: Colors.grey),
          ),
          titlePadding: EdgeInsets.symmetric(
            horizontal: SizeConfig.width(16),
            vertical: SizeConfig.height(8),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: SizeConfig.width(16),
            vertical: SizeConfig.height(8),
          ),
          actions: [
            TextButton(
              onPressed: no,
              child: Text(
                'Tidak',
                style: TextStyle(fontSize: SizeConfig.text(14)),
              ),
            ),
            TextButton(
              onPressed: yes,
              child: Text(
                (Platform.isIOS) ? 'Pengaturan' : 'Pengaturan',
                style: TextStyle(fontSize: SizeConfig.text(14)),
              ),
            ),
          ],
          actionsPadding: EdgeInsets.symmetric(
            horizontal: SizeConfig.width(16),
            vertical: 0,
          ),
        );
      },
    );
  }

  Future<void> requestImageOrPhoto(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile imageOrPhoto = await picker.pickImage(source: source);
    if (imageOrPhoto != null) {
      this.imgPath.value = imageOrPhoto.path;
    }
  }

  void showConfirmationDialog(BuildContext context) async {
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Izin Akses'),
        content: Column(
          children: [
            const Text(
                'Kami mengerti bahwa Anda ingin mengatur izin secara manual. Jika Anda berubah pikiran atau ingin memberikan izin nanti, Anda dapat membuka pengaturan aplikasi di perangkat Anda dan mengatur izin dengan mudah.'),
          ],
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () async {
              Get
                ..back()
                ..back()
                ..back();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _showDialogReqCamera(
      BuildContext context, ImageSource source) async {
    bool permissionGranted = false;

    await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Izin Kamera'),
        content: Column(
          children: [
            const Text(
                'Untuk mengunggah bukti transfer atau pembayaran iuran lingkungan, kami perlu mengakses kamera pada perangkat Anda. Tolong beri izin akses kamera.'),
          ],
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);

              showConfirmationDialog(context);
            },
            child: const Text('Tolak'),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () async {
              var status = await Permission.camera.request();
              permissionGranted = status.isGranted;
              if (permissionGranted) {
                Get.back();
                requestImageOrPhoto(source);
              } else if (status.isPermanentlyDenied) {
                showConfirmationDialog(context);
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _showDialogReqGallery(
      BuildContext context, ImageSource source) async {
    bool permissionGranted = false;

    await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Izin Gallery'),
        content: Column(
          children: [
            const Text(
                'Untuk mengunggah bukti transfer atau pembayaran iuran lingkungan, kami perlu mengakses gallery pada perangkat Anda. Tolong beri izin akses gallery.'),
          ],
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);

              showConfirmationDialog(context);
            },
            child: const Text('Tolak'),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () async {
              var status = await Permission.photos.request();
              permissionGranted = status.isGranted;
              if (permissionGranted) {
                Get.back();
                requestImageOrPhoto(source);
              } else if (status.isPermanentlyDenied) {
                showConfirmationDialog(context);
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<bool> _showDialogReqCameraOpenSetting(
      BuildContext context, ImageSource source) async {
    bool permissionGranted = false;

    await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Izin Gallery'),
        content: Column(
          children: [
            const Text(
                'Untuk menggunakan fitur yang membutuhkan kamera, kami memerlukan izin akses kamera Anda. Kami akan membuka pengaturan sekarang. Apakah Anda ingin memberikan izin akses sekarang?'),
          ],
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              showConfirmationDialog(context);
            },
            child: const Text('Tidak'),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () async {
              Navigator.of(context).pop();
              await openAppSettings();
            },
            child: const Text('Pengaturan'),
          ),
        ],
      ),
    );

    return permissionGranted;
  }

  Future<bool> _showDialogReqGalleryOpenSetting(
      BuildContext context, ImageSource source) async {
    bool permissionGranted = false;

    await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Izin Gallery'),
        content: Column(
          children: [
            const Text(
                'Untuk menggunakan fitur yang membutuhkan gallery, kami memerlukan izin akses gallery Anda. Kami akan membuka pengaturan sekarang. Apakah Anda ingin memberikan izin akses sekarang?'),
          ],
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              showConfirmationDialog(context);
            },
            child: const Text('Tidak'),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () async {
              Navigator.of(context).pop();
              await openAppSettings();
            },
            child: const Text('Pengaturan'),
          ),
        ],
      ),
    );

    return permissionGranted;
  }
}
