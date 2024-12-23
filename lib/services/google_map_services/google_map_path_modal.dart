import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapPathModal {
  List<LatLng> path;
  int distanceInMeters;
  int timeInSeconds;
  Map allOtherData;
  bool success;

  GoogleMapPathModal({
    required this.success,
    required this.path,
    required this.distanceInMeters,
    required this.timeInSeconds,
    required this.allOtherData,
  });

  // factory GoogleMapPathModal.fromJson(Map json) {
  //   return GoogleMapPathModal(
  //     path: path,
  //     distance: distance,
  //     timeInMinutes: timeInMinutes,
  //     allOtherData: allOtherData,
  //   );
  // }
}
