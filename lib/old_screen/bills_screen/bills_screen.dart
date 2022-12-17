import 'package:aplikasi_rw/bloc/bills_tab_bloc.dart';
import 'package:aplikasi_rw/model/bills_tab_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sizer/sizer.dart';

class BillScreen extends StatefulWidget {
  @override
  State<BillScreen> createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> with TickerProviderStateMixin {
  TabController controller;

  // bloc
  BillTabColorBloc bloc;

  var _future;

  @override
  void initState() {
    super.initState();
    _future = BillEventServices.getTab();
  }

  @override
  void dispose() {
    super.dispose();
    if (controller != null) {
      controller.dispose();
    }
  }

  int initIndex = 0;

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<BillTabColorBloc>(context);

    return BlocBuilder<BillTabColorBloc, TabState>(
        builder: (context, state) => FutureBuilder<List<BillTab>>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                controller = TabController(
                  length: snapshot.data.length,
                  initialIndex: initIndex,
                  vsync: this,
                );

                controller.addListener(() {
                  bloc.add(
                      TabEvent(index: controller.index, tab: snapshot.data));
                });

                return Scaffold(
                    appBar: PreferredSize(
                      preferredSize: Size.fromHeight(18.h),
                      child: AppBar(
                        brightness: Brightness.light,
                        backgroundColor:
                            snapshot.data[controller.index].colorsAppBar,
                        flexibleSpace: Container(
                          padding: EdgeInsets.only(bottom: 2.5.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                margin:
                                    EdgeInsets.only(left: 5.0.w, bottom: 2.0.h),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Event',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 26.0.sp,
                                            fontFamily: 'poppins'),
                                      ),
                                      Text(
                                        'Event Warga',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.0.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ]),
                              ),
                            ],
                          ),
                        ),
                        bottom: TabBar(
                            labelPadding:
                                EdgeInsets.symmetric(horizontal: 1.0.w),
                            onTap: (value) {
                              initIndex = value;
                            },
                            controller: controller,
                            labelColor: state.colorsText,
                            indicatorColor: Colors.white,
                            labelStyle: TextStyle(fontWeight: FontWeight.bold),
                            tabs: snapshot.data.map((e) => e.tab).toList()),
                      ),
                    ),
                    body: TabBarView(
                      controller: controller,
                      children: snapshot.data.map((e) => e.screen).toList(),
                    ));
              } else {
                return Container();
              }
            }));
  }
}
