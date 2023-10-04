import 'package:aplikasi_rw/modules/home/models/category_request.dart';
import 'package:aplikasi_rw/modules/home/models/history_payment.dart';
import 'package:aplikasi_rw/modules/home/services/category_request_service.dart';
import 'package:aplikasi_rw/modules/home/services/history_payment_services.dart';
import 'package:aplikasi_rw/server-app.dart';
import 'package:aplikasi_rw/utils/size_config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

class RiwayatPermintaan extends StatefulWidget {
  RiwayatPermintaan({Key key}) : super(key: key);

  @override
  State<RiwayatPermintaan> createState() => _RiwayatPermintaanState();
}

class _RiwayatPermintaanState extends State<RiwayatPermintaan> {
  final items = [
    'All',
    'Diproses',
    'Terkirim',
    'Ditolak',
  ];

  final ScrollController _scrollController = ScrollController();
  final List<HistoryPayment> _historyData = [];
  int _start = 0;
  int _limit = 10;

  RxString valueType = ''.obs;

  @override
  void initState() {
    super.initState();
    _loadHistoryData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        _historyData.length % _limit == 0) {
      // Scroll mencapai paling bawah dan tidak sedang dalam proses loading.
      // Muat data selanjutnya di sini.
      _loadHistoryData();
    }
  }

  Future<void> _loadHistoryData() async {
    try {
      final newData = await HistoryPaymentService.getHistory(
        start: _start,
        limit: _limit,
      );

      if (newData.isNotEmpty) {
        setState(() {
          _historyData.addAll(newData);
          _start += _limit;
        });
      }
    } catch (error) {
      // Handle error
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Status Permintaan'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.width(16),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide:
                      BorderSide(color: Colors.blue), // Warna border yang aktif
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(
                    color: Color(0xffEDEDED),
                  ), // Warna border yang non-aktif
                ),
                hintText: 'Search',
                hintStyle: TextStyle(
                  fontSize: SizeConfig.text(14),
                ),
                suffixIcon: Icon(
                  Icons.search,
                  size: SizeConfig.image(16),
                ),
              ),
              style: TextStyle(fontSize: SizeConfig.text(14)),
              onChanged: (value) async {},
            ),
            SizedBox(
              height: SizeConfig.height(16),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FutureBuilder<List<CategoryRequest>>(
                    future: CategoryRequestService.getCategoryRequest(),
                    builder: (ctx, snapshot) {
                      if (snapshot.hasData) {
                        final reversedData = snapshot.data.reversed.toList();
                        valueType.value = reversedData[0].id;

                        return Obx(
                          () => Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: Color(0xffEDEDED),
                                width: 1.0,
                              ),
                            ),
                            child: DropdownButton(
                              style: TextStyle(
                                fontSize: SizeConfig.text(14),
                                color: Color(0xff757575),
                              ),
                              value: valueType.value,
                              isDense: true,
                              underline: Container(
                                height: 0, // Tinggi underline 0
                              ),
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                                color: Color(0xff757575),
                              ),
                              // Array list of items
                              items: reversedData.map((category) {
                                return DropdownMenuItem(
                                  value: category.id,
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 3.5,
                                    child: Text(
                                      category.category,
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontSize: SizeConfig.text(14),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                              // After selecting the desired option,it will
                              // change button value to selected value
                              onChanged: (String newValue) {
                                valueType.value = newValue;
                              },
                            ),
                          ),
                        );
                      }

                      return CircularProgressIndicator.adaptive(
                        value: 0.5,
                      );
                    }),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: Color(0xffEDEDED),
                      width: 1.0,
                    ),
                  ),
                  child: DropdownButton(
                    style: TextStyle(
                      fontSize: SizeConfig.text(14),
                      color: Color(0xff757575),
                    ),
                    isDense: true,
                    underline: Container(
                      height: 0, // Tinggi underline 0
                    ),
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Color(0xff757575),
                    ),
                    value: items[0],
                    // Array list of items
                    items: items.reversed.toList().map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width / 3.5,
                            child: Text(items)),
                      );
                    }).toList(),
                    // After selecting the desired option,it will
                    // change button value to selected value
                    onChanged: (String newValue) {},
                  ),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.height(16),
            ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _historyData.length + 1,
                itemBuilder: (context, index) {
                  if (index < _historyData.length) {
                    final data = _historyData[index];
                    return CardRequest(
                      imageUrl: data.image,
                      id: data.id,
                      dateCreated: data.createAt,
                      idUser: data.idUser,
                      periode: data.periode,
                      statusReq: data.status,
                      title: 'Pengambilan Kantong Sampah',
                    );
                  } else {
                    if (_historyData.length % _limit == 0) {
                      // Tampilkan loading indicator jika masih ada data untuk dimuat.
                      return Center(
                        child: CircularProgressIndicator.adaptive(value: 0.5),
                      );
                    } else {
                      return SizedBox(); // Tampilkan widget kosong jika tidak ada data lagi untuk dimuat.
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardRequest extends StatelessWidget {
  CardRequest(
      {Key key,
      this.imageUrl,
      this.periode,
      this.title,
      this.dateCreated,
      this.statusReq,
      this.id,
      this.idUser})
      : super(key: key);

  final String imageUrl, periode, title, dateCreated, statusReq, id, idUser;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: SizeConfig.height(16),
      ),
      child: InkWell(
        onTap: () {},
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.width(8),
            vertical: SizeConfig.height(8),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: Color(0xffEDEDED),
            ),
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: CachedNetworkImage(
                      imageUrl: '${ServerApp.url}${imageUrl}',
                      fit: BoxFit.cover,
                      width: SizeConfig.width(70),
                      height: SizeConfig.height(70),
                    ),
                  ),
                  SizedBox(
                    width: SizeConfig.width(16),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          periode,
                          style: TextStyle(
                            fontSize: SizeConfig.text(10),
                            color: Color(0xff2094F3),
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.height(4),
                        ),
                        SizedBox(
                          height: SizeConfig.height(42),
                          child: Text(
                            title,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: TextStyle(
                              fontSize: SizeConfig.text(12),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.height(4),
                        ),
                        Text(
                          dateCreated,
                          style: TextStyle(
                            fontSize: SizeConfig.text(10),
                            color: Color(0xff9E9E9E),
                          ),
                        )
                      ],
                    ),
                  ),
                  status(status: statusReq)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget status({String status = ''}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.width(8),
        vertical: SizeConfig.height(2),
      ),
      decoration: BoxDecoration(
        color: (status == 'Ditolak')
            ? Color(0xffFFF4F2)
            : (status == 'Diproses')
                ? Color(0xffF0F3FF)
                : Color(0xffEAFFF5),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: (status == 'Ditolak')
              ? Color(0xffEEB4B0)
              : (status == 'Diproses')
                  ? Color(0xffB1C5F6)
                  : Color(0xffB8DBCA),
        ),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: SizeConfig.text(10),
          color: (status == 'Ditolak')
              ? Color(0xffCB3A31)
              : (status == 'Diproses')
                  ? Color(0xff3267E3)
                  : Color(0xff20573D),
        ),
      ),
    );
  }
}
