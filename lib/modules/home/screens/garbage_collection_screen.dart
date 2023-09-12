import 'package:aplikasi_rw/modules/home/screens/upload_payment_ipl_screen.dart';
import 'package:aplikasi_rw/modules/home/services/upload_ipl_services.dart';
import 'package:aplikasi_rw/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GarbageCollectionScreen extends StatelessWidget {
  const GarbageCollectionScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Permintaan Kantong Sampah'),
        titleTextStyle: Theme.of(context).appBarTheme.titleTextStyle,
        systemOverlayStyle: Theme.of(context).appBarTheme.systemOverlayStyle,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: FutureBuilder<Map<String, dynamic>>(
            future: UploadIplServices.checkPayment(),
            builder: (context, snapshot) {
              // return Text('${snapshot.data['status']}');

              if (snapshot.hasData) {
                switch (snapshot.data['status']) {
                  case 'Diproses':
                    return onProcess(context, snapshot.data['message']);
                  case 'Diterima':
                    return accept(context, snapshot.data['message']);
                  case 'Ditolak':
                    return reject(context, snapshot.data['message']);
                  case 'tidak ada pembayaran dibulan ini':
                    return Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.width(16)),
                      height: MediaQuery.of(context).size.height,
                      child: NoPayIpl(),
                    );
                }
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }),
      )),
    );
  }

  Widget onProcess(BuildContext context, String message) {
    return Container(
      height: MediaQuery.of(context).size.height -
          MediaQuery.of(context).padding.top,
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.width(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            height: SizeConfig.height(147),
          ),
          Image(
              width: SizeConfig.width(254),
              image: AssetImage('assets/img/citizen_menu/onprocess.png')),
          SizedBox(
            height: SizeConfig.height(40),
          ),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: SizeConfig.text(30), fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: SizeConfig.height(12),
          ),
          Text(
            'Tunggu notifikasi selanjutnya untuk informasi mengambil kantong sampah di kantor RW 05',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: SizeConfig.text(12),
              fontWeight: FontWeight.w400,
              color: Color(0xff757575),
            ),
          ),
        ],
      ),
    );
  }

  Widget accept(BuildContext context, String message) {
    return Container(
      height: MediaQuery.of(context).size.height -
          MediaQuery.of(context).padding.top,
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.width(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            height: SizeConfig.height(147),
          ),
          Image(
              width: SizeConfig.width(254),
              image: AssetImage('assets/img/citizen_menu/acceptpay.png')),
          SizedBox(
            height: SizeConfig.height(40),
          ),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: SizeConfig.text(30), fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: SizeConfig.height(12),
          ),
          Text(
            'Silahkan datang ke kantor RW 05 BGM PIK untuk mengambil kantong sampah',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: SizeConfig.text(12),
              fontWeight: FontWeight.w400,
              color: Color(0xff757575),
            ),
          ),
        ],
      ),
    );
  }

  Widget reject(BuildContext context, String note) {
    return Container(
      height: MediaQuery.of(context).size.height -
          MediaQuery.of(context).padding.top,
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.width(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            height: SizeConfig.height(134),
          ),
          Image(
              height: SizeConfig.height(160),
              width: SizeConfig.width(170),
              fit: BoxFit.cover,
              image: AssetImage('assets/img/citizen_menu/reject-pay.png')),
          SizedBox(
            height: SizeConfig.height(40),
          ),
          Text(
            'Ooppss permintaan ditolak',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: SizeConfig.text(30), fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: SizeConfig.height(12),
          ),
          Text(
            note,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: SizeConfig.text(12),
              fontWeight: FontWeight.w400,
              color: Color(0xff757575),
            ),
          ),
          SizedBox(
            height: SizeConfig.height(142),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
              onPressed: () {
                Get.to(UploadPaymentIplScreen());
              },
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50))),
              child: Text('Upload Pembayaran IPL'),
            ),
          )
        ],
      ),
    );
  }
}

class NoPayIpl extends StatelessWidget {
  const NoPayIpl({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: SizeConfig.height(134),
        ),
        Center(
          child: Column(
            children: [
              Image(
                height: SizeConfig.height(200),
                width: SizeConfig.width(188),
                image: AssetImage('assets/img/citizen_menu/one-step.png'),
              ),
              SizedBox(
                height: SizeConfig.height(40),
              ),
              Text(
                'Satu Langkah Lagi!',
                style: TextStyle(
                    fontSize: SizeConfig.text(30), fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: SizeConfig.height(12),
              ),
              Text(
                'Unggah Bukti Pembayaran IPL Anda untuk Mengambil Kantong Sampah',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: SizeConfig.text(12)),
              )
            ],
          ),
        ),
        SizedBox(
          height: SizeConfig.height(142),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
            onPressed: () => Get.to(UploadPaymentIplScreen(),
                transition: Transition.rightToLeft),
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            )),
            child: Text(
              'Upload Pembayaran IPL',
              style: TextStyle(
                fontSize: SizeConfig.text(16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
