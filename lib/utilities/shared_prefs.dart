import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences instance;

  static Future<void> init() async {
    if (instance == null) {
      instance = await SharedPreferences.getInstance();
    }
  }

  /// Set up all reminder time key - boolean value pairs
  static void setUpBools() {
    if (!instance.containsKey("Reminder830")) {
      instance.setBool("Reminder830", true);
    }
    if (!instance.containsKey("Reminder1030")) {
      instance.setBool("Reminder1030", true);
    }
    if (!instance.containsKey("Reminder1230")) {
      instance.setBool("Reminder1230", true);
    }
    if (!instance.containsKey("Reminder1430")) {
      instance.setBool("Reminder1430", true);
    }
    if (!instance.containsKey("Reminder1630")) {
      instance.setBool("Reminder1630", true);
    }
    if (!instance.containsKey("Reminder1830")) {
      instance.setBool("Reminder1830", true);
    }
    if (!instance.containsKey("Reminder2030")) {
      instance.setBool("Reminder2030", true);
    }
  }

  /// When the user has submitted at a time point, disable the
  /// follow-up reminder notification for that time point
  static void tickOffFollowUpReminder() {
    final now = DateTime.now();
    if (now.hour == 8) {
      instance.setBool("Reminder830", false);
    } else if (now.hour == 10) {
      instance.setBool("Reminder1030", false);
    } else if (now.hour == 12) {
      instance.setBool("Reminder1230", false);
    } else if (now.hour == 14) {
      instance.setBool("Reminder1430", false);
    } else if (now.hour == 16) {
      instance.setBool("Reminder1630", false);
    } else if (now.hour == 18) {
      instance.setBool("Reminder1830", false);
    } else if (now.hour == 20) {
      instance.setBool("Reminder2030", false);
    }
  }
}
