import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';

class SizeConfig {
  static double _screenWidth;
  static double _screenHeight;
  static double _blockWidth = 0;
  static double _blockHeight = 0;

  static double textMultiplier;
  static double imageSizeMultiplier;
  static double heightMultiplier;
  static double widthMultiplier;
  static bool isPortrait = true;
  static bool isMobilePortrait = false;

  static double slicingHeight = 8.12;
  static double slicingWidth = 3.75;
  static double slicingImage = 3.75;
  static double slicingText = 8.12;

  static double width(double val) {
    return (val / slicingWidth) * widthMultiplier;
  }

  static double height(double val) {
    return (val / slicingHeight) * heightMultiplier;
  }

  static double text(double val) {
    return (val / slicingText) * textMultiplier;
  }

  static double image(double val) {
    return (val / slicingImage) * imageSizeMultiplier;
  }

  final logger = Logger();

  void init(BoxConstraints constraints, Orientation orientation) {
    if (orientation == Orientation.portrait) {
      _screenWidth = constraints.maxWidth;
      _screenHeight = constraints.maxHeight;
      isPortrait = true;
      if (_screenWidth < 450) {
        isMobilePortrait = true;
      }
    } else {
      _screenWidth = constraints.maxHeight;
      _screenHeight = constraints.maxWidth;
      isPortrait = false;
      isMobilePortrait = false;
    }

    _blockWidth = _screenWidth / 100;
    _blockHeight = _screenHeight / 100;

    textMultiplier = _blockHeight;
    imageSizeMultiplier = _blockWidth;
    heightMultiplier = _blockHeight;
    widthMultiplier = _blockWidth;

    logger.i(
      'width = $widthMultiplier \nheight = $heightMultiplier \ntext = $textMultiplier \nimage = $imageSizeMultiplier',
    );
  }
}
