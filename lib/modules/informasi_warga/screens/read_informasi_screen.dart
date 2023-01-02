import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class ReadInformation extends StatelessWidget {
  ReadInformation({Key key}) : super(key: key);
  var argumentData = Get.arguments;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 800));

    return Scaffold(
      appBar: AppBar(
        title: Text('Informasi Warga'),
        titleTextStyle: TextStyle(fontSize: 19.sp),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                Html(
                  data: argumentData[0],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
