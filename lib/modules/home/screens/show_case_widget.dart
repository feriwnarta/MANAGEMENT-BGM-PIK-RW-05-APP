import 'package:aplikasi_rw/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

class ShowCaseWrapper extends StatelessWidget {
  ShowCaseWrapper(
      {Key key, this.gKey, this.title, this.description, this.child})
      : super(key: key);

  final GlobalKey gKey;
  final String title, description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Showcase(
      key: gKey,
      showArrow: true,
      title: title,
      description: description,
      titleTextStyle:
          TextStyle(fontSize: SizeConfig.text(14), fontWeight: FontWeight.w400),
      descTextStyle: TextStyle(fontSize: SizeConfig.text(12)),
      titleAlignment: TextAlign.start,
      disableMovingAnimation: true,
      child: child,
    );
  }
}
