import 'package:aplikasi_rw/modules/home/services/news_service.dart';
import 'package:aplikasi_rw/modules/informasi_warga/screens/read_informasi_screen.dart';
import 'package:aplikasi_rw/utils/size_config.dart';
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
        titleTextStyle: Theme.of(context).appBarTheme.titleTextStyle,
        systemOverlayStyle: Theme.of(context).appBarTheme.systemOverlayStyle,
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
                                snapshot.data[index].title,
                                snapshot.data[index].url,
                              ],
                            ),
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: SizeConfig.width(16),
                              ).copyWith(top: SizeConfig.height(16)),
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      height: SizeConfig.image(188),
                                      width: double.infinity,
                                      child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl:
                                            '${ServerApp.url}${snapshot.data[index].url}',
                                        progressIndicatorBuilder:
                                            (context, url, downloadProgress) =>
                                                Center(
                                          child: SizedBox(
                                            width: SizeConfig.width(30),
                                            height: SizeConfig.height(35),
                                            child: CircularProgressIndicator
                                                .adaptive(
                                                    value: downloadProgress
                                                        .progress),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: SizeConfig.height(8),
                                  ),
                                  Divider(
                                    thickness: 3,
                                  ),
                                ],
                              ),
                            ),
                          );
                        })
                    : SizedBox(
                        width: SizeConfig.width(30),
                        height: SizeConfig.height(35),
                        child: CircularProgressIndicator.adaptive()),
              ),
              Container(
                height: SizeConfig.height(20),
              )
            ],
          ),
        ),
      ),
    );
  }
}
