import 'package:aplikasi_rw/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SuccessUploadPaymentScreen extends StatelessWidget {
  const SuccessUploadPaymentScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.width(16)),
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Image(
                  image: AssetImage(
                      'assets/img/citizen_menu/success_upload_ipl.png'),
                ),
                SizedBox(
                  height: SizeConfig.height(124),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    onPressed: () {
                      Get
                        ..back()
                        ..back()
                        ..back();
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50))),
                    child: Text('Kembali ke Beranda'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
