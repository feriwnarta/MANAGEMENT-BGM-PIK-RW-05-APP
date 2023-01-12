import 'package:aplikasi_rw/modules/estate_manager/services/chart_line_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/state_manager.dart';
import 'package:logger/logger.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

import '../models/LineChartModel.dart';

//ignore: must_be_immutable
class CardLineChart extends StatefulWidget {
  AsyncSnapshot<List<LineChartModel>> snapshot;
  int index;
  RxInt category;
  String rangeDate, date;

  CardLineChart(
      {Key key,
      this.snapshot,
      this.index,
      this.category,
      this.date,
      this.rangeDate})
      : super(key: key);

  @override
  State<CardLineChart> createState() =>
      _CardLineChartState(category: category, index: index, snapshot: snapshot);
}

class _CardLineChartState extends State<CardLineChart> {
  AsyncSnapshot<List<LineChartModel>> snapshot;
  int index;
  RxInt category;
  RxString test = ''.obs;
  bool isUpdate = false;
  Map<String, dynamic> dataUpdate = {};

  _CardLineChartState({this.category, this.index, this.snapshot});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 16.h,
            ),
            Text(
              'Penilaian ${snapshot.data[index].title}',
              style: TextStyle(fontSize: 10.sp, color: Color(0xff757575)),
            ),
            SizedBox(
              height: 24.h,
              width: double.infinity,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  hint: Text(
                    (!isUpdate)
                        ? '${snapshot.data[index].dropdown[0]['name_category']}'
                        : dataUpdate['name_category'],
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.sp,
                    ),
                  ),
                  isDense: true,
                  underline: null,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500),
                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),

                  items: snapshot.data[index].dropdown.map((e) {
                    return DropdownMenuItem<String>(
                        value: '${e['id_category']}',
                        child: Text('${e['name_category']}'));
                  }).toList(),

                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (String category) async {
                    test.value = category;

                    dataUpdate = await ChartLineServices.updateChart(
                        date: widget.date,
                        idCategory: test.value,
                        idUser: '1',
                        rangeDate: widget.rangeDate);

                    setState(() {
                      isUpdate = true;
                    });

                    final logger = Logger();
                    logger.d(dataUpdate.toString());
                  },
                ),
              ),
            ),
            SizedBox(
              height: 16.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    SizedBox(
                      width: 100.w,
                      height: 49.h,
                      child: Text(
                        (!isUpdate)
                            ? '${snapshot.data[index].persentaseSekarang[0]}'
                            : dataUpdate['persentase_sekarang'],
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 19.h,
                    ),
                    (!isUpdate)
                        ? SizedBox(
                            width: 100.w,
                            height: 20.h,
                            child: Row(
                                children: (snapshot.data[index].pic[0] != null)
                                    ? snapshot.data[index].pic[0]
                                        .map<Widget>((data) => Text(
                                              '$data',
                                              overflow: TextOverflow.ellipsis,
                                            ))
                                        .toList()
                                    : [Text('-')]),
                          )
                        : SizedBox(
                            width: 100.w,
                            height: 20.h,
                            child: Row(
                                children: (dataUpdate['pic'] != null)
                                    ? dataUpdate['pic']
                                        .map<Widget>((data) => Text(
                                              '$data',
                                              overflow: TextOverflow.ellipsis,
                                            ))
                                        .toList()
                                    : [Text('-')]),
                          ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 96.w,
                      child: SfSparkAreaChart(
                        data: (snapshot.data[index].dataChart[0].length != 0)
                            ? snapshot.data[index].dataChart[0]
                                .map<double>((data) => double.parse(data))
                                .toList()
                            : [100, 100, 100, 100],
                        color: (snapshot.data[index].status[0] == 'minus')
                            ? Colors.red.withOpacity(0.05)
                            : Colors.green.withOpacity(0.05),
                        borderColor: snapshot.data[index].status[0] == 'minus'
                            ? Colors.red
                            : Colors.green,
                        borderWidth: 2,
                        axisLineColor: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    (!isUpdate)
                        ? SizedBox(
                            height: 20.h,
                            width: 60.w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                (snapshot.data[index].status[0] == 'plus' &&
                                        snapshot.data[index].persentase[0] ==
                                            '100 %')
                                    ? Spacer()
                                    : SvgPicture.asset(
                                        'assets/img/image-svg/low.svg'),
                                Text('${snapshot.data[index].persentase[0]}')
                              ],
                            ))
                        : SizedBox(
                            height: 20.h,
                            width: 60.w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                (dataUpdate['status'] == 'plus' &&
                                        dataUpdate['persentase'] == '100 %')
                                    ? Spacer()
                                    : SvgPicture.asset(
                                        'assets/img/image-svg/low.svg'),
                                Text(dataUpdate['persentase'])
                              ],
                            )),
                    SizedBox(
                      height: 16.h,
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
