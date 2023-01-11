import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrivacyPolicy extends StatelessWidget {
  PrivacyPolicy({Key key}) : super(key: key);

  final TextStyle style = TextStyle(fontSize: 12.sp);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 800));
    return Scaffold(
      appBar: AppBar(
        title: Text('Kebijakan Privasi'),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            children: [
              AutoSizeText(
                'Kebijakan Privasi adalah komitmen nyata dari BGM PIK untuk menghargai dan melindungi setiap data atau informasi pribadi Pengguna aplikasi BGM PIK. \n\nKebijakan Privasi ini (beserta syarat-syarat penggunaan sebagaimana tercantum dalam “Syarat dan Ketentuan” dan informasi lain yang tercantum di aplikasi BGM PIK) menetapkan dasar atas perolehan, pengumpulan, pengolahan, penganalisisan, penampilan, pembukaan, dan/ atau segala bentuk pengelolaan yang terkait dengan data atau informasi yang Pengguna berikan kepada BGM PIK atau yang BGM PIK kumpulkan dari Pengguna, termasuk data pribadi Pengguna, baik pada saat Pengguna melakukan pendaftaran di aplikasi, mengakses aplikasi, maupun mempergunakan layanan-layanan pada aplikasi (selanjutnya disebut sebagai “data”)\n\n Dengan mengakses dan/ atau mempergunakan layanan BGM PIK, Pengguna menyatakan bahwa setiap data Pengguna merupakan data yang benar dan sah, serta Pengguna dianggap telah membaca dan memahami dan memberikan persetujuan kepada BGM PIK untuk memperoleh, mengumpulkan, menyimpan, mengelola, dan mempergunakan data tersebut sebagaimana tercantum dalam kebijakan Privasi maupun Syarat & Ketentuan BGM PIK. \n\nPerolehan dan Pengumpulan Data Pengguna BGM PIK mengumpulkan data Pengguna dengan tujuan untuk mengelola dan memperlancar proses penggunaan situs, serta tujuan-tujuan lainnya selama diizinkan oleh peraturan perundang-undangan yang berlaku. Adapun data Pengguna yang dikumpulkan adalah sebagai berikut: ',
                style: style,
              ),
              SizedBox(
                height: 8.h,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('1.', style: style),
                  Expanded(
                    child: AutoSizeText(
                      'Data yang diserahkan secara mandiri oleh Pengguna, termasuk namun tidak terbatas, pada data yang diserahkan pada saat Pengguna :',
                      style: style,
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 24.w),
                child: Column(
                  children: [
                    SizedBox(
                      height: 8.h,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '1. ',
                          style: style,
                        ),
                        Expanded(
                          child: AutoSizeText(
                            'Membuat atau memperbaiki akun BGM PIK, termasuk diantaranya nama pengguna (username), alamat rumah, nomor rumah, nomor IPL, nomor telfon, foto, alamat email, dan lain-lain yang diminta  BGM PIK.',
                            style: style,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('2. '),
                        Expanded(
                          child: AutoSizeText(
                            'Mengisi survei yang dikirimkan oleh BGM PIK atau atas nama BGM PIK.',
                            style: style,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('3. '),
                        Expanded(
                          child: AutoSizeText(
                            'Melakukan interaksi dengan Pengguna lainnya melalui fitur pesan, diskusi, ulasan, rating dan sebagainya.',
                            style: style,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '4. ',
                          style: style,
                        ),
                        Expanded(
                          child: AutoSizeText(
                            'Menggunakan fitur yang membutuhkan izin akses terhadap perangkat Pengguna seperti izin akses membuka kamera pada saat masuk ke menu foto lokasi peduli lingkungan.',
                            style: style,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 13.h,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '2.',
                    style: style,
                  ),
                  Expanded(
                    child: AutoSizeText(
                      'Data yang terekam pada saat Pengguna mempergunakan aplikasi BGM PIK termasuk namun tidak terbatas pada:',
                      style: style,
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 24.w),
                child: Column(
                  children: [
                    SizedBox(
                      height: 8.h,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('1. '),
                        Expanded(
                          child: AutoSizeText(
                            'Data lokasi riil atau perkiraannya seperti alat IP, lokasi wifi, geolocation, dan sebagainya.',
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '2. ',
                          style: style,
                        ),
                        Expanded(
                          child: AutoSizeText(
                            'Data lokasi geografis Pengguna saat menggunakan aplikasi maupun tidak, untuk menyediakan Pengguna layanan mengenai informasi lokasi zona.',
                            style: style,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '3. ',
                          style: style,
                        ),
                        Expanded(
                          child: AutoSizeText(
                            'Data berupa waktu dari setaiap aktivitas Pengguna termasuk aktivitas pendaftaran, login dan lainnya.',
                            style: style,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '4. ',
                          style: style,
                        ),
                        Expanded(
                          child: AutoSizeText(
                            'Data seluruh konten yang Pengguna buat, bagikan atau Pengguna kirimkan dalam bentuk audio, video, teks, gambar atau jenis media atau file perangkat lunak lainnya.',
                            style: style,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
