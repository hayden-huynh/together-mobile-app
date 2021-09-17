import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences instance;

  static Future<void> init() async {
    if (instance == null) {
      instance = await SharedPreferences.getInstance();
    }
  }

  /// Set up all reminder time key - boolean value pairs
  static Future<void> setUpBools() async {
    if (!instance.containsKey("Reminder830")) {
      await instance.setBool("Reminder830", true);
    }
    if (!instance.containsKey("Reminder1030")) {
      await instance.setBool("Reminder1030", true);
    }
    if (!instance.containsKey("Reminder1230")) {
      await instance.setBool("Reminder1230", true);
    }
    if (!instance.containsKey("Reminder1430")) {
      await instance.setBool("Reminder1430", true);
    }
    if (!instance.containsKey("Reminder1630")) {
      await instance.setBool("Reminder1630", true);
    }
    if (!instance.containsKey("Reminder1830")) {
      await instance.setBool("Reminder1830", true);
    }
    if (!instance.containsKey("Reminder2030")) {
      await instance.setBool("Reminder2030", true);
    }
  }

  /// When the user has submitted at a time point, disable the
  /// follow-up reminder notification for that time point
  static Future<void> tickOffFollowUpReminder() async {
    final now = DateTime.now();
    // Only turn off reminder notification if questionnaire is
    // submitted before minute 30 of the seven main time points
    if (now.minute < 30) {
      if (now.hour == 8) {
        await instance.setBool("Reminder830", false);
      } else if (now.hour == 10) {
        await instance.setBool("Reminder1030", false);
      } else if (now.hour == 12) {
        await instance.setBool("Reminder1230", false);
      } else if (now.hour == 14) {
        await instance.setBool("Reminder1430", false);
      } else if (now.hour == 16) {
        await instance.setBool("Reminder1630", false);
      } else if (now.hour == 18) {
        await instance.setBool("Reminder1830", false);
      } else if (now.hour == 20) {
        await instance.setBool("Reminder2030", false);
      }
    }
  }
}
