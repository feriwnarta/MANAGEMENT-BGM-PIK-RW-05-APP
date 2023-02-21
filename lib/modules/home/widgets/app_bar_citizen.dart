import 'dart:async';

import 'package:aplikasi_rw/modules/home/controller/notification_controller.dart';
import 'package:aplikasi_rw/modules/home/screens/notification_screen.dart';
import 'package:aplikasi_rw/modules/theme/sizer.dart';
import 'package:aplikasi_rw/utils/screen_size.dart';
import 'package:aplikasi_rw/utils/size_config.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:badges/badges.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class AppBarCitizen extends StatefulWidget {
  const AppBarCitizen({Key key}) : super(key: key);

  @override
  State<AppBarCitizen> createState() => _AppBarCitizenState();
}

class _AppBarCitizenState extends State<AppBarCitizen> {
  final AssetImage image = AssetImage('assets/img/logo_rw.png');
  NotificationController controller = Get.put(NotificationController());

  @override
  void initState() {
    controller.timer.value = Timer.periodic(
      Duration(seconds: 5),
      (_) {
        controller.getCountNotif();
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    if (controller.timer.value != null && controller.timer.value.isActive) {
      controller.timer.value.cancel();
    }
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    precacheImage(image, context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: Size(360, 800),
      minTextAdapt: false,
    );
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Sizer.gapHorizontal16),
      child: Row(
        children: [
          AutoSizeText(
            'BGM RW 05',
            style: TextStyle(
              fontSize: (19 / Sizer.designText) * SizeConfig.textMultiplier,
              fontWeight: FontWeight.w500,
              color: Color(0xff2094F3),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Spacer(flex: 1),
          Image(
            width:
                (34 / SizeConfig.widthMultiplier) * SizeConfig.widthMultiplier,
            image: image,
            fit: BoxFit.cover,
            repeat: ImageRepeat.noRepeat,
          ),
          Spacer(flex: 3),
          Obx(
            () => InkWell(
              splashColor: Colors.white,
              borderRadius: BorderRadius.circular(200),
              radius: (15 / SizeConfig.heightMultiplier) *
                  SizeConfig.heightMultiplier,
              onTap: () {
                Get.to(
                  () => NotificationScreen(),
                  transition: Transition.rightToLeft,
                );
              },
              child: Badge(
                badgeColor: Colors.red,
                padding: EdgeInsets.all(3),
                badgeContent: Text(
                  '${controller.count.value}',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: (11 / SizeConfig.textMultiplier) *
                          SizeConfig.textMultiplier),
                ),
                position: BadgePosition.topEnd(top: -10, end: -10),
                child: SvgPicture.asset(
                  'assets/img/image-svg/bell.svg',
                  color: Color(0xff404040),
                ),
                animationType: BadgeAnimationType.fade,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
