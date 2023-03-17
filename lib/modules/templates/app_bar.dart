import 'dart:async';

import 'package:aplikasi_rw/modules/home/controller/notification_controller.dart';
import 'package:aplikasi_rw/modules/home/screens/notification_screen.dart';
import 'package:aplikasi_rw/utils/size_config.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class RwAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  State<RwAppBar> createState() => _RwAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _RwAppBarState extends State<RwAppBar> {
  NotificationController controller = Get.put(NotificationController());

  final AssetImage image = AssetImage('assets/img/logo_rw.png');

  @override
  void initState() {
    super.initState();

    controller.timer.value = Timer.periodic(
      Duration(seconds: 5),
      (_) {
        controller.getCountNotif();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(
        color: Color(0xff2094F3),
      ),
      leadingWidth: SizeConfig.width(200),
      leading: Row(
        children: [
          SizedBox(
            width: SizeConfig.width(16),
          ),
          Text(
            'BGM RW 05',
            style: TextStyle(
              fontSize: SizeConfig.text(19),
              color: Colors.blue,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
      title: Image(
        width: SizeConfig.width(34),
        height: SizeConfig.height(40),
        image: image,
        fit: BoxFit.cover,
        repeat: ImageRepeat.noRepeat,
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: EdgeInsets.only(right: SizeConfig.width(24)),
          child: Obx(
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
                showBadge: (controller.count.value == '0') ? false : true,
                badgeContent: Text(
                  '${controller.count.value}',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: (11 / SizeConfig.textMultiplier) *
                          SizeConfig.textMultiplier),
                ),
                position: BadgePosition.topEnd(top: 8, end: -8),
                child: SvgPicture.asset(
                  'assets/img/image-svg/bell.svg',
                  color: Color(0xff404040),
                ),
                animationType: BadgeAnimationType.fade,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
