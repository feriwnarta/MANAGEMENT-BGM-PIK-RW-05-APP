import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CameraComplaint extends StatefulWidget {
  const CameraComplaint({Key key}) : super(key: key);

  @override
  State<CameraComplaint> createState() => _CameraComplaintState();
}

class _CameraComplaintState extends State<CameraComplaint> {
  CameraController _cameraController;

  final logger = Logger();

  int selectedCameraIndex;
  List<CameraDescription> cameras;

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      availableCameras().then((value) {
        if (value.length > 0) {
          cameras = value;
          selectedCameraIndex = 0;
          initCamera(cameras[0]);
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
      XFile picture = await _cameraController.takePicture();
      logger.i(picture.path);
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
    selectedCameraIndex =
        selectedCameraIndex < cameras.length - 1 ? selectedCameraIndex++ : 0;
    CameraDescription selectedCameras = cameras[selectedCameraIndex];
    // logger.e('$cameras');
    initCamera(selectedCameras);
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
    } catch (e) {
      logger.e(e);
    }
  }

  Widget cameraPreview() {
    if (_cameraController == null || !_cameraController.value.isInitialized) {
      return Text('loading');
    } else {
      return Transform.scale(
        scaleY: 1.5,
        child: AspectRatio(
          aspectRatio: _cameraController.value.aspectRatio,
          child: CameraPreview(_cameraController),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Column(
        children: [
          SizedBox(
            height: 100.h,
          ),
          cameraPreview(),
          SizedBox(
            height: 50.h,
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
          )
        ],
      ),
    );
  }
}
