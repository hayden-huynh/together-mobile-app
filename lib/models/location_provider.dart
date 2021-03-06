import 'dart:async';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart' as gl;
import "package:cron/cron.dart";

import 'package:together_app/utilities/local_database.dart';

class LocationProvider with ChangeNotifier {
  StreamSubscription<LocationData> _locationStream;

  /// Check if Location service is already enabled.
  /// If not, prompt the user to enable Location service
  Future<void> enableLocationServices() async {
    if (await Location().serviceEnabled() == false) {
      await Location().requestService();
    }
  }

  /// Check if the location permission has been set to "Always"
  /// If not, prompt the user to always allow the app to access their location
  Future<void> askForLocationPermission() async {
    if (await gl.Geolocator.checkPermission() != gl.LocationPermission.always) {
      await Permission.location.request();
      await Permission.locationAlways.request();
    }
  }

  void setUpLocationStream() {
    if (TimeOfDay.now().hour > 7 && TimeOfDay.now().hour < 20) {
      final location = Location();
      location.changeNotificationOptions(
        title: "Check-in Location Service",
        subtitle: "Check-in background location service is running",
        iconName: "@drawable/notification_icon",
        onTapBringToFront: true,
        color: Colors.green[300],
      );
      location.changeSettings(
        accuracy: LocationAccuracy.high,
        interval: 0,
        distanceFilter: 10.0,
      );
      location.enableBackgroundMode(enable: true);
      _locationStream = location.onLocationChanged.listen((location) async {
        final timeStamp = DateTime.now().toString();

        LocalDatabase.insert('location', 'location_data', {
          'timestamp': timeStamp,
          'latitude': location.latitude,
          'longitude': location.longitude,
        });
      });

      // Schedule the cancellation of location logging as a cron job at 20:00 sharp everyday
      final cron = Cron();
      cron.schedule(Schedule.parse("0 20 * * *"), () async {
        location.enableBackgroundMode(enable: false);
        _locationStream.cancel();
        await cron.close();
      });
    }
  }
}
