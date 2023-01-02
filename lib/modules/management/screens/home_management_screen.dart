import 'package:aplikasi_rw/controller/user_login_controller.dart';
import 'package:aplikasi_rw/main.dart';
import 'package:aplikasi_rw/routes/app_routes.dart';
import 'package:aplikasi_rw/utils/UserSecureStorage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../server-app.dart';
import '../../users/screens/change_data_user.dart';

class HomeManagementScreen extends StatelessWidget {
  HomeManagementScreen({Key key}) : super(key: key);

  final controller = Get.put(UserLoginController());
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      endDrawer: drawerSideBar(context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Header(scaffoldKey: scaffoldKey),
              // DashboardStatistic(),
            ],
          ),
        ),
      ),
    );
  }

  Drawer drawerSideBar(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Align(
              alignment: Alignment.topLeft,
              child: Obx(() {
                print('DRAWERRR :::${controller.username}');
                return Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: CachedNetworkImageProvider(
                          '${ServerApp.url}${controller.urlProfile.value}'),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Text(
                        '${controller.username.value}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.person,
              color: Colors.grey,
            ),
            title: Text(
              'Profile',
              style: TextStyle(color: Colors.grey),
            ),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                builder: (context) => ChangeDataUser(),
              ))
                  .then((value) {
                if (value == 'refresh') {
                  controller.update();
                }
              });
            },
          ),
          Obx(
            () => Visibility(
              visible: controller.accessManagement.value,
              child: ListTile(
                leading: Icon(
                  Icons.compare_arrows_rounded,
                  color: Colors.grey,
                ),
                title: Text(
                  'Warga',
                  style: TextStyle(color: Colors.grey),
                ),
                onTap: () {
                  Get.offAll(MainApp());
                },
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.grey),
            title: Text(
              'Log Out',
              style: TextStyle(color: Colors.grey),
            ),
            onTap: () async {
              await UserSecureStorage.deleteIdUser();
              await UserSecureStorage.deleteStatus();
              controller.logout();
              Get.offAllNamed(RouteName.home);
            },
          ),
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    Key key,
    @required this.scaffoldKey,
  }) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'BGM RW O5',
            style: TextStyle(fontSize: 19.sp, color: Color(0xff485E88)),
          ),
          Padding(
            padding: EdgeInsets.only(right: 50.w),
            child: Image(
              width: 34.w,
              height: 40.h,
              image: AssetImage('assets/img/logo_rw.png'),
              fit: BoxFit.cover,
              repeat: ImageRepeat.noRepeat,
            ),
          ),
          IconButton(
              icon: SvgPicture.asset('assets/img/image-svg/hamburger-menu.svg'),
              onPressed: () {
                scaffoldKey.currentState.openEndDrawer();
              }),
        ],
      ),
    );
  }
}
