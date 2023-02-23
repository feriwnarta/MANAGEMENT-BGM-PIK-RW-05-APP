import 'package:aplikasi_rw/utils/size_config.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TermAndCondition extends StatelessWidget {
  TermAndCondition({Key key}) : super(key: key);

  final TextStyle style = TextStyle(fontSize: SizeConfig.text(12));

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 800));

    return Scaffold(
      appBar: AppBar(
        title: Text('Syarat dan ketentuan'),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: SizeConfig.width(16)),
          child: Column(
            children: [
              SizedBox(
                height: SizeConfig.height(16),
              ),
              Text(
                'Syarat dan ketentuan yang ditetapkan di bawah ini mengatur Pengguna layanan yang disediakan oleh BGM PIK, baik berupa informasi, teks, grafik, atau data lain, unduhan, unggahan, atau menggunakan layanan. Pengguna disarankan membaca dengan seksama karena dapat berdampak kepada hak dan kewajiban Pengguna di bawah hukum. \n\nDengan mendaftar dan/ atau menggunakan aplikasi BGM PIK, maka pengguna dianggap telah membaca, mengerti, memahami dan menyetujui semua isi dalam syarat dan ketentuan. Syarat dan ketentuan ini merupakan bentuk kesepakatan yang dituangkan dalam sebuah perjanjian yang sah antara Pengguna dengan aplikasi BGM PIK. Jika Pengguna tidak menyetujui salah satu, sebagian, atau seluruh isi syarat dan ketentuan, makan Pengguna tidak diperkenankan menggunakan layanan di aplikasi BGM PIK. \n\nKami berhak untuk mengubah syarat dan ketentuan ini dari waktu ke waktu tanpa pemberitahuan. Pengguna mengakui dan menyetujui bahwa merupakan tanggung jawab Pengguna untuk meninjau Syarat dan Ketentuan ini secara berkala untuk mengetahui perubahan apa pun. Dengan tetap mengakses dan menggunakan layanan BGM PIK, maka pengguna di anggap menyetujui perubahan-perubahan dalam Syarat dan Ketentuan. \n\nLarangan \n\nPengguna dapat menggunakan layanan BGM PIK hanya untuk tujuan yang sah. Pengguna tidak dapat menggunakan layanan BGM PIK dengan cara apa pun yang :',
                style: TextStyle(fontSize: SizeConfig.text(12)),
              ),
              SizedBox(
                height: SizeConfig.height(8),
              ),
              Padding(
                padding: EdgeInsets.only(left: SizeConfig.width(24)),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '1.',
                          style: style,
                        ),
                        SizedBox(
                          width: SizeConfig.width(2),
                        ),
                        Expanded(
                          child: Text(
                            'Melanggar peraturan perundang-undangan yang berlaku di Negara Kesatuan Republik Indonesia.',
                            style: style,
                          ),
                        )
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '2.',
                          style: style,
                        ),
                        SizedBox(
                          width: SizeConfig.width(2),
                        ),
                        Expanded(
                          child: Text(
                            'Dengan cara apapun melanggar hukum atau melakukan penipuan, atau memiliki tujuan atau efek yang melanggar hukum atau menipu.',
                            style: style,
                          ),
                        )
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '3.',
                          style: style,
                        ),
                        SizedBox(
                          width: SizeConfig.width(2),
                        ),
                        Expanded(
                          child: Text(
                            'Merugikan atau berupaya untuk menyakiti individu atau entititas lain dengan cara apa pun. Memperbanyak, menggandakan, menyalin, menjual, menjual kembali, atau mengesploitasi bagian  manapun dari layanan, pengguna layanan, atau akses ke layanan tanpa izin tertulis dari BG',
                            style: style,
                          ),
                        )
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('4.', style: style),
                        SizedBox(
                          width: SizeConfig.width(2),
                        ),
                        Expanded(
                          child: Text(
                            'Memperbanyak, menggandakan, menyalin, menjual, menjual kembali, atau mengesploitasi bagian  manapun dari layanan, pengguna layanan, atau akses ke layanan tanpa izin tertulis dari BGM PIK.',
                            style: style,
                          ),
                        )
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '5.',
                          style: style,
                        ),
                        SizedBox(
                          width: SizeConfig.width(2),
                        ),
                        Expanded(
                          child: Text(
                            'Atau menyalahgunakan baik secara verbal, fisik, tertulis atau penyalahgunaan lainnya (termasuk ancaman kekerasan atau retribusi) dari setiap pengguna, karyawan, anggota atau petugas BGM PIK.',
                            style: style,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: SizeConfig.height(50),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
