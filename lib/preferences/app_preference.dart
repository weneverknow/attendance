import 'dart:convert';

import 'package:attendance/models/employee.dart';
import 'package:attendance/models/company.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static SharedPreferences? _preferences;

  static init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future<void> saveSetting() async {
    await init();
    final body = {
      "latitude": Company.location?.latitude,
      "longitude": Company.location?.longitude,
      "address": Company.address,
      "fullname": Employee.fullname
    };
    print("body $body");
    await _preferences!.setString("setting", jsonEncode(body));
  }

  static Future<Map<String, dynamic>?> getSetting() async {
    await init();
    var setting = await _preferences!.getString("setting");
    if (setting != null) {
      return jsonDecode(setting);
    }
  }
}
