import 'package:aplikasi_rw/modules/admin/models/InformasiModel.dart';
import 'package:aplikasi_rw/modules/admin/screens/informasi_warga/buat_informasi_warga_screen_title.dart';
import 'package:aplikasi_rw/modules/admin/services/admin_services.dart';
import 'package:aplikasi_rw/server-app.dart';
import 'package:aplikasi_rw/utils/size_config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class InformasiWarga extends StatelessWidget {
  const InformasiWarga({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tulis Informasi Warga'),
        systemOverlayStyle: Theme.of(context).appBarTheme.systemOverlayStyle,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(
            vertical: SizeConfig.height(16),
            horizontal: SizeConfig.width(16),
          ),
          child: FutureBuilder<List<InformasiModel>>(
            future: AdminServices.getInformasiWarga(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    Text(
                      'Informasi warga yang sudah ditulisa dan dipublikasi kepada warga.',
                      style: TextStyle(
                        fontSize: SizeConfig.text(16),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.height(32),
                    ),
                    Column(
                      children: snapshot.data
                          .map<Widget>((informasiModel) => CardInformasi(
                                url:
                                    '${ServerApp.url}/${informasiModel.urlImageNews}',
                              ))
                          .toList(),
                    )
                  ],
                );
              } else {
                return Center(child: CircularProgressIndicator.adaptive());
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => BuatInformasiWarga());
        },
        child: Image.asset('assets/img/admin/Group 127.png'),
      ),
    );
  }
}

class CardInformasi extends StatelessWidget {
  const CardInformasi({
    Key key,
    this.url,
  }) : super(key: key);

  final url;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Slidable(
          child: SizedBox(
            width: double.infinity,
            child: CachedNetworkImage(
              imageUrl: url,
            ),
          ),
          endActionPane: ActionPane(
            motion: BehindMotion(),
            extentRatio: SizeConfig.width(0.4),
            children: [
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: SizeConfig.width(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: SizeConfig.width(95),
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: SvgPicture.asset(
                          'assets/img/admin/pencil.svg',
                          width: SizeConfig.image(16),
                          fit: BoxFit.cover,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 0,
                          alignment: Alignment.centerLeft,
                        ),
                        label: Text(
                          'Edit',
                          style: TextStyle(
                            fontSize: SizeConfig.text(14),
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: SizeConfig.width(95),
                      child: Divider(
                        color: Color(0xffF5F5F5),
                        thickness: 2,
                      ),
                    ),
                    SizedBox(
                      width: SizeConfig.width(95),
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: SvgPicture.asset(
                          'assets/img/admin/trash.svg',
                          width: SizeConfig.image(16),
                          fit: BoxFit.cover,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 0,
                          alignment: Alignment.centerLeft,
                        ),
                        label: Text(
                          'Hapus',
                          style: TextStyle(
                            fontSize: SizeConfig.text(14),
                            fontWeight: FontWeight.w500,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: SizeConfig.height(8),
        ),
        SizedBox(
          width: double.infinity,
          child: Divider(
            color: Color(0xffF5F5F5),
            thickness: 2,
          ),
        ),
        SizedBox(
          height: SizeConfig.height(8),
        ),
      ],
    );
  }
}
