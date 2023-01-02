import 'package:aplikasi_rw/modules/home/services/news_service.dart';
import 'package:aplikasi_rw/modules/informasi_warga/screens/read_informasi_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../server-app.dart';
import '../../home/models/card_news.dart';
import 'package:get/get.dart';

class InformasiWargaScreen extends StatelessWidget {
  const InformasiWargaScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 800));

    return Scaffold(
      appBar: AppBar(
        title: Text('Informasi Warga'),
        titleTextStyle: TextStyle(fontSize: 19.sp),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              FutureBuilder<List<CardNews>>(
                  future: NewsServices.getNews(),
                  builder: (context, snapshot) => (snapshot.hasData)
                      ? ListView.builder(
                          itemCount: snapshot.data.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (_, index) {
                            return GestureDetector(
                              onTap: () => Get.to(
                                () => ReadInformation(),
                                transition: Transition.rightToLeft,
                                arguments: [
                                  snapshot.data[index].content,
                                ],
                              ),
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                ).copyWith(top: 16.h),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 188.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Image(
                                        fit: BoxFit.cover,
                                        image: CachedNetworkImageProvider(
                                          '${ServerApp.url}${snapshot.data[index].url}',
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8.h,
                                    ),
                                    Divider(
                                      thickness: 1,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          })
                      : CircularProgressIndicator.adaptive()),
              Container(
                height: 20.h,
              )
            ],
          ),
        ),
      ),
    );
  }
}
