import 'dart:io';

import 'package:aplikasi_rw/modules/report_screen/screens/add_complaint.dart';
import 'package:aplikasi_rw/utils/size_config.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

//ignore: must_be_immutable
class CameraComplaint extends StatefulWidget {
  CameraComplaint({Key key, this.toast}) : super(key: key);

  Function toast;
  @override
  State<CameraComplaint> createState() => _CameraComplaintState();
}

class _CameraComplaintState extends State<CameraComplaint> {
  CameraController _cameraController;
  XFile picture;

  final logger = Logger();

  int selectedCameraIndex;
  List<CameraDescription> cameras;

  RxString statusCapture = 'false'.obs;
  StepperController stepperController;

  @override
  initState() {
    super.initState();
    stepperController = Get.put(StepperController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      availableCameras().then((value) {
        if (value.length > 0) {
          cameras = value;
          selectedCameraIndex = 0;
          initCamera(cameras[0]);
          logger.d(value);
        } else {
          logger.i('tidak ada kamera');
        }
      }).catchError((e) {
        logger.e(e);
      });
    });
  }

  Widget cameraToggle() {
    if (cameras == null || cameras.isEmpty) {
      return Spacer();
    }

    CameraDescription selectedCamera = cameras[selectedCameraIndex];
    CameraLensDirection cameraLensDirection = selectedCamera.lensDirection;

    return CircleAvatar(
      backgroundColor: Colors.blue,
      child: IconButton(
        onPressed: onSwitchCamera,
        alignment: Alignment.bottomLeft,
        icon: Icon(
          getCameraLensIcon(cameraLensDirection),
        ),
      ),
    );
  }

  Widget takePictureToogle() {
    if (cameras == null || cameras.isEmpty) {
      return Spacer();
    }

    return CircleAvatar(
      backgroundColor: Colors.blue,
      radius: SizeConfig.height(30),
      child: IconButton(
        onPressed: onCapture,
        icon: Icon(Icons.circle),
      ),
    );
  }

  void onCapture() async {
    if (_cameraController.value.isTakingPicture) {
      return null;
    }

    try {
      if (cameras.isNotEmpty && cameras != null) {
        picture = await _cameraController.takePicture();
        statusCapture = 'true'.obs;
        logger.i(statusCapture.value);
        stepperController.index.value = 2;
        stepperController.imagePath.value = picture.path;
        // widget.toast();
      }
    } on CameraException catch (e) {
      printError(info: e.toString());
      return null;
    }
  }

  IconData getCameraLensIcon(CameraLensDirection lens) {
    switch (lens) {
      case CameraLensDirection.back:
        return CupertinoIcons.switch_camera;
        break;
      case CameraLensDirection.front:
        return CupertinoIcons.switch_camera_solid;
        break;
      case CameraLensDirection.external:
        return CupertinoIcons.photo_camera;
        break;
      default:
        return Icons.device_unknown;
    }
  }

  void onSwitchCamera() {
    selectedCameraIndex = selectedCameraIndex < cameras.length - 1 ? 1 : 0;
    CameraDescription selectedCameras = cameras[selectedCameraIndex];
    logger.e(selectedCameraIndex);
    logger.e(cameras.length);
    initCamera(selectedCameras);
  }

  void reCaputre() {
    statusCapture.value = 'false';
    _cameraController.initialize();
  }

  Future<void> initCamera(CameraDescription desc) async {
    // if (_cameraController != null) _cameraController.dispose();

    try {
      _cameraController = CameraController(
        desc,
        ResolutionPreset.ultraHigh,
        imageFormatGroup: ImageFormatGroup.yuv420,
        enableAudio: false,
      );

      await _cameraController.initialize().then((_) {
        if (_cameraController.value.hasError) logger.e('kamera error');

        _cameraController.addListener(() {
          if (mounted) setState(() {});
        });
      }).catchError((Object e) {
        if (e is CameraException) {
          logger.e(e.code);
          switch (e.code) {
            case 'CameraAccessDenied':
              requestCameraPermission(context);
              break;
            case 'CameraAccessDeniedWithoutPrompt':
              requestCameraPermission(context);
              break;
            default:
              // Handle other errors here.
              break;
          }
        }
      });

      _cameraController.setFlashMode(FlashMode.off);
    } catch (e) {
      logger.e(e);
    }
  }

  Future<void> requestCameraPermission(BuildContext ctx) async {
    bool cameraPermission = await Permission.camera.status.isDenied;

    // dialog akses kamera
    if (cameraPermission) {
      await _dialogRequirePermissions(
        title: 'Berikan Akses Kamera',
        content:
            'Untuk menggunakan fitur yang membutuhkan kamera, kami memerlukan izin akses kamera Anda. Apakah Anda ingin memberikan izin akses sekarang?',
        no: () {
          if (Platform.isAndroid) {
            Get.back();
            Get.back();
          }
        },
        yes: () async {
          bool reqCamera = await _initPermisionCamera();

          if (!reqCamera) {
            await openAppSettings();
          }

          Get.back();
        },
        context: ctx,
      );
    } else if (await Permission.camera.status.isPermanentlyDenied) {
      await _dialogRequirePermissionsOpenSettings(
        title: 'Berikan Akses Kamera',
        content:
            'Untuk menggunakan fitur yang membutuhkan kamera, kami memerlukan izin akses kamera Anda. Kami akan membuka pengaturan sekarang. Apakah Anda ingin memberikan izin akses sekarang?',
        no: () async {
          Get.back();

          await _dialogMessage(
              title: 'Berikan Akses Kamera',
              content:
                  'Kami mengerti bahwa Anda ingin mengatur izin secara manual. Jika Anda berubah pikiran atau ingin memberikan izin nanti, Anda dapat membuka pengaturan aplikasi di perangkat Anda dan mengatur izin dengan mudah.',
              yes: () {
                Get
                  ..back()
                  ..back();
              },
              context: ctx);
        },
        yes: () async {
          await openAppSettings();
          Get.back();
        },
        context: ctx,
      );
    }
  }

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

  Future<dynamic> _dialogRequirePermissions(
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
            (Platform.isAndroid)
                ? TextButton(
                    onPressed: no,
                    child: Text(
                      'Tidak',
                      style: TextStyle(fontSize: SizeConfig.text(14)),
                    ),
                  )
                : SizedBox(),
            TextButton(
              onPressed: yes,
              child: Text(
                (Platform.isIOS) ? 'Selanjutnya' : 'Ya',
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

  /// inisialisasi ijin akses camera
  Future<bool> _initPermisionCamera() async {
    // akses kamera
    bool permissionCamera = await Permission.camera.status.isDenied;

    if (permissionCamera) {
      PermissionStatus statusCamera = await Permission.camera.request();

      if (statusCamera.isGranted) {
        return true;
      }

      return false;
    } else if (await Permission.camera.status.isPermanentlyDenied) {
      await openAppSettings();
    }

    return false;
  }

  Widget cameraPreview() {
    if (_cameraController == null || !_cameraController.value.isInitialized) {
      return Text('loading');
    } else {
      return AspectRatio(
        aspectRatio: 1,
        child: CameraPreview(
          _cameraController,
          child: Positioned(
            bottom: 30,
            left: MediaQuery.of(context).size.width / 2.8,
            child: Container(
              child: Column(
                children: [
                  SizedBox(
                    height: SizeConfig.height(40),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      cameraToggle(),
                      SizedBox(
                        width: SizeConfig.width(10),
                      ),
                      takePictureToogle(),
                    ],
                  ),
                  // SizedBox(
                  //   height: SizeConfig.height(20),
                  // ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.height(650),
      child: cameraPreview(),
    );
  }
}
