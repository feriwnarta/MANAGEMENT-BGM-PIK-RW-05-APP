import 'package:aplikasi_rw/modules/home/widgets/app_bar_citizen.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../server-app.dart';
import '../models/card_news.dart';
import '../services/news_services.dart';

class HeaderScreen extends StatelessWidget {
  const HeaderScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 800));
    return Column(
      children: [
        SizedBox(
          height: 16.h,
        ),
        AppBarCitizen(),
        SizedBox(
          height: 32.h,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.h),
          child: Row(
            children: [
              SizedBox(
                height: 48.h,
                width: 48.w,
                child: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                        '${ServerApp.url}imageuser/default_profile/blank_profile_picture.jpg')),
              ),
              SizedBox(
                width: 14.w,
              ),
              SizedBox(
                width: 257.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      'Hi, Laura Meldy',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    AutoSizeText(
                      'Akasia golf',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff616161),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 24.h,
        ),
        Divider(
          thickness: 1,
        ),
        SizedBox(
          height: 24.h,
        ),
        FutureBuilder<List<CardNews>>(
          future: NewsServices.getNews(),
          builder: (context, snapshot) => (snapshot.hasData)
              ? CarouselSlider(
                  options: CarouselOptions(
                      height: 188.h,
                      enableInfiniteScroll: false,
                      enlargeCenterPage: false,
                      viewportFraction: 0.9),
                  items: snapshot.data.map((e) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(right: 16.w),
                          child: CachedNetworkImage(
                            imageUrl: '${ServerApp.url}${e.url}',
                          ),
                        );
                      },
                    );
                  }).toList(),
                )
              : CarouselSlider(
                  options: CarouselOptions(
                    height: 188.h,
                    enableInfiniteScroll: false,
                    enlargeCenterPage: false,
                    viewportFraction: 0.9,
                  ),
                  items: [
                    1,
                    2,
                    3,
                  ].map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300],
                          highlightColor: Colors.grey[200],
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(10)),
                            width: MediaQuery.of(context).size.width,
                            height: 188.h,
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
        ),
      ],
    );
  }
}