import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Menu extends StatelessWidget {
  Menu({Key key, this.icon, this.text, this.onTap}) : super(key: key);

  final String icon, text;

  final Function onTap;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 800));
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 70.w,
        child: Column(
          children: [
            Container(
              width: 70.w,
              height: 62.h,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(icon),
                ),
              ),
            ),
            SizedBox(
              height: 8.h,
            ),
            AutoSizeText(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              minFontSize: 12,
            ),
          ],
        ),
      ),
    );
  }
}
