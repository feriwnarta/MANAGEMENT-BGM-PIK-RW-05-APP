import 'package:aplikasi_rw/screen/bills_screen/event_bill_screen.dart';
import 'package:aplikasi_rw/utils/UserSecureStorage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../server-app.dart';

class BillTab {
  Tab tab;
  Widget screen;
  Color colorsAppBar;
  Color colorsText;

  BillTab({this.tab, this.screen, this.colorsAppBar, this.colorsText});
}

class BillTabModel {
  static List<BillTab> tabs() {
    return [
      BillTab(
          colorsAppBar: Colors.red,
          tab: Tab(
              child:
                  Text('Event 17 August', style: TextStyle(fontSize: 12.0.sp))),
          screen: EventBillScrenn(
            urlHeroImage:
                'https://asset.kompas.com/crops/wvIJirTN7tp9S7AQ4mmlkdkMk0o=/0x0:780x520/750x500/data/photo/2020/08/13/5f354e00ebe40.jpg',
            titleEvent: 'citizen dues for the 17 august 2022',
            price: '200.000',
            dueDate: 'due date 7 agustus',
            background: Colors.red,
          ),
          colorsText: Colors.white),
      BillTab(
        colorsAppBar: Colors.blue,
        tab: Tab(
          child: Text(
            'Event idul adha',
            style: TextStyle(fontSize: 12.0.sp),
          ),
        ),
        screen: EventBillScrenn(
          urlHeroImage:
              'https://kemenkumham.go.id/images/foto/2019/8_Agustus/2019-08-11_-_Idul_Adha_1.jpg',
          titleEvent: 'cost to buy sacrificial animals',
          price: '200.000',
          dueDate: 'due date 7 agustus',
          background: Colors.blue,
        ),
        colorsText: Colors.white,
      )
    ];
  }
}

class BillEventServices {
  static Future<List<BillTab>> getTab() async {
    String idUser = await UserSecureStorage.getIdUser();
    String url = '${ServerApp.url}src/event/event.php';
    var data = {'id_user': idUser};

    http.Response response =
        await http.post(Uri.parse(url), body: jsonEncode(data));
    var obj = jsonDecode(response.body) as List;
    return obj
        .map((item) => BillTab(
              colorsAppBar: Colors.blue,
              colorsText: Colors.white,
              tab: Tab(
                child: Text(
                  item['tab_title'],
                  style: TextStyle(fontSize: 12.sp, color: Colors.white),
                ),
              ),
              screen: EventBillScrenn(
                  urlHeroImage: '${ServerApp.url}${item['url_image_event']}',
                  titleEvent: item['title_event'],
                  price: item['price'],
                  dueDate: item['duedate'],
                  background: Colors.blue),
            ))
        .toList();
  }
}
