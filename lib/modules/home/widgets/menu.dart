import 'package:aplikasi_rw/utils/size_config.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Menu extends StatelessWidget {
  Menu({Key key, this.icon, this.text, this.onTap}) : super(key: key);

  final String icon, text;

  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: (75 / SizeConfig.widthMultiplier) * SizeConfig.widthMultiplier,
        child: Column(
          children: [
            Container(
              width: (70 / SizeConfig.widthMultiplier) *
                  SizeConfig.widthMultiplier,
              height: (62 / SizeConfig.heightMultiplier) *
                  SizeConfig.heightMultiplier,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(icon),
                ),
              ),
            ),
            SizedBox(
              height: (8 / SizeConfig.heightMultiplier) *
                  SizeConfig.heightMultiplier,
            ),
            AutoSizeText(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: (12 / SizeConfig.textMultiplier) *
                    SizeConfig.textMultiplier,
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
