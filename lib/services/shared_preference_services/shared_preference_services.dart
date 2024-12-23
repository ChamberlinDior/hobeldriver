import 'dart:convert';

import 'package:connect_app_driver/constants/global_data.dart';
import 'package:connect_app_driver/functions/print_function.dart';
import 'package:connect_app_driver/services/shared_preference_services/shared_preference_keys.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SharedPreferenceServices {
  static updateSharePreferenceToLocal(LatLng latLng) {
    sharedPreference.setDouble(SharedPreferenceKeys.latitude, latLng.latitude);
    sharedPreference.setDouble(
        SharedPreferenceKeys.longitude, latLng.longitude);
  }

  static LatLng getLocation() {
    return LatLng(
        sharedPreference.getDouble(SharedPreferenceKeys.latitude) ?? 0,
        sharedPreference.getDouble(SharedPreferenceKeys.longitude) ?? 0);
  }

  static Future<void> savePathToLocalStorage(List<LatLng> path) async {
    // Convert LatLng list to a list of maps
    List<Map<String, double>> latLngList = path
        .map((latLng) => {
              SharedPreferenceKeys.latitude: latLng.latitude,
              SharedPreferenceKeys.longitude: latLng.longitude
            })
        .toList();

    // Convert list of maps to a JSON string
    String jsonPath = jsonEncode(latLngList);

    // Store JSON string in local storage
    await sharedPreference.setString(
        SharedPreferenceKeys.coveredPath, jsonPath);
    myCustomPrintStatement("Path saved to local storage!");
  }

// Function to retrieve the list of LatLng from local storage
  static Future<List<LatLng>> getPathFromLocalStorage() async {
    String? jsonPath =
        sharedPreference.getString(SharedPreferenceKeys.coveredPath);
    if (jsonPath != null) {
      List<dynamic> latLngList = jsonDecode(jsonPath);
      return latLngList
          .map((latLng) => LatLng(latLng[SharedPreferenceKeys.latitude],
              latLng[SharedPreferenceKeys.longitude]))
          .toList();
    }
    return [];
  }
}
