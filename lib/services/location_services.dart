import 'dart:async';

import 'package:aplikasi_rw/model/user_location.dart';
import 'package:location/location.dart';

class LocationServices {
  Location location = Location();
  StreamController<UserLocation> _locationStreamController =
      StreamController<UserLocation>();
  Stream<UserLocation> get locationStream => _locationStreamController.stream;

  LocationServices() {
    location.requestPermission().then((permision) => {
          if (permision == PermissionStatus.granted)
            {
              location.getLocation().then((locationData) => {
                    if (locationData != null)
                      {
                        _locationStreamController.add(UserLocation(
                            latitude: locationData.latitude,
                            longitude: locationData.longitude))
                      }
                  })

              // realtime location

              // location.onLocationChanged.listen((locationData) {
              //   if(locationData != null) {
              //     _locationStreamController.add(UserLocation(
              //       latitude: locationData.latitude,
              //       longitude: locationData.longitude
              //     ));
              //   }
              // })
            }
        });
  }

  void disponse() => _locationStreamController.close();
}
