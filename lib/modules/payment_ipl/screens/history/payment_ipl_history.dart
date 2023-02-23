import 'package:aplikasi_rw/model/payment_ipl_history_model.dart';
import 'package:aplikasi_rw/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    ScreenUtil.init(context, designSize: const Size(360, 800));

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
                            style: TextStyle(fontSize: SizeConfig.text(12)),
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
    return Column(
      children: [
        SizedBox(
          height: SizeConfig.height(20),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: SizeConfig.width(16)),
          height: SizeConfig.height(92),
          child: Card(
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: SizeConfig.height(8),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: SizeConfig.width(8),
                    ),
                    Text(
                      noIpl,
                      style: TextStyle(
                        fontSize: SizeConfig.text(16),
                        color: Color(0xff2094F3),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: SizeConfig.height(8),
                ),
                Container(
                  color: Color(0xffE0E0E0),
                  child: Column(children: [
                    SizedBox(
                      height: SizeConfig.height(8),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: SizeConfig.width(8),
                        ),
                        SizedBox(
                          width: SizeConfig.width(82),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Jumlah tagihan',
                                style: TextStyle(
                                    fontSize: SizeConfig.text(10),
                                    color: Color(0xff757575)),
                              ),
                              Text(
                                jumlahTagihan,
                                style: TextStyle(
                                  fontSize: SizeConfig.text(12),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: SizeConfig.width(16.5),
                        ),
                        SizedBox(
                          width: SizeConfig.width(102),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Bulan tagihan',
                                style: TextStyle(
                                    fontSize: SizeConfig.text(10),
                                    color: Color(0xff757575)),
                              ),
                              Text(
                                (bulanTagihan == null) ? '-' : bulanTagihan,
                                style: TextStyle(
                                  fontSize: SizeConfig.text(12),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: SizeConfig.width(16.5)),
                        SizedBox(
                          width: SizeConfig.width(95),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Status pembayaran',
                                style: TextStyle(
                                    fontSize: SizeConfig.text(10),
                                    color: Color(0xff757575)),
                              ),
                              Text(
                                statusPembayaran,
                                style: TextStyle(
                                  fontSize: SizeConfig.text(12),
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
                      height: SizeConfig.height(8),
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
