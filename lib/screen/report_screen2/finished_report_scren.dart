import 'package:aplikasi_rw/services/report_finished_services.dart';
import 'package:flutter/material.dart';
import '../report_screen2/card_report_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//ignore: must_be_immutable
class FinishedReportScreen extends StatelessWidget {
  List<ReportFinishedModel> report;

  FinishedReportScreen({this.report});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          title: Text(
            'Report Finished',
            style: TextStyle(
                color: Colors.black,
                fontSize: 14.0.sp,
                fontWeight: FontWeight.bold),
          ),
        ),
        body: (report.isEmpty)
            ? Center(
                child: Text('No Report Finished'),
              )
            : ListView.builder(
                shrinkWrap: true,
                itemCount: report[0].listReportFinish.length,
                itemBuilder: (context, index) => CardReportScreen(
                  urlImageReport: report[0].listReportFinish[0].urlImageReport,
                  description: report[0].listReportFinish[0].description,
                  location: report[0].listReportFinish[0].location,
                  noTicket: report[0].listReportFinish[0].noTicket,
                  time: report[0].listReportFinish[0].time,
                  status: report[0].listReportFinish[0].status,
                  category: report[0].listReportFinish[0].category,
                  categoryIcon: report[0].listReportFinish[0].iconCategory,
                  latitude: report[0].listReportFinish[0].latitude,
                  longitude: report[0].listReportFinish[0].longitude,
                  idReport: report[0].listReportFinish[0].idReport,
                  idUser: report[0].listReportFinish[0].idUser,
                  dataKlasifikasi:
                      report[0].listReportFinish[0].dataKlasifikasi,
                ),
              ));
  }
}
