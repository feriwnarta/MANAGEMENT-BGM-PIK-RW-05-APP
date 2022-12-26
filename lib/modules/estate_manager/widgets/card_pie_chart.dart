import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../cordinator/screens/home_screen_cordinator.dart';

class CardPieChart extends StatefulWidget {
  const CardPieChart({Key key}) : super(key: key);

  @override
  State<CardPieChart> createState() => _CardPieChartState();
}

class _CardPieChartState extends State<CardPieChart> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 800));
    return SizedBox(
      width: 328.w,
      child: Card(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 11.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20.h,
              ),
              Text(
                'Total laporan',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 20.h,
              ),
              Row(
                children: [
                  Container(
                    width: 120.w,
                    height: 120.h,
                    alignment: Alignment.center,
                    child:
                        SfCircularChart(margin: EdgeInsets.zero, annotations: [
                      CircularChartAnnotation(
                        widget: Text('Total laporan'),
                      )
                    ], series: <CircularSeries>[
                      DoughnutSeries<ChartData, String>(
                          dataSource: <ChartData>[
                            ChartData(
                                label: 'security', point: int.parse('1') + 1),
                            ChartData(
                                label: 'administrasi',
                                point: int.parse('2') + 1),
                            ChartData(
                                label: 'building controll',
                                point: int.parse('3') + 1),
                            ChartData(
                              label: 'mekanikel elektrikel',
                              point: int.parse('4') + 1,
                            ),
                            ChartData(
                                label: 'landscape', point: int.parse('3') + 1),
                          ],
                          innerRadius: '70%',
                          radius: '100%',
                          xValueMapper: (ChartData data, _) => data.label,
                          yValueMapper: (ChartData data, _) => data.point,
                          pointColorMapper: (chart, index) {
                            if (chart.label == 'security') {
                              return Color(0xff44A1E9);
                            } else if (chart.label == 'administrasi') {
                              return Color(0xff1F8EE5);
                            } else if (chart.label == 'building controll') {
                              return Color(0xff6AB4EE);
                            } else if (chart.label == 'mekanikel elektrikel') {
                              return Color(0xff8FC6F2);
                            } else if (chart.label == 'landscape') {
                              return Color(0xffDBEFFF);
                            } else {
                              return Color(0xffDBEFFF);
                            }
                          })
                    ]),
                  ),
                  SizedBox(
                    width: 24.w,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
