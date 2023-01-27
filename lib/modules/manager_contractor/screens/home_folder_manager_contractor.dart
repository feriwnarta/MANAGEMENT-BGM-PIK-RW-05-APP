import 'package:aplikasi_rw/modules/authentication/controllers/access_controller.dart';
import 'package:aplikasi_rw/modules/contractor/screens/dashboard_cordinator_screen.dart';
import 'package:aplikasi_rw/modules/home/widgets/header_screen.dart';
import 'package:aplikasi_rw/modules/report_screen/screens/sub_menu_report.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../home/widgets/menu.dart';

class MenuFolderManagerContractor extends StatefulWidget {
  const MenuFolderManagerContractor({Key key}) : super(key: key);

  @override
  State<MenuFolderManagerContractor> createState() =>
      _CordinatorHomeFolderScreenState();
}

class _CordinatorHomeFolderScreenState
    extends State<MenuFolderManagerContractor> {
  final accessController = Get.find<AccessController>();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 800));
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
                            (accessController.dashboardManagerCon.value)
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
                                          'Fitur ini hanya bisa diakses oleh Manager Kontraktor',
                                          dismissOnTap: true);
                                    },
                                    text: 'Dashboard',
                                  ),
                            SizedBox(
                              width: 16.w,
                            ),
                            (accessController
                                    .statusPeduliLingkunganManagerCord.value)
                                ? Menu(
                                    icon:
                                        'assets/img/estate_manager_menu/status_peduli_lingkungan.jpg',
                                    onTap: () {
                                      Get.to(
                                        () => SubMenuReport(
                                          typeStatusPeduliLingkungan:
                                              'managercon',
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
                                          'Fitur ini hanya bisa diakses oleh Manager Kontraktor',
                                          dismissOnTap: true);
                                    },
                                    text: 'Status Peduli Lingkungan',
                                  ),
                            SizedBox(
                              width: 16.w,
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
