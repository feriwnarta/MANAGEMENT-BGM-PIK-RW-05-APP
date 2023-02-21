import 'package:aplikasi_rw/controller/user_login_controller.dart';
import 'package:aplikasi_rw/modules/home/services/news_service.dart';
import 'package:aplikasi_rw/modules/home/widgets/app_bar_citizen.dart';
import 'package:aplikasi_rw/modules/informasi_warga/screens/read_informasi_screen.dart';
import 'package:aplikasi_rw/modules/theme/sizer.dart';
import 'package:aplikasi_rw/utils/screen_size.dart';
import 'package:aplikasi_rw/utils/size_config.dart';
import 'package:aplikasi_rw/utils/view_image.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../server-app.dart';
import '../models/card_news.dart';
import 'package:get/get.dart';

//ignore: must_be_immutable
class HeaderScreen extends StatelessWidget {
  HeaderScreen({Key key, this.isEmOrCord}) : super(key: key);

  bool isEmOrCord = false;

  final userLoginController = Get.put(UserLoginController());

  @override
  Widget build(BuildContext context) {
    ScreenSize.designSize(context);

    return Column(
      children: [
        SizedBox(
          height: (16 * Sizer.slicingHeight) / SizeConfig.heightMultiplier,
        ),
        AppBarCitizen(),
        SizedBox(
          height: (32 / Sizer.slicingHeight) * SizeConfig.heightMultiplier,
        ),
        Container(
          margin: EdgeInsets.symmetric(
              horizontal:
                  (16 / Sizer.slicingWidth) * SizeConfig.widthMultiplier),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Get.to(
                    () => ViewImage(
                      urlImage:
                          '${ServerApp.url}${userLoginController.urlProfile.value}',
                    ),
                    transition: Transition.fadeIn,
                  );
                },
                child: SizedBox(
                  height:
                      (48 / Sizer.slicingHeight) * SizeConfig.heightMultiplier,
                  width: (48 / Sizer.slicingWidth) * SizeConfig.widthMultiplier,
                  child: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                        '${ServerApp.url}${userLoginController.urlProfile.value}'),
                  ),
                ),
              ),
              SizedBox(
                width: (14 / Sizer.slicingWidth) * SizeConfig.widthMultiplier,
              ),
              SizedBox(
                width: (257 / Sizer.slicingWidth) * SizeConfig.widthMultiplier,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      '${userLoginController.name.value}',
                      style: TextStyle(
                        fontSize: (16 / Sizer.slicingText) *
                            SizeConfig.textMultiplier,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    (userLoginController.status.value
                            .isCaseInsensitiveContainsAny('WARGA'))
                        ? AutoSizeText(
                            '${userLoginController.cluster.value} ${userLoginController.houseNumber.value}',
                            style: TextStyle(
                              fontSize: (14 / Sizer.slicingText) *
                                  SizeConfig.textMultiplier,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff616161),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          )
                        : AutoSizeText(
                            '${userLoginController.status.value}',
                            style: TextStyle(
                              fontSize: (14 / Sizer.slicingText) *
                                  SizeConfig.textMultiplier,
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
          height: (24 / Sizer.slicingHeight) * SizeConfig.heightMultiplier,
        ),
        Divider(
          thickness: 1,
        ),
        SizedBox(
          height: (24 / Sizer.slicingHeight) * SizeConfig.heightMultiplier,
        ),
        (!isEmOrCord)
            ? FutureBuilder<List<CardNews>>(
                future: NewsServices.getNews(),
                builder: (context, snapshot) => (snapshot.hasData)
                    ? CarouselSlider(
                        options: CarouselOptions(
                          height: (188 / Sizer.slicingHeight) *
                              SizeConfig.heightMultiplier,
                          // aspectRatio: 16 / 2,
                          enableInfiniteScroll: false,
                          enlargeCenterPage: false,
                          viewportFraction: 0.8,
                        ),
                        items: snapshot.data.map((e) {
                          return Builder(
                            builder: (BuildContext context) {
                              return GestureDetector(
                                onTap: () => Get.to(() => ReadInformation(),
                                    transition: Transition.rightToLeft,
                                    arguments: [e.content]),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.only(
                                    right: (16 / Sizer.slicingWidth) *
                                        SizeConfig.widthMultiplier,
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: '${ServerApp.url}${e.url}',
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      )
                    : CarouselSlider(
                        options: CarouselOptions(
                          height: (188 / Sizer.slicingHeight) *
                              SizeConfig.heightMultiplier,
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
                                  height: (188 / Sizer.slicingHeight) *
                                      SizeConfig.heightMultiplier,
                                  margin: EdgeInsets.symmetric(
                                    horizontal: (5 / Sizer.slicingWidth) *
                                        SizeConfig.widthMultiplier,
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
              )
            : SizedBox(),
      ],
    );
  }
}
