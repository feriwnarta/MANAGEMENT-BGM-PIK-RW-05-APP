import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MaintenanceScreen extends StatelessWidget {
  const MaintenanceScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LottieBuilder.asset(
                'assets/animation/maintenance.json',
                width: 200.w,
              ),
              Text(
                'Server is under maintenance',
                style: TextStyle(color: Colors.blue, fontSize: 16.sp),
              )
            ],
          ),
        ),
      ),
    );
  }
}
