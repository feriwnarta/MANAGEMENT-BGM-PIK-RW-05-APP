import 'package:aplikasi_rw/utils/size_config.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger/logger.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../contractor/screens/home_screen_cordinator.dart';

class CardPieChart extends StatefulWidget {
  const CardPieChart({Key key, this.title, this.total, this.dataPie})
      : super(key: key);

  final String title, total;
  final List<Map<String, dynamic>> dataPie;

  @override
  State<CardPieChart> createState() => _CardPieChartState();
}

class _CardPieChartState extends State<CardPieChart> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 800));
    return SizedBox(
      width: SizeConfig.width(328),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.width(11)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: SizeConfig.height(20),
              ),
              Text(
                '${widget.title}',
                style: TextStyle(
                  fontSize: SizeConfig.text(16),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: SizeConfig.height(20),
              ),
              Row(
                children: [
                  Container(
                    width: SizeConfig.width(120),
                    height: SizeConfig.height(120),
                    alignment: Alignment.center,
                    child:
                        SfCircularChart(margin: EdgeInsets.zero, annotations: [
                      CircularChartAnnotation(
                        widget: Text(
                          '${widget.total}',
                          style: TextStyle(
                            fontSize: SizeConfig.text(10),
                          ),
                        ),
                      )
                    ], series: <CircularSeries>[
                      DoughnutSeries<ChartData, String>(
                          // dataSource: <ChartData>[
                          //   ChartData(
                          //       label: 'security', point: int.parse('1') + 1),
                          //   ChartData(
                          //       label: 'administrasi',
                          //       point: int.parse('2') + 1),
                          //   ChartData(
                          //       label: 'building controll',
                          //       point: int.parse('3') + 1),
                          //   ChartData(
                          //     label: 'mekanikel elektrikel',
                          //     point: int.parse('4') + 1,
                          //   ),
                          //   ChartData(
                          //       label: 'landscape', point: int.parse('3') + 1),
                          // ],
                          dataSource: widget.dataPie
                              .map<ChartData>(
                                (e) => ChartData(
                                  label: e['unit'],
                                  point: e['total'],
                                ),
                              )
                              .toList(),
                          innerRadius: '70%',
                          radius: '100%',
                          xValueMapper: (ChartData data, _) => data.label,
                          yValueMapper: (ChartData data, _) => data.point,
                          pointColorMapper: (chart, index) {
                            for (int i = 0; i < widget.dataPie.length; i++) {
                              final logger = Logger();
                              logger.i(widget.dataPie[i]['color']);

                              if (chart.label
                                  .contains(widget.dataPie[i]['unit'])) {
                                return Color(
                                    int.parse(widget.dataPie[i]['color']));
                              }
                            }
                            return Colors.blue;
                          })
                    ]),
                  ),
                  SizedBox(
                    width: SizeConfig.width(24),
                  ),
                  Expanded(
                    child: Column(
                      children: widget.dataPie
                          .map<Widget>(
                            (e) => Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    DotIcon(
                                      color: Color(int.parse('${e['color']}')),
                                    ),
                                    SizedBox(
                                      width: SizeConfig.width(8),
                                    ),
                                    Expanded(
                                      child: Text(
                                        '${e['total']} ${e['unit']}',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: SizeConfig.text(14),
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xff757575),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: SizeConfig.height(4),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: SizeConfig.height(20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
