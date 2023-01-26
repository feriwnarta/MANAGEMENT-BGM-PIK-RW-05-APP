import 'package:aplikasi_rw/services/absen_worker_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:table_calendar/table_calendar.dart';

class AbsenScreen extends StatefulWidget {
  const AbsenScreen({Key key}) : super(key: key);

  @override
  _AbsenScreenState createState() => _AbsenScreenState();
}

class _AbsenScreenState extends State<AbsenScreen> {
  // CalendarController _calendarController;

  @override
  void initState() {
    // _calendarController = CalendarController();
    super.initState();
  }

  @override
  void dispose() {
    // _calendarController.dispose();
    super.dispose();
  }

  var textAbsen = TextStyle(
      fontSize: 14.sp, fontWeight: FontWeight.w500, color: Colors.white);

  var style2 = TextStyle(
      fontSize: 56.sp, fontWeight: FontWeight.w500, color: Colors.white);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Absensi',
            style: TextStyle(color: Colors.white, fontSize: 19.sp)),
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: FutureBuilder<Map<String, dynamic>>(
            future: AbsenServices.checkAbsen(),
            builder: (context, snapshot) => (snapshot.hasData)
                ? Column(
                    children: [
                      TableCalendar(
                        focusedDay: DateTime.now(),
                        availableCalendarFormats: {
                          CalendarFormat.month: 'Month'
                        },
                        firstDay: DateTime.utc(2010, 10, 16),
                        lastDay: DateTime.utc(2030, 3, 14),
                        rowHeight: 60,
                        calendarStyle: CalendarStyle(
                          // highlightToday: true,
                          isTodayHighlighted: true
                        ),
                        headerStyle: HeaderStyle(
                          // centerHeaderTitle: true,
                          titleCentered: true,
                          headerMargin: EdgeInsets.symmetric(
                            horizontal: 16.w,
                          ),
                          headerPadding: EdgeInsets.only(bottom: 32.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            color: Color(0xffFD6060),
                            width: 156.w,
                            height: 101.h,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 8.h),
                                Text(
                                  'Total Absen',
                                  style: textAbsen,
                                ),
                                Expanded(
                                  child: (snapshot.data['message'] == null)
                                      ? Text('${snapshot.data['total_absen']}',
                                          style: style2)
                                      : Text('0', style: style2),
                                )
                              ],
                            ),
                          ),
                          Container(
                            color: Color(0xff2094F3),
                            width: 156.w,
                            height: 101.h,
                            child: Column(
                              children: [
                                SizedBox(height: 8.h),
                                Text(
                                  'Total Hadir',
                                  style: textAbsen,
                                ),
                                Expanded(
                                    child: (snapshot.data['message'] == null)
                                        ? Text(
                                            '${snapshot.data['total_hadir']}',
                                            style: style2)
                                        : Text('0', style: style2))
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  )
                : LinearProgressIndicator()),
      ),
    );
  }
}
