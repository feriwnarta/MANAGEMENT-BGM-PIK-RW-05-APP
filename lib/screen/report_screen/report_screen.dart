import 'package:aplikasi_rw/bloc/report_screen_bloc.dart';
import 'package:aplikasi_rw/model/card_laporan_warga_model.dart';
import 'package:aplikasi_rw/screen/report_screen/create_report_screen.dart';
import 'package:aplikasi_rw/screen/report_screen/card_laporan_warga.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//ignore: must_be_immutable
class ReportScreen extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool isVisibility = true;

  ReportScreen(this.scaffoldKey);

  // bloc
  ReportScreenBloc blocScreenReport;

  @override
  Widget build(BuildContext context) {
    blocScreenReport = BlocProvider.of<ReportScreenBloc>(context);

    return BlocBuilder<ReportScreenBloc, ReportState>(
      builder: (context, state) => SafeArea(
        child: Scaffold(
          body: ListView(
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 5.0.w, top: 2.0.h),
                        child: Text(
                          'Report',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'poppins',
                              fontSize: 21.0.sp),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.0.h),
                  Column(
                    children: [
                      Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                          width: 96.0.w,
                          height: 7.0.h,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              splashColor: Colors.indigo,
                              onTap: () {
                                if (isVisibility) {
                                  blocScreenReport
                                      .add(ReportEvent(isVisibility: false));
                                  isVisibility = false;
                                } else {
                                  blocScreenReport
                                      .add(ReportEvent(isVisibility: true));
                                  isVisibility = true;
                                }
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'My Report',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.0.sp,
                                        fontFamily: 'poppins'),
                                  ),
                                  Row(
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsets.only(right: 3.0.w),
                                            child: Text(
                                              CardLaporanWargaModel
                                                  .getAllLaporan.length
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14.0.sp),
                                            ),
                                          ),
                                          Icon(
                                            FontAwesomeIcons.clipboard,
                                            size: 3.0.h,
                                            color: Colors.white,
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          VerticalDivider(
                                            color: Colors.white,
                                            width: 50,
                                            thickness: 1,
                                            indent: 2.0.h,
                                            endIndent: 2.0.h,
                                          ),
                                          Material(
                                              color: Colors.transparent,
                                              child: SizedBox(
                                                height: 5.0.h,
                                                width: 6.0.w,
                                                child: InkWell(
                                                  splashColor: Colors.indigo,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  child: AnimatedSwitcher(
                                                      duration: Duration(
                                                          milliseconds: 900),
                                                      child: (state
                                                              .isVisibility)
                                                          ? Icon(
                                                              FontAwesomeIcons
                                                                  .angleUp,
                                                              color:
                                                                  Colors.white,
                                                            )
                                                          : Icon(
                                                              FontAwesomeIcons
                                                                  .angleDown,
                                                              color:
                                                                  Colors.white,
                                                            )),
                                                  onTap: () {
                                                    if (isVisibility) {
                                                      blocScreenReport.add(
                                                          ReportEvent(
                                                              isVisibility:
                                                                  false));

                                                      isVisibility = false;
                                                    } else {
                                                      blocScreenReport.add(
                                                          ReportEvent(
                                                              isVisibility:
                                                                  true));

                                                      isVisibility = true;
                                                    }
                                                  },
                                                ),
                                              ))
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 1.5.h,
                  ),
                  buildVisibilityQuickGuide(),
                  buildVisibilityHeaderCard(),
                  buildVisibilityCardLaporan(),
                ],
              )
            ],
          ),
          floatingActionButton: buildSizeBoxFloatingActionButton(context),
        ),
      ),
    );
  }

  BlocBuilder buildVisibilityCardLaporan() {
    return BlocBuilder<ReportScreenBloc, ReportState>(
      builder: (context, state) => Visibility(
        visible: state.isVisibility,
        child: ListView.builder(
          physics: ScrollPhysics(),
          shrinkWrap: true,
          reverse: true,
          itemCount: CardLaporanWargaModel.getAllLaporan.length,
          itemBuilder: (context, index) {
            return (CardLaporanWargaModel.getAllLaporan[index].status
                        .toLowerCase() ==
                    'listed')
                ? buildSlidableCardLaporanWarga(index, context)
                : CardLaporanWarga(
                    // 7 digit kode
                    noTicket:
                        CardLaporanWargaModel.getAllLaporan[index].noTicket,
                    status: CardLaporanWargaModel.getAllLaporan[index].status,
                    additionalInformation:
                        CardLaporanWargaModel.getAllLaporan[index].content,
                    // description: ,
                  );
          },
        ),
      ),
    );
  }

  Slidable buildSlidableCardLaporanWarga(int index, BuildContext context) {
    return Slidable(
      // actionPane: SlidableDrawerActionPane(),
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            label: 'delete',
            backgroundColor: Colors.blue,
            icon: Icons.delete_forever_outlined,
            onPressed: (context) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.blue,
                content: Text(
                  '${CardLaporanWargaModel.getAllLaporan[index].noTicket} delete',
                  textAlign: TextAlign.center,
                ),
              ));
            },
          )
        ],
      ),

      child: CardLaporanWarga(
        // 7 digit kode
        noTicket: CardLaporanWargaModel.getAllLaporan[index].noTicket,
        judul: CardLaporanWargaModel.getAllLaporan[index].judul,
        status: CardLaporanWargaModel.getAllLaporan[index].status,
      ),
    );
  }

  Visibility buildVisibilityHeaderCard() {
    return Visibility(
      visible: true,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.0.w, vertical: 2.0.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'No tickets',
              style: TextStyle(fontSize: 8.0.sp, color: Colors.grey),
            ),
            Text(
              'Title',
              style: TextStyle(fontSize: 8.0.sp, color: Colors.grey),
            ),
            Text(
              'Status',
              style: TextStyle(fontSize: 8.0.sp, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  BlocBuilder buildVisibilityQuickGuide() {
    return BlocBuilder<ReportScreenBloc, ReportState>(
      builder: (context, state) => Visibility(
        visible: state.isVisibileGuide,
        child: Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 5.0.w),
            width: 85.0.w,
            decoration: BoxDecoration(
                color: Colors.yellow[700],
                borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Quick Guide',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.0.sp,
                          fontWeight: FontWeight.bold),
                    ),
                    Material(
                        color: Colors.transparent,
                        child: SizedBox(
                          height: 5.0.h,
                          width: 10.0.w,
                          child: InkWell(
                            splashColor: Colors.indigo,
                            borderRadius: BorderRadius.circular(20),
                            child: Icon(
                              Icons.clear_rounded,
                              color: Colors.white,
                            ),
                            onTap: () {
                              blocScreenReport
                                  .add(ReportEvent(isVisibileGuide: false));
                            },
                          ),
                        ))
                  ],
                ),
                Divider(
                  color: Colors.white,
                  thickness: 1.2,
                ),
                Column(
                  children: [
                    Text(
                      'Ini adalah bagian untuk membuat laporan, silahkan klik tombol (+) masukan judul, dan isi laporan beserta gambar kemudian laporan akan segera kami proses.',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 10.0.sp),
                    ),
                    SizedBox(
                      height: 1.5.h,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox buildSizeBoxFloatingActionButton(BuildContext context) {
    return SizedBox(
      height: 7.0.h,
      child: FittedBox(
        child: FloatingActionButton(
          heroTag: 'btn1',
          child: Icon(
            Icons.add,
            size: 4.0.h,
          ),
          backgroundColor: Colors.lightBlue,
          splashColor: Colors.indigo,
          onPressed: () {
            showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (context) {
                return CreateReportScreen();
              },
            );
          },
        ),
      ),
    );
  }
}
