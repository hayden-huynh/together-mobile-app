import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:together_app/utilities/key.dart';

class PlaceQuery {
  static Future<String> _queryPlaceId(double lat, double long) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=$GOOGLE_API_KEY');
    final response = await http.get(url);
    return jsonDecode(response.body)['results'][0]['place_id'];
  }

  static Future<Map<String, String>> queryPlaceDetails(double lat, double long) async {
    String placeId = await _queryPlaceId(lat, long);
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$GOOGLE_API_KEY');
    final response = await http.get(url);
    final jsonResult = jsonDecode(response.body)['result'];
    return {
      'formatted_address': jsonResult['formatted_address'],
      'name': jsonResult['name'],
    };
  }
}
