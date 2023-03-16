import 'package:aplikasi_rw/modules/admin/models/InformasiModel.dart';
import 'package:aplikasi_rw/modules/informasi_warga/services/informasi_umum_services.dart';
import 'package:aplikasi_rw/server-app.dart';
import 'package:aplikasi_rw/utils/size_config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class InformasiUmum extends StatelessWidget {
  const InformasiUmum({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Informasi Umum',
        ),
        systemOverlayStyle: Theme.of(context).appBarTheme.systemOverlayStyle,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: SizeConfig.width(16),
            vertical: SizeConfig.height(16),
          ),
          child: FutureBuilder<List<InformasiUmumModel>>(
              future: InformasiUmumServices.getInformasiUmum(),
              builder: (context, snapshot) => (snapshot.hasData)
                  ? Column(
                      children: snapshot.data
                          .map<Widget>(
                            (informasi) => Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: SizeConfig.height(188),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl:
                                          '${ServerApp.url}/${informasi.urlImageNews}',
                                      progressIndicatorBuilder: (context, url,
                                              downloadProgress) =>
                                          CircularProgressIndicator.adaptive(
                                              value: downloadProgress.progress),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: SizeConfig.height(8),
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: Divider(
                                    thickness: 3,
                                  ),
                                ),
                                SizedBox(
                                  height: SizeConfig.height(8),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                    )
                  : Center(child: CircularProgressIndicator.adaptive())),
        ),
      ),
    );
  }
}
