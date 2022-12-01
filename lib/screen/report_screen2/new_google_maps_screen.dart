import 'dart:async';
import 'package:aplikasi_rw/bloc/google_map_bloc.dart';
import 'package:aplikasi_rw/model/user_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoder/geocoder.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:aplikasi_rw/services/location_services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';

class NewGoogleMaps extends StatefulWidget {
  @override
  State<NewGoogleMaps> createState() => NewGoogleMapsState();
}

class NewGoogleMapsState extends State<NewGoogleMaps> {
  LocationServices userLocation;
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController googleMapController;
  final markers = Set<Marker>();
  MarkerId markerId = MarkerId('1');
  RxString jalan = "".obs;
  String address;
  RxDouble deflatitude, deflongitude;
  RxDouble latitude = 0.0.obs, longitude = 0.0.obs;
  GoogleMapBloc bloc;
  GoogleMapsPlaces _places;

  RxList<PlacesSearchResult> nearbyPlaces;

  @override
  void initState() {
    super.initState();
    _places =
        GoogleMapsPlaces(apiKey: 'AIzaSyDbZjwizgtMKuRhgruNqb4eBg2jQzuQjFE');
    userLocation = LocationServices();
    nearbyPlaces = <PlacesSearchResult>[].obs;
  }

  @override
  void dispose() {
    userLocation.disponse();
    bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<GoogleMapBloc>(context);
    return StreamBuilder<UserLocation>(
        stream: userLocation.locationStream,
        builder: (context, snapshot) {
          return new Scaffold(
            appBar: AppBar(
              title: Text(
                'Pilih lokasi kejadian',
                style: TextStyle(fontSize: 19.sp, color: Colors.white),
              ),
            ),
            body: (snapshot.hasData)
                ? BlocBuilder<GoogleMapBloc, GoogleMapState>(
                    builder: (context, state) => Stack(
                      children: [
                        SafeArea(
                          child: GoogleMap(
                            myLocationEnabled: false,
                            myLocationButtonEnabled: false,
                            zoomControlsEnabled: false,
                            compassEnabled: false,
                            markers: markers,
                            mapType: MapType.normal,
                            onCameraMove: (position) async {
                              setState(() {
                                markers.add(Marker(
                                    markerId: markerId,
                                    position: position.target));
                              });
                              if (latitude.value == 0.0 &&
                                  longitude.value == 0.0) {
                                var address = await Geocoder.google(
                                        'AIzaSyDbZjwizgtMKuRhgruNqb4eBg2jQzuQjFE')
                                    .findAddressesFromCoordinates(Coordinates(
                                        position.target.latitude,
                                        position.target.longitude));

                                bloc.add(
                                  GoogleMapEvent(
                                      latitude: position.target.latitude,
                                      longitude: position.target.longitude,
                                      address: address.first.addressLine),
                                );

                                jalan.update((val) {
                                  jalan = address.first.addressLine.obs;
                                });

                                deflatitude.update((val) {
                                  deflatitude = position.target.latitude.obs;
                                });

                                deflongitude.update((val) {
                                  deflongitude = position.target.longitude.obs;
                                });

                                getNearbyPlaces(LatLng(position.target.latitude,
                                    position.target.longitude));
                              }
                            },
                            initialCameraPosition: CameraPosition(
                                bearing: 192.8334901395799,
                                target: LatLng(snapshot.data.latitude,
                                    snapshot.data.longitude),
                                tilt: 0,
                                zoom: 15.151926040649414),
                            onMapCreated: (GoogleMapController controller) {
                              setState(() {
                                markers.add(Marker(
                                    markerId: markerId,
                                    position: LatLng(snapshot.data.latitude,
                                        snapshot.data.longitude),
                                    infoWindow:
                                        InfoWindow(title: 'Lokasi anda')));
                              });
                              Geocoder.google(
                                      'AIzaSyDbZjwizgtMKuRhgruNqb4eBg2jQzuQjFE')
                                  .findAddressesFromCoordinates(Coordinates(
                                      snapshot.data.latitude,
                                      snapshot.data.longitude))
                                  .then((value) {
                                // setState(() {
                                // jalan = value.first.addressLine.obs;
                                deflatitude = snapshot.data.latitude.obs;
                                deflongitude = snapshot.data.longitude.obs;
                                // });
                                jalan.update((val) {
                                  jalan = value.first.addressLine.obs;
                                });
                              });
                              var latlng = LatLng(snapshot.data.latitude,
                                  snapshot.data.longitude);
                              getNearbyPlaces(latlng);

                              _controller.complete(controller);
                              googleMapController = controller;
                            },
                          ),
                        ),
                        GestureDetector(
                          child: Container(
                            width: 328.w,
                            height: 36.h,
                            margin: EdgeInsets.only(
                              top: 24.h,
                              left: 16.w,
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6),
                                boxShadow: [
                                  BoxShadow(color: Colors.grey, blurRadius: 2),
                                ]),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Cari lokasi',
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Color(0xff757575)),
                                ),
                                SvgPicture.asset(
                                  'assets/img/image-svg/search-maps.svg',
                                ),
                              ],
                            ),
                          ),
                          onTap: () async {
                            Prediction p = await PlacesAutocomplete.show(
                                context: context,
                                mode: Mode.overlay,
                                language: 'id',
                                apiKey:
                                    'AIzaSyDbZjwizgtMKuRhgruNqb4eBg2jQzuQjFE');
                            displayPrediction(prediction: p);
                          },
                        ),
                        Align(
                            alignment: Alignment(0.9, 0.5),
                            child: TextButton.icon(
                                style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  foregroundColor: Color(0xff2094F3),
                                ),
                                onPressed: () {
                                  _goToUserCurrentLocation(
                                      snapshot.data.latitude,
                                      snapshot.data.longitude);
                                },
                                icon: SvgPicture.asset(
                                    'assets/img/image-svg/coordinate.svg'),
                                label: Text(
                                  'Lokasi terkini',
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: Colors.white,
                                  ),
                                ))),
                        Obx(
                          () => SlidingUpPanel(
                            minHeight: 150.h,
                            panel: Column(
                              children: [
                                SizedBox(height: 16.h),
                                Container(
                                  width: 40.w,
                                  height: 4.h,
                                  decoration: BoxDecoration(
                                    color: Color(0xffE0E0E0),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                                SizedBox(
                                  height: 16.h,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.back(result: {
                                      'data': jalan.value,
                                      'latitude': deflatitude.value,
                                      'longitude': deflongitude.value,
                                    });
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 16.w),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                            'assets/img/image-svg/location-maps.svg'),
                                        SizedBox(width: 4.w),
                                        Expanded(
                                            child: Text(
                                          '${jalan.value}',
                                          style: TextStyle(
                                              fontSize: 12.sp,
                                              color: Color(0xff2094F3)),
                                        ))
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 11.h,
                                ),
                                Container(
                                  color: Color(0xffF5F5F5),
                                  width: double.infinity,
                                  padding:
                                      EdgeInsets.only(top: 4.h, left: 48.w),
                                  height: 24.h,
                                  child: Text(
                                    'Tempat terdekat',
                                    style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Color(0xff9E9E9E)),
                                  ),
                                ),
                                ListView.builder(
                                  itemCount: (nearbyPlaces.length == 0)
                                      ? nearbyPlaces.length
                                      : 11,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) => Container(
                                    width: double.infinity,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 16.w),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 8,
                                        ),
                                        GestureDetector(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SvgPicture.asset(
                                                'assets/img/image-svg/unselected-maps.svg',
                                              ),
                                              SizedBox(width: 4.w),
                                              Expanded(
                                                  child: Text(
                                                '${nearbyPlaces[index].name} ',
                                                style: TextStyle(
                                                    fontSize: 12.sp,
                                                    color: Color(0xff9E9E9E)),
                                              ))
                                            ],
                                          ),
                                          onTap: () {
                                            displayPrediction(
                                                placeId:
                                                    '${nearbyPlaces[index].placeId}');
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(8)),
                          ),
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ),
            // floatingActionButton: FloatingActionButton.extended(
            //   onPressed: () {
            //     _goToUserCurrentLocation(
            //         snapshot.data.latitude, snapshot.data.longitude);
            //   },
            //   label: Text('Lokasi terkini'),
            //   icon: Icon(Icons.location_on_sharp),
            // ),
          );
        });
  }

  Future<Null> displayPrediction(
      {Prediction prediction, String placeId}) async {
    if (prediction != null || placeId != null) {
      PlacesDetailsResponse detail;
      if (placeId == null) {
        detail = await _places.getDetailsByPlaceId(prediction.placeId);
      } else {
        detail = await _places.getDetailsByPlaceId(placeId);
      }

      // var placeId = p.placeId;
      double lat = detail.result.geometry.location.lat;
      double lng = detail.result.geometry.location.lng;

      var address =
          await Geocoder.google('AIzaSyDbZjwizgtMKuRhgruNqb4eBg2jQzuQjFE')
              .findAddressesFromCoordinates(Coordinates(lat, lng));
      var latlng = LatLng(lat, lng);

      latitude.update((val) {
        latitude = lat.obs;
      });
      longitude.update((val) {
        longitude = lng.obs;
      });

      setState(() {
        markers.add(Marker(markerId: markerId, position: latlng));
        googleMapController
            .animateCamera(CameraUpdate.newLatLng(latlng))
            .then((value) {
          latitude.update((val) {
            latitude = 0.0.obs;
          });
          longitude.update((val) {
            longitude = 0.0.obs;
          });
        });
      });

      Geocoder.google('AIzaSyDbZjwizgtMKuRhgruNqb4eBg2jQzuQjFE')
          .findAddressesFromCoordinates(Coordinates(lat, lng))
          .then((value) {
        bloc.add(GoogleMapEvent(
            latitude: lat, longitude: lng, address: address.first.addressLine));
      });

      getNearbyPlaces(latlng);
    }
  }

  Future<void> _goToUserCurrentLocation(
      double latitude, double longitude) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(latitude, longitude),
        tilt: 0,
        zoom: 19.151926040649414)));

    var coordinates = new Coordinates(latitude, longitude);
    Geocoder.google('AIzaSyDbZjwizgtMKuRhgruNqb4eBg2jQzuQjFE')
        .findAddressesFromCoordinates(coordinates)
        .then((value) => print('${value.first.addressLine}'));
  }

  void getNearbyPlaces(LatLng center) async {
    final location = Location(lat : center.latitude, lng: center.longitude);
    final result = await _places.searchNearbyWithRadius(location, 2500);

    // setState(() {
    if (result.status == "OK") {
      // setState(() {
      this.nearbyPlaces.assignAll(result.results.obs);
      // });
    }
    // print(result.status);
    // });
  }
}

class Popover extends StatelessWidget {
  const Popover({
    Key key,
    this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      // margin: const EdgeInsets.all(16.0),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [_buildHandle(context), if (child != null) child],
      ),
    );
  }

  Widget _buildHandle(BuildContext context) {
    final theme = Theme.of(context);

    return FractionallySizedBox(
      widthFactor: 0.25,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 12.0,
        ),
        child: Container(
          height: 4.h,
          width: 40.w,
          decoration: BoxDecoration(
            color: theme.dividerColor,
            borderRadius: const BorderRadius.all(Radius.circular(2.5)),
          ),
        ),
      ),
    );
  }
}
