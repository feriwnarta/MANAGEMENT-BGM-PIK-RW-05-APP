// import 'dart:async';
// import 'package:aplikasi_rw/model/user_location.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:geocoder/geocoder.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:aplikasi_rw/services/location_services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class MapSample extends StatefulWidget {
//   @override
//   State<MapSample> createState() => MapSampleState();
// }

// class MapSampleState extends State<MapSample> {
//   LocationServices userLocation;
//   Completer<GoogleMapController> _controller = Completer();
//   final markers = Set<Marker>();
//   MarkerId markerId = MarkerId('1');
//   String jalan = "";
//   String address;
//   double deflatitude, deflongitude;
//   double latitude, longitude;

//   @override
//   void initState() {
//     super.initState();
//     userLocation = LocationServices();
//   }

//   @override
//   void dispose() {
//     userLocation.disponse();
  
//     super.dispose();
//   }

  

//   @override
//   Widget build(BuildContext context) {
  
//     return StreamBuilder<UserLocation>(
//         stream: userLocation.locationStream,
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             markers.add(Marker(
//                 markerId: markerId,
//                 position:
//                     LatLng(snapshot.data.latitude, snapshot.data.longitude),
//                 infoWindow: InfoWindow(title: 'Lokasi anda')));
//             Geocoder.local
//                 .findAddressesFromCoordinates(Coordinates(
//                     snapshot.data.latitude, snapshot.data.longitude))
//                 .then((value) {
//               setState(() {
//                 jalan = value.first.addressLine;
//                 deflatitude = snapshot.data.latitude;
//                 deflongitude = snapshot.data.longitude;
//               });
//             });
//           }
//           return new Scaffold(
//             body: (snapshot.hasData)
//                 ? BlocBuilder<GoogleMapBloc, GoogleMapState>(
//                     builder: (context, state) => Stack(
//                       children: [
//                         SafeArea(
//                           child: GoogleMap(
//                             myLocationEnabled: false,
//                             myLocationButtonEnabled: false,
//                             zoomControlsEnabled: false,
//                             markers: markers,
//                             mapType: MapType.normal,
//                             onTap: (argument) {
//                               setState(() {
//                                 markers.add(Marker(
//                                     markerId: markerId, position: argument));
//                               });
//                               Geocoder.local
//                                   .findAddressesFromCoordinates(Coordinates(
//                                       argument.latitude, argument.longitude))
//                                   .then((value) {
//                                 bloc.add(GoogleMapEvent(
//                                     latitude: argument.latitude,
//                                     longitude: argument.longitude,
//                                     address: value.first.addressLine));
//                               });
//                             },
//                             onCameraMove: (position) {
//                               setState(() {
//                                 markers.add(Marker(
//                                     markerId: markerId,
//                                     position: position.target));
//                               });
//                               Geocoder.local
//                                   .findAddressesFromCoordinates(Coordinates(
//                                       position.target.latitude,
//                                       position.target.longitude))
//                                   .then((value) {
//                                 bloc.add(GoogleMapEvent(
//                                     latitude: position.target.latitude,
//                                     longitude: position.target.longitude,
//                                     address: value.first.addressLine));
//                               });
//                             },
//                             initialCameraPosition: CameraPosition(
//                                 bearing: 192.8334901395799,
//                                 target: LatLng(snapshot.data.latitude,
//                                     snapshot.data.longitude),
//                                 tilt: 0,
//                                 zoom: 19.151926040649414),
//                             onMapCreated: (GoogleMapController controller) {
//                               _controller.complete(controller);
//                             },
//                           ),
//                         ),
//                         Positioned.fill(
//                           child: Align(
//                             alignment: Alignment.bottomCenter,
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 Container(
//                                   height: 7.0.h,
//                                   width: 95.0.w,
//                                   decoration: BoxDecoration(
//                                       color: Colors.white,
//                                       borderRadius: BorderRadius.circular(20)),
//                                   child: Center(
//                                     child: Text(
//                                       (state.address == null)
//                                           ? jalan
//                                           : state.address,
//                                       // address.first.addressLine,
//                                       maxLines: 2,
//                                       textAlign: TextAlign.center,
//                                       overflow: TextOverflow.clip,
//                                       style: TextStyle(
//                                           fontSize: 11.0.sp,
//                                           fontFamily: 'roboto'),
//                                     ),
//                                   ),
//                                 ),
//                                 Align(
//                                   alignment: Alignment.centerRight,
//                                   child: Padding(
//                                     padding: EdgeInsets.only(right: 2.7.w),
//                                     child: TextButton(
//                                       style: TextButton.styleFrom(
//                                         shape: RoundedRectangleBorder(
//                                             borderRadius:
//                                                 BorderRadius.circular(10)),
//                                         foregroundColor: Colors.yellow[800],
//                                       ),
//                                       child: Text(
//                                         'gunakan lokasi ini',
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                       onPressed: () {
//                                         if (state.address != null) {
//                                           print(state.latitude);
//                                           Navigator.pop(context, [
//                                             state.latitude,
//                                             state.longitude,
//                                             state.address
//                                           ]);
//                                           bloc.add(GoogleMapEventDelete());
//                                         } else {
//                                           Navigator.pop(context, [
//                                             deflatitude,
//                                             deflongitude,
//                                             jalan
//                                           ]);
//                                         }
//                                       },
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   height: 11.0.h,
//                                 )
//                               ],
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   )
//                 : Center(
//                     child: CircularProgressIndicator(),
//                   ),
//             floatingActionButton: FloatingActionButton.extended(
//               onPressed: () {
//                 _goToUserCurrentLocation(
//                     snapshot.data.latitude, snapshot.data.longitude);
//               },
//               label: Text('Lokasi terkini'),
//               icon: Icon(Icons.location_on_sharp),
//             ),
//           );
//         });
//   }

//   Future<void> _goToUserCurrentLocation(
//       double latitude, double longitude) async {
//     final GoogleMapController controller = await _controller.future;
//     controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
//         bearing: 192.8334901395799,
//         target: LatLng(latitude, longitude),
//         tilt: 0,
//         zoom: 19.151926040649414)));

//     var coordinates = new Coordinates(latitude, longitude);
//     Geocoder.local
//         .findAddressesFromCoordinates(coordinates)
//         .then((value) => print('${value.first.addressLine}'));
//   }
// }
