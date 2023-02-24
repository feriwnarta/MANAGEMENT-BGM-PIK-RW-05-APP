import 'package:aplikasi_rw/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

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
            SizedBox(height: SizeConfig.height(104)),
            SizedBox(
                width: SizeConfig.width(181),
                height: SizeConfig.height(199),
                child: SvgPicture.asset('assets/img/image-svg/pana.svg')),
            SizedBox(height: SizeConfig.height(32)),
            Text(
              'Complaint berhasil diselesaikan',
              style: TextStyle(
                fontSize: SizeConfig.text(16),
              ),
            ),
            SizedBox(height: SizeConfig.height(24)),
            Text(
              'Waktu kerja : ',
              style: TextStyle(
                fontSize: SizeConfig.text(16),
              ),
            ),
            SizedBox(height: SizeConfig.height(8)),
            Text(
              time,
              style: TextStyle(fontSize: SizeConfig.text(32)),
            ),
            SizedBox(height: SizeConfig.height(211)),
            SizedBox(
              width: SizeConfig.width(328),
              height: SizeConfig.height(40),
              child: TextButton(
                onPressed: () {
                  Get.back();
                },
                style: TextButton.styleFrom(
                  backgroundColor: Color(0xff2094F3),
                ),
                child: Text(
                  'Kembali ke home',
                  style: TextStyle(
                      fontSize: SizeConfig.text(16), color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
