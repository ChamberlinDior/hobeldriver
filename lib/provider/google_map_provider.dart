import 'dart:async';
import 'package:connect_app_driver/constants/global_data.dart';
import 'package:connect_app_driver/functions/calculateDistanceBetweenTwoPoints.dart';
import 'package:connect_app_driver/provider/live_booking_provider.dart';
import 'package:connect_app_driver/services/google_map_services/custom_map_keys.dart';
import 'package:connect_app_driver/services/shared_preference_services/shared_preference_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../constants/global_keys.dart';
import '../../constants/my_colors.dart';
import '../../constants/my_image_url.dart';
import '../../provider/location_provider.dart';
import '../../services/google_map_services/google_map_services.dart';
import '../../services/google_map_services/static_paths.dart';
import 'package:provider/provider.dart';

class GoogleMapProvider extends ChangeNotifier {
  GoogleMapController? googleMapController;
  // double initialZoom = 15;
  double navigationZoom = 16;
  LatLng initialMapLocation = LatLng(22.7004171, 75.8758533);

  CustomInfoWindowController customInfoWindowController =
      CustomInfoWindowController();

  Set<Marker> markers = {};
  Set<String> markerIds = {};

  Set<Polyline> polyLines = {};
  bool fakeLocationStarted = false;
  bool fakeLoctionPause = false;

  List<LatLng> coveredPathLatLngList = [];
  addMarker({
    required LatLng latLng,
    required Widget? infowindow,
    required String markerId,
    List<int> icon = MyImagesUrl.carTopList,
  }) {
    print('adding marker ${markerId}');
    if (!markerIds.contains(markerId)) {
      markerIds.add(markerId);
      markers.add(Marker(
          markerId: MarkerId(markerId),
          position: latLng,
          anchor: const Offset(0.5, 0.5),
          flat: true,
          icon: BitmapDescriptor.fromBytes(
            Uint8List.fromList(icon),
          ),
          onTap: () {
            if (infowindow != null) {
              customInfoWindowController.addInfoWindow!(
                infowindow,
                latLng,
              );
            }
          }));
    } else {
      markers = markers.map((element) {
        if (element.markerId == MarkerId(markerId)) {
          return element.copyWith(
            positionParam: latLng,
            rotationParam: CustomMapKeys.fromMarker == markerId ||
                    CustomMapKeys.whereToMarker == markerId
                ? 0
                : GoogleMapServices.calculateBearing(element.position, latLng),
            iconParam: BitmapDescriptor.fromBytes(
              Uint8List.fromList(icon),
            ),
          );
        } else {
          // var fs= Marker(markerId: MarkerId('sfd'), rotation: )
          return element;
        }
      }).toSet();
    }

    notifyListeners();
  }

  removeMarker(String markerId) {
    markers.removeWhere((test) => test.markerId.value == markerId);
  }

  removeAllMarkers() {
    markers.clear();
    markerIds.clear();
    notifyListeners();
  }

  removeAllPolyLines() {
    polyLines.clear();
    notifyListeners();
  }

  removePolyline(String polylineId) async {
    polyLines.removeWhere((element) => element.polylineId.value == polylineId);
  }

  Set<Marker> showAllMarkers() {
    return markers;
  }

  Set<Polyline> showAllPolyLines() {
    return polyLines;
  }

  addPolyLine(
      {required String polylineId,
      Color color = MyColors.primaryColor,
      int width = 4,
      required List<LatLng> points}) async {
    // polyLines.clear();
    notifyListeners();

    // for (int i = 3; i < points.length; i++) {
    //   polyLines.add(Polyline(
    //       polylineId: PolylineId(polylineId),
    //       color: color,
    //       width: width,
    //       points: points.sublist(0, i + 1)));
    //   notifyListeners();
    //   await Future.delayed(Duration(milliseconds: 10));
    // }
    polyLines.add(Polyline(
        polylineId: PolylineId(polylineId),
        color: color,
        width: width,
        points: points));
  }

  ValueNotifier<bool> autoNavigation = ValueNotifier(true);
  Timer? startRouteTimer;

  updateFirstPolyLine() async {
    var locationProvider = Provider.of<MyLocationProvider>(
        MyGlobalKeys.navigatorKey.currentContext!,
        listen: false);

    var points = polyLines.first.points;
    var target = LatLng(locationProvider.latitude, locationProvider.longitude);
    int index =
        GoogleMapServices.getNearestLatLngIndexFromLatLngList(points, target);

    print('updating polyline to index $index');

    addPolyLine(
        polylineId: polyLines.first.polylineId.value,
        points: points.sublist(index));
  }

  checkPolyLineExistOrNot(String polylineId) async {
    return polyLines.any((poly) => poly.polylineId == PolylineId(polylineId));
  }

  animateMarker(LatLng start, LatLng end) async {
    var distance = calculateDistance(
        start.latitude, start.longitude, end.latitude, end.longitude);
    var pointAre = (distance * 50).round();
    var betweenPoints = GoogleMapServices.getPointsBetweenTwoPoints(start, end,
        numberOfPoints: pointAre == 0 ? 3 : pointAre);

    for (int i = 0; i < betweenPoints.length; i++) {
      addMarker(
          latLng: betweenPoints[i],
          infowindow: null,
          markerId: 'temp',
          icon: userData == null? MyImagesUrl.carTopList: vehicleTypesMap[userData!.vehicleModal!.vehicle_type]!
              .markerListImage);
      await Future.delayed(Duration(milliseconds: 30));
    }
  }

  startRoute({String? polyLineId}) async {
    startRouteTimer?.cancel();
    var locationProvider = Provider.of<MyLocationProvider>(
        MyGlobalKeys.navigatorKey.currentContext!,
        listen: false);

    /// live
    LatLng previous = locationProvider.oldLatLng;
    LatLng latlng =
        LatLng(locationProvider.latitude, locationProvider.longitude);
    // await animateMarker(previous ?? latlng, latlng);
    googleMapController?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: latlng,
            bearing: previous == null
                ? 0
                : GoogleMapServices.calculateBearing(previous, latlng),
            zoom: 17,
            tilt: 2)));

    /// test
    // tempRouteNavigation();
  }

  tempRouteNavigation() async {
    var mylocationProvider = Provider.of<MyLocationProvider>(
        MyGlobalKeys.navigatorKey.currentContext!,
        listen: false);
    var liveBookingProvider = Provider.of<LiveBookingProvider>(
        MyGlobalKeys.navigatorKey.currentContext!,
        listen: false);
    var path = StaticPaths.routeId670608Final;
    mylocationProvider.oldLatLng = path[0];
    mylocationProvider.latitude = path[0].latitude;
    mylocationProvider.longitude = path[0].longitude;
    if (fakeLocationStarted == false) {
      fakeLocationStarted = true;
      int i = 0;
      Timer.periodic(const Duration(seconds: 3), (timer) async {
        if (fakeLoctionPause == false) {
          print('animating to ${i}....${path[i]}');

          var latlng = path[i];
          LatLng? previous;
          mylocationProvider.oldLatLng = path[i == path.length - 1
              ? i
              : i == 0
                  ? 0
                  : i - 1];
          previous = path[i == path.length - 1
              ? i
              : i == 0
                  ? 0
                  : i - 1];
          mylocationProvider.latitude = path[i].latitude;
          mylocationProvider.longitude = path[i].longitude;
          await SharedPreferenceServices.updateSharePreferenceToLocal(path[i]);
          if (i < path.length - 1) {
            i++;
          } else {
            // i = 0;
            return;
          }

          // markers.clear();
          // addMarker(latLng: latlng, infowindow: null, markerId: 'temp');

          // addMarker(
          //     latLng: latlng,
          //     infowindow: null,
          //     markerId: CustomMapKeys.myMarkerIsThat,
          //     icon: vehicleTypesMap[userData!.vehicleModal!.vehicle_type]!
          //         .markerListImage);

          animateMarker(previous ?? latlng, latlng);

          // if(true){
          if (autoRecenter) {
            await googleMapController?.animateCamera(
                CameraUpdate.newCameraPosition(CameraPosition(
                    target: latlng,
                    bearing: previous == null
                        ? 0
                        : GoogleMapServices.calculateBearing(previous, latlng),
                    zoom: navigationZoom,
                    tilt: 2)));
            autoRecenter = true;
            await Future.delayed(Duration(milliseconds: 500));
            autoRecenter = true;
            notifyListeners();
          }

          updateFirstPolyLine();
          // await Future.delayed(Duration(milliseconds: 10));
          liveBookingProvider.onDriverLocationChange();
        }
      });
    }
  }

  bool autoRecenter = true;
}
