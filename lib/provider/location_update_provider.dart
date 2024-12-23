import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_app_driver/constants/global_data.dart';
import 'package:connect_app_driver/functions/print_function.dart';
import 'package:connect_app_driver/provider/location_provider.dart';
import 'package:connect_app_driver/services/firebase_services/firebase_collections.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:provider/provider.dart';

import '../constants/api_keys.dart';
import '../constants/global_keys.dart';

class LocationUpdateProvider extends ChangeNotifier {
  Timer? locationTimer;
  bool firstTimeAtTheApp = true;
  updateLocationToFirebaseTimer() async {
    print('Location time is going to be initialized');

    var locationProvider = Provider.of<MyLocationProvider>(
        MyGlobalKeys.navigatorKey.currentContext!,
        listen: false);

    await locationProvider.checkPermission();
    locationTimer?.cancel();
    locationTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      myCustomLogStatements(
          "checking lat lng $firstTimeAtTheApp ${locationProvider.latitude} ${locationProvider.oldLatLng.latitude}  ${locationProvider.longitude} ${locationProvider.oldLatLng.longitude}");
      if (firstTimeAtTheApp ||
          ((locationProvider.latitude != locationProvider.oldLatLng.latitude ||
                  locationProvider.longitude !=
                      locationProvider.oldLatLng.longitude) &&
              locationProvider.latitude != 0 &&
              locationProvider.longitude != 0)) {
        firstTimeAtTheApp = false;
        var request = {
          ApiKeys.latitude: locationProvider.latitude,
          ApiKeys.longitude: locationProvider.longitude,
          ApiKeys.location: GeoFirePoint(
                  locationProvider.latitude, locationProvider.longitude)
              .data,
          ApiKeys.lastUpdated: Timestamp.now(),
        };

        FirebaseCollections.users.doc(userData!.userId).update(request);
      }
    });
  }

  cancelTimer() {
    locationTimer?.cancel();
  }
}
