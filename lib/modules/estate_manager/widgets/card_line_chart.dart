import 'package:aplikasi_rw/modules/estate_manager/services/chart_line_services.dart';
import 'package:aplikasi_rw/utils/size_config.dart';
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
    ScreenUtil.init(context, designSize: const Size(360, 800));
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.width(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: SizeConfig.height(16),
            ),
            Text(
              'Penilaian ${snapshot.data[index].title}',
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TextStyle(
                  fontSize: SizeConfig.text(10), color: Color(0xff757575)),
            ),
            SizedBox(
              height: SizeConfig.height(24),
              width: double.infinity,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  hint: SizedBox(
                    width: SizeConfig.width(280),
                    child: Text(
                      (!isUpdate)
                          ? '${snapshot.data[index].dropdown[0]['name_category']}'
                          : dataUpdate['name_category'],
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: SizeConfig.text(16),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  isDense: true,
                  underline: null,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: SizeConfig.text(16),
                      fontWeight: FontWeight.w500),
                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),

                  items: snapshot.data[index].dropdown.map((e) {
                    return DropdownMenuItem<String>(
                        value: '${e['id_category']}',
                        child: SizedBox(
                          width: SizeConfig.width(270),
                          child: Text(
                            '${e['name_category']}',
                            style: TextStyle(
                              fontSize: SizeConfig.text(14),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ));
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
              height: SizeConfig.height(16),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: SizeConfig.width(100),
                      height: SizeConfig.height(49),
                      child: Text(
                        (!isUpdate)
                            ? '${snapshot.data[index].persentaseSekarang[0]}'
                            : dataUpdate['persentase_sekarang'],
                        style: TextStyle(
                          fontSize: SizeConfig.text(28),
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.height(19),
                    ),
                    (!isUpdate)
                        ? SizedBox(
                            width: SizeConfig.width(200),
                            // height: 20.h,
                            child: (snapshot.data[index].pic[0] != null)
                                ? Text(
                                    '${snapshot.data[index].pic[0].join(', ')}',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: SizeConfig.text(14),
                                    ),
                                  )
                                : Text('-'),
                          )
                        : SizedBox(
                            width: SizeConfig.width(100),
                            // height: 20.h,
                            child: (dataUpdate['pic'] != null)
                                ? Text(
                                    '${dataUpdate['pic'].join(', ')}',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: SizeConfig.text(14),
                                    ),
                                  )
                                : Text('-'),
                          ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    (isUpdate)
                        ? SizedBox(
                            width: SizeConfig.width(96),
                            child: SfSparkAreaChart(
                              data: (dataUpdate['data_chart'] != null)
                                  ? dataUpdate['data_chart']
                                      .map<double>((data) => double.parse(data))
                                      .toList()
                                  : [100, 100, 100, 100],
                              color: (dataUpdate['status'] == 'minus')
                                  ? Colors.red.withOpacity(0.05)
                                  : Colors.green.withOpacity(0.05),
                              borderColor: dataUpdate['status'] == 'minus'
                                  ? Colors.red
                                  : Colors.green,
                              borderWidth: 2,
                              axisLineColor: Colors.white,
                            ),
                          )
                        : SizedBox(
                            width: SizeConfig.width(96),
                            child: SfSparkAreaChart(
                              data: (snapshot.data[index].dataChart[0].length !=
                                      0)
                                  ? snapshot.data[index].dataChart[0]
                                      .map<double>((data) => double.parse(data))
                                      .toList()
                                  : [100, 100, 100, 100],
                              color: (snapshot.data[index].status[0] == 'minus')
                                  ? Colors.red.withOpacity(0.05)
                                  : Colors.green.withOpacity(0.05),
                              borderColor:
                                  snapshot.data[index].status[0] == 'minus'
                                      ? Colors.red
                                      : Colors.green,
                              borderWidth: 2,
                              axisLineColor: Colors.white,
                            ),
                          ),
                    SizedBox(
                      height: SizeConfig.height(15),
                    ),
                    (!isUpdate)
                        ? SizedBox(
                            height: SizeConfig.height(20),
                            width: SizeConfig.width(60),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                (snapshot.data[index].status[0] == 'plus' &&
                                        snapshot.data[index].persentase[0] ==
                                            '100 %')
                                    ? Spacer()
                                    : SvgPicture.asset(
                                        'assets/img/image-svg/low.svg',
                                        width: SizeConfig.width(20),
                                        height: SizeConfig.height(20),
                                      ),
                                Text(
                                  '${snapshot.data[index].persentase[0]}',
                                  style:
                                      TextStyle(fontSize: SizeConfig.text(14)),
                                )
                              ],
                            ))
                        : SizedBox(
                            height: SizeConfig.height(20),
                            width: SizeConfig.width(60),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                (dataUpdate['status'] == 'plus' &&
                                        dataUpdate['persentase'] == '100 %')
                                    ? Spacer()
                                    : SvgPicture.asset(
                                        'assets/img/image-svg/low.svg',
                                        width: SizeConfig.width(20),
                                        height: SizeConfig.height(20),
                                      ),
                                Text(
                                  dataUpdate['persentase'],
                                  style:
                                      TextStyle(fontSize: SizeConfig.text(14)),
                                )
                              ],
                            )),
                    SizedBox(
                      height: SizeConfig.height(16),
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
