import 'package:aplikasi_rw/modules/theme/sizer.dart';
import 'package:aplikasi_rw/utils/size_config.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  Menu({Key key, this.icon, this.text, this.onTap}) : super(key: key);

  final String icon, text;

  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: (75 / Sizer.slicingWidth) * SizeConfig.widthMultiplier,
        child: Column(
          children: [
            Container(
              width: (70 / Sizer.slicingWidth) * SizeConfig.widthMultiplier,
              height: (62 / Sizer.slicingHeight) * SizeConfig.heightMultiplier,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(icon),
                ),
              ),
            ),
            SizedBox(
              height: (8 / Sizer.slicingHeight) * SizeConfig.heightMultiplier,
            ),
            AutoSizeText(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: (12 / Sizer.slicingText) * SizeConfig.textMultiplier,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              minFontSize: 10,
            ),
          ],
        ),
      ),
    );
  }
}
