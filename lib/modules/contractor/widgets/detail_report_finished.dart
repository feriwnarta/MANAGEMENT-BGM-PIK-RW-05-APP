import 'package:aplikasi_rw/modules/contractor/data/detail_laporan_selesai_model.dart';
import 'package:aplikasi_rw/modules/contractor/services/detail_laporan_selesai_service.dart';
import 'package:aplikasi_rw/server-app.dart';
import 'package:aplikasi_rw/utils/size_config.dart';
import 'package:aplikasi_rw/utils/view_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:timeline_tile/timeline_tile.dart';

class DetailLaporanSelesai extends StatefulWidget {
  const DetailLaporanSelesai({Key key, this.idReport}) : super(key: key);

  final String idReport;

  @override
  State<DetailLaporanSelesai> createState() => _DetailLaporanSelesaiState();
}

class _DetailLaporanSelesaiState extends State<DetailLaporanSelesai> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 800));
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail laporan selesai'),
      ),
      body: FutureBuilder<DetailLaporanSelesaiModel>(
        future:
            DetailLaporanSelesaiSevices.getDetail(idReport: widget.idReport),
        builder: (context, snapshot) => (snapshot.hasData)
            ? SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: SizeConfig.width(16),
                    vertical: SizeConfig.height(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Laporan telah selesai dikerjakan oleh kontraktor lapangan.',
                        style: TextStyle(
                          fontSize: SizeConfig.text(16),
                          color: Color(0xff616161),
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.clip,
                      ),
                      SizedBox(
                        height: SizeConfig.height(32),
                      ),
                      Text(
                        'Foto laporan diproses',
                        style: TextStyle(
                          fontSize: SizeConfig.text(14),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: SizeConfig.height(16),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Visibility(
                            visible: snapshot.data.imageProcess1 != null &&
                                    snapshot.data.imageProcess1.isNotEmpty
                                ? true
                                : false,
                            child: GestureDetector(
                              onTap: () => Get.to(
                                () => ViewImage(
                                  urlImage:
                                      '${ServerApp.url}${snapshot.data.imageProcess1}',
                                ),
                                transition: Transition.fadeIn,
                              ),
                              child: CachedNetworkImage(
                                imageUrl:
                                    '${ServerApp.url}${snapshot.data.imageProcess1}',
                                width: SizeConfig.width(156),
                                height: SizeConfig.height(156),
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: (snapshot.data.imageProcess2 != null &&
                                    snapshot.data.imageProcess2.isNotEmpty)
                                ? true
                                : false,
                            child: GestureDetector(
                              onTap: () => Get.to(
                                () => ViewImage(
                                  urlImage:
                                      '${ServerApp.url}${snapshot.data.imageProcess2}',
                                ),
                                transition: Transition.fadeIn,
                              ),
                              child: CachedNetworkImage(
                                imageUrl:
                                    '${ServerApp.url}${snapshot.data.imageProcess2}',
                                width: SizeConfig.width(156),
                                height: SizeConfig.height(156),
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: SizeConfig.height(36),
                      ),
                      Text(
                        'Foto laporan selesai',
                        style: TextStyle(
                          fontSize: SizeConfig.text(14),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: SizeConfig.height(16),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Visibility(
                            visible: snapshot.data.imageComplete1 != null &&
                                    snapshot.data.imageComplete1.isNotEmpty
                                ? true
                                : false,
                            child: GestureDetector(
                              onTap: () => Get.to(
                                () => ViewImage(
                                  urlImage:
                                      '${ServerApp.url}${snapshot.data.imageComplete1}',
                                ),
                                transition: Transition.fadeIn,
                              ),
                              child: CachedNetworkImage(
                                imageUrl:
                                    '${ServerApp.url}${snapshot.data.imageComplete1}',
                                width: SizeConfig.width(156),
                                height: SizeConfig.height(156),
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: snapshot.data.imageComplete2 != null &&
                                    snapshot.data.imageComplete2.isNotEmpty
                                ? true
                                : false,
                            child: GestureDetector(
                              onTap: () => Get.to(
                                () => ViewImage(
                                  urlImage:
                                      '${ServerApp.url}${snapshot.data.imageComplete2}',
                                ),
                                transition: Transition.fadeIn,
                              ),
                              child: CachedNetworkImage(
                                imageUrl:
                                    '${ServerApp.url}${snapshot.data.imageComplete2}',
                                width: SizeConfig.width(156),
                                height: SizeConfig.height(156),
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: SizeConfig.height(32),
                      ),
                      ListTileTheme(
                        dense: true,
                        child: ExpansionTile(
                          tilePadding: EdgeInsets.zero,
                          childrenPadding: EdgeInsets.all(0)
                              .copyWith(bottom: SizeConfig.height(20)),
                          title: Row(
                            children: [
                              SizedBox(
                                width: SizeConfig.width(16),
                                height: SizeConfig.height(16),
                                child: Image(
                                  fit: BoxFit.cover,
                                  image: AssetImage('assets/img/clock.jpg'),
                                ),
                              ),
                              SizedBox(
                                width: SizeConfig.width(8),
                              ),
                              Expanded(
                                child: Text.rich(
                                  TextSpan(
                                    text: 'Selesai dalam ',
                                    style: TextStyle(
                                      fontSize: SizeConfig.text(14),
                                    ),
                                    children: [
                                      TextSpan(
                                        text: '${snapshot.data.duration}',
                                        style: TextStyle(
                                          fontSize: SizeConfig.text(14),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              )
                            ],
                          ),
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.width(40)),
                              padding: EdgeInsets.zero,
                              child: Column(
                                children: snapshot.data.processReport
                                    .map<Widget>(
                                      (e) => TimelineTile(
                                        axis: TimelineAxis.vertical,
                                        isLast: (e['index'] == 'last')
                                            ? true
                                            : false,
                                        alignment: TimelineAlign.start,
                                        isFirst: (e['index'] == 'first')
                                            ? true
                                            : false,
                                        endChild: Container(
                                          child: ListTile(
                                            title: Text(
                                              '${e['title']}',
                                              style: TextStyle(
                                                  fontSize:
                                                      SizeConfig.text(12)),
                                            ),
                                            subtitle: Text(
                                              '${e['subtitle']}',
                                              style: TextStyle(
                                                  fontSize:
                                                      SizeConfig.text(11)),
                                            ),
                                          ),
                                        ),
                                        beforeLineStyle: LineStyle(
                                          color: Color(0xffC2C2C2),
                                          thickness: 1,
                                        ),
                                        afterLineStyle: LineStyle(
                                          color: Color(0xffC2C2C2),
                                          thickness: 1,
                                        ),
                                        indicatorStyle: IndicatorStyle(
                                          width: SizeConfig.width(12),
                                          color: Color(
                                            0xff404040,
                                          ),
                                          iconStyle: IconStyle(
                                            iconData: Icons.check,
                                            color: Colors.white,
                                            fontSize: SizeConfig.text(12),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Image(
                            width: SizeConfig.width(16),
                            height: SizeConfig.height(16),
                            image: AssetImage(
                              'assets/img/star.jpg',
                            ),
                            fit: BoxFit.cover,
                          ),
                          SizedBox(
                            width: SizeConfig.width(8),
                          ),
                          Expanded(
                            child: Text(
                              '${snapshot.data.star} Bintang',
                              style: TextStyle(
                                fontSize: SizeConfig.text(14),
                                color: Color(0xff404040),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.clip,
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: snapshot.data.complaint
                            .map<Widget>((e) => Padding(
                                  padding: EdgeInsets.only(
                                      top: SizeConfig.height(24)),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/img/image-svg/shield-exclamation.svg',
                                        width: SizeConfig.width(16),
                                        height: SizeConfig.height(16),
                                      ),
                                      SizedBox(
                                        width: SizeConfig.width(8),
                                      ),
                                      Expanded(
                                        child: Text(
                                          '$e',
                                          style: TextStyle(
                                            fontSize: SizeConfig.text(14),
                                            color: Color(0xff404040),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.clip,
                                        ),
                                      )
                                    ],
                                  ),
                                ))
                            .toList(),
                      ),
                      SizedBox(
                        height: SizeConfig.height(24),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            'assets/img/image-svg/location-marker-complaint.svg',
                            height: SizeConfig.height(16),
                            width: SizeConfig.width(16),
                          ),
                          SizedBox(
                            width: SizeConfig.width(8),
                          ),
                          Expanded(
                            child: Text(
                              snapshot.data.location,
                              style: TextStyle(
                                fontSize: SizeConfig.text(14),
                                color: Color(0xff404040),
                              ),
                              maxLines: 7,
                              overflow: TextOverflow.clip,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              )
            : LinearProgressIndicator(),
      ),
    );
  }
}
