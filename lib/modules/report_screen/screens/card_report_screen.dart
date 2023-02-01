import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'card_laporan_view.dart';

//ignore: must_be_immutable
class CardReportScreen extends StatelessWidget {
  String urlImageReport,
      noTicket,
      description,
      additionalInformation,
      location,
      time,
      category,
      categoryIcon,
      status,
      latitude,
      idReport,
      idUser,
      longitude,
      star,
      comment,
      statusWorking,
      photoProcess1,
      photoProcess2,
      photoComplete1,
      photoComplete2;
  List<dynamic> dataKlasifikasi;

  CardReportScreen(
      {this.urlImageReport,
      this.noTicket,
      this.description,
      this.location,
      this.time,
      this.additionalInformation,
      this.status,
      this.categoryIcon,
      this.category,
      this.idReport,
      this.latitude,
      this.idUser,
      this.longitude,
      this.star,
      this.comment,
      this.dataKlasifikasi,
      this.statusWorking,
      this.photoComplete1,
      this.photoComplete2,
      this.photoProcess1,
      this.photoProcess2});

  final AssetImage image = AssetImage('assets/img/loading.gif');

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 800));
    precacheImage(image, context);
    return Center(
      child: Container(
        // padding: EdgeInsets.only(bottom: 10),
        // height: 86.h,
        margin: EdgeInsets.only(bottom: 20.h),
        width: 328.w,
        child: GestureDetector(
          child: Card(
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 8.h,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 8.w,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: FadeInImage(
                        imageErrorBuilder: (BuildContext context,
                            Object exception, StackTrace stackTrace) {
                          print('Error Handler');
                          return Container(
                            width: 70.w,
                            height: 70.h,
                            child: Icon(Icons.error),
                          );
                        },
                        placeholder: image,
                        image: CachedNetworkImageProvider(urlImageReport),
                        fit: BoxFit.cover,
                        width: 70.w,
                        height: 70.h,
                      ),
                    ),
                    SizedBox(
                      width: 16.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              noTicket,
                              style: TextStyle(
                                  fontSize: 10.sp, color: Color(0xff2094F3)),
                            ),
                            SizedBox(
                              width: 76.w,
                            ),
                            Container(
                              width: 78.w,
                              padding: EdgeInsets.symmetric(
                                  vertical: 2.h, horizontal: 8.w),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: (status == 'Menunggu')
                                      ? Color(0xffEEB4B0)
                                      : (status == 'Diproses')
                                          ? Color(0xffEECEB0)
                                          : (status == 'Selesai')
                                              ? Color(0xffB8DBCA)
                                              : Color(
                                                  0xffFF6A6A,
                                                ),
                                ),
                                borderRadius: BorderRadius.circular(6),
                                color: (status == 'Menunggu')
                                    ? Color(0xffEEB4B0).withOpacity(0.5)
                                    : (status == 'Diproses')
                                        ? Color(0xffEECEB0).withOpacity(0.5)
                                        : (status == 'Selesai')
                                            ? Color(0xffB8DBCA).withOpacity(0.5)
                                            : Color(0xffFFC9C9)
                                                .withOpacity(0.5),
                              ),
                              child: AutoSizeText(
                                status,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: (status == 'Eskalasi tingkat 1' ||
                                          status == 'Eskalasi tingkat 2' ||
                                          status == 'Eskalasi tingkat 3')
                                      ? Color(0xffF32020)
                                      : Colors.black,
                                ),
                                overflow: TextOverflow.ellipsis,
                                minFontSize: 11,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 125.w,
                          height: 42.h,
                          child: AutoSizeText(
                            (description.isEmpty)
                                ? 'Laporan tentang : ' + category
                                : description,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12.sp),
                            minFontSize: 12,
                          ),
                        ),
                        SizedBox(
                          width: 125.w,
                          child: Text(
                            time,
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: Color(0xff9E9E9E),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 8.h,
                )
              ],
            ),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CardLaporanView(
                    noTicket: noTicket,
                    additionalInformation: additionalInformation,
                    description: description,
                    urlImage: urlImageReport,
                    status: status,
                    time: time,
                    category: category,
                    categoryIcon: categoryIcon,
                    latitude: latitude,
                    longitude: longitude,
                    idReport: idReport,
                    idUser: idUser,
                    dataKlasifikasi: dataKlasifikasi,
                    photoComplete1: photoComplete1,
                    photoComplete2: photoComplete2,
                    photoProcess1: photoProcess1,
                    photoProcess2: photoProcess2,
                    statusWorking: statusWorking,
                    star: star,
                    comment: comment,
                  ),
                ));
          },
        ),
      ),
    );
  }
}
