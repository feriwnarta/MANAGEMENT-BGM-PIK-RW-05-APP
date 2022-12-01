import 'package:aplikasi_rw/screen/report_screen2/card_laporan_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        child: Card(
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.symmetric(horizontal: 2.w),
          child: Column(
            children: [
              SizedBox(
                height: 2.0.h,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 3.0.w,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: FadeInImage(
                      imageErrorBuilder: (BuildContext context,
                          Object exception, StackTrace stackTrace) {
                        print('Error Handler');
                        return Container(
                          width: 25.0.w,
                          height: 12.5.h,
                          child: Icon(Icons.error),
                        );
                      },
                      placeholder: AssetImage('assets/img/loading.gif'),
                      image: CachedNetworkImageProvider(urlImageReport),
                      fit: BoxFit.cover,
                      width: 25.0.w,
                      height: 12.5.h,
                    ),
                  ),
                  SizedBox(width: 5.0.w),
                  Container(
                    height: 10.0.h,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                                width: 60.0.w,
                                child: Text(
                                  noTicket,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 9.0.sp,
                                      color: Colors.indigo,
                                      fontWeight: FontWeight.bold),
                                )),
                          ],
                        ),
                        Container(
                            width: 60.0.w,
                            child: Text(
                              description,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 12.0.sp),
                            )),
                        Container(
                            width: 60.0.w,
                            child: Text(
                              location,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 9.0.sp),
                            )),
                        Container(
                            width: 60.0.w,
                            child: Text(
                              time,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 9.0.sp),
                            )),
                      ],
                    ),
                  )
                ],
              ),
              Container(
                height: 4.0.h,
                width: 20.0.w,
                margin: EdgeInsets.only(left: 70.0.w),
                decoration: BoxDecoration(
                    color: (status.toLowerCase() == 'listed')
                        ? Colors.red
                        : (status.toLowerCase() == 'noticed')
                            ? Colors.yellow[900]
                            : (status.toLowerCase() == 'process')
                                ? Colors.yellow[600]
                                : Colors.green,
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                    child: Text(
                  status,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                )),
              ),
              SizedBox(height: 2.0.h)
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
    );
  }
}
