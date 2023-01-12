import 'dart:async';

import 'package:aplikasi_rw/modules/home/controller/notification_controller.dart';
import 'package:aplikasi_rw/modules/home/screens/notification_screen.dart';
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
    controller.timer = Timer.periodic(
      Duration(seconds: 1),
      (_) {
        controller.getCountNotif();
      },
    ).obs;
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
    ScreenUtil.init(context, designSize: const Size(360, 800));
    return Container(
      width: 328.w,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          AutoSizeText(
            'BGM RW 05',
            style: TextStyle(
              fontSize: 19.sp,
              fontWeight: FontWeight.w500,
              color: Color(0xff2094F3),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(
            width: 38.w,
          ),
          Image(
            width: 34.w,
            height: 40.h,
            image: image,
            fit: BoxFit.cover,
            repeat: ImageRepeat.noRepeat,
          ),
          SizedBox(
            width: 127.w,
          ),
          Obx(
            () => InkWell(
              splashColor: Colors.white,
              borderRadius: BorderRadius.circular(200),
              radius: 15.h,
              onTap: () {
                Get.to(
                  () => NotificationScreen(),
                  transition: Transition.rightToLeft,
                );
              },
              child: Badge(
                badgeColor: Colors.red,
                // showBadge: () ? true : false,
                badgeContent: Text(
                  '${controller.count.value}',
                  style: TextStyle(color: Colors.white),
                ),
                position: BadgePosition.topEnd(top: -15, end: -10),
                child: SvgPicture.asset(
                  'assets/img/image-svg/bell.svg',
                  color: Color(0xff404040),
                ),
                animationType: BadgeAnimationType.scale,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
