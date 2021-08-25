import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

Future<void> registerTimezone(String authToken) async {
  final localTimezone = await FlutterNativeTimezone.getLocalTimezone();
  final topic = localTimezone.replaceFirst(RegExp(r'/'), "-");

  final url = Uri.parse("https://s4622569-together.uqcloud.net/add-timezone");
  try {
    await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode({
        "token": authToken,
        "timezone": localTimezone,
        "topic": topic,
      }),
    );
  } catch (err) {
    print(err);
  }
}
