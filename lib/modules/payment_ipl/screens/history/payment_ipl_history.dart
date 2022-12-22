import 'package:aplikasi_rw/model/payment_ipl_history_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../services/payment_ipl_history_services/payment_ipl_history_services.dart';

class PaymentIplHistory extends StatefulWidget {
  const PaymentIplHistory({Key key}) : super(key: key);

  @override
  State<PaymentIplHistory> createState() => _PaymentIplHistoryState();
}

class _PaymentIplHistoryState extends State<PaymentIplHistory> {
  var _future;

  @override
  void initState() {
    super.initState();
    _future = HistoryPaymentIplServices.getLastPayment();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat Pembayaran IPL'),
      ),
      body: RefreshIndicator(
        onRefresh: () async =>
            _future = await HistoryPaymentIplServices.getLastPayment(),
        child: Container(
          child: FutureBuilder<List<PaymentIplHistoryModel>>(
              future: _future,
              builder: (context, snapshot) => (snapshot.hasData)
                  ? (snapshot.data.isEmpty)
                      ? Center(
                          child: Text(
                            'Fitur ini hanya dimiliki oleh warga',
                            style: TextStyle(fontSize: 12.sp),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          physics: ScrollPhysics(),
                          itemBuilder: (context, index) =>
                              CardHistoryPaymentIpl(
                                  jumlahTagihan:
                                      snapshot.data[index].jumlahTagihan,
                                  noIpl: snapshot.data[index].nomorIpl,
                                  statusPembayaran:
                                      snapshot.data[index].statusPembayaran,
                                  tanggalPembayaran:
                                      snapshot.data[index].tanggalPembayaran,
                                  bulanTagihan:
                                      snapshot.data[index].bulanTagihan),
                        )
                  : Center(child: CircularProgressIndicator())),
        ),
      ),
    );
  }
}

class CardHistoryPaymentIpl extends StatelessWidget {
  final String noIpl,
      tanggalPembayaran,
      statusPembayaran,
      jumlahTagihan,
      bulanTagihan;

  CardHistoryPaymentIpl(
      {this.noIpl,
      this.tanggalPembayaran,
      this.statusPembayaran,
      this.jumlahTagihan,
      this.bulanTagihan});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 200));
    ScreenUtil.init(context);
    return Column(
      children: [
        SizedBox(
          height: 20.h,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          height: 92.h,
          child: Card(
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
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
                      noIpl,
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
                                jumlahTagihan,
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
                                'Bulan tagihan',
                                style: TextStyle(
                                    fontSize: 10.sp, color: Color(0xff757575)),
                              ),
                              Text(
                                (bulanTagihan == null) ? '-' : bulanTagihan,
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
                                statusPembayaran,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: (statusPembayaran == 'paid')
                                      ? Color(0xff3BDE38)
                                      : Colors.red,
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
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
