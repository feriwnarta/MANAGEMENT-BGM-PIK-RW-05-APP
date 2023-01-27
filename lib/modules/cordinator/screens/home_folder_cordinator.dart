import 'package:aplikasi_rw/modules/authentication/controllers/access_controller.dart';
import 'package:aplikasi_rw/modules/contractor/screens/dashboard_cordinator_screen.dart';
import 'package:aplikasi_rw/modules/home/widgets/header_screen.dart';
import 'package:aplikasi_rw/modules/report_screen/screens/sub_menu_report.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../home/widgets/menu.dart';

class MenuFolderCordinator extends StatefulWidget {
  const MenuFolderCordinator({Key key}) : super(key: key);

  @override
  State<MenuFolderCordinator> createState() =>
      _CordinatorHomeFolderScreenState();
}

class _CordinatorHomeFolderScreenState extends State<MenuFolderCordinator> {
  final accessController = Get.find<AccessController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Obx(
              () => Column(
                children: [
                  HeaderScreen(
                    isEmOrCord: true,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            (accessController.dashboardCord.value)
                                ? Menu(
                                    icon:
                                        'assets/img/estate_manager_menu/dashboard-em.jpg',
                                    onTap: () {
                                      Get.to(
                                        () => DashboardCordinator(),
                                        transition: Transition.rightToLeft,
                                      );
                                    },
                                    text: 'Dashboard',
                                  )
                                : Menu(
                                    icon:
                                        'assets/img/estate_manager_menu/dashboard-em.jpg',
                                    onTap: () {
                                      EasyLoading.showInfo(
                                          'Fitur ini hanya bisa diakses oleh contractor',
                                          dismissOnTap: true);
                                    },
                                    text: 'Dashboard',
                                  ),
                            SizedBox(
                              width: 16.w,
                            ),
                            (accessController.statusPeduliLingkunganCord.value)
                                ? Menu(
                                    icon:
                                        'assets/img/estate_manager_menu/status_peduli_lingkungan.jpg',
                                    onTap: () {
                                      Get.to(
                                        () => SubMenuReport(
                                          typeStatusPeduliLingkungan: 'cord',
                                        ),
                                        transition: Transition.cupertino,
                                      );
                                    },
                                    text: 'Status Peduli Lingkungan',
                                  )
                                : Menu(
                                    icon:
                                        'assets/img/estate_manager_menu/status_peduli_lingkungan.jpg',
                                    onTap: () {
                                      EasyLoading.showInfo(
                                          'Fitur ini hanya bisa diakses oleh contractor',
                                          dismissOnTap: true);
                                    },
                                    text: 'Status Peduli Lingkungan',
                                  ),
                            SizedBox(
                              width: 16.w,
                            ),
                            (accessController.absensiCord.value)
                                ? Menu(
                                    icon:
                                        'assets/img/estate_manager_menu/absensi_cord.jpg',
                                    onTap: () {
                                      EasyLoading.showInfo(
                                        'Fitur ini sedang dalam pengembangan',
                                      );
                                    },
                                    text: 'Absensi',
                                  )
                                : Menu(
                                    icon:
                                        'assets/img/estate_manager_menu/absensi_cord.jpg',
                                    onTap: () {
                                      EasyLoading.showInfo(
                                        'Fitur ini sedang dalam pengembangan',
                                      );
                                    },
                                    text: 'Absensi',
                                  ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
