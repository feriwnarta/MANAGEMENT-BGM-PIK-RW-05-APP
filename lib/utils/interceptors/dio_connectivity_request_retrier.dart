// import 'dart:async';

// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';

// import 'package:logger/logger.dart';

// class DioConnectivityRequestRetrier {
//   final Dio dio;
//   final Connectivity connectivity;

//   DioConnectivityRequestRetrier({
//     @required this.dio,
//     @required this.connectivity,
//   });

//   Future<Response> scheduleRequestRetry(Options requestOptions) async {
//     StreamSubscription streamSubscription;
//     final responseCompleter = Completer<Response>();
//     FormData formData;

//     if (requestOptions.contentType is FormData) {
//       formData = FormData();
//       formData.fields.addAll(requestOptions.data.fields);
//       for (MapEntry mapFile in requestOptions.data.files) {
//         final logger = Logger();
//         logger.d(mapFile.value.filename);
//         formData.files.add(MapEntry(
//             mapFile.key,
//             MultipartFile.fromFileSync(mapFile.value.filename, //fixed!
//                 filename: mapFile.value.filename)));
//       }
//       requestOptions.data = formData;
//     }

//     streamSubscription = connectivity.onConnectivityChanged.listen(
//       (connectivityResult) async {
//         // We're connected either to WiFi or mobile data
//         if (connectivityResult != ConnectivityResult.none) {
//           // Ensure that only one retry happens per connectivity change by cancelling the listener
//           streamSubscription.cancel();
//           // Copy & paste the failed request's data into the new request
//           responseCompleter.complete(dio.request(
//             requestOptions.path,
//             cancelToken: requestOptions.cancelToken,
//             data: requestOptions.data,
//             onReceiveProgress: requestOptions.onReceiveProgress,
//             onSendProgress: requestOptions.onSendProgress,
//             queryParameters: requestOptions.queryParameters,
//             options: requestOptions,
//           ));
//         }
//       },
//     );
//     return responseCompleter.future;
//   }
// }
