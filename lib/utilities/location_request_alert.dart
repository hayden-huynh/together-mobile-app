import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as gl;
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import 'package:together_app/models/location_provider.dart';

Future<void> showLocationAlert(BuildContext context) async {
  final locationProvider = Provider.of<LocationProvider>(
    context,
    listen: false,
  );

  if (await Location().serviceEnabled() &&
      await gl.Geolocator.checkPermission() == gl.LocationPermission.always) {
    locationProvider.setUpLocationStream();
  } else {
    AlertDialog locationAlert = AlertDialog(
      title: Text(
        'IMPORTANT DO NOT SKIP',
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: RichText(
          textAlign: TextAlign.justify,
          text: TextSpan(
            style: TextStyle(
              height: 1.5,
              color: Colors.black,
              fontSize: 18,
            ),
            children: [
              TextSpan(
                text:
                    'For the app to work properly, please ALWAYS keep Location Service ',
              ),
              WidgetSpan(child: Icon(Icons.location_on_outlined)),
              TextSpan(
                text:
                    ' on, allow the app to ALWAYS use your location, and keep the app running in the background.',
              ),
            ],
          ),
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        Align(
          child: Container(
            width: 150,
            child: ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await locationProvider.enableLocationServices();
                await locationProvider.askForLocationPermission();
                locationProvider.setUpLocationStream();
              },
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor,
                elevation: 5,
              ),
              child: Text(
                'I agree',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
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
