import 'package:aplikasi_rw/modules/authentication/controllers/access_controller.dart';
import 'package:aplikasi_rw/modules/contractor/screens/dashboard_cordinator_screen.dart';
import 'package:aplikasi_rw/modules/home/widgets/header_screen.dart';
import 'package:aplikasi_rw/modules/report_screen/screens/sub_menu_report.dart';
import 'package:aplikasi_rw/modules/templates/app_bar.dart';
import 'package:aplikasi_rw/modules/util_widgets/init_permission.dart';
import 'package:aplikasi_rw/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../home/widgets/menu.dart';

class MenuFolderCordinator extends StatefulWidget {
  const MenuFolderCordinator({Key key}) : super(key: key);

  @override
  State<MenuFolderCordinator> createState() =>
      _CordinatorHomeFolderScreenState();
}

class _CordinatorHomeFolderScreenState extends State<MenuFolderCordinator> {
  final accessController = Get.find<AccessController>();

  InitPermissionApp initPermissionApp;

  @override
  void initState() {
    super.initState();

    initPermissionApp = InitPermissionApp();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) async => await initPermissionApp.initPermissionApp(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RwAppBar(),
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
                    margin:
                        EdgeInsets.symmetric(horizontal: SizeConfig.width(16)),
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
                                          'Fitur ini hanya bisa diakses oleh estate cordinator',
                                          dismissOnTap: true);
                                    },
                                    text: 'Dashboard',
                                  ),
                            SizedBox(
                              width: SizeConfig.width(16),
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
                                          'Fitur ini hanya bisa diakses oleh estate cordinator',
                                          dismissOnTap: true);
                                    },
                                    text: 'Status Peduli Lingkungan',
                                  ),
                            SizedBox(width: SizeConfig.width(16)),
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
