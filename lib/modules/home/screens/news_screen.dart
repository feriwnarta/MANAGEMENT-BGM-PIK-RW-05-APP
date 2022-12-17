import 'package:aplikasi_rw/screen/report_screen2/view_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:sizer/sizer.dart' as z;

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
            expandedHeight: 250.h,
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
                    padding: EdgeInsets.only(right: 10.w, top: 10.h),
                    child: Text(
                      writerAndTime,
                      style:
                          TextStyle(fontFamily: 'Montserrat', fontSize: 9.0.sp),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                // caption
                Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.0.h),
                    child: Text(
                      caption,
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontFamily: 'poppins'),
                    )),
                SizedBox(
                  height: 10.h,
                ),

                Divider(
                  thickness: 2,
                  indent: 120.w,
                  endIndent: 120.w,
                ),

                // body
                Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.7.h),
                  child: Text(
                    content,
                    style: TextStyle(
                        fontFamily: 'Montserrat', height: 2, fontSize: 12.sp),
                  ),
                ),

                SizedBox(
                  height: 20.h,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
