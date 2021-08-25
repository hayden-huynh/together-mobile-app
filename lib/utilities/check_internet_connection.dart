import 'dart:io';

Future<bool> isConnectedToInternet() async {
  try {
    await InternetAddress.lookup("example.com");
  } on SocketException catch (_) {
    return false;
  }
  return true;
}
