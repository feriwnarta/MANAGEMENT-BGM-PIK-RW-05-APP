import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

import '../services/chart_line_services.dart';
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
                    CardLine(widget: button()),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget button() {
    return Column(children: [
      Row(
        children: [
          buttonSelectDate(),
          SizedBox(
            width: 12.w,
          ),
          buttonFiter(),
        ],
      ),
      SizedBox(
        height: 16.h,
      ),
    ]);
  }

  SizedBox buttonFiter() {
    return SizedBox(
      width: 92.w,
      child: OutlinedButton.icon(
          onPressed: () {},
          icon: SvgPicture.asset('assets/img/image-svg/filter.svg'),
          style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              )),
          label: Text(
            'Filter',
            style: TextStyle(fontSize: 14.sp),
          )),
    );
  }

  SizedBox buttonSelectDate() {
    return SizedBox(
      width: 142.w,
      child: OutlinedButton.icon(
          onPressed: () {},
          icon: SvgPicture.asset('assets/img/image-svg/pilih-tanggal.svg'),
          style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              )),
          label: Text(
            'Pilih tanggal',
            style: TextStyle(fontSize: 14.sp),
          )),
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
