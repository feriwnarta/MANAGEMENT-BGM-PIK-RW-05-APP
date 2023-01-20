import 'package:aplikasi_rw/modules/estate_manager/data/chart_data_selection.dart';
import 'package:aplikasi_rw/modules/estate_manager/models/LineChartModel.dart';
import 'package:aplikasi_rw/modules/estate_manager/services/chart_pie_services.dart';
import 'package:aplikasi_rw/modules/estate_manager/widgets/card_line_chart.dart';
import 'package:aplikasi_rw/modules/estate_manager/widgets/card_pie_chart.dart';
import 'package:async/async.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../services/chart_line_services.dart';

class CardLine extends StatefulWidget {
  const CardLine({
    Key key,
  }) : super(key: key);

  @override
  State<CardLine> createState() => _CardLineState();
}

class _CardLineState extends State<CardLine> {
  Future future = ChartLineServices.getChart(
      date: DateFormat('yyyy-MM-dd').format(DateTime.now().toUtc()),
      rangeDate: '1hr');

  Future futurePie = ChartPieServices.getChartPie(
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
  RxString rangeDate = '1hr'.obs;
  RxString date = ''.obs;
  // RxInt category = 0.obs;

  final logger = Logger();

  @override
  void initState() {
    super.initState();
    date.value = DateFormat('yyyy-MM-dd').format(DateTime.now().toUtc());
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 800));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        groupedButton(),
        SizedBox(
          height: 16.h,
        ),
        button(),
        buttonSearch(),
        SizedBox(
          height: 16.h,
        ),
        FutureBuilder<List<LineChartModel>>(
          future: future,
          builder: (context, snapshot) =>
              (snapshot.connectionState == ConnectionState.done)
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) => Container(
                        width: 328.w,
                        margin: EdgeInsets.only(bottom: 24.h),
                        child: CardLineChart(
                          index: index,
                          snapshot: snapshot,
                          date: date.value,
                          rangeDate: rangeDate.value,
                        ),
                      ),
                    )
                  : Center(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(),
                      ),
                    ),
        ),
        FutureBuilder<List<ChartPieModel>>(
          future: futurePie,
          builder: (context, snapshot) =>
              (snapshot.connectionState == ConnectionState.done)
                  ? ListView.builder(
                      itemCount: snapshot.data.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => CardPieChart(
                        title: snapshot.data[index].title,
                        total: snapshot.data[index].total,
                        dataPie: snapshot.data[index].dataPie,
                      ),
                    )
                  : SizedBox(),
        ),
        SizedBox(
          height: 66.h,
        ),
        Card(
          elevation: 5,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AutoSizeText(
                  'Jumlah Tenaga Pekerja tiap Divisi / Hari',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  minFontSize: 10,
                ),
                SizedBox(
                  height: 16.h,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    // horizontal: 16.w,
                    vertical: 6.h,
                  ).copyWith(left: 23.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5), //shadow color
                        spreadRadius: 0.5, // spread radius
                        blurRadius: 2, // shadow blur radius
                        offset:
                            const Offset(0, 0), // changes position of shadow
                      ),
                    ],
                  ),
                  child: DropdownButton<String>(
                    underline: SizedBox(),
                    isDense: true,
                    elevation: 0,
                    isExpanded: true,
                    alignment: Alignment.centerLeft,
                    borderRadius: BorderRadius.circular(4),
                    items: [
                      DropdownMenuItem<String>(
                        value: '1',
                        child: AutoSizeText(
                          'Perawatan taman',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.sp,
                          ),
                          maxLines: 2,
                          minFontSize: 13,
                        ),
                      )
                    ],
                    hint: AutoSizeText(
                      'Perawatan taman',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      minFontSize: 11,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onChanged: (value) {},
                  ),
                ),
                SizedBox(
                  height: 24.h,
                ),
                SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  series: <CartesianSeries>[
                    ColumnSeries<ChartDataSelection, String>(
                      dataSource: [
                        ChartDataSelection(label: 'Landscape', point: 10),
                        ChartDataSelection(label: 'Em', point: 5),
                        ChartDataSelection(label: 'Mekanikel', point: 2),
                      ],
                      xValueMapper: (ChartDataSelection data, _) => data.label,
                      yValueMapper: (ChartDataSelection data, _) => data.point,
                      // selectionBehavior: _selectionBehavior,
                    )
                  ],
                ),
              ],
            ),
          ),
        )
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
                date: date.value, rangeDate: data[index]);
            futurePie = ChartPieServices.getChartPie(
                date: date.value, rangeDate: data[index]);
          });
          rangeDate.value = data[index];
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

  Widget button() {
    return Column(children: [
      Row(
        children: [
          buttonSelectDate(),
          SizedBox(
            width: 12.w,
          ),
          // buttonFiter(),
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
          onPressed: () async {
            var datePicker = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime.now());
            if (datePicker != null) {
              String dateString = datePicker.toString();
              var split = dateString.split(' ');
              date.value = split[0];

              setState(() {
                future = ChartLineServices.getChart(
                    date: date.value, rangeDate: rangeDate.value);

                futurePie = ChartPieServices.getChartPie(
                    date: date.value, rangeDate: rangeDate.value);
              });

              logger.i(date.value);
              logger.i(rangeDate.value);
            }
          },
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
}
