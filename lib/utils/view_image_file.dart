import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//ignore: must_be_immutable
class ViewImageFile extends StatelessWidget {
  String path;

  ViewImageFile({this.path});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        systemOverlayStyle: SystemUiOverlayStyle.light,
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
            child: (path != null && path.isNotEmpty)
                ? AspectRatio(
                    aspectRatio: 1 / 1,
                    child: Image(
                      image: FileImage(File(path)),
                      fit: BoxFit.cover,
                    ),
                  )
                : Text('Path Not Exist'),
          ),
        ),
      ),
    );
  }
}
