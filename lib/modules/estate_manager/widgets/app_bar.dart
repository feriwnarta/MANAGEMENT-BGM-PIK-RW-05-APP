import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class AppBarEm extends StatelessWidget {
  const AppBarEm({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 800));
    return Container(
      margin: EdgeInsets.only(top: 16.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 16.w,
              ),
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
                image: AssetImage('assets/img/logo_rw.png'),
                fit: BoxFit.cover,
                repeat: ImageRepeat.noRepeat,
              ),
              SizedBox(
                width: 110.w,
              ),
              IconButton(
                  icon: SvgPicture.asset(
                      'assets/img/image-svg/hamburger-menu.svg'),
                  onPressed: () {}),
            ],
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
