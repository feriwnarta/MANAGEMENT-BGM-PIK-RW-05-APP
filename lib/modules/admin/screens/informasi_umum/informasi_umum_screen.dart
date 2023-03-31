import 'package:aplikasi_rw/modules/admin/controllers/AdminController.dart';
import 'package:aplikasi_rw/modules/admin/models/InformasiModel.dart';
import 'package:aplikasi_rw/modules/admin/screens/informasi_umum/buat_informasi_umum_screen_title.dart';
import 'package:aplikasi_rw/modules/admin/screens/informasi_umum/edit_informasi_umum.dart';
import 'package:aplikasi_rw/modules/admin/services/admin_services.dart';
import 'package:aplikasi_rw/server-app.dart';
import 'package:aplikasi_rw/utils/size_config.dart';
import 'package:aplikasi_rw/utils/view_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class InformasiUmum extends StatefulWidget {
  InformasiUmum({Key key}) : super(key: key);

  @override
  State<InformasiUmum> createState() => _InformasiWargaState();
}

class _InformasiWargaState extends State<InformasiUmum> {
  Future future;

  final AdminController controller = Get.put(AdminController());

  @override
  void initState() {
    super.initState();
    future = AdminServices.getInformasiUmum();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tulis Informasi Umum'),
        systemOverlayStyle: Theme.of(context).appBarTheme.systemOverlayStyle,
      ),
      body: RefreshIndicator(
        key: controller.refreshIndicatorKey2,
        onRefresh: () async {
          setState(() {
            future = AdminServices.getInformasiUmum();
          });
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            margin: EdgeInsets.symmetric(
              vertical: SizeConfig.height(16),
              horizontal: SizeConfig.width(16),
            ),
            child: FutureBuilder<List<InformasiUmumModel>>(
              future: future,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Text(
                        'Informasi warga yang sudah dituliskan dan dipublikasi kepada warga.',
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
                                  url: '${informasiModel.urlImageNews}',
                                  id: '${informasiModel.idNews}',
                                  content: '${informasiModel.content}',
                                  title: '${informasiModel.caption}',
                                  refreshIndicatorKey:
                                      controller.refreshIndicatorKey2,
                                ))
                            .toList(),
                      )
                    ],
                  );
                } else {
                  return Center(
                      child: SizedBox(
                          width: SizeConfig.width(30),
                          height: SizeConfig.height(35),
                          child: CircularProgressIndicator.adaptive()));
                }
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => BuatInformasiUmum());
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
    this.id,
    this.content,
    this.title,
    this.refreshIndicatorKey,
  }) : super(key: key);

  final url;
  final String id, title, content;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(
        ViewImage(urlImage: '${ServerApp.url}/${url}'),
        transition: Transition.cupertino,
      ),
      child: Column(
        children: [
          Slidable(
            child: Container(
              width: double.infinity,
              height: SizeConfig.height(188),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: '${ServerApp.url}/$url',
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(
                    child: SizedBox(
                      width: SizeConfig.width(30),
                      height: SizeConfig.height(35),
                      child: CircularProgressIndicator.adaptive(
                          value: downloadProgress.progress),
                    ),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
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
                          onPressed: () {
                            Get.to(
                              EditInformasiUmum(
                                  id: id,
                                  url: url,
                                  content: content,
                                  title: title),
                              transition: Transition.cupertino,
                            );
                          },
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
                          onPressed: () async {
                            EasyLoading.show(status: 'menghapus');

                            var result =
                                await AdminServices.deleteInformasiUmum(id: id);

                            if (result != null || result.isNotEmpty) {
                              EasyLoading.showSuccess('berhasil menghapus');
                              refreshIndicatorKey.currentState.show();
                            } else {
                              EasyLoading.showError('ada sesuatu yang salah');
                            }
                          },
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
      ),
    );
  }
}
