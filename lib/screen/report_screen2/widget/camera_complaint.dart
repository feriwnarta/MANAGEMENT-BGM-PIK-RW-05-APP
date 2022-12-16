import 'package:aplikasi_rw/screen/report_screen2/add_complaint.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:logger/logger.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

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
      radius: 30.h,
      child: IconButton(
        onPressed: onCapture,
        icon: Icon(Icons.circle),
      ),
    );
  }

  void onCapture() async {
    if (cameras.isNotEmpty && cameras != null) {
      picture = await _cameraController.takePicture();
      statusCapture = 'true'.obs;
      logger.i(statusCapture.value);
      // Get.back(result: {'pathImage': picture.path});
      stepperController.index.value = 2;
      stepperController.imagePath.value = picture.path;
      widget.toast();
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
      _cameraController = CameraController(desc, ResolutionPreset.high,
          imageFormatGroup: ImageFormatGroup.yuv420);

      if (_cameraController.value.hasError) logger.e('kamera error');

      _cameraController.addListener(() {
        if (mounted) setState(() {});
      });

      await _cameraController.initialize();
      _cameraController.setFlashMode(FlashMode.off);
    } catch (e) {
      logger.e(e);
    }
  }

  Widget cameraPreview() {
    if (_cameraController == null || !_cameraController.value.isInitialized) {
      return Text('loading');
    } else {
      return AspectRatio(
        aspectRatio: _cameraController.value.aspectRatio,
        child: CameraPreview(_cameraController),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 500.h,
            child: cameraPreview(),
          ),

          Container(
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(
                  height: 20.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    cameraToggle(),
                    SizedBox(
                      width: 10.w,
                    ),
                    takePictureToogle(),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
              ],
            ),
          ),

          // Obx(() => (statusCapture.value == 'true')
          //     ? Container(
          //         margin: EdgeInsets.symmetric(horizontal: 16.w),
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             SizedBox(
          //               width: 97.w,
          //               child: TextButton(
          //                 onPressed: reCaputre,
          //                 child: Text(
          //                   'Ulangi',
          //                   style: TextStyle(
          //                     color: Colors.white,
          //                     fontSize: 14.sp,
          //                   ),
          //                 ),
          //                 style: TextButton.styleFrom(
          //                   backgroundColor: Color(0xff2094F3),
          //                   shape: RoundedRectangleBorder(
          //                     borderRadius: BorderRadius.circular(50),
          //                   ),
          //                 ),
          //               ),
          //             ),
          //             SizedBox(
          //               width: 97.w,
          //               child: TextButton(
          //                 onPressed: () {
          //                   if (picture != null) {
          //                     widget.nextStep(picture.path);
          //                   }
          //                 },
          //                 child: Text(
          //                   'Lanjutkan',
          //                   style: TextStyle(
          //                     color: Colors.white,
          //                     fontSize: 14.sp,
          //                   ),
          //                 ),
          //                 style: TextButton.styleFrom(
          //                   backgroundColor: Color(0xff2094F3),
          //                   shape: RoundedRectangleBorder(
          //                     borderRadius: BorderRadius.circular(50),
          //                   ),
          //                 ),
          //               ),
          //             ),
          //           ],
          //         ),
          //       )
          //     : Spacer())
        ],
      ),
    );
  }
}
