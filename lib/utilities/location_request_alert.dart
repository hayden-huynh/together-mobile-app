import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import 'package:together_app/models/location_provider.dart';

Future<void> showLocationAlert(BuildContext context) async {
  bool locationServiceEnabled = await Geolocator.isLocationServiceEnabled();
  LocationPermission permission = await Geolocator.checkPermission();
  final locationProvider = Provider.of<LocationProvider>(
    context,
    listen: false,
  );

  if (locationServiceEnabled && permission == LocationPermission.always) {
    await locationProvider.setUpLocationStream();
  } else {
    AlertDialog locationAlert = AlertDialog(
      title: Text(
        'IMPORTANT DO NOT SKIP',
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: RichText(
        text: TextSpan(
          style: TextStyle(
            color: Theme.of(context).accentColor,
            fontSize: 18,
          ),
          children: [
            TextSpan(
              text: 'For the app to work properly, please ALWAYS keep Location',
            ),
            WidgetSpan(child: Icon(Icons.location_on_outlined)),
            TextSpan(
              text:
                  'Service on, allow the app to ALWAYS use your location, and keep the app running in the background.',
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            Navigator.of(context).pop();
            await locationProvider.enableLocationServices();
            await locationProvider.askForLocationPermission();
            await locationProvider.setUpLocationStream();
          },
          child: Text(
            'OK',
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 18,
            ),
          ),
        )
      ],
    );

    showDialog(
      context: context,
      builder: (ctx) => locationAlert,
    );
  }
}
