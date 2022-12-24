import 'package:aplikasi_rw/modules/estate_manager/models/LineChartModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

import '../services/chart_line_services.dart';

class CardLine extends StatefulWidget {
  final Widget widget;

  const CardLine({Key key, this.widget}) : super(key: key);

  @override
  State<CardLine> createState() => _CardLineState();
}

class _CardLineState extends State<CardLine> {
  Future future = ChartLineServices.getChart(
      date: DateFormat('yyyy-MM-dd').format(DateTime.now().toUtc()),
      rangeDate: '1hr');

  bool vertical = false;
  RxList<bool> _selectedFruits = <bool>[false, false, false, true].obs;
  // var styleGue = TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500);
  RxList<Widget> fruits = <Widget>[
    Text('12 bulan',
        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500)),
    Text('30 hari',
        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500)),
    Text('7 hari',
        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500)),
    Text(
      '24 jam',
      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
    )
  ].obs;

  List<String> data = ['1th', '30hr', '7hr', '1hr'];

  final logger = Logger();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('render ke 2');
    ScreenUtil.init(context, designSize: const Size(360, 800));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        groupedButton(),
        SizedBox(
          height: 16.h,
        ),
        widget.widget,
        buttonSearch(),
        FutureBuilder<List<LineChartModel>>(
            future: future,
            builder: (context, snapshot) => (snapshot.hasData)
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) => Container(
                      width: 328.w,
                      height: 172.h,
                      margin: EdgeInsets.only(bottom: 24.h),
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.5.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Penilaian ${snapshot.data[index].title}',
                                style: TextStyle(
                                    fontSize: 10.sp, color: Color(0xff757575)),
                              ),
                              SizedBox(
                                height: 24.h,
                                width: double.infinity,
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    hint: Text(
                                      '${snapshot.data[index].dropdown[0]['name_category']}',
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

                                    items:
                                        snapshot.data[index].dropdown.map((e) {
                                      return DropdownMenuItem<String>(
                                          value: '${e['id_category']}',
                                          child: Text('${e['name_category']}'));
                                    }).toList(),

                                    // After selecting the desired option,it will
                                    // change button value to selected value
                                    onChanged: (String category) async {
                                      // widget.future = await UpdateChartWorkerServices.updateChart
                                      //(category: category);
                                      setState(() {});
                                      print('change');
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 16.h,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      SizedBox(
                                        width: 100.w,
                                        height: 49.h,
                                        child: Text(
                                          '${snapshot.data[0].persentaseSekarang[index]}',
                                          style: TextStyle(
                                            fontSize: 28.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 19.h,
                                      ),
                                      SizedBox(
                                        width: 100.w,
                                        height: 20.h,
                                        child: Row(
                                            children: (snapshot
                                                        .data[index].pic[0] !=
                                                    null)
                                                ? snapshot.data[index].pic[0]
                                                    .map<Widget>((data) => Text(
                                                          '${data}',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ))
                                                    .toList()
                                                : [Text('-')]),
                                      )
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 96.w,
                                        child: SfSparkAreaChart(
                                          data: (snapshot.data[index]
                                                      .dataChart[0].length !=
                                                  0)
                                              ? snapshot
                                                  .data[index].dataChart[0]
                                                  .map<num>((data) =>
                                                      double.parse(data))
                                                  .toList()
                                              : [100, 100, 100, 100],
                                          color: (snapshot
                                                      .data[index].status[0] ==
                                                  'minus')
                                              ? Colors.red.withOpacity(0.05)
                                              : Colors.green.withOpacity(0.05),
                                          borderColor:
                                              snapshot.data[index].status[0] ==
                                                      'minus'
                                                  ? Colors.red
                                                  : Colors.green,
                                          borderWidth: 2,
                                          axisLineColor: Colors.white,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15.h,
                                      ),
                                      SizedBox(
                                          height: 20.h,
                                          width: 60.w,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SvgPicture.asset(
                                                  'assets/img/image-svg/low.svg'),
                                              Text(
                                                  '${snapshot.data[index].persentase[0]}')
                                            ],
                                          ))
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : CircularProgressIndicator()),
      ],
    );
  }

  SizedBox buttonSearch() {
    return SizedBox(
      width: 248.w,
      child: OutlinedButton.icon(
          onPressed: () {},
          icon: SvgPicture.asset('assets/img/image-svg/search-em.svg'),
          style: OutlinedButton.styleFrom(
              alignment: Alignment.centerLeft,
              foregroundColor: Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              )),
          label: Text(
            'Search',
            style: TextStyle(fontSize: 14.sp),
          )),
    );
  }

  Widget groupedButton() {
    return Obx(
      () => ToggleButtons(
        direction: Axis.horizontal,
        onPressed: (int index) {
          // The button that is tapped is set to true, and the others to false.
          for (int i = 0; i < _selectedFruits.length; i++) {
            _selectedFruits[i] = i == index;
          }
          setState(() {
            future = ChartLineServices.getChart(
                date: DateFormat('yyyy-MM-dd').format(DateTime.now().toUtc()),
                rangeDate: data[index]);
          });
        },
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        selectedBorderColor: Colors.blue[700],
        selectedColor: Colors.white,
        fillColor: Colors.blue[200],
        color: Colors.grey,
        constraints: const BoxConstraints(
          minHeight: 40.0,
          minWidth: 80.0,
        ),
        isSelected: _selectedFruits.value,
        children: fruits,
      ),
    );
  }
}
