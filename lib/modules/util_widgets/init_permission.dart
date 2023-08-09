import 'package:aplikasi_rw/utils/size_config.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class InitPermissionApp {
  /// FIREBASE BACKGROUND NOTIFICATION
  // @pragma('vm:entry-point')
  // Future<void> _firebaseMessagingBackgroundHandler(
  //     RemoteMessage message) async {
  //   // If you're going to use other Firebase services in the background, such as Firestore,
  //   // make sure you call `initializeApp` before using other Firebase services.
  //   await Firebase.initializeApp(
  //     options: DefaultFirebaseOptions.currentPlatform,
  //   );

  //   AwesomeNotifications().createNotification(
  //       content: NotificationContent(
  //           id: 10,
  //           channelKey: 'basic_channel',
  //           title: '${message.notification.title}',
  //           body: '${message.notification.body}',
  //           actionType: ActionType.Default));

  //   print("Handling a background message: ${message.messageId}");
  // }

  Future<void> _initPermissionNotification() async {
    FirebaseMessaging m = FirebaseMessaging.instance;

    FirebaseMessaging.onMessage.listen((event) {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 10,
          channelKey: 'basic_channel',
          title: '${event.notification.title}',
          body: '${event.notification.body}',
          actionType: ActionType.Default,
          wakeUpScreen: true,
          displayOnBackground: true,
          displayOnForeground: true,
        ),
      );
    });

    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    m.getToken().then((token) => print(token));

    NotificationSettings settings = await m.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  Future<void> initPermissionApp(BuildContext context) async {
    /// tampikan dialog permision
    await _displayDialogPermission(context);
  }

  Future<void> _displayDialogPermission(BuildContext ctx) async {
    bool cameraPermission = await Permission.camera.status.isDenied;

    bool locationPermission = await Permission.location.status.isDenied;
    bool storagePermission = await Permission.photos.isDenied;

    if (await Permission.notification.isDenied) {
      await _dialogRequirePermissions(
        title: 'Berikan Akses Notifikasi',
        content:
            'Untuk menggunakan fitur yang membutuhkan notifikasi, kami memerlukan izin akses notifikasi Anda. Apakah Anda ingin memberikan izin akses sekarang?',
        no: () {
          Get.back();
        },
        yes: () async {
          await _initPermissionNotification();
          Get.back();
        },
        context: ctx,
      );
    } else if (await Permission.notification.isPermanentlyDenied) {
      await _dialogRequirePermissions(
        title: 'Berikan Akses Kamera',
        content:
            'Untuk menggunakan fitur yang membutuhkan kamera, kami memerlukan izin akses kamera Anda. Apakah Anda ingin memberikan izin akses sekarang?',
        no: () {
          Get.back();
        },
        yes: () async {
          await openAppSettings();
          Get.back();
        },
        context: ctx,
      );
    }

    // dialog akses kamera
    if (cameraPermission) {
      await _dialogRequirePermissions(
        title: 'Berikan Akses Kamera',
        content:
            'Untuk menggunakan fitur yang membutuhkan kamera, kami memerlukan izin akses kamera Anda. Apakah Anda ingin memberikan izin akses sekarang?',
        no: () {
          Get.back();
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
      await _dialogRequirePermissions(
        title: 'Berikan Akses Kamera',
        content:
            'Untuk menggunakan fitur yang membutuhkan kamera, kami memerlukan izin akses kamera Anda. Apakah Anda ingin memberikan izin akses sekarang?',
        no: () {
          Get.back();
        },
        yes: () async {
          await openAppSettings();
          Get.back();
        },
        context: ctx,
      );
    }

    // dialog akses lokasi
    if (locationPermission) {
      await _dialogRequirePermissions(
        title: 'Berikan Akses Lokasi',
        content:
            'Untuk menggunakan fitur yang membutuhkan lokasi, kami memerlukan izin akses lokasi Anda. Apakah Anda ingin memberikan izin akses sekarang?',
        no: () {
          Get.back();
        },
        yes: () async {
          await _initPermissionLocation();
          Get.back();
        },
        context: ctx,
      );
    } else if (await Permission.location.isPermanentlyDenied) {
      await _dialogRequirePermissions(
        title: 'Berikan Akses Lokasi',
        content:
            'Untuk menggunakan fitur yang membutuhkan lokasi, kami memerlukan izin akses lokasi Anda. Apakah Anda ingin memberikan izin akses sekarang?',
        no: () {
          Get.back();
        },
        yes: () async {
          await openAppSettings();
          Get.back();
        },
        context: ctx,
      );
    }

    // dialog akses Media
    // if (storagePermission) {
    //   await _dialogRequirePermissions(
    //     title: 'Berikan Akses Media',
    //     content:
    //         'Untuk menggunakan fitur yang membutuhkan akses media, kami memerlukan izin akses media Anda. Apakah Anda ingin memberikan izin akses sekarang?',
    //     no: () {
    //       Get.back();
    //     },
    //     yes: () async {
    //       await _initPermisionStorage();
    //       Get.back();
    //     },
    //     context: ctx,
    //   );
    // } else if (await Permission.photos.isPermanentlyDenied) {
    //   await _dialogRequirePermissions(
    //     title: 'Berikan Akses Media',
    //     content:
    //         'Untuk menggunakan fitur yang membutuhkan akses media, kami memerlukan izin akses media Anda. Apakah Anda ingin memberikan izin akses sekarang?',
    //     no: () {
    //       Get.back();
    //     },
    //     yes: () async {
    //       await openAppSettings();
    //       Get.back();
    //     },
    //     context: ctx,
    //   );
    // }
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
    }

    return false;
  }

  /// inisialisasi ijin akses storage
  Future<bool> _initPermisionStorage() async {
    // akses storage
    bool permissionStorage = await Permission.photos.isGranted;

    if (!permissionStorage) {
      PermissionStatus accessStorage = await Permission.photos.request();

      if (accessStorage.isGranted) {
        return true;
      }
    }

    return false;
  }

  /// inisialisasi ijin akses lokasi
  Future<bool> _initPermissionLocation() async {
    // akses storage
    bool permissionLocation = await Permission.location.status.isDenied;

    if (permissionLocation) {
      PermissionStatus accessLocation = await Permission.location.request();

      if (accessLocation.isGranted) {
        return true;
      }

      return false;
    }

    return false;
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
                'Ya',
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
}
