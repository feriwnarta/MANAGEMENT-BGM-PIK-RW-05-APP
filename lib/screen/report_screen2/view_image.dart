import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//ignore: must_be_immutable
class ViewImage extends StatelessWidget {
  String urlImage;

  ViewImage({this.urlImage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: Colors.black,
        child: Center(
          child: InteractiveViewer(
            panEnabled: true,
            boundaryMargin: EdgeInsets.all(0),
            scaleEnabled: true,
            minScale: 1,
            maxScale: 2.5,
            child: CachedNetworkImage(
              imageUrl: urlImage,
              width: double.infinity,
              height: 500.h,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
