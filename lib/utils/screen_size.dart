import 'package:flutter/material.dart';

class ScreenSize {
  static Size designSize(BuildContext context) {
    return Size(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
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
