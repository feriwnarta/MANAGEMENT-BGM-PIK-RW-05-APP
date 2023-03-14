import 'package:aplikasi_rw/modules/admin/controllers/AdminController.dart';
import 'package:aplikasi_rw/modules/admin/screens/informasi_warga/buat_informasi_warga_detail.dart';
import 'package:aplikasi_rw/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuatInformasiWargaContent extends StatelessWidget {
  BuatInformasiWargaContent({Key key}) : super(key: key);

  final adminController = Get.find<AdminController>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tulis Informasi Warga',
        ),
        systemOverlayStyle: Theme.of(context).appBarTheme.systemOverlayStyle,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: SizeConfig.width(16),
              vertical: SizeConfig.height(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      style: TextButton.styleFrom(
                        elevation: 0,
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: SizeConfig.text(14),
                          color: Colors.black,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          Get.to(() => BuatInformasiWargaDetail());
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: Text(
                        'Selesai',
                        style: TextStyle(
                          fontSize: SizeConfig.text(10),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: SizeConfig.height(24),
                ),
                Text(
                  '${adminController.controllerTitle.text}',
                  style: TextStyle(
                    fontSize: SizeConfig.text(14),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.height(4),
                ),
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: adminController.controllerContent,
                    maxLines: 10,
                    decoration: InputDecoration(
                      hintText:
                          'Agung Sedayu Group bekerja sama dengan TNI dan Yayasan Budha TzuChi Indonesia menyelenggarakan kegiatan vaksinasi Covid-19 di PIK Avenue secara gratis bagi warga DKI Jakarta/Non DKI Jakarta.',
                      hintStyle: TextStyle(
                        fontSize: SizeConfig.text(14),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: SizeConfig.height(6),
                          horizontal: SizeConfig.width(12)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty || value != null) {
                        _formKey.currentState.validate();
                      }
                    },
                    validator: (String value) {
                      return (value != null && value.isEmpty)
                          ? 'Konten tidak boleh kosong'
                          : null;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
