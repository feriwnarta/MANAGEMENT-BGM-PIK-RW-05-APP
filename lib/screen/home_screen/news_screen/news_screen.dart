import 'package:aplikasi_rw/screen/report_screen2/view_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sizer/sizer.dart' as z;

class NewsScreen extends StatelessWidget {
  final String urlImage, caption, content, writerAndTime;

  NewsScreen({this.urlImage, this.caption, this.content, this.writerAndTime});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            brightness: Brightness.dark,
            expandedHeight: 30.0.h,
            floating: true,
            pinned: true,
            snap: true,
            actionsIconTheme: IconThemeData(opacity: 0.0),
            flexibleSpace: Stack(
              children: <Widget>[
                Positioned.fill(
                    child: GestureDetector(
                  child: CachedNetworkImage(
                    imageUrl: urlImage,
                    fit: BoxFit.cover,
                    repeat: ImageRepeat.noRepeat,
                    placeholder: (context, _) => Container(
                      color: Colors.grey,
                    ),
                    errorWidget: (context, url, _) => Container(
                      color: Colors.grey,
                      child: Icon(
                        Icons.error,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ViewImage(
                      urlImage: urlImage,
                    ),
                  )),
                ))
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.only(right: 1.5.w, top: 1.0.h),
                    child: Text(
                      writerAndTime,
                      style:
                          TextStyle(fontFamily: 'Montserrat', fontSize: 9.0.sp),
                    ),
                  ),
                ),
                // caption
                Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: 4.0.w, vertical: 2.0.h),
                    child: Text(
                      caption,
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontFamily: 'poppins'),
                    )),

                Divider(
                  thickness: 3,
                  indent: 40.0.w,
                  endIndent: 40.0.w,
                ),

                // body
                Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 2.7.h),
                  child: Text(
                    content,
                    style: TextStyle(
                        fontFamily: 'Montserrat', height: 2, fontSize: 12.sp),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
