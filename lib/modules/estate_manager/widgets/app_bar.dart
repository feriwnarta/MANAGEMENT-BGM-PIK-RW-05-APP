import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppBarEm extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  AppBarEm({Key key, this.scaffoldKey}) : super(key: key);

  final AssetImage image = AssetImage('assets/img/logo_rw.png');

  @override
  Widget build(BuildContext context) {
    precacheImage(image, context);

    ScreenUtil.init(context, designSize: const Size(360, 800));
    return Container(
      margin: EdgeInsets.only(top: 16.h),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'BGM RW 05',
                  style: TextStyle(fontSize: 19.sp, color: Color(0xff485E88)),
                ),
                SizedBox(
                  width: 38.w,
                ),
                Image(
                  width: 34.w,
                  height: 40.h,
                  image: image,
                  fit: BoxFit.cover,
                  repeat: ImageRepeat.noRepeat,
                ),
                SizedBox(
                  width: 147.w,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 12.h,
          ),
          Divider(
            thickness: 2,
          )
        ],
      ),
    );
  }
}
