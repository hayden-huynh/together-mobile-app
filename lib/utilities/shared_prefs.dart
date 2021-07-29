import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences instance;

  static Future<void> init() async {
    if (instance == null) {
      instance = await SharedPreferences.getInstance();
    }
  }

  static void setUpBools() {
    if (!instance.containsKey("Reminder9")) {
      instance.setBool("Reminder9", true);
    }
    if (!instance.containsKey("Reminder11")) {
      instance.setBool("Reminder11", true);
    }
    if (!instance.containsKey("Reminder13")) {
      instance.setBool("Reminder13", true);
    }
    if (!instance.containsKey("Reminder15")) {
      instance.setBool("Reminder15", true);
    }
    if (!instance.containsKey("Reminder17")) {
      instance.setBool("Reminder17", true);
    }
    if (!instance.containsKey("Reminder19")) {
      instance.setBool("Reminder19", true);
    }
    if (!instance.containsKey("Reminder21")) {
      instance.setBool("Reminder21", true);
    }
  }

  static void tickOffFollowUpReminder() {
    final now = DateTime.now();
    if (now.hour == 8) {
      instance.setBool("Reminder9", false);
    } else if (now.hour == 10) {
      instance.setBool("Reminder11", false);
    } else if (now.hour == 12) {
      instance.setBool("Reminder13", false);
    } else if (now.hour == 14) {
      instance.setBool("Reminder15", false);
    } else if (now.hour == 16) {
      instance.setBool("Reminder17", false);
    } else if (now.hour == 18) {
      instance.setBool("Reminder19", false);
    } else if (now.hour == 20) {
      instance.setBool("Reminder21", false);
    }
  }
}