import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sizer/sizer.dart';
import 'package:lottie/lottie.dart';

Future showLoading(BuildContext context) {
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Loading',
            style: TextStyle(fontSize: 12.0.sp),
          ),
          insetPadding: EdgeInsets.all(10.0.h),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: SizedBox(
            width: 15.0.w,
            height: 15.0.h,
            child: Center(
                child: LottieBuilder.asset(
              'assets/animation/loading-plane.json',
              fit: BoxFit.cover,
              alignment: Alignment.center,
            )),
          ),
        );
      });
}
