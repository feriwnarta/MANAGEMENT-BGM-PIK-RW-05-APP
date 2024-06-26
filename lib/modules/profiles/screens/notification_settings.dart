import 'package:aplikasi_rw/modules/profiles/services/notification_services.dart';
import 'package:aplikasi_rw/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/state_manager.dart';

//ignore: must_be_immutable
class NotificationSettings extends StatelessWidget {
  NotificationSettings({Key key}) : super(key: key);

  RxBool laporanDiterima = false.obs;
  RxBool laporanDikerjakan = false.obs;
  RxBool laporanSelesai = false.obs;
  RxBool komentar = false.obs;
  RxBool suka = false.obs;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 800));

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Notifikasi',
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: FutureBuilder<Map<String, dynamic>>(
              future: NotificationServices.getNotification(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  initSwitch(data: snapshot.data);
                  return Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: SizeConfig.width(16)),
                    child: Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: SizeConfig.height(16),
                          ),
                          Text(
                            'Peduli Lingkungan',
                            style: TextStyle(
                                fontSize: SizeConfig.text(16),
                                fontWeight: FontWeight.w500),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                            height: SizeConfig.height(16),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Laporan diterima',
                                style: TextStyle(fontSize: SizeConfig.text(12)),
                                maxLines: 1,
                              ),
                              SizedBox(
                                width: SizeConfig.width(28),
                                height: SizeConfig.height(16),
                                child: Switch(
                                  value: laporanDiterima.value,
                                  onChanged: (value) async {
                                    String response = await updateNotif(
                                        status: 'laporan_diterima',
                                        value: value);
                                    print(response);

                                    laporanDiterima.value = value;
                                  },
                                  activeColor: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: SizeConfig.height(16),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Laporan dikerjakan',
                                style: TextStyle(fontSize: SizeConfig.text(12)),
                                maxLines: 1,
                              ),
                              SizedBox(
                                width: SizeConfig.width(28),
                                height: SizeConfig.height(16),
                                child: Switch(
                                  value: laporanDikerjakan.value,
                                  onChanged: (value) async {
                                    await updateNotif(
                                        status: 'laporan_dikerjakan',
                                        value: value);

                                    laporanDikerjakan.value = value;
                                  },
                                  activeColor: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: SizeConfig.height(16),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Laporan selesai',
                                style: TextStyle(
                                  fontSize: SizeConfig.text(12),
                                ),
                                maxLines: 1,
                              ),
                              SizedBox(
                                width: SizeConfig.width(28),
                                height: SizeConfig.height(16),
                                child: Switch(
                                  value: laporanSelesai.value,
                                  onChanged: (value) async {
                                    await updateNotif(
                                        status: 'laporan_selesai',
                                        value: value);
                                    laporanSelesai.value = value;
                                  },
                                  activeColor: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: SizeConfig.height(16),
                          ),
                          Divider(
                            thickness: 1,
                          ),
                          SizedBox(
                            height: SizeConfig.height(16),
                          ),
                          Text(
                            'Suka dan komentar di postingan',
                            style: TextStyle(
                                fontSize: SizeConfig.text(16),
                                fontWeight: FontWeight.w500),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                            height: SizeConfig.height(16),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Komentar',
                                style: TextStyle(fontSize: SizeConfig.text(12)),
                                maxLines: 1,
                              ),
                              SizedBox(
                                width: SizeConfig.width(28),
                                height: SizeConfig.height(16),
                                child: Switch(
                                  value: komentar.value,
                                  onChanged: (value) async {
                                    await updateNotif(
                                        status: 'komentar', value: value);
                                    komentar.value = value;
                                  },
                                  activeColor: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: SizeConfig.height(16),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Suka',
                                style: TextStyle(fontSize: SizeConfig.text(12)),
                                maxLines: 1,
                              ),
                              SizedBox(
                                width: SizeConfig.width(24),
                                height: SizeConfig.height(24),
                                child: Switch(
                                  value: suka.value,
                                  onChanged: (value) async {
                                    await updateNotif(
                                        status: 'like_status', value: value);
                                    suka.value = value;
                                  },
                                  activeColor: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return LinearProgressIndicator();
                }
              },
            ),
          ),
        ));
  }

  Future<String> updateNotif({String status, bool value}) async {
    String result = await NotificationServices.updateNotification(
        status: status, value: value);
    return result;
  }

  void initSwitch({Map<String, dynamic> data}) {
    print(data);

    if (data['report_received'] == '1') {
      laporanDiterima.value = true;
    }
    if (data['report_received'] == '0') {
      laporanDiterima.value = false;
    }
    if (data['report_done'] == '1') {
      laporanDikerjakan.value = true;
    }
    if (data['report_done'] == '0') {
      laporanDikerjakan.value = false;
    }
    if (data['report_completed'] == '1') {
      laporanSelesai.value = true;
    }
    if (data['report_completed'] == '0') {
      laporanSelesai.value = false;
    }
    if (data['commentar'] == '1') {
      komentar.value = true;
    }
    if (data['commentar'] == '0') {
      komentar.value = false;
    }
    if (data['like_status'] == '1') {
      suka.value = true;
    }
    if (data['like_status'] == '0') {
      suka.value = false;
    }
  }
}
