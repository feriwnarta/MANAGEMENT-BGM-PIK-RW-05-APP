import 'package:aplikasi_rw/modules/theme/sizer.dart';
import 'package:aplikasi_rw/utils/size_config.dart';
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
    return Container(
      margin: EdgeInsets.only(
        left: SizeConfig.width(16),
        right: SizeConfig.width(32),
        bottom: SizeConfig.height(20),
      ),
      child: GestureDetector(
        child: Card(
          margin: EdgeInsets.all(0),
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height:
                      (8 / Sizer.slicingHeight) * SizeConfig.heightMultiplier,
                ),
                Row(
                  children: [
                    SizedBox(
                      width:
                          (8 / Sizer.slicingWidth) * SizeConfig.widthMultiplier,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: FadeInImage(
                        imageErrorBuilder: (BuildContext context,
                            Object exception, StackTrace stackTrace) {
                          print('Error Handler');
                          return Container(
                            width: (70 / Sizer.slicingWidth) *
                                SizeConfig.widthMultiplier,
                            height: (70 / Sizer.slicingHeight) *
                                SizeConfig.heightMultiplier,
                            child: Icon(Icons.error),
                          );
                        },
                        placeholder: image,
                        image: CachedNetworkImageProvider(urlImageReport),
                        fit: BoxFit.cover,
                        width: (70 / Sizer.slicingWidth) *
                            SizeConfig.widthMultiplier,
                        height: (70 / Sizer.slicingHeight) *
                            SizeConfig.heightMultiplier,
                      ),
                    ),
                    SizedBox(
                      width: (16 / Sizer.slicingWidth) *
                          SizeConfig.widthMultiplier,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              noTicket,
                              style: TextStyle(
                                  fontSize: (10 / Sizer.slicingText) *
                                      SizeConfig.textMultiplier,
                                  color: Color(0xff2094F3),
                                  overflow: TextOverflow.clip),
                            ),
                            SizedBox(
                              width: (76 / Sizer.slicingWidth) *
                                  SizeConfig.widthMultiplier,
                            ),
                            Container(
                              width: (78 / Sizer.slicingWidth) *
                                  SizeConfig.widthMultiplier,
                              padding: EdgeInsets.symmetric(
                                vertical: (2 / Sizer.slicingHeight) *
                                    SizeConfig.heightMultiplier,
                              ),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: (status == 'Menunggu')
                                      ? Color(0xffEEB4B0)
                                      : (status == 'Diproses')
                                          ? Color(0xffEECEB0)
                                          : (status == 'Selesai')
                                              ? Color(0xffB8DBCA)
                                              : (status == 'Diterima')
                                                  ? Color(0xffB1C5F6)
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
                                            : (status == 'Diterima')
                                                ? Color(0xffF0F3FF)
                                                : Color(0xffFFC9C9)
                                                    .withOpacity(0.5),
                              ),
                              child: Text(
                                status,
                                style: TextStyle(
                                  fontSize: (12 / Sizer.slicingText) *
                                      SizeConfig.textMultiplier,
                                  color: (status == 'Eskalasi tingkat 1' ||
                                          status == 'Eskalasi tingkat 2' ||
                                          status == 'Eskalasi tingkat 3')
                                      ? Color(0xffF32020)
                                      : (status == 'Menunggu')
                                          ? Color(0xffCB3A31)
                                          : (status == 'Diproses')
                                              ? Color(0xff734011)
                                              : (status == 'Selesai')
                                                  ? Color(0xff20573D)
                                                  : (status == 'Diterima')
                                                      ? Color(0xff4C4DDC)
                                                      : Colors.black,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: (125 / Sizer.slicingWidth) *
                              SizeConfig.widthMultiplier,
                          height: (42 / Sizer.slicingHeight) *
                              SizeConfig.heightMultiplier,
                          child: Text(
                            (description.isEmpty)
                                ? 'Laporan tentang : ' + category
                                : description,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: (12 / Sizer.slicingText) *
                                    SizeConfig.textMultiplier),
                          ),
                        ),
                        SizedBox(
                          width: (125 / Sizer.slicingWidth) *
                              SizeConfig.widthMultiplier,
                          child: Text(
                            time,
                            style: TextStyle(
                              fontSize: (10 / Sizer.slicingText) *
                                  SizeConfig.textMultiplier,
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
                  height:
                      (8 / Sizer.slicingHeight) * SizeConfig.heightMultiplier,
                )
              ],
            ),
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
