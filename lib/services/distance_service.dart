import 'package:latlong2/latlong.dart';

class DistanceService {
  static Distance _distance = Distance();

  static double getDistance(
      {required LatLng empLocation, required LatLng companyLocation}) {
    var distance = _distance.as(LengthUnit.Meter, empLocation, companyLocation);
    return distance;
  }
}
