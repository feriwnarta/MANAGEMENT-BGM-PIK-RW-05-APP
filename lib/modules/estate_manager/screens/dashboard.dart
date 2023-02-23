import 'package:aplikasi_rw/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/statistic_chart.dart';

class DashboardEm extends StatefulWidget {
  const DashboardEm({Key key}) : super(key: key);

  @override
  State<DashboardEm> createState() => _DashboardEmState();
}

class _DashboardEmState extends State<DashboardEm> {
  // final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 800));

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.width(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    title(),
                    SizedBox(
                      height: SizeConfig.height(20),
                    ),
                    CardLine(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      // endDrawer: drawerSideBar(),
      // Disable opening the end drawer with a swipe gesture.
      // endDrawerEnableOpenDragGesture: false,
    );
  }

  Drawer drawerSideBar() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  children: [
                    SizedBox(
                      height: 15.h,
                    ),
                    Text(
                      'as',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                )),
          ),
          ListTile(
            leading: Icon(
              Icons.person,
              color: Colors.grey,
            ),
            title: Text(
              'Buat akun',
              style: TextStyle(color: Colors.grey),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.person,
              color: Colors.grey,
            ),
            title: Text(
              'Laporan',
              style: TextStyle(color: Colors.grey),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.grey),
            title: Text(
              'Keluar',
              style: TextStyle(color: Colors.grey),
            ),
            onTap: () async {},
          ),
        ],
      ),
    );
  }

  Widget title() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: SizeConfig.height(16),
        ),
        Text(
          'Lacak, kelola, dan perkirakan pegawai dan laporan yang ada.',
          style: TextStyle(
            fontSize: SizeConfig.text(16),
            color: Color(0xff9E9E9E),
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 5,
        ),
      ],
    );
  }
}
