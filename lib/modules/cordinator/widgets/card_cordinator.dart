import 'package:aplikasi_rw/utils/size_config.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../utils/view_image.dart';
import '../../contractor/screens/complaint/process_report.dart';

class CardCordinator extends StatefulWidget {
  CardCordinator({
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
  State<CardCordinator> createState() => _CardWorkerState();
}

class _CardWorkerState extends State<CardCordinator> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 800));
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.width(16), vertical: SizeConfig.height(16)),
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
                width: SizeConfig.width(148),
                child: Text(
                  widget.title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                  style: TextStyle(
                    fontSize: SizeConfig.text(19),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.width(8),
                    vertical: SizeConfig.height(2)),
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
                                : (widget.status.isCaseInsensitiveContainsAny(
                                        'Selesai'))
                                    ? Color(0xff5AFD79)
                                    : Color(
                                        0xffFF6A6A,
                                      ),
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
                              : widget.status
                                      .isCaseInsensitiveContainsAny('Selesai')
                                  ? Color(0xffD6FFDD)
                                  : Color(0xffFFC9C9),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    widget.status,
                    overflow: TextOverflow.ellipsis,
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
                                  : (widget.status.isCaseInsensitiveContainsAny(
                                          'Selesai'))
                                      ? Color(0xff20F348)
                                      : Color(
                                          0xffF32020,
                                        ),
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: SizeConfig.height(16),
          ),
          Divider(
            thickness: 1,
          ),
          SizedBox(
            height: SizeConfig.height(16),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Get.to(
                  () => ViewImage(urlImage: '${widget.image}'),
                ),
                child: Container(
                  width: SizeConfig.width(70),
                  height: SizeConfig.height(70),
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
                width: SizeConfig.width(16),
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
                          'assets/img/estate_manager_menu/location-marker-em.svg',
                          width: SizeConfig.width(16),
                          height: SizeConfig.height(16),
                        ),
                        SizedBox(
                          width: SizeConfig.width(8),
                        ),
                        Expanded(
                          child: Text(
                            widget.address,
                            maxLines: 5,
                            style: TextStyle(
                              fontSize: SizeConfig.text(14),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: SizeConfig.height(8),
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
                              height: SizeConfig.height(16),
                              width: SizeConfig.width(16),
                            ),
                            SizedBox(width: SizeConfig.width(4)),
                            Text(
                              'Lihat peta lokasi',
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: SizeConfig.text(10),
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
            height: SizeConfig.height(8),
          ),
          Text.rich(
            TextSpan(
              text: 'Waktu laporan : ',
              style: TextStyle(
                fontSize: SizeConfig.text(10),
                fontWeight: FontWeight.w400,
              ),
              children: [
                TextSpan(
                  text: widget.waktu,
                  style: TextStyle(
                    fontSize: SizeConfig.text(12),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: SizeConfig.height(16),
          ),
          ElevatedButton.icon(
            onPressed: widget.onTap,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            icon: Icon(Icons.phone, size: SizeConfig.height(16)),
            label: Text(
              'Manager Kontraktor',
              style: TextStyle(
                fontSize: SizeConfig.text(14),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
