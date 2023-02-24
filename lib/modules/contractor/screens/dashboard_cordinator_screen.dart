import 'package:aplikasi_rw/controller/user_login_controller.dart';
import 'package:aplikasi_rw/utils/size_config.dart';
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
  bool isUpdate = false;

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
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: SizeConfig.width(16),
            vertical: SizeConfig.height(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                loginController.name.value,
                style: TextStyle(
                  fontSize: SizeConfig.text(19),
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: SizeConfig.height(4),
              ),
              Text(
                'Sudahkah cek laporan hari ini ?',
                style: TextStyle(
                  fontSize: SizeConfig.text(14),
                  fontWeight: FontWeight.w400,
                  color: Color(0xff616161),
                ),
              ),
              SizedBox(
                height: SizeConfig.height(32),
              ),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: future,
                builder: (context, snapshot) => (snapshot.hasData)
                    ? (snapshot.data != null)
                        ? lineChart(snapshot.data)
                        : Text(
                            'Fitur ini hanya khusus untuk estate cordinator',
                          )
                    : Shimmer.fromColors(
                        child: Container(
                          height: SizeConfig.height(173),
                          width: SizeConfig.width(328),
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
                builder: (context, snapshot) => (snapshot.hasData)
                    ? pieChart(snapshot)
                    : Shimmer.fromColors(
                        child: Container(
                          height: SizeConfig.height(173),
                          width: SizeConfig.width(328),
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

  Card lineChart(List<Map<String, dynamic>> snapshot) {
    return Card(
        elevation: 3,
        shadowColor: Colors.grey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: SizeConfig.width(8)),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: SizeConfig.height(16)),
                  Text(
                    '${snapshot[0]['title']}',
                    style: TextStyle(
                      fontSize: SizeConfig.text(10),
                      color: Color(0xff757575),
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.height(8),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            // Initial Value
                            value: '${snapshot[0]['subtitle']}',
                            isDense: true,
                            underline: null,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: SizeConfig.text(16),
                                fontWeight: FontWeight.w500),
                            // Down Arrow Icon
                            icon: const Icon(Icons.keyboard_arrow_down),
                            // Array list of items
                            items: snapshot
                                .map<DropdownMenuItem<String>>(
                                    (data) => DropdownMenuItem(
                                          value: data['subtitle'].toString(),
                                          child: Text(
                                              '${data['subtitle'].toString()}'),
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
                      )
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.height(16),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: SizeConfig.width(156),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${snapshot[0]['persentase']} %',
                              style: TextStyle(
                                fontSize: SizeConfig.text(33),
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 2,
                            ),
                            SizedBox(height: SizeConfig.height(19)),
                            Text(
                              '${snapshot[0]['pic']}',
                              style: TextStyle(
                                fontSize: SizeConfig.text(14),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: SizeConfig.width(96),
                            child: SfSparkAreaChart(
                              data: snapshot[0]['chart'].cast<num>(),
                              color: Colors.red.withOpacity(0.05),
                              borderColor: Colors.red,
                              borderWidth: 2,
                              axisLineColor: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: SizeConfig.height(10),
                          ),
                          (snapshot[0]['persentase_indicator'] == 0)
                              ? SizedBox()
                              : Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    ('${snapshot[0]['status_indicator']}' ==
                                            'minus')
                                        ? SvgPicture.asset(
                                            'assets/img/image-svg/trending-down.svg',
                                          )
                                        : SvgPicture.asset(
                                            'assets/img/image-svg/trending-down.svg',
                                          ),
                                    SizedBox(
                                      width: SizeConfig.width(5),
                                    ),
                                    Text(
                                      '${snapshot[0]['persentase_indicator']}%',
                                      style: TextStyle(
                                        fontSize: SizeConfig.text(14),
                                        fontWeight: FontWeight.w500,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                          SizedBox(
                            height: SizeConfig.height(24),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.height(8),
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
          margin: EdgeInsets.symmetric(horizontal: SizeConfig.width(22)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: SizeConfig.height(20)),
              Text(
                '${snapshot.data['unit']}',
                style: TextStyle(
                    fontSize: SizeConfig.text(16), fontWeight: FontWeight.w500),
              ),
              SizedBox(height: SizeConfig.height(20)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      width: SizeConfig.width(120),
                      height: SizeConfig.height(120),
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
                    width: SizeConfig.width(24),
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
                            SizedBox(width: SizeConfig.width(8)),
                            Expanded(
                              child: Text(
                                '${snapshot.data['total_laporan']} Laporan ',
                                overflow: TextOverflow.clip,
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: SizeConfig.text(12),
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
                            SizedBox(width: SizeConfig.width(8)),
                            Expanded(
                              child: Text(
                                '${snapshot.data['laporan_belum_dikerjakan']} Belum Dikerjakan',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: SizeConfig.text(12),
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
                            SizedBox(width: SizeConfig.width(8)),
                            Expanded(
                              child: Text(
                                '${snapshot.data['laporan_sedang_dikerjakan']} Sedang dikerjakan',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: SizeConfig.text(12),
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
                            SizedBox(width: SizeConfig.width(8)),
                            Expanded(
                              child: Text(
                                '${snapshot.data['laporan_selesai']} Selesai',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: SizeConfig.text(12),
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
              SizedBox(height: SizeConfig.height(20))
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
