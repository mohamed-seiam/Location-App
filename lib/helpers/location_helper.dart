import 'package:geolocator/geolocator.dart';

class LocationHelper {
  static Future<Position> determineCurrentLocation () async
  {
    bool isServicedEnabled = await Geolocator.isLocationServiceEnabled();
    if(!isServicedEnabled)
    {
      Geolocator.requestPermission();
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}