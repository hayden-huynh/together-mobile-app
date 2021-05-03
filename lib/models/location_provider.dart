import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' show Location;

import 'package:together_app/utilities/place_query.dart';

class LocationProvider with ChangeNotifier {
  Position location;
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

  Future<void> setUpLocationStream() async {
    Geolocator.getPositionStream(
      desiredAccuracy: LocationAccuracy.best,
      distanceFilter: 5,
      intervalDuration: Duration(seconds: 0),
    ).listen((location) async {
      print('in listen');
      this.location = location;
      final locationDetails = await PlaceQuery.queryPlaceDetails(
        location.latitude,
        location.longitude,
      );
      this.locationAddress = locationDetails['formatted_address'];
      this.locationName = locationDetails['name'];
      notifyListeners();
    });
  }
}
