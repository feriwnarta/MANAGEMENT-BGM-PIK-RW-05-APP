import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaymentIplHistory extends StatefulWidget {
  const PaymentIplHistory({Key key}) : super(key: key);

  @override
  State<PaymentIplHistory> createState() => _PaymentIplHistoryState();
}

class _PaymentIplHistoryState extends State<PaymentIplHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat Pembayaran IPL'),
      ),
      body: Container(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: 10,
          physics: ScrollPhysics(),
          itemBuilder: (context, index) => CardHistoryPaymentIpl(),
        ),
      ),
    );
  }
}

class CardHistoryPaymentIpl extends StatelessWidget {
  final String noIpl, tanggalPembayaran, statusPembayaran, jumlahTagihan;

  CardHistoryPaymentIpl(
      {this.noIpl,
      this.tanggalPembayaran,
      this.statusPembayaran,
      this.jumlahTagihan});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      height: 92.h,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 8.h,
            ),
            Row(
              children: [
                SizedBox(
                  width: 8.w,
                ),
                Text(
                  'BGM/BAST/AG1/010',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Color(0xff2094F3),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8.h,
            ),
            Container(
              color: Color(0xffE0E0E0),
              child: Column(children: [
                SizedBox(
                  height: 8.h,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 8.w,
                    ),
                    SizedBox(
                      width: 82.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Jumlah tagihan',
                            style: TextStyle(
                                fontSize: 10.sp, color: Color(0xff757575)),
                          ),
                          Text(
                            '958.000',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 16.5.w,
                    ),
                    SizedBox(
                      width: 102.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tanggal pembayaran',
                            style: TextStyle(
                                fontSize: 10.sp, color: Color(0xff757575)),
                          ),
                          Text(
                            '',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 16.5.w,
                    ),
                    SizedBox(
                      width: 95.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Status pembayaran',
                            style: TextStyle(
                                fontSize: 10.sp, color: Color(0xff757575)),
                          ),
                          Text(
                            'Belum lunas',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Color(0xff3BDE38),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8.h,
                )
              ]),
            )
          ],
        ),
      ),
    );
  }
}
