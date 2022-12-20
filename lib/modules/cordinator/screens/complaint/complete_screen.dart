import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../home_screen_cordinator.dart';

//ignore: must_be_immutable
class CompleteScreen extends StatelessWidget {
  CompleteScreen({Key key, this.time, this.name}) : super(key: key);

  String time, name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 104.22.h),
            SizedBox(
                width: 181.86.w,
                height: 199.76.h,
                child: SvgPicture.asset('assets/img/image-svg/pana.svg')),
            SizedBox(height: 32.02.h),
            Text(
              'Complaint berhasil diselesaikan',
              style: TextStyle(fontSize: 16.sp),
            ),
            SizedBox(height: 24.h),
            Text(
              'Waktu kerja : ',
              style: TextStyle(fontSize: 16.sp),
            ),
            SizedBox(height: 8.h),
            Text(
              time,
              style: TextStyle(fontSize: 32.sp),
            ),
            SizedBox(height: 211.h),
            SizedBox(
              width: 328.w,
              height: 40.h,
              child: TextButton(
                onPressed: () =>
                    // Navigator.of(context).pushReplacement(MaterialPageRoute(
                    //     builder: (context) => HomeScreenCordinator(
                    //           name: name,
                    //         )))
                    Get.offAll(HomeScreenCordinator(name: name)),
                style: TextButton.styleFrom(
                  backgroundColor: Color(0xff2094F3),
                ),
                child: Text(
                  'Kembali ke home',
                  style: TextStyle(fontSize: 16.sp, color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
