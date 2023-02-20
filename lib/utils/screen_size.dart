import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScreenSize {
  static void designSize(BuildContext context) {
    var size = Size(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
    ScreenUtil.init(context, designSize: size);
  }

  static double realWidth(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double pixelRatio = MediaQuery.of(context).devicePixelRatio;

    double screenWidth = screenSize.width * pixelRatio;

    return screenWidth;
  }

  static double realHeight(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double pixelRatio = MediaQuery.of(context).devicePixelRatio;

    double screenHeight = screenSize.height * pixelRatio;

    return screenHeight;
  }
}
