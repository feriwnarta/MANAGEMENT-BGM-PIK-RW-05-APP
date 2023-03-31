import 'package:aplikasi_rw/server-app.dart';
import 'package:aplikasi_rw/utils/size_config.dart';
import 'package:aplikasi_rw/utils/view_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

//ignore: must_be_immutable
class ReadInformasiUmum extends StatelessWidget {
  ReadInformasiUmum({Key key, this.url, this.content, this.title})
      : super(key: key);
  String url, title, content;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Informasi Umum'),
        titleTextStyle: Theme.of(context).appBarTheme.titleTextStyle,
        systemOverlayStyle: Theme.of(context).appBarTheme.systemOverlayStyle,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.width(16),
              vertical: SizeConfig.height(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () => Get.to(
                    ViewImage(
                      urlImage: '${ServerApp.url}$url',
                    ),
                  ),
                  child: Container(
                    height: SizeConfig.image(188),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image:
                            CachedNetworkImageProvider('${ServerApp.url}$url'),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.height(16),
                ),
                Text(
                  '$title',
                  style: TextStyle(
                    fontSize: SizeConfig.text(22),
                    fontWeight: FontWeight.w700,
                    fontFamily: 'inter',
                  ),
                ),
                SizedBox(
                  height: SizeConfig.height(16),
                ),
                Text(
                  '$content',
                  style: TextStyle(fontSize: SizeConfig.text(16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
