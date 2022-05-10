import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/attendance.dart';

class AttendancePreference {
  static SharedPreferences? _preferences;

  static init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future<void> saveAttendance(List<Attendance> attendance) async {
    await init();
    await _preferences!.setString(
        "attendance", jsonEncode(attendance.map((e) => e.toJson()).toList()));
  }

  static Future<String?> getAttendance() async {
    await init();
    var data = await _preferences!.getString("attendance");
    return data;
  }
}
