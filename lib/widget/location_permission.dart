import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

Future<Map?> getGPS({required BuildContext context}) async {
  late Position currentPosition;
  bool enable = await CurrentLocation.checkPermissionEnable();
  if (enable) {
    currentPosition = await CurrentLocation.getCurrentPosition();

    var currentAddress = await placemarkFromCoordinates(
            currentPosition.latitude, currentPosition.longitude)
        .then((List<Placemark> placeMarks) {
      Placemark place = placeMarks[0];

      var address = '${place.locality}';
      return address;
    });

    String lat = currentPosition.latitude.toString();
    String lng = currentPosition.longitude.toString();
    Map data = {
      'lat': lat,
      'lng': lng,
      'address': currentAddress,
    };
    return data;
  }
  return null;
}

class CurrentLocation {
  static Future<bool> checkPermissionEnable() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      } else if (permission == LocationPermission.deniedForever) {
        print("'Location permissions are permanently denied");
        return false;
      } else {
        print("GPS Location service is granted");
        return true;
      }
    } else {
      print("GPS Location permission granted.");
      return true;
    }
  }

  static Future<Position> getCurrentPosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return position;
  }
}
