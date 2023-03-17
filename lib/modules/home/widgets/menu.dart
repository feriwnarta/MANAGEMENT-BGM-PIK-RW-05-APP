import 'package:aplikasi_rw/utils/size_config.dart';
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
        width: SizeConfig.width(75),
        child: Column(
          children: [
            Container(
              width: SizeConfig.width(70),
              height: SizeConfig.height(72),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(icon),
                ),
              ),
            ),
            SizedBox(
              height: SizeConfig.height(8),
            ),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: SizeConfig.text(12),
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
