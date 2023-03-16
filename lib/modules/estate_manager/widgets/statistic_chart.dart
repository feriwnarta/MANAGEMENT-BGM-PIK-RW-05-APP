import 'package:aplikasi_rw/modules/estate_manager/models/LineChartModel.dart';
import 'package:aplikasi_rw/modules/estate_manager/services/chart_pie_services.dart';
import 'package:aplikasi_rw/modules/estate_manager/widgets/card_line_chart.dart';
import 'package:aplikasi_rw/modules/estate_manager/widgets/card_pie_chart.dart';
import 'package:aplikasi_rw/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
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
    Text(
      '12 bulan',
    ),
    Text(
      '30 hari',
    ),
    Text(
      '7 hari',
    ),
    Text(
      '24 jam',
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
          height: SizeConfig.height(16),
        ),
        button(),
        SizedBox(
          height: SizeConfig.height(16),
        ),
        // buttonSearch(),
        // SizedBox(
        //   height: SizeConfig.height(16),
        // ),
        FutureBuilder<List<LineChartModel>>(
          future: future,
          builder: (context, snapshot) =>
              (snapshot.connectionState == ConnectionState.done)
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) => Container(
                        margin: EdgeInsets.only(
                          bottom: SizeConfig.height(24),
                        ),
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
                        width: SizeConfig.width(30),
                        height: SizeConfig.height(30),
                        child: CircularProgressIndicator.adaptive(),
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
                      itemBuilder: (context, index) => Container(
                        margin: EdgeInsets.only(
                          bottom: SizeConfig.height(24),
                        ),
                        child: CardPieChart(
                          title: snapshot.data[index].title,
                          total: snapshot.data[index].total,
                          dataPie: snapshot.data[index].dataPie,
                        ),
                      ),
                    )
                  : SizedBox(),
        ),
        SizedBox(
          height: SizeConfig.height(66),
        ),
      ],
    );
  }

  SizedBox buttonSearch() {
    return SizedBox(
      width: SizeConfig.width(248),
      height: SizeConfig.height(40),
      child: OutlinedButton.icon(
          onPressed: () {},
          icon: SvgPicture.asset(
            'assets/img/image-svg/search-em.svg',
            height: SizeConfig.height(20),
            width: SizeConfig.width(20),
          ),
          style: OutlinedButton.styleFrom(
              alignment: Alignment.centerLeft,
              foregroundColor: Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              )),
          label: Text(
            'Search',
            style: TextStyle(fontSize: SizeConfig.text(14)),
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
        textStyle: TextStyle(
          fontSize: SizeConfig.text(14),
        ),
        fillColor: Colors.blue[200],
        color: Colors.grey,
        constraints: BoxConstraints(
          minHeight: SizeConfig.height(40),
          minWidth: SizeConfig.width(81),
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
            width: SizeConfig.width(12),
          ),
          // buttonFiter(),
        ],
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
      width: SizeConfig.width(142),
      height: SizeConfig.height(40),
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
          icon: SvgPicture.asset(
            'assets/img/image-svg/pilih-tanggal.svg',
            width: SizeConfig.width(20),
            height: SizeConfig.height(20),
          ),
          style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              )),
          label: Text(
            'Pilih tanggal',
            style: TextStyle(fontSize: SizeConfig.text(14)),
          )),
    );
  }
}
