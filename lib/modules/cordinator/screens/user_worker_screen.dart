import 'package:aplikasi_rw/controller/user_login_controller.dart';
import 'package:aplikasi_rw/routes/app_routes.dart';
import 'package:aplikasi_rw/utils/UserSecureStorage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserWorker extends StatefulWidget {
  const UserWorker({Key key}) : super(key: key);

  @override
  State<UserWorker> createState() => _UserWorkerState();
}

class _UserWorkerState extends State<UserWorker> {
  final controller = Get.put(UserLoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Settings'),
      ),
      body: Column(
        children: [
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
