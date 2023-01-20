import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    title(),
                    SizedBox(
                      height: 20.h,
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
          height: 16.h,
        ),
        AutoSizeText(
          'Lacak, kelola, dan perkirakan pegawai dan laporan yang ada.',
          style: TextStyle(
            fontSize: 16.sp,
            color: Color(0xff9E9E9E),
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 5,
        ),
      ],
    );
  }
}
