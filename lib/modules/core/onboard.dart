import 'package:aplikasi_rw/controller/user_login_controller.dart';
import 'package:aplikasi_rw/main.dart';
import 'package:aplikasi_rw/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../authentication/screens/login_screen.dart';
import '../authentication/widgets/onboarding_screen.dart';
import '../maintenance/screens/maintenance_screen.dart';

class OnBoard extends StatefulWidget {
  @override
  _OnBoardState createState() => _OnBoardState();
}

class _OnBoardState extends State<OnBoard> {
  final UserLoginController _loginController = Get.put(UserLoginController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return (_loginController.statusConnection.value == 'offline')
          ? NoConnetion()
          : (_loginController.statusServer.value == 'normal')
              ? _loginController.otpWhenExit.value == true
                  ? LoginScreen(
                      email: _loginController.email.value,
                      noTelp: _loginController.noTelp.value,
                      controllerIpl: TextEditingController(
                          text: _loginController.noIpl.value),
                    )
                  : (!_loginController.status.value
                          .isCaseInsensitiveContainsAny('logout'))
                      ? MainApp()
                      : OnboardingScreen()
              : MaintenanceScreen();
    });
  }

  Future buildShowDialogAnimation(String title, String btnMessage,
      String urlAsset, double size, BuildContext context) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              title,
              style: TextStyle(fontSize: 12.0.sp),
            ),
            insetPadding: EdgeInsets.all(10.0.h),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            content: SizedBox(
              width: size.w,
              height: size.h,
              child: LottieBuilder.asset(urlAsset),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(btnMessage),
                onPressed: () {},
              ),
            ],
          );
        });
  }
}

class NoConnetion extends StatefulWidget {
  const NoConnetion({
    Key key,
  }) : super(key: key);

  @override
  _NoConnetionState createState() => _NoConnetionState();
}

class _NoConnetionState extends State<NoConnetion> {
  @override
  initState() {
    super.initState();
    SchedulerBinding.instance
        .addPostFrameCallback((_) => showAlertDialog(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                child:
                    LottieBuilder.asset('assets/animation/loading-bgm.json')),
          ],
        ));
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    // Widget okButton = TextButton(
    //   child: Text("OK"),
    //   onPressed: () {},
    // );

    Widget retryButton = TextButton(
      child: Text("RETRY"),
      onPressed: () {
        Navigator.of(context).pop();
        Get.offAllNamed(RouteName.home);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "No Internet",
        style: TextStyle(fontSize: 16.sp),
      ),
      content: Text(
        "Please Check Internet Connection",
        style: TextStyle(fontSize: 12.sp),
      ),
      actions: [retryButton],
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
