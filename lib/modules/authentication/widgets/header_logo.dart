import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HeaderLogo extends StatefulWidget {
  const HeaderLogo({
    Key key,
  }) : super(key: key);

  @override
  State<HeaderLogo> createState() => _HeaderLogoState();
}

class _HeaderLogoState extends State<HeaderLogo> {
  AssetImage image = AssetImage('assets/img/background-login-rw.png');

  @override
  void didChangeDependencies() {
    precacheImage(image, context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 800));
    return Container(
      height: 302.h,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30)),
          image: DecorationImage(
            image: image,
            alignment: Alignment.center,
            fit: BoxFit.fill,
            repeat: ImageRepeat.noRepeat,
          )),
    );
  }
}
