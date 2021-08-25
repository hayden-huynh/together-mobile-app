import 'dart:async';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart' as gl;

import 'package:together_app/utilities/local_database.dart';

class LocationProvider with ChangeNotifier {
  LocationData location;
  StreamSubscription<LocationData> _locationStream;

  Future<void> enableLocationServices() async {
    if (await Location().serviceEnabled() == false) {
      await Location().requestService();
    }
  }

  Future<void> askForLocationPermission() async {
    if (await gl.Geolocator.checkPermission() != gl.LocationPermission.always) {
      await Permission.location.request();
      await Permission.locationAlways.request();
    }
  }

  Future<void> _listenToStream(LocationData location) async {
    final timeStamp = DateTime.now().toString();
    this.location = location;

    LocalDatabase.insert('location', 'location_data', {
      'timestamp': timeStamp,
      'latitude': location.latitude,
      'longitude': location.longitude,
    });
    // .then((value) async {
    //   print(await LocalDatabase.retrieve('location', 'location_data'));
    // });
    notifyListeners();
  }

  void setUpLocationStream() {
    if (TimeOfDay.now().hour >= 7 && TimeOfDay.now().hour < 20) {
      final location = Location();
      location.changeSettings(
        accuracy: LocationAccuracy.high,
        interval: 0,
        distanceFilter: 5.0,
      );
      location.enableBackgroundMode(enable: true);
      _locationStream = location.onLocationChanged.listen((location) async {
        await _listenToStream(location);
      });

      Timer.periodic(Duration(seconds: 30), (timer) {
        if (TimeOfDay.now().hour >= 20) {
          _locationStream.cancel();
          timer.cancel();
        }
      });
    }
  }
}
