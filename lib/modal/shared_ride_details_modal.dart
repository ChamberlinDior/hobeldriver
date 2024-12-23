import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_app_driver/constants/api_keys.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SharedRideDetailsModal {
  LatLng startDestinationLatLng;
  LatLng endDestinationLatLng;
  String startDestination;
  Map startGeoPoint;
  Map endGeoPoint;
  String endDestination;
  Timestamp lastUpdated;

  SharedRideDetailsModal({
    required this.endDestination,
    required this.endDestinationLatLng,
    required this.endGeoPoint,
    required this.startDestination,
    required this.startDestinationLatLng,
    required this.startGeoPoint,
    required this.lastUpdated,
  });

  factory SharedRideDetailsModal.fromJson(json) {
    var start = (json[ApiKeys.startGeoPoint]['geopoint']);
    var end = (json[ApiKeys.endGeoPoint]['geopoint']);
    return SharedRideDetailsModal(
      startGeoPoint: json[ApiKeys.startGeoPoint],
      endGeoPoint: json[ApiKeys.endGeoPoint],
      startDestinationLatLng: LatLng(start.latitude, start.longitude),
      endDestinationLatLng: LatLng(end.latitude, end.longitude),
      startDestination: json[ApiKeys.startDestination],
      endDestination: json[ApiKeys.endDestination],
      lastUpdated: json[ApiKeys.lastUpdated],
    );
  }
}
