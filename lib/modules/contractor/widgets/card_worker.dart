import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../utils/view_image.dart';
import '../screens/complaint/process_report.dart';

class CardWorker extends StatefulWidget {
  CardWorker({
    Key key,
    this.title,
    this.status,
    this.image,
    this.address,
    this.lat,
    this.long,
    this.waktu,
    this.onTap,
    this.cordinatorPhone,
  }) : super(key: key);

  final String title, status, image, address, lat, long, waktu;
  final List<Map<String, dynamic>> cordinatorPhone;
  Function onTap;

  @override
  State<CardWorker> createState() => _CardWorkerState();
}

class _CardWorkerState extends State<CardWorker> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), //shadow color
            spreadRadius: 0.5, // spread radius
            blurRadius: 2, // shadow blur radius
            offset: const Offset(0, 0), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 148.w,
                child: AutoSizeText(
                  widget.title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                  style: TextStyle(
                    fontSize: 19.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                width: 103.w,
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: (widget.status
                            .isCaseInsensitiveContainsAny('Menunggu'))
                        ? Color(
                            0xffFF6A6A,
                          )
                        : widget.status.isCaseInsensitiveContainsAny('Diterima')
                            ? Color(0xff90C5F0)
                            : widget.status
                                    .isCaseInsensitiveContainsAny('Diproses')
                                ? Color(0xffFCC870)
                                : Color(0xff5AFD79),
                  ),
                  color: (widget.status
                          .isCaseInsensitiveContainsAny('Menunggu'))
                      ? Color(
                          0xffFFC9C9,
                        )
                      : widget.status.isCaseInsensitiveContainsAny('Diterima')
                          ? Color(0xffF2F9FF)
                          : widget.status
                                  .isCaseInsensitiveContainsAny('Diproses')
                              ? Color(0xffFFEBC9)
                              : Color(0xffD6FFDD),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: AutoSizeText(
                    widget.status,
                    overflow: TextOverflow.ellipsis,
                    minFontSize: 10,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: (widget.status
                              .isCaseInsensitiveContainsAny('Menunggu'))
                          ? Color(
                              0xffF32020,
                            )
                          : widget.status
                                  .isCaseInsensitiveContainsAny('Diterima')
                              ? Color(0xff2094F3)
                              : widget.status
                                      .isCaseInsensitiveContainsAny('Diproses')
                                  ? Color(0xffF3A520)
                                  : Color(0xff20F348),
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 16.h,
          ),
          Divider(
            thickness: 1,
          ),
          SizedBox(
            height: 16.h,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Get.to(
                  () => ViewImage(urlImage: '${widget.image}'),
                ),
                child: Container(
                  width: 70.w,
                  height: 70.h,
                  child: CachedNetworkImage(
                    imageUrl: '${widget.image}',
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.low,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) =>
                            CircularProgressIndicator(
                                value: downloadProgress.progress),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
              SizedBox(
                width: 16.w,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                            'assets/img/estate_manager_menu/location-marker-em.svg'),
                        SizedBox(
                          width: 8.w,
                        ),
                        Expanded(
                          child: AutoSizeText(
                            widget.address,
                            maxLines: 5,
                            style: TextStyle(
                              fontSize: 14.sp,
                            ),
                            minFontSize: 10,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Material(
                      child: InkWell(
                        splashColor: Colors.grey[200],
                        onTap: () {
                          ProcessReportScreen.navigateTo(
                              double.parse(widget.lat),
                              double.parse(widget.long));
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              'assets/img/image-svg/Icon-map.svg',
                            ),
                            SizedBox(width: 4.w),
                            AutoSizeText(
                              'Lihat peta lokasi',
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: Color(0xff2094F3),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 8.h,
          ),
          AutoSizeText.rich(
            TextSpan(
              text: 'Waktu laporan : ',
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w400,
              ),
              children: [
                TextSpan(
                  text: widget.waktu,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 16.h,
          ),
          ElevatedButton(
            onPressed: widget.onTap,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            child: Text(
              'Detail Laporan',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
