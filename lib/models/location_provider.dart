import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' show Location;

import 'package:together_app/utilities/place_query.dart';

class LocationProvider with ChangeNotifier {
  Position location;
  StreamSubscription<Position> _locationStream;
  String locationAddress;
  String locationName;

  Future<void> enableLocationServices() async {
    final location = Location();
    if (await Geolocator.isLocationServiceEnabled() == false) {
      await location.requestService();
    }
  }

  Future<void> askForLocationPermission() async {
    if (await Geolocator.checkPermission() != LocationPermission.always) {
      await Geolocator.requestPermission();
    }
  }

  Future<void> _listenToStream(Position location) async {
    this.location = location;
    final locationDetails = await PlaceQuery.queryPlaceDetails(
      location.latitude,
      location.longitude,
    );
    this.locationAddress = locationDetails['formatted_address'];
    this.locationName = locationDetails['name'];
    // print('Address: ${this.locationAddress} - Name: ${this.locationName}\n');
    notifyListeners();
  }

  void setUpLocationStream() {
    if (TimeOfDay.now().hour >= 7 && TimeOfDay.now().hour < 20) {
      Timer.periodic(Duration(seconds: 30), (timer) {
        if (TimeOfDay.now().hour >= 20) {
          _locationStream.cancel();
          timer.cancel();
        }
      });
      _locationStream = Geolocator.getPositionStream(
        desiredAccuracy: LocationAccuracy.best,
        distanceFilter: 5,
        intervalDuration: Duration(seconds: 0),
      ).listen((location) async {
        await _listenToStream(location);
      });
    }
  }
}
