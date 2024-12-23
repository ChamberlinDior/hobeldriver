import 'dart:math' as math;

import 'package:connect_app_driver/constants/global_keys.dart';
import 'package:connect_app_driver/functions/print_function.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../provider/location_provider.dart';

double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const double pi = 3.1415926535897932;
  const double earthRadius = 6371; // Earth's radius in kilometers
  double dLat = (lat2 - lat1) * (pi / 180);
  double dLon = (lon2 - lon1) * (pi / 180);
  double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.cos(lat1 * (pi / 180)) *
          math.cos(lat2 * (pi / 180)) *
          math.sin(dLon / 2) *
          math.sin(dLon / 2);
  double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  double distance = earthRadius * c;
  return double.parse(distance.toStringAsFixed(1));
}

double calculateDistanceInMeter(
    double lat1, double lon1, double lat2, double lon2) {
  const double pi = 3.1415926535897932;
  const double earthRadius = 6371; // Earth's radius in kilometers
  double dLat = (lat2 - lat1) * (pi / 180);
  double dLon = (lon2 - lon1) * (pi / 180);
  double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.cos(lat1 * (pi / 180)) *
          math.cos(lat2 * (pi / 180)) *
          math.sin(dLon / 2) *
          math.sin(dLon / 2);
  double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  double distance = earthRadius * c;
  return distance;
}

double calculateDistanceFromCurrentLocation(
  double lat1,
  double lon1,
) {
  var provider = Provider.of<MyLocationProvider>(
      MyGlobalKeys.navigatorKey.currentContext!,
      listen: false);

  print(
      'sfklsj ${lat1}, $lon1....   ${provider.latitude},${provider.longitude}');
  const double pi = 3.1415926535897932;
  const double earthRadius = 6371; // Earth's radius in kilometers
  double dLat = (provider.latitude - lat1) * (pi / 180);
  double dLon = (provider.longitude - lon1) * (pi / 180);
  double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.cos(lat1 * (pi / 180)) *
          math.cos(provider.latitude * (pi / 180)) *
          math.sin(dLon / 2) *
          math.sin(dLon / 2);
  double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  double distance = earthRadius * c;
  myCustomPrintStatement("Distance calcutaed is that ${distance}");
  return double.parse(distance.toStringAsFixed(1));
}

double calculateTotalDistanceFromList(
    {required List<LatLng> latLngList, bool returnInMeter = true}) {
  double totalDistance = 0.0;

  if (latLngList.length < 2) {
    return totalDistance; // Not enough points to calculate distance
  }

  myCustomLogStatements("the distance in meter is ${latLngList.length}");
  for (int i = 0; i < latLngList.length - 1; i++) {
    var indexDistnace = Geolocator.distanceBetween(
      latLngList[i].latitude,
      latLngList[i].longitude,
      latLngList[i + 1].latitude,
      latLngList[i + 1].longitude,
    );
    totalDistance += indexDistnace;
    myCustomLogStatements("the index distance in meter is [$i] $indexDistnace");
  }
  return returnInMeter
      ? totalDistance
      : totalDistance /
          1000; // Distance in meters default set false for in kilometer
}
