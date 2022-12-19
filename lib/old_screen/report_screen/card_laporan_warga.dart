import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../modules/report_screen/screens/card_laporan_view.dart';
import '../../modules/transitions/screens/slide_transition.dart';
import 'card_laporan_warga_edit.dart';

//ignore: must_be_immutable
class CardLaporanWarga extends StatelessWidget {
  String noTicket, judul, status, additionalInformation;

  CardLaporanWarga(
      {this.noTicket, this.judul, this.status, this.additionalInformation});

  Color colorStatusCheck() {
    return (status.toLowerCase() == 'listed')
        ? Colors.grey
        : (status.toLowerCase() == 'noticed'
            ? Colors.yellow[700]
            : Colors.green);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 2,
      child: Material(
        color: Colors.transparent,
        elevation: 0,
        child: InkWell(
          splashColor: Colors.indigo,
          borderRadius: BorderRadius.circular(20),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 3.0.w),
            leading: Padding(
              padding: EdgeInsets.only(top: 3),
              child: Text(
                noTicket,
                style: TextStyle(
                    fontSize: 10.0.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo),
              ),
            ),
            title: Text(
              // 36 kata
              judul,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 10.0.sp, fontWeight: FontWeight.bold),
            ),
            trailing: Text(
              status,
              style: TextStyle(
                  fontSize: 10.0.sp,
                  fontWeight: FontWeight.bold,
                  color: colorStatusCheck()),
            ),
          ),
          onTap: () {
            if (status.toLowerCase() == 'listed') {
              Navigator.of(context).push(SlideTranstionRoute(
                  child: CardLaporanWargaEdit(
                    noTickects: noTicket,
                  ),
                  direction: AxisDirection.right));
            } else {
              Navigator.of(context).push(SlideTranstionRoute(
                  child: CardLaporanView(
                    description: judul,
                    additionalInformation: additionalInformation,
                    noTicket: noTicket,
                  ),
                  direction: AxisDirection.right));
            }
          },
        ),
      ),
    );
  }
}

// ListTile(
//               contentPadding: EdgeInsets.symmetric(horizontal: 4.0.w),
//               leading: Padding(
//                 padding: EdgeInsets.only(top: 1.0.h),
//                 child: Text(
//                   noTicket,
//                   style: TextStyle(
//                       fontSize: 9.0.sp,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.indigo),
//                 ),
//               ),
//               title: Text(
//                 // 36 kata
//                 judul,
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//                 style: TextStyle(fontSize: 9.0.sp, fontWeight: FontWeight.bold),
//               ),
//               trailing: Text(
//                 status,
//                 style: TextStyle(
//                     fontSize: 9.0.sp,
//                     fontWeight: FontWeight.bold,
//                     color: colorStatusCheck()),
//               ),
//             ),
