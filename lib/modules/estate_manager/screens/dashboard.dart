import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/app_bar.dart';
import '../widgets/card_line.dart';

class DashboardEm extends StatefulWidget {
  const DashboardEm({Key key}) : super(key: key);

  @override
  State<DashboardEm> createState() => _DashboardEmState();
}

class _DashboardEmState extends State<DashboardEm> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 800));
    print('render');
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBarEm(),
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
    );
  }

  Widget title() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selamat datang, Danu',
          style: TextStyle(
            fontSize: 23.sp,
          ),
        ),
        SizedBox(
          height: 4.h,
        ),
        Text(
          'Lacak, kelola, dan perkirakan pegawai dan laporan yang ada.',
          style: TextStyle(fontSize: 16.sp, color: Color(0xff9E9E9E)),
        ),
      ],
    );
  }
}
