import 'dart:convert';
import 'dart:math' as math;

import 'package:connect_app_driver/services/google_map_services/google_map_path_modal.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert' as convert;
import 'package:provider/provider.dart';

import '../../../functions/print_function.dart';
import '../../constants/global_keys.dart';
import '../../functions/calculateDistanceBetweenTwoPoints.dart';
import '../../provider/admin_settings_provider.dart';
import '../../widget/show_snackbar.dart';
import '../newest_webservices.dart';
import 'google_api_keys.dart';

class GoogleMapServices {
  // static const googleMapApiKey = 'AIzaSyBCV_9MoubJ8OG3DNtmfUAtFC9EPGRbPyQ';/// commented on 10-07-2024
  // static const googleMapApiKey = 'AIzaSyBgwFg2GYp7N3LPg1va6Wnr7upfoeku8f0';
  // static const googleMapApiKeys = 'AIzaSyBZ-2VSmvUZxkm4eIL6Vbm41RPPbJUS2zo';/// commented on 04-2-2024
  static Future<List> getPlacePridiction(text) async {
    String googleMapApiKey = Provider.of<AdminSettingsProvider>(
            MyGlobalKeys.navigatorKey.currentContext!,
            listen: false)
        .defaultAppSettingModal
        .googleApiKey!;
    String url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$text&key=${googleMapApiKey}&language=en";
    final response = await http.get(Uri.parse(url));
    final extractedData = convert.json.decode(response.body);
    if (extractedData["error_message"] != null) {
      var error = extractedData["error_message"];
      if (error == "This API project is not authorized to use this API.")
        error +=
            " Make sure the Places API is activated on your Google Cloud Platform";
      return [];
      // throw Exception(error);
    } else {
      final predictions = extractedData["predictions"];
      return predictions;
    }
  }

  static Future<Map> getLatLngByPlaceId(String placeId) async {
    String googleMapApiKey = Provider.of<AdminSettingsProvider>(
            MyGlobalKeys.navigatorKey.currentContext!,
            listen: false)
        .defaultAppSettingModal
        .googleApiKey!;
    String url =
        'https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeId&key=$googleMapApiKey';
    http.Response response =
        http.Response('{"message":"failure","status":0}', 404);
    try {
      http.Response response = await http.get(
        Uri.parse(url),
      );

      if (response.statusCode == 200) {
        print(response.body.runtimeType);
        var jsonResponse = convert.jsonDecode(response.body);
        return jsonResponse;
      } else {
        throw {"status": "0"};
      }
    } catch (e) {
      throw {"status": "0"};
    }
  }

  static Future<String> getAddressFromLatLng(double? lat, double? lang) async {
    if (lat == null || lang == null) return "";

    try {
      print('the lat long are ${lat}...$lang');
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lang);
      myCustomPrintStatement(
          "address ---------------${placemarks[0].toString()}");
      String addressString = '';
      if (placemarks[0].name == placemarks[0].subLocality) {
        addressString =
            '${placemarks[0].street}, ${placemarks[0].subLocality}, ${placemarks[0].subAdministrativeArea},${placemarks[0].postalCode}, ${placemarks[0].administrativeArea}, ${placemarks[0].country}';
      } else {
        addressString =
            '${placemarks[0].street}, ${placemarks[0].name}, ${placemarks[0].subLocality}, ${placemarks[0].subAdministrativeArea}, ${placemarks[0].postalCode}, ${placemarks[0].administrativeArea}, ${placemarks[0].country}';
      }

      return addressString;
    } catch (err) {
      myCustomPrintStatement('err from reverseGeocoding()-----------$err');

      return '';
    }
  }

  static launchGoogleMap({required LatLng latLng}) {
    Uri url = Uri.parse(
        'https://www.google.com/maps/dir/Current+Location/${latLng.latitude},${latLng.longitude}');
    launchUrl(url);
  }

  static getStaticMapImageUrl(LatLng latLng, {String? customMarkerUrl}) {
    String googleMapApiKey = Provider.of<AdminSettingsProvider>(
            MyGlobalKeys.navigatorKey.currentContext!,
            listen: false)
        .defaultAppSettingModal
        .googleApiKey!;
    if (customMarkerUrl != null) {
      return 'https://maps.googleapis.com/maps/api/staticmap?center=${latLng.latitude},${latLng.longitude}&markers=icon:$customMarkerUrl|${latLng.latitude},${latLng.longitude}&format=gif&zoom=14&size=400x400&key=$googleMapApiKey';
    }
    return 'https://maps.googleapis.com/maps/api/staticmap?center=${latLng.latitude},${latLng.longitude}&markers=color:red%7Csize:mid%7Clabel:S%7C${latLng.latitude},${latLng.longitude}&format=gif&zoom=14&size=400x400&key=$googleMapApiKey';
  }

  static List<LatLng> getPointsBetweenTwoPoints(LatLng start, LatLng end,
      {int numberOfPoints = 15}) {
    List<LatLng> points = [];

    double latStep = (end.latitude - start.latitude) / (numberOfPoints + 1);
    double lngStep = (end.longitude - start.longitude) / (numberOfPoints + 1);

    for (int i = 1; i <= numberOfPoints; i++) {
      double latitude = start.latitude + latStep * i;
      double longitude = start.longitude + lngStep * i;
      points.add(LatLng(latitude, longitude));
    }

    return points;
  }
  // static LatLngBounds? getLatLongBoundsFromLatLngList(List<LatLng> latLongList) {
  //   if (latLongList.isEmpty) {
  //     return null;
  //   }
  //   double minLat = latLongList[0].latitude;
  //   double maxLat = latLongList[0].latitude;
  //   double minLong = latLongList[0].longitude;
  //   double maxLong = latLongList[0].longitude;
  //   for (var latLong in latLongList) {
  //     double lat = latLong.latitude;
  //     double long = latLong.longitude;
  //     minLat = (lat < minLat) ? lat : minLat;
  //     maxLat = (lat > maxLat) ? lat : maxLat;
  //     minLong = (long < minLong) ? long : minLong;
  //     maxLong = (long > maxLong) ? long : maxLong;
  //   }
  //   // return LatLngBounds(minLat, maxLat, minLong, maxLong);
  //   return LatLngBounds(southwest: LatLng(minLat, minLong), northeast: LatLng(maxLat, maxLong));
  // }

  static LatLngBounds? getLatLongBoundsFromLatLngList(List<LatLng> latLongList,
      {double bottomPaddingPercentage = 0.1}) {
    if (latLongList.isEmpty) {
      return null;
    }

    double minLat = latLongList[0].latitude;
    double maxLat = latLongList[0].latitude;
    double minLong = latLongList[0].longitude;
    double maxLong = latLongList[0].longitude;

    for (var latLong in latLongList) {
      double lat = latLong.latitude;
      double long = latLong.longitude;
      minLat = (lat < minLat) ? lat : minLat;
      maxLat = (lat > maxLat) ? lat : maxLat;
      minLong = (long < minLong) ? long : minLong;
      maxLong = (long > maxLong) ? long : maxLong;
    }

    // Calculate the bottom padding
    double latPadding = (maxLat - minLat) * bottomPaddingPercentage;

    // Adjust the min latitude by the bottom padding
    minLat -= latPadding;

    return LatLngBounds(
        southwest: LatLng(minLat, minLong), northeast: LatLng(maxLat, maxLong));
  }

  static double calculateZoomLevel(LatLngBounds bounds, Size screenSize) {
    final double GLOBE_WIDTH = 256; // Constant for Google Maps
    final double ZOOM_MAX = 21; // Maximum zoom level
    final double ZOOM_MIN = 1; // Minimum zoom level

    double ne = bounds.northeast.longitude;
    double sw = bounds.southwest.longitude;
    double lngDiff = ne - sw;

    double latFraction =
        (math.sin(degreesToRadians(bounds.northeast.latitude)) -
                math.sin(degreesToRadians(bounds.southwest.latitude))) /
            2;

    double lngFraction = ((ne < sw) ? (ne + 360 - sw) : lngDiff) / 360;

    double latZoom = zoom(latFraction, screenSize.height, GLOBE_WIDTH);
    double lngZoom = zoom(lngFraction, screenSize.width, GLOBE_WIDTH);

    double result = math.min(math.min(latZoom, lngZoom), ZOOM_MAX);
    result = math.max(result, ZOOM_MIN);

    return result;
  }

  static double degreesToRadians(double degrees) {
    return degrees * math.pi / 180;
  }

  static double zoom(double fraction, double mapDimension, double globeWidth) {
    return math.log(mapDimension / (fraction * globeWidth)) / math.ln2;
  }

  static List<LatLng> decodePoly(String encoded) {
    List<LatLng> points = [];
    int index = 0;
    int len = encoded.length;
    int lat = 0;
    int lng = 0;
    while (index < len) {
      int b;
      int shift = 0;
      int result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;
      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;
      double latitude = lat / 1E5;
      double longitude = lng / 1E5;
      points.add(LatLng(latitude, longitude));
    }
    return points;
  }

  static Future<GoogleMapPathModal> getGoogleMapPathModalBetweenCoordinates({
    List<LatLng> wayPoints = const [],
    required LatLng startPoint,
    required LatLng? destination,
    bool includeStartEndPoints = true,
  }) async {
    // https://maps.googleapis.com/maps/api/directions/json?origin=22.7196,75.8577&destination=28.7041,77.1025&waypoints=23.2599,77.4126%7C26.9124,75.7873&key=AIzaSyBZ-2VSmvUZxkm4eIL6Vbm41RPPbJUS2zo
    String apiKey = Provider.of<AdminSettingsProvider>(
            MyGlobalKeys.navigatorKey.currentContext!,
            listen: false)
        .defaultAppSettingModal
        .googleApiKey!;
    if (destination == null) {
      return GoogleMapPathModal(
        path: [],
        success: false,
        distanceInMeters: 0,
        timeInSeconds: 0,
        allOtherData: {},
      );
    }
    var request = {
      'origin': '${startPoint.latitude},${startPoint.longitude}',
      'destination': '${destination.latitude},${destination.longitude}',
      // 'waypoints':[],
      'key': apiKey,
      // 'key': apiKey,
    };

    List<String> wayPoint = [];
    for (LatLng point in wayPoints) {
      wayPoint.add('${point.latitude},${point.longitude}');
    }
    request['waypoints'] = wayPoint.join("|");
    var response = await http.post(
      Uri.parse(
        NewestWebServices.getUrlString(
          apiUrl: 'https://maps.googleapis.com/maps/api/directions/json',
          request: request,
        ),
      ),
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      myCustomLogStatements('the jsons    ${jsonResponse}');
      if (jsonResponse[GoogleApiKeys.status] == "OK") {
        try {
          if (jsonResponse[GoogleApiKeys.routes][0]?['overview_polyline']
                  ?['points'] !=
              null) {
            String pointsString =
                jsonResponse['routes'][0]['overview_polyline']['points'];
            return GoogleMapPathModal(
              success: true,
              path: includeStartEndPoints
                  ? [
                      startPoint,
                      ...GoogleMapServices.decodePoly(pointsString),
                      destination
                    ]
                  : GoogleMapServices.decodePoly(pointsString),
              distanceInMeters: (double.tryParse(jsonResponse['routes'][0]
                              ['legs'][0]['distance']['value']
                          .toString()) ??
                      0)
                  .toInt(),
              timeInSeconds: (double.tryParse(jsonResponse['routes'][0]['legs']
                              [0]['duration']['value']
                          .toString()) ??
                      0)
                  .toInt(),
              allOtherData: jsonResponse,
            );
          }
        } catch (e) {
          showSnackbar('Path is not drawn');
        }
      } else {
        try {
          showSnackbar(
              'Path is not drawn: ${jsonResponse['error_message'] ?? jsonResponse['status']}');
        } catch (e) {
          showSnackbar('Path is not drawn in the map');
        }
      }
    }

    return GoogleMapPathModal(
      path: [],
      success: false,
      distanceInMeters: 0,
      timeInSeconds: 0,
      allOtherData: {},
    );
  }

  static Future<List<LatLng>> getCoordinatesBetweenTwoPoints(
      {List<LatLng> wayPoints = const [],
      required LatLng startPoint,
      required LatLng? destination}) async {
    // https://maps.googleapis.com/maps/api/directions/json?origin=22.7196,75.8577&destination=28.7041,77.1025&waypoints=23.2599,77.4126%7C26.9124,75.7873&key=AIzaSyBZ-2VSmvUZxkm4eIL6Vbm41RPPbJUS2zo
    String apiKey = Provider.of<AdminSettingsProvider>(
            MyGlobalKeys.navigatorKey.currentContext!,
            listen: false)
        .defaultAppSettingModal
        .googleApiKey!;
    if (destination == null) {
      return [];
    }
    var request = {
      'origin': '${startPoint.latitude},${startPoint.longitude}',
      'destination': '${destination.latitude},${destination.longitude}',
      // 'waypoints':[],
      'key': apiKey,
      // 'key': apiKey,
    };

    List<String> wayPoint = [];
    for (LatLng point in wayPoints) {
      wayPoint.add('${point.latitude},${point.longitude}');
    }
    request['waypoints'] = wayPoint.join("|");
    var response = await http.post(
      Uri.parse(
        NewestWebServices.getUrlString(
          apiUrl: 'https://maps.googleapis.com/maps/api/directions/json',
          request: request,
        ),
      ),
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      myCustomLogStatements('the jsons    ${jsonResponse}');
      if (jsonResponse[GoogleApiKeys.status] == "OK") {
        try {
          if (jsonResponse[GoogleApiKeys.routes][0]?['overview_polyline']
                  ?['points'] !=
              null) {
            String pointsString =
                jsonResponse['routes'][0]['overview_polyline']['points'];
            return GoogleMapServices.decodePoly(pointsString);
          }
        } catch (e) {
          showSnackbar('Path is not drawn');
        }
      } else {
        try {
          showSnackbar(
              'Path is not drawn: ${jsonResponse['error_message'] ?? jsonResponse['status']}');
        } catch (e) {
          showSnackbar('Path is not drawn in the map');
        }
      }
    }

    return [];
  }

  static int getNearestLatLngIndexFromLatLngList(
      List<LatLng> points, LatLng target) {
    double minDistance = double.infinity;
    LatLng nearestPoint = LatLng(points.first.latitude, points.first.longitude);
    int index = -1;

    for (int i = 0; i < points.length; i++) {
      // for (CustomGpxLatLngModal point in points) {
      double distance = calculateDistance(target.latitude, target.longitude,
          points[i].latitude, points[i].longitude);
      if (distance < minDistance) {
        print(
            'the min distance is $minDistance...${distance} for ${points[i].latitude}, ${points[i].longitude}');
        minDistance = distance;
        index = i;
        nearestPoint = LatLng(points[i].latitude, points[i].longitude);
      }
    }

    myCustomPrintStatement('Returning.... $nearestPoint...$index');
    return index;
  }

  static double calculateBearing(LatLng from, LatLng to) {
    double lat1 = _toRadians(from.latitude);
    double lon1 = _toRadians(from.longitude);
    double lat2 = _toRadians(to.latitude);
    double lon2 = _toRadians(to.longitude);

    double deltaLon = lon2 - lon1;

    double y = math.sin(deltaLon) * math.cos(lat2);
    double x = math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(deltaLon);

    double initialBearing = math.atan2(y, x);

    // Convert bearing from radians to degrees
    initialBearing = _toDegrees(initialBearing);

    // Ensure the result is within [0, 360) range
    initialBearing = (initialBearing + 360) % 360;

    return initialBearing;
  }

  static double _toRadians(double degrees) {
    return degrees * (math.pi / 180);
  }

  static double _toDegrees(double radians) {
    return radians * (180 / math.pi);
  }
}
