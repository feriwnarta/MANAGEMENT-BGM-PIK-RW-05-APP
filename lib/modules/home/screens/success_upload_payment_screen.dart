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
                  height: SizeConfig.height(236),
                  image: AssetImage(
                      'assets/img/citizen_menu/success-upload-ipl.png'),
                ),
                SizedBox(
                  height: SizeConfig.height(40),
                ),
                Text(
                  'Bukti Sudah Terkirim',
                  style: TextStyle(
                      fontSize: SizeConfig.text(30),
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: SizeConfig.height(12),
                ),
                Text(
                  'Tunggu untuk informasi dari admin kami untuk mengambil kantong sampah di kantor RW 05',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: SizeConfig.text(12),
                      color: Color(0xff757575),
                      fontWeight: FontWeight.w500),
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
