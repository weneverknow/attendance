import 'package:location/location.dart';

class LocationService {
  static Location _location = Location();
  static Future<bool> getPermission() async {
    bool result = true;
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        result = false;
      }
    }

    var permission = await _location.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await _location.requestPermission();
      if (permission != PermissionStatus.granted) {
        result = false;
      }
    }

    return result;
  }

  static Future<LocationData?> getLocation() async {
    final isAllowed = await getPermission();
    if (isAllowed) {
      return await _location.getLocation();
    }
  }
}
