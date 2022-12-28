import 'package:aplikasi_rw/modules/home/widgets/menu.dart';
import 'package:aplikasi_rw/modules/report_screen/screens/sub_menu_report.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../widgets/header_screen.dart';

class CitizenScreen extends StatefulWidget {
  const CitizenScreen({Key key}) : super(key: key);

  @override
  State<CitizenScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<CitizenScreen> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 800));

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              HeaderScreen(),
              SizedBox(
                height: 24.h,
              ),
              Divider(
                thickness: 1,
              ),
              SizedBox(
                height: 24.h,
              ),
              Container(
                height: 236.h,
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Menu(
                          icon: 'assets/img/citizen_menu/ipl.jpg',
                          text: 'Peduli lingkungan',
                          onTap: () => Get.to(() => SubMenuReport()),
                        ),
                        SizedBox(
                          width: 14.w,
                        ),
                        Menu(
                          icon:
                              'assets/img/citizen_menu/status-peduli-lingkungan.jpg',
                          text: 'Peduli lingkungan',
                          onTap: () {},
                        ),
                        SizedBox(
                          width: 14.w,
                        ),
                        Menu(
                          icon: 'assets/img/citizen_menu/ipl.jpg',
                          text: 'Status IPL\n',
                          onTap: () {},
                        ),
                        SizedBox(
                          width: 14.w,
                        ),
                        Menu(
                          icon: 'assets/img/citizen_menu/informasi-warga.jpg',
                          text: 'Informasi Warga',
                          onTap: () {},
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    Row(
                      children: [
                        Menu(
                          icon: 'assets/img/citizen_menu/informasi-umum.jpg',
                          text: 'Informasi Umum',
                          onTap: () {},
                        ),
                        SizedBox(
                          width: 14.w,
                        ),
                        Menu(
                          icon: 'assets/img/citizen_menu/media.jpg',
                          text: 'Informasi Umum',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 70.h,
              )
            ],
          ),
        ),
      ),
    );
  }
}
