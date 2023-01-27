import 'dart:convert';
import 'package:aplikasi_rw/controller/user_login_controller.dart';
import 'package:aplikasi_rw/modules/authentication/controllers/access_controller.dart';
import 'package:aplikasi_rw/server-app.dart';
import 'package:aplikasi_rw/utils/UserSecureStorage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

import '../../core/onboard.dart';

class SplashView extends StatefulWidget {
  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final _loginController = Get.find<UserLoginController>();
  final _accessController = Get.put(AccessController());
  Future _future;

  @override
  initState() {
    super.initState();
    _future = initializeSettings();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
              color: Colors.white,
              child: LottieBuilder.asset('assets/animation/loading-bgm.json'));
        } else {
          if (snapshot.hasError) {
            return Scaffold(
              body: Container(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LottieBuilder.asset('assets/animation/error-dialog.json'),
                    Text(
                      'something is wrong, please exit the app, and open again',
                      style: TextStyle(fontSize: 12.sp),
                    )
                  ],
                ),
              ),
            );
          } else {
            return OnBoard();
          }
        }
      },
    );
  }

  Future<void> initializeSettings() async {
    await checkConnectivity();
  }

  Future<String> checkLoginActive() async {
    // cek device info
    var deviceInfoPlugin = DeviceInfoPlugin();
    var deviceName;
    // var deviceVersion;
    var identifier;

    if (Platform.isAndroid) {
      var build = await deviceInfoPlugin.androidInfo;
      deviceName = build.model;
      // deviceVersion = build.version.toString();
      identifier = build.id; //UUID for Android
    } else if (Platform.isIOS) {
      var data = await deviceInfoPlugin.iosInfo;
      deviceName = data.name;
      // deviceVersion = data.systemVersion;
      identifier = data.identifierForVendor; //UUID for iOS
    }

    String idUser = await UserSecureStorage.getIdUser();
    final logger = Logger();
    logger.e(idUser);

    if (idUser != null) {
      String url =
          '${ServerApp.url}/src/login/credentials/check_login_active.php';

      var data = {
        "id_user": idUser,
        "device_name": deviceName,
        "device_identifier": identifier
      };

      logger.w(data);
      var response = await http.post(Uri.parse(url), body: jsonEncode(data));

      if (response.statusCode >= 200 && response.statusCode <= 399) {
        var message = jsonDecode(response.body);

        final logger = Logger();
        logger.d(message);
        if (message == 'FAILL') {
          logger.e(message);
          return 'FAILL';
        } else {
          return 'OKE';
        }
      }
    }

    return 'NOT LOGIN';
  }

  Future<void> checkConnectivity() async {
    try {
      final logger = Logger();
      var checkConnection = await InternetAddress.lookup('${ServerApp.ip}');
      logger.i(checkConnection);

      if (checkConnection.isNotEmpty &&
          checkConnection[0].rawAddress.isNotEmpty) {
        var connection = await (Connectivity().checkConnectivity());
        final logger = Logger();

        logger.d(connection);

        if (connection == ConnectivityResult.none) {
          await _loginController.noConnection();
        } else {
          String status = await UserSecureStorage.getStatus();
          String message = 'OKE';
          final logger = Logger();
          if (message.isCaseInsensitiveContainsAny('OKE') ||
              message.isCaseInsensitiveContainsAny('RELOG')) {
            logger.e(status);
            _loginController.connect();
            await checkOtpWhenExit();
            await _loginController.checkLogin();
            checkAccess();
            await checkMaintenance();
          } else if (message.isCaseInsensitiveContainsAny('FAILL')) {
            _loginController.logout();
            Get.snackbar('message', 'your account has been logged out');
          } else {}
        }
      } else {
        await _loginController.noConnection();
      }
    } on SocketException catch (_) {
      await _loginController.noConnection();
    }
  }

  Future<void> checkOtpWhenExit() async {
    final storage = FlutterSecureStorage();
    String status = await storage.read(key: 'successotp');

    if (status != null) {
      if (status.isCaseInsensitiveContainsAny('false')) {
        String noIpl = await storage.read(key: 'noipl');
        String email = await storage.read(key: 'email');
        String noTelp = await storage.read(key: 'notelp');
        _loginController.otpWhenExit = true.obs;
        _loginController.email = email.obs;
        _loginController.noIpl = noIpl.obs;
        _loginController.noTelp = noTelp.obs;
        final logger = Logger();
        logger.e(_loginController.email.value);
      }
    } else {
      // _loginController.resetOtpWhenExit();
      _loginController.otpWhenExit = false.obs;
      _loginController.update();
    }
  }

  Future<void> checkMaintenance() async {
    await _loginController.checkServer();
  }

  Future<void> checkAccess() async {
    String idUser = await UserSecureStorage.getIdUser();
    if (idUser != null) {
      String url = '${ServerApp.url}src/login/credentials/check_access.php';

      var data = {'id_user': idUser};

      var response = await http.post(Uri.parse(url), body: jsonEncode(data));
      if (response.statusCode >= 200 && response.statusCode <= 399) {
        var message = jsonDecode(response.body);
        final logger = Logger();
        logger.e(idUser);
        if (message.toString() != 'E001' && message.toString() != 'E002') {
          logger.i(message[0]['warga']);
          if (message[0]['warga'] == '1') {
            _accessController.accessAsCitizen();
          }

          if (message[0]['cordinator'] == '1') {
            _accessController.accessAsCordinator();
          }

          if (message[0]['otp'] == '1') {
            // _loginController.enabledOtp = true.obs;
          } else {
            // _loginController.enabledOtp = false.obs;
          }

          if (message[0]['management'] == '1') {
            _accessController.accessAsPengelola();
            // _loginController.accessManagement = true.obs;
          }

          if (message[0]['manager_kontraktor'] == '1') {
            _accessController.accessManagerCon();
          }

          if (message[0]['estate_manager'] == '1') {
            _accessController.accessAsEm();
          }

          if (message[0]['kepala_contractor'] == '1') {
            _accessController.accessAsKepalaContractor();
          }

          logger.i(_accessController.statistikPeduliLindungi.value);
        } else {
          //error
        }
      }
    }
  }
}
