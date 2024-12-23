import 'dart:async';

import 'package:connect_app_driver/constants/global_data.dart';
import 'package:connect_app_driver/provider/live_booking_provider.dart';
import 'package:connect_app_driver/services/google_map_services/static_paths.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart' as handler;
import 'package:provider/provider.dart';
import '../constants/error_constants.dart';
import '../constants/global_keys.dart';
import '../functions/print_function.dart';
import '../functions/showCustomDialog.dart';
import '../services/custom_navigation_services.dart';
import '../services/location/location_permission_alert.dart';
import '../services/location/location_permission_denied_forever.dart';
import '../services/location/location_service_alert.dart';
import '../services/shared_preference_services/shared_preference_services.dart';
import 'google_map_provider.dart';

class MyLocationProvider extends ChangeNotifier {
  double latitude = 0;
  double longitude = 0;
  String? addressString;
  Stream<Position>? data;
  bool isLocationServiceEnabled = false;
  bool isLocationServiceDialogOpen = false;
  bool isCheckPermissionDialogOpen = false;
  late LocationPermission permission;
  bool isForceLocationPermission = true;
  LatLng oldLatLng = const LatLng(0, 0);

  checkPermission({bool navigateMap = false}) async {
    permission = await Geolocator.checkPermission();
    var googleMapProvider = Provider.of<GoogleMapProvider>(
        MyGlobalKeys.navigatorKey.currentContext!,
        listen: false);
    myCustomPrintStatement('m1------------$permission');
    if (permission == LocationPermission.denied) {
      isCheckPermissionDialogOpen = false;
      await showPermissionNeedPopup(navigateMap: navigateMap);
    } else if (permission == LocationPermission.deniedForever) {
      isCheckPermissionDialogOpen = false;
      await openAppSettingpopup();
    } else if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      if (navigateMap) {
        var latLng = LatLng(latitude, longitude);
        googleMapProvider.initialMapLocation = latLng;
        myCustomLogStatements(
            "initialMapLocation checkpermission ------ ${DateTime.now()}  $latLng");
        if (userData != null) {
          myCustomPrintStatement('the google map initial lat long are $latLng');
          googleMapProvider.googleMapController?.animateCamera(
              CameraUpdate.newLatLng(LatLng(latitude, longitude)));
        }
      }
      await initializeLocationServiceStream();
    }
  }

  Future ask({bool navigateMap = false}) async {
    myCustomPrintStatement('start----------------');
    var googleMapProvider = Provider.of<GoogleMapProvider>(
        MyGlobalKeys.navigatorKey.currentContext!,
        listen: false);
    permission = await Geolocator.checkPermission();
    myCustomLogStatements("permission is that $permission");
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      myCustomLogStatements("permission is that $permission");
      if (permission == LocationPermission.whileInUse) {
        var perm = await handler.Permission.locationAlways.request();
        if (perm.isGranted) {
          if (navigateMap) {
            googleMapProvider.initialMapLocation = LatLng(latitude, longitude);
            if (userData != null) {
              googleMapProvider.googleMapController?.animateCamera(
                  CameraUpdate.newLatLng(LatLng(latitude, longitude)));
              if (userData!.isOnline) {
                var liveBookingsProvider = Provider.of<LiveBookingProvider>(
                    MyGlobalKeys.navigatorKey.currentContext!,
                    listen: false);
                liveBookingsProvider.listenForCurrentBooking();
              }
            }
            myCustomLogStatements(
                "initialMapLocation ask permission ------ ${DateTime.now()}  ${googleMapProvider.initialMapLocation}");
          }
          await initializeLocationServiceStream();
        } else {
          checkPermission(navigateMap: navigateMap);
        }
      } else if (permission == LocationPermission.denied) {
        isCheckPermissionDialogOpen = false;
        return showPermissionNeedPopup(navigateMap: navigateMap);
      } else if (permission == LocationPermission.deniedForever) {
        isCheckPermissionDialogOpen = false;
        openAppSettingpopup();
      }
    } else if (permission == LocationPermission.deniedForever) {
      isCheckPermissionDialogOpen = false;
      await openAppSettingpopup();
    } else if (permission == LocationPermission.deniedForever) {
      myCustomLogStatements("permission is that $permission");
      var perm = await handler.Permission.locationAlways.request();
      if (perm.isGranted) {
        await initializeLocationServiceStream();
      } else {
        checkPermission(navigateMap: navigateMap);
      }
    } else {
      if (navigateMap) {
        googleMapProvider.initialMapLocation = LatLng(latitude, longitude);
        if (userData != null) {
          googleMapProvider.googleMapController?.animateCamera(
              CameraUpdate.newLatLng(LatLng(latitude, longitude)));
          if (userData!.isOnline) {
            var liveBookingsProvider = Provider.of<LiveBookingProvider>(
                MyGlobalKeys.navigatorKey.currentContext!,
                listen: false);
            liveBookingsProvider.listenForCurrentBooking();
          }
        }
        myCustomLogStatements(
            "initialMapLocation ask permission else block------ ${DateTime.now()}  ${googleMapProvider.initialMapLocation}");
      }
      return;
    }
  }

  showPermissionNeedPopup({bool navigateMap = false}) async {
    return await showCustomDialog(
        height: 300,
        canPop: false,
        child: LocationPermissionAlert(
          isForceLocationPermission: isForceLocationPermission,
          onTap: () async {
            isCheckPermissionDialogOpen = true;
            Navigator.pop(MyGlobalKeys.navigatorKey.currentContext!);
            Future.delayed(const Duration(milliseconds: 500), () async {
              ask(navigateMap: navigateMap);
            });
          },
        ));
  }

  openAppSettingpopup() async {
    return await showCustomDialog(
        height: 300,
        canPop: false,
        child: LocationPermissionDeniedForever(
          isForceLocationPermission: isForceLocationPermission,
          onTap: () async {
            isCheckPermissionDialogOpen = true;
            Navigator.pop(MyGlobalKeys.navigatorKey.currentContext!);
            Future.delayed(const Duration(milliseconds: 500), () async {
              handler.openAppSettings();
            });
          },
        ));
  }

  //////////////////////////////////////////////////////////////////////////////////////
  Stream<ServiceStatus> getServiceStatusStreamWithCurrentStatus() async* {
    yield await Geolocator.isLocationServiceEnabled().then(
        (value) => value ? ServiceStatus.enabled : ServiceStatus.disabled);
    yield* Geolocator.getServiceStatusStream();
  }

  StreamSubscription<ServiceStatus>? locationStatusStream;

  initializeLocationServiceStream() async {
    locationStatusStream?.cancel();
    locationStatusStream = getServiceStatusStreamWithCurrentStatus()
        .listen((ServiceStatus status) async {
      isLocationServiceEnabled = status == ServiceStatus.enabled;
      if (!isLocationServiceEnabled && isLocationServiceDialogOpen == false) {
        isLocationServiceDialogOpen = true;
        await showCustomDialog(
            height: 200,
            canPop: false,
            child: LocationServiceAlert(
              onTap: () async {
                await Geolocator.openLocationSettings();
                if (isLocationServiceEnabled) {
                  await CustomNavigation.pop(
                      MyGlobalKeys.navigatorKey.currentContext!);
                }
              },
            ));
        isLocationServiceDialogOpen = false;
      } else {
        if (isLocationServiceDialogOpen) {
          CustomNavigation.pop(MyGlobalKeys.navigatorKey.currentContext!);
        }
        myCustomPrintStatement(
            'start-----------xxxxxxxxxxxxxxxxxxxxxxxxxxx------$isLocationServiceEnabled-');

        /// check this one at the time of development
        if (permission == LocationPermission.always ||
            permission == LocationPermission.whileInUse) {
          myCustomPrintStatement('xxxxxxxxxxxxxxxxxxxxxxxxxxx');
          await updateLatLong();
        }
      }
      notifyListeners();
    });
    await updateLatLong();
  }

  updateLatLong() async {
    try {
      var position = await Geolocator.getCurrentPosition(
          // forceAndroidLocationManager: true,

          );
      myCustomPrintStatement(
          'the position is inside updated lat lng $position');
      oldLatLng = LatLng(latitude, longitude);
      latitude = position.latitude;
      longitude = position.longitude;

      notifyListeners();
      await updateAddress();
    } catch (e) {
      myCustomLogStatements("error inside update lat lng");
      updateAddress();
    }
  }

  StreamSubscription<Position>? locationStream;
  initializePositionStream() async {
    var liveBookingProvider = Provider.of<LiveBookingProvider>(
        MyGlobalKeys.navigatorKey.currentContext!,
        listen: false);

    if (!runOnLiveLocation) {
      myCustomPrintStatement('Running locally $runOnLiveLocation');
      var path = StaticPaths.routeId670608Final;
      oldLatLng = path[0];
      latitude = path[0].latitude;
      longitude = path[0].longitude;
      SharedPreferenceServices.updateSharePreferenceToLocal(
          LatLng(latitude, longitude));
    } else if (data == null) {
      myCustomPrintStatement('Updating user location x');
      data = Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 1,
      )).handleError((e) {
        myCustomPrintStatement("error on the position stream $e");
      });

      locationStream?.cancel();
      locationStream = data!.listen((event) async {
        try {
          myCustomPrintStatement(
              'Updating user location $latitude.... $longitude....$event');
          oldLatLng = LatLng(latitude, longitude);
          latitude = event.latitude;
          longitude = event.longitude;
          var googleMapProvider = Provider.of<GoogleMapProvider>(
              MyGlobalKeys.navigatorKey.currentContext!,
              listen: false);
          googleMapProvider.animateMarker(
              oldLatLng, LatLng(latitude, longitude));
          await SharedPreferenceServices.updateSharePreferenceToLocal(
              LatLng(latitude, longitude));
          notifyListeners();
          liveBookingProvider.onDriverLocationChange();
        } catch (e) {
          myCustomPrintStatement(
              'Error in catch block unable to fetch the location....$e');
        }
      });
    } else {
      myCustomPrintStatement('location stream is already initialized');
    }
  }

  updateAddress() async {
    if (addressString != null || addressString == "") {
      addressString = null;
      notifyListeners();
    }

    myCustomPrintStatement(
        'About to determine position..d. $runOnLiveLocation $data');
    if (runOnLiveLocation && data == null) {
      myCustomPrintStatement(
          'About to determine position..d. inside data $data');
      await initializePositionStream();
      await Future.delayed(const Duration(seconds: 2));
      updateAddress();
      return;
    }

    addressString = await getAddressFromLatLng(latitude, longitude);
    if (addressString!.contains(MyErrorConstants.noAddressFound)) {
      addressString = null;
      if (latitude == 0) {
        await updateLatLong();
      }
    } else {}
    notifyListeners();
  }

  Future<String> getAddressFromLatLng(double? lat, double? lang) async {
    if (lat == null || lang == null) return "";

    try {
      myCustomPrintStatement('Getting address string$lat');
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lang);
      myCustomPrintStatement(
          "address ---------------${placemarks[0].toString()}");
      String addressString = '';
      if (placemarks[0].name == placemarks[0].subLocality) {
        // addressString = '${placemarks[0].street}, ${placemarks[0].subLocality}, ${placemarks[0].subAdministrativeArea}, ${placemarks[0].administrativeArea}, ${placemarks[0].postalCode} ${placemarks[0].country}';
        addressString = ' ${placemarks[0].locality}';
      } else {
        addressString = ' ${placemarks[0].locality}';
        // addressString = '${placemarks[0].street}, ${placemarks[0].name}, ${placemarks[0].subLocality}, ${placemarks[0].subAdministrativeArea}, ${placemarks[0].administrativeArea}, ${placemarks[0].postalCode} ${placemarks[0].country}';
      }

      return addressString;
    } catch (err) {
      myCustomPrintStatement('err from reverseGeocoding()-----------$err');

      return '${MyErrorConstants.noAddressFound} $lat.....$lang';
    }
  }
}
