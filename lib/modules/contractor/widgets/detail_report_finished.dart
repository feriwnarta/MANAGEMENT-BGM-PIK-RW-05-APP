import 'package:aplikasi_rw/modules/contractor/data/detail_laporan_selesai_model.dart';
import 'package:aplikasi_rw/modules/contractor/services/detail_laporan_selesai_service.dart';
import 'package:aplikasi_rw/server-app.dart';
import 'package:aplikasi_rw/utils/view_image.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:timeline_tile/timeline_tile.dart';

class DetailLaporanSelesai extends StatefulWidget {
  const DetailLaporanSelesai({Key key, this.idReport}) : super(key: key);

  final String idReport;

  @override
  State<DetailLaporanSelesai> createState() => _DetailLaporanSelesaiState();
}

class _DetailLaporanSelesaiState extends State<DetailLaporanSelesai> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 800));
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail laporan selesai'),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: FutureBuilder<DetailLaporanSelesaiModel>(
        future:
            DetailLaporanSelesaiSevices.getDetail(idReport: widget.idReport),
        builder: (context, snapshot) => (snapshot.hasData)
            ? SingleChildScrollView(
                child: Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        'Laporan telah selesai dikerjakan oleh kontraktor lapangan.',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Color(0xff616161),
                        ),
                        maxLines: 3,
                        minFontSize: 15,
                        overflow: TextOverflow.clip,
                      ),
                      SizedBox(
                        height: 32.h,
                      ),
                      AutoSizeText(
                        'Foto laporan diproses',
                        style: TextStyle(
                          fontSize: 14.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        minFontSize: 13,
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Visibility(
                            visible: snapshot.data.imageProcess1 != null &&
                                    snapshot.data.imageProcess1.isNotEmpty
                                ? true
                                : false,
                            child: GestureDetector(
                              onTap: () => Get.to(
                                () => ViewImage(
                                  urlImage:
                                      '${ServerApp.url}${snapshot.data.imageProcess1}',
                                ),
                                transition: Transition.fadeIn,
                              ),
                              child: CachedNetworkImage(
                                imageUrl:
                                    '${ServerApp.url}${snapshot.data.imageProcess1}',
                                width: 156.w,
                                height: 156.h,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: (snapshot.data.imageProcess2 != null &&
                                    snapshot.data.imageProcess2.isNotEmpty)
                                ? true
                                : false,
                            child: GestureDetector(
                              onTap: () => Get.to(
                                () => ViewImage(
                                  urlImage:
                                      '${ServerApp.url}${snapshot.data.imageProcess2}',
                                ),
                                transition: Transition.fadeIn,
                              ),
                              child: CachedNetworkImage(
                                imageUrl:
                                    '${ServerApp.url}${snapshot.data.imageProcess2}',
                                width: 156.w,
                                height: 156.h,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 36.h,
                      ),
                      AutoSizeText(
                        'Foto laporan selesai',
                        style: TextStyle(
                          fontSize: 14.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        minFontSize: 13,
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Visibility(
                            visible: snapshot.data.imageComplete1 != null &&
                                    snapshot.data.imageComplete1.isNotEmpty
                                ? true
                                : false,
                            child: GestureDetector(
                              onTap: () => Get.to(
                                () => ViewImage(
                                  urlImage:
                                      '${ServerApp.url}${snapshot.data.imageComplete1}',
                                ),
                                transition: Transition.fadeIn,
                              ),
                              child: CachedNetworkImage(
                                imageUrl:
                                    '${ServerApp.url}${snapshot.data.imageComplete1}',
                                width: 156.w,
                                height: 156.h,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: snapshot.data.imageComplete2 != null &&
                                    snapshot.data.imageComplete2.isNotEmpty
                                ? true
                                : false,
                            child: GestureDetector(
                              onTap: () => Get.to(
                                () => ViewImage(
                                  urlImage:
                                      '${ServerApp.url}${snapshot.data.imageComplete2}',
                                ),
                                transition: Transition.fadeIn,
                              ),
                              child: CachedNetworkImage(
                                imageUrl:
                                    '${ServerApp.url}${snapshot.data.imageComplete2}',
                                width: 156.w,
                                height: 156.h,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 32.h,
                      ),
                      ExpansionTile(
                        tilePadding: EdgeInsets.zero,
                        childrenPadding: EdgeInsets.zero,
                        title: Row(
                          children: [
                            SizedBox(
                              width: 16.w,
                              height: 16.h,
                              child: Image(
                                fit: BoxFit.cover,
                                image: AssetImage('assets/img/clock.jpg'),
                              ),
                            ),
                            SizedBox(
                              width: 8.w,
                            ),
                            Expanded(
                              child: AutoSizeText.rich(
                                TextSpan(
                                  text: 'Selesai dalam ',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: '${snapshot.data.duration}',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                minFontSize: 15,
                              ),
                            )
                          ],
                        ),
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 40.w),
                            child: Column(
                              children: [
                                TimelineTile(
                                  endChild: Container(
                                    child: ListTile(
                                      title: Text(
                                        'Laporan selesai',
                                        style: TextStyle(fontSize: 12.0.sp),
                                      ),
                                      subtitle: Text(
                                        'Laporan selesai',
                                        style: TextStyle(fontSize: 11.0.sp),
                                      ),
                                    ),
                                  ),
                                  isFirst: true,
                                  beforeLineStyle: LineStyle(
                                    color: Color(0xffC2C2C2),
                                    thickness: 1,
                                  ),
                                  afterLineStyle: LineStyle(
                                    color: Color(0xffC2C2C2),
                                    thickness: 1,
                                  ),
                                  indicatorStyle: IndicatorStyle(
                                    width: 12.w,
                                    color: Color(
                                      0xff404040,
                                    ),
                                    iconStyle: IconStyle(
                                      iconData: Icons.check,
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                TimelineTile(
                                  endChild: Container(
                                    margin: EdgeInsets.only(top: 20.h),
                                    child: ListTile(
                                      title: Text(
                                        '1',
                                        style: TextStyle(fontSize: 12.0.sp),
                                      ),
                                      subtitle: Text(
                                        '1',
                                        style: TextStyle(fontSize: 11.0.sp),
                                      ),
                                    ),
                                  ),
                                  beforeLineStyle: LineStyle(
                                    color: Color(0xffC2C2C2),
                                    thickness: 1,
                                  ),
                                  afterLineStyle: LineStyle(
                                    color: Color(0xffC2C2C2),
                                    thickness: 1,
                                  ),
                                  indicatorStyle: IndicatorStyle(
                                      color: Color(0xffC2C2C2), width: 12.w),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Image(
                            width: 16.w,
                            height: 16.h,
                            image: AssetImage(
                              'assets/img/star.jpg',
                            ),
                            fit: BoxFit.cover,
                          ),
                          SizedBox(
                            width: 8.w,
                          ),
                          Expanded(
                            child: AutoSizeText(
                              '${snapshot.data.star} Bintang',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Color(0xff404040),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.clip,
                              minFontSize: 13,
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: snapshot.data.complaint
                            .map<Widget>((e) => Padding(
                                  padding: EdgeInsets.only(top: 24.h),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/img/image-svg/shield-exclamation.svg',
                                      ),
                                      SizedBox(
                                        width: 8.w,
                                      ),
                                      Expanded(
                                        child: AutoSizeText(
                                          '$e',
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color: Color(0xff404040),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.clip,
                                          minFontSize: 13,
                                        ),
                                      )
                                    ],
                                  ),
                                ))
                            .toList(),
                      ),
                      SizedBox(
                        height: 24.h,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            'assets/img/image-svg/location-marker-complaint.svg',
                            height: 16.h,
                            width: 16.w,
                          ),
                          SizedBox(
                            width: 8.w,
                          ),
                          Expanded(
                            child: AutoSizeText(
                              'Jalan Marina Indah Raya No.1 ​Pantai Indah Kapuk, RT.7/RW.2, Kamal Muara, Kec. Penjaringan, Kota Jkt Utara, Daerah Khusus Ibukota Jakarta 14470',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Color(0xff404040),
                              ),
                              maxLines: 7,
                              overflow: TextOverflow.clip,
                              minFontSize: 13,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              )
            : LinearProgressIndicator(),
      ),
    );
  }
}
