import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DashboardStatistic extends StatefulWidget {
  const DashboardStatistic({Key key}) : super(key: key);

  @override
  State<DashboardStatistic> createState() => _DashboardStatisticState();
}

class _DashboardStatisticState extends State<DashboardStatistic> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100.0.h,
      width: double.infinity,
      child: WebView(
        initialUrl: 'https://next-g.website/rw-05',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
        debuggingEnabled: false,
      ),
    );
  }
}
