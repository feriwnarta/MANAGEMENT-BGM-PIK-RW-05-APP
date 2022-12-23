import 'dart:async';

import 'package:aplikasi_rw/modules/cordinator/screens/home_screen_cordinator.dart';
import 'package:aplikasi_rw/services/chart_worker/get_chart_worker.dart';
import 'package:aplikasi_rw/services/chart_worker/get_pie_chart_worker.dart';
import 'package:aplikasi_rw/services/chart_worker/total_manpower_services.dart';
import 'package:aplikasi_rw/services/chart_worker/update_chart_worker.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

//ignore: must_be_immutable
class HomeListOfCard extends StatefulWidget {
  HomeListOfCard({Key key}) : super(key: key);

  final dataDropdown = [];
  Future<Map<String, dynamic>> futureLineChart;
  Future<Map<String, dynamic>> futurePieChart;
  Future<List<TotalManPowerModel>> futureBarChart;

  @override
  State<HomeListOfCard> createState() => _HomeListOfCardState();
}

class _HomeListOfCardState extends State<HomeListOfCard> {
  @override
  initState() {
    super.initState();
    final logger = Logger();
    logger.e('clicked');

    widget.futureLineChart = GetChartWorkerServices.getChart();
    widget.futurePieChart = PieChartServices.getPie();
    widget.futureBarChart = TotalManPowerServices.getManPower();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 800));
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          widget.futureLineChart = GetChartWorkerServices.getChart();
          widget.futurePieChart = PieChartServices.getPie();
          widget.futureBarChart = TotalManPowerServices.getManPower();
        });
      },
      child: SingleChildScrollView(
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            width: 328.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),
                FutureBuilder<Map<String, dynamic>>(
                    future: widget.futureLineChart,
                    // future: GetChartWorkerServices.getChart(),
                    builder: (context, snapshot) =>
                        (snapshot.connectionState == ConnectionState.done)
                            ? lineChart(snapshot)
                            : Shimmer.fromColors(
                                child: Container(
                                  height: 173.h,
                                  width: 328.w,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                                baseColor: Colors.grey[300],
                                highlightColor: Colors.grey[200])),
                FutureBuilder<Map<String, dynamic>>(
                    future: widget.futurePieChart,
                    // future: PieChartServices.getPie(),
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
                                highlightColor: Colors.grey[200])),
                FutureBuilder(
                    // future: TotalManPowerServices.getManPower(),
                    future: widget.futureBarChart,
                    builder: (context, snapshot) =>
                        (snapshot.connectionState == ConnectionState.done)
                            ? barChart(snapshot)
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
                                highlightColor: Colors.grey[200])),
                SizedBox(
                  height: 30.h,
                ),
              ],
            )),
      ),
    );
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          DotIcon(
                            color: Colors.blue,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            '${snapshot.data['total_laporan']} Laporan',
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          DotIcon(
                            color: Colors.blue,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            '${snapshot.data['laporan_belum_dikerjakan']} Belum Dikerjakan',
                            style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          DotIcon(
                            color: Colors.blue,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            '${snapshot.data['laporan_sedang_dikerjakan']} Sedang dikerjakan',
                            style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          DotIcon(
                            color: Colors.blue,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            '${snapshot.data['laporan_selesai']} Selesai',
                            style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20.h)
            ],
          ),
        ));
  }

  Card lineChart(AsyncSnapshot<Map<String, dynamic>> snapshot) {
    return Card(
        elevation: 3,
        shadowColor: Colors.grey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    '${snapshot.data['title']}',
                    style: TextStyle(fontSize: 10.sp, color: Color(0xff757575)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
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
                                widget.futureLineChart =
                                    UpdateChartWorkerServices.updateChart(
                                        category: category);
                              });

                              // widget.future = await UpdateChartWorkerServices.updateChart(category: category);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.5.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        '${snapshot.data['persentase']} %',
                        style: TextStyle(
                            fontSize: 33.sp, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 19.h),
                      Text(
                        '${snapshot.data['pic']}',
                        style: TextStyle(
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                  Column(
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
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 16.h),
          ],
        ));
  }
}
