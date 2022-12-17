import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HeaderLogo extends StatelessWidget {
  const HeaderLogo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 302.h,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30)),
          image: DecorationImage(
            image: AssetImage('assets/img/background-login-rw.png'),
            alignment: Alignment.center,
            fit: BoxFit.fill,
            repeat: ImageRepeat.noRepeat,
          )),
    );
  }
}
