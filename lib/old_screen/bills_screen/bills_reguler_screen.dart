import 'package:aplikasi_rw/bloc/bills_reguler_screen_bloc.dart';
import 'package:aplikasi_rw/model/bills_history_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'details_bill_screen.dart';

//ignore: must_be_immutable
class BillsRegulerScreen extends StatelessWidget {
  bool isExpand = false;

  // bloc
  BillRegulerBloc bloc;

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<BillRegulerBloc>(context);

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 1.h,
          ),
          buildContainerCardBills(context),
          Container(
            margin: EdgeInsets.only(top: 1.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 5.0.w, vertical: 1.0.h),
                  child: Text(
                    'Previous Bill',
                    style: TextStyle(fontSize: 13.0.sp, fontFamily: 'poppins'),
                  ),
                ),
                Center(child: buildContainerPreviousBill()),
                SizedBox(
                  height: 1.0.h,
                ),
                Container(
                  child: Column(
                    children: [
                      buildListTileBottomStatus(Icons.notifications_none,
                          'Bill Reminder', '3 Maret 2022'),
                      buildListTileBottomStatus(Icons.email_outlined,
                          'Send E-Bill', 'example@gmail.com'),
                      buildListTileBottomStatus(
                          FontAwesomeIcons.questionCircle, 'Help', 'FAQ'),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  ListTile buildListTileBottomStatus(
      IconData icon, String description, String status) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 3.0.w),
      title: Row(
        children: [
          Icon(
            icon,
            color: Colors.black,
            size: 20,
          ),
          SizedBox(
            width: 1.0.w,
          ),
          Text(
            description,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11.0.sp),
          ),
        ],
      ),
      trailing: Text(
        status,
        style: TextStyle(color: Colors.grey, fontSize: 11.0.sp),
      ),
      onTap: () {},
    );
  }

  Container buildContainerPreviousBill() {
    return Container(
      width: 95.0.w,
      height: 45.0.h,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey[400])),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          margin: EdgeInsets.only(bottom: 1.0.h, left: 0.2.w, right: 0.2.w),
          child: SingleChildScrollView(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BlocBuilder<BillRegulerBloc, List<BillsHistoryModel>>(
                builder: (context, state) => ExpansionPanelList(
                  expansionCallback: (panelIndex, isExpanded) {
                    bloc.add(BillRegulerEvent(
                        index: panelIndex, isExpanded: !isExpanded));
                  },
                  children: state
                      .map<ExpansionPanel>((items) => ExpansionPanel(
                          isExpanded: items.isExpanded,
                          canTapOnHeader: true,
                          headerBuilder: (context, isExpanded) => ListTile(
                                title: Text(
                                  '${items.month} ${items.year}',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 12.0.sp,
                                  ),
                                ),
                                subtitle: Text(
                                  '${items.total} IDR',
                                  style: TextStyle(fontFamily: 'Roboto'),
                                ),
                              ),
                          body: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: items.billsHistoryBody.length,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            reverse: true,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                      '${items.billsHistoryBody[index].description}',
                                      style: TextStyle(
                                          fontFamily: 'saira condensed',
                                          fontSize: 13.0.sp,
                                          color: Colors.blue[800]),
                                    ),
                                    subtitle: Text(
                                        '${items.billsHistoryBody[index].date}-${items.billsHistoryBody[index].month}-${items.billsHistoryBody[index].year}'),
                                    trailing: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color:
                                            Colors.green[100].withOpacity(0.5),
                                      ),
                                      padding: EdgeInsets.all(5),
                                      child: Text(
                                        '${items.billsHistoryBody[index].price} IDR',
                                        style: TextStyle(
                                            color: Colors.green[900],
                                            fontSize: 10.0.sp),
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    thickness: 1,
                                    height: 1,
                                  )
                                ],
                              );
                            },
                          )))
                      .toList(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container buildContainerCardBills(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.0.w, vertical: 2.0.h),
      width: 95.0.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xff2297F4), Color(0xff3ABBFD)])),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: 6.0.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('My bill',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0.sp,
                            fontWeight: FontWeight.bold)),
                    Text(
                      'March 2022',
                      style: TextStyle(color: Colors.white, fontSize: 10.0.sp),
                    )
                  ],
                ),
                VerticalDivider(
                  color: Colors.white,
                  // width: 50,
                  thickness: 1,
                  endIndent: 8,
                ),
                Text(
                  '3.500.000 IDR',
                  style: TextStyle(color: Colors.white, fontSize: 16.0.sp),
                )
              ],
            ),
          ),
          Divider(
            color: Colors.white,
            thickness: 1,
          ),
          Padding(
            padding: EdgeInsets.only(top: 1.0.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 40.0.w,
                  height: 4.0.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        foregroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        side: BorderSide(color: Colors.white)),
                    child: Text('See Details'),
                    onPressed: () {
                      showModalBottomSheet(
                          backgroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                          ),
                          isScrollControlled: true,
                          context: context,
                          builder: (context) => DetailsBillScreen());
                    },
                  ),
                ),
                SizedBox(
                  width: 40.0.w,
                  height: 4.0.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    child: Text(
                      'Pay off now',
                      style: TextStyle(
                          color: Colors.indigo, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {},
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
