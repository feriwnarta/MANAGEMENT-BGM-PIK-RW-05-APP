import 'package:aplikasi_rw/controller/user_login_controller.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/instance_manager.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

import '../../../services/chart_worker/get_chart_worker.dart';
import '../../../services/chart_worker/get_pie_chart_worker.dart';
import '../../../services/chart_worker/total_manpower_services.dart';
import '../../../services/chart_worker/update_chart_worker.dart';
import 'home_screen_cordinator.dart';

class DashboardCordinator extends StatefulWidget {
  const DashboardCordinator({Key key}) : super(key: key);

  @override
  State<DashboardCordinator> createState() => _DashboardCordinatorState();
}

class _DashboardCordinatorState extends State<DashboardCordinator> {
  final loginController = Get.find<UserLoginController>();

  Future future;

  @override
  void initState() {
    future = GetChartWorkerServices.getChart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard',
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 20.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoSizeText(
                loginController.name.value,
                style: TextStyle(
                  fontSize: 19.sp,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: 4.h,
              ),
              AutoSizeText(
                'Sudahkah cek laporan hari ini ?',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff616161),
                ),
              ),
              SizedBox(
                height: 32.h,
              ),
              FutureBuilder<Map<String, dynamic>>(
                future: future,
                builder: (context, snapshot) => (snapshot.hasData)
                    ? (snapshot.data != null)
                        ? lineChart(snapshot)
                        : Text(
                            'Fitur ini hanya khusus untuk estate cordinator',
                          )
                    : Shimmer.fromColors(
                        child: Container(
                          height: 173.h,
                          width: 328.w,
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        baseColor: Colors.grey[300],
                        highlightColor: Colors.grey[200]),
              ),
              FutureBuilder<Map<String, dynamic>>(
                // future: widget.futurePieChart,
                future: PieChartServices.getPie(),
                builder: (context, snapshot) =>
                    (snapshot.connectionState == ConnectionState.done)
                        ? pieChart(snapshot)
                        : Shimmer.fromColors(
                            child: Container(
                              height: 173.h,
                              width: 328.w,
                              margin: EdgeInsets.only(top: 5),
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            baseColor: Colors.grey[300],
                            highlightColor: Colors.grey[200],
                          ),
              ),
              FutureBuilder(
                future: TotalManPowerServices.getManPower(),
                // future: widget.futureBarChart,
                builder: (context, snapshot) =>
                    (snapshot.connectionState == ConnectionState.done)
                        ? (snapshot.data != null)
                            ? barChart(snapshot)
                            : SizedBox()
                        : Shimmer.fromColors(
                            child: Container(
                              height: 349.h,
                              width: 328.w,
                              margin: EdgeInsets.only(top: 5),
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            baseColor: Colors.grey[300],
                            highlightColor: Colors.grey[200],
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Card lineChart(AsyncSnapshot<Map<String, dynamic>> snapshot) {
    return Card(
        elevation: 3,
        shadowColor: Colors.grey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 8.w),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),
                  AutoSizeText(
                    '${snapshot.data['title']}',
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: Color(0xff757575),
                    ),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            // Initial Value
                            value: '${snapshot.data['subtitle']}',
                            isDense: true,
                            underline: null,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500),
                            // Down Arrow Icon
                            icon: const Icon(Icons.keyboard_arrow_down),
                            // Array list of items
                            items: snapshot.data['data_dropdown']
                                .map<DropdownMenuItem<String>>((data) =>
                                    DropdownMenuItem(
                                      value: data['name_category'].toString(),
                                      child: Text(
                                          '${data['name_category'].toString()}'),
                                    ))
                                .toList(),

                            // After selecting the desired option,it will
                            // change button value to selected value
                            onChanged: (String category) async {
                              setState(() {
                                future = UpdateChartWorkerServices.updateChart(
                                    category: category);
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 156.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AutoSizeText(
                              '${snapshot.data['persentase']} %',
                              style: TextStyle(
                                fontSize: 33.sp,
                                fontWeight: FontWeight.w500,
                              ),
                              minFontSize: 13,
                              maxLines: 2,
                            ),
                            SizedBox(height: 19.h),
                            AutoSizeText(
                              '${snapshot.data['pic']}',
                              style: TextStyle(
                                fontSize: 14.sp,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 96.w,
                            child: SfSparkAreaChart(
                              data: snapshot.data['chart'].cast<num>(),
                              color: Colors.red.withOpacity(0.05),
                              borderColor: Colors.red,
                              borderWidth: 2,
                              axisLineColor: Colors.white,
                            ),
                          ),
                          (snapshot.data['persentase_indicator'] == 0)
                              ? SizedBox()
                              : Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    ('${snapshot.data['status_indicator']}' ==
                                            'minus')
                                        ? SvgPicture.asset(
                                            'assets/img/image-svg/trending-down.svg',
                                          )
                                        : SvgPicture.asset(
                                            'assets/img/image-svg/trending-down.svg',
                                          ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    AutoSizeText(
                                      '${snapshot.data['persentase_indicator']}',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                          SizedBox(
                            height: 24.h,
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Card pieChart(AsyncSnapshot<Map<String, dynamic>> snapshot) {
    return Card(
        elevation: 3,
        shadowColor: Colors.grey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 22.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Text(
                '${snapshot.data['unit']}',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      width: 120.w,
                      height: 120.h,
                      child: SfCircularChart(annotations: [
                        CircularChartAnnotation(
                          widget: Text('${snapshot.data['total_laporan']}'),
                        )
                      ], series: <CircularSeries>[
                        DoughnutSeries<ChartData, String>(
                            dataSource: <ChartData>[
                              ChartData(
                                  label: 'jumlah laporan',
                                  point: int.parse(
                                          '${snapshot.data['total_laporan']}') +
                                      1),
                              ChartData(
                                  label: 'belum dikerjakan',
                                  point: int.parse(
                                          '${snapshot.data['laporan_belum_dikerjakan']}') +
                                      1),
                              ChartData(
                                  label: 'sedang dikerjakan',
                                  point: int.parse(
                                          '${snapshot.data['laporan_sedang_dikerjakan']}') +
                                      1),
                              ChartData(
                                  label: 'selesai',
                                  point: int.parse(
                                          '${snapshot.data['laporan_selesai']}') +
                                      1),
                            ],
                            innerRadius: '80%',
                            xValueMapper: (ChartData data, _) => data.label,
                            yValueMapper: (ChartData data, _) => data.point,
                            pointColorMapper: (chart, index) {
                              if (chart.label == 'jumlah laporan') {
                                return Colors.blue;
                              } else if (chart.label == 'belum dikerjakan') {
                                return Colors.red;
                              } else if (chart.label == 'sedang dikerjakan') {
                                return Colors.yellow;
                              } else {
                                return Colors.green;
                              }
                            })
                      ])),
                  SizedBox(
                    width: 24.w,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            DotIcon(
                              color: Colors.blue,
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: AutoSizeText(
                                '${snapshot.data['total_laporan']} Laporan ',
                                overflow: TextOverflow.clip,
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            DotIcon(
                              color: Color(0xffF32020),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: AutoSizeText(
                                '${snapshot.data['laporan_belum_dikerjakan']} Belum Dikerjakan',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            DotIcon(
                              color: Color(0xffF3A520),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: AutoSizeText(
                                '${snapshot.data['laporan_sedang_dikerjakan']} Sedang dikerjakan',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            DotIcon(
                              color: Color(0xff20F348),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: AutoSizeText(
                                '${snapshot.data['laporan_selesai']} Selesai',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h)
            ],
          ),
        ));
  }

  Card barChart(AsyncSnapshot snapshot) {
    return Card(
      elevation: 3,
      shadowColor: Colors.grey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20.h),
          Text(
            'Jumlah Tenaga Pekerja Landscape / Hari',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 24.h),
          SfCartesianChart(
            primaryXAxis: CategoryAxis(
              labelStyle: TextStyle(
                fontSize: 12.sp,
              ),
              majorGridLines: MajorGridLines(width: 0),
              axisLine: AxisLine(width: 0),
            ),
            primaryYAxis: NumericAxis(
              majorGridLines: MajorGridLines(width: 0),
              axisLine: AxisLine(width: 0),
            ),
            plotAreaBorderWidth: 0,
            palette: [Color(0xff2094F3)],
            series: <ChartSeries<ChartData, String>>[
              ColumnSeries(
                width: 0.1,
                dataSource: snapshot.data
                    .map<ChartData>((data) => ChartData.axis(
                          x: data.cluster,
                          y: int.parse(data.total),
                        ))
                    .toList(),
                // [
                //   ChartData.axis(
                //       x: 'Akasia\nGolf', y: 24),
                //   ChartData.axis(
                //       x: 'Cendana\nGolf', y: 27),
                //   ChartData.axis(x: 'Ebony\nGolf', y: 29),
                //   ChartData.axis(x: 'Damar\nGolf', y: 31),
                //   ChartData.axis(
                //       x: 'All\nCluster', y: 31),
                // ],
                borderRadius: BorderRadius.circular(100),
                xValueMapper: (datum, _) => datum.x,
                yValueMapper: (datum, index) => datum.y,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
