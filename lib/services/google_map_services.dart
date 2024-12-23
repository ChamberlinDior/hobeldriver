import 'dart:math';

import 'package:connect_app_driver/constants/global_keys.dart';
import 'package:connect_app_driver/provider/admin_settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert' as convert;

import '../functions/print_function.dart';

class GoogleMapServices {
  // static const googleMapApiKey = 'AIzaSyBgwFg2GYp7N3LPg1va6Wnr7upfoeku8f0';
  // static const googleMapApiKey = 'AIzaSyBZ-2VSmvUZxkm4eIL6Vbm41RPPbJUS2zo'; commented on 04-2-2024
  static Future<List> getPlacePridiction(text) async {
    String googleMapApiKey = Provider.of<AdminSettingsProvider>(
            MyGlobalKeys.navigatorKey.currentContext!,
            listen: false)
        .defaultAppSettingModal
        .googleApiKey!;
    String url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$text&key=${googleMapApiKey}&language=en";
    myCustomPrintStatement("the url is this ${url}");
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

  static Widget createMap(LatLng latLng, {String? customMarkerUrl}) {
    return Container();
  }

  // Widget dfkls(){
  //   return ValueListenableBuilder(
  //       valueListenable: pickup,
  //       builder: (c,p,w) {
  //         return Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //
  //             for(int i=0;i<p.length;i++)
  //               GestureDetector(
  //                 onTap: () async{
  //                   pickupLocation['controller'].text=p[i]['description'];
  //                   var address = await getLatLngByPlaceId(p[i]['place_id']);
  //                   pickupLocation['lat'] =address['result']['geometry']['location']['lat'] ;
  //                   pickupLocation['lng'] =address['result']['geometry']['location']['lng'] ;
  //                   _focusDrop.requestFocus();
  //                 },
  //                 child: Container(
  //                   width: MediaQuery.of(context).size.width,
  //                   padding: const EdgeInsets.all(10),
  //                   decoration: BoxDecoration(
  //                     border: Border(
  //                       bottom: i == p.length-1
  //                           ? BorderSide.none
  //                           : const BorderSide(
  //                         color: MyColors.greyish,
  //                       ),
  //                     ),
  //                   ),
  //                   child: Text(p[i]['description'], overflow: TextOverflow.ellipsis,),
  //                 ),
  //               ),
  //           ],);
  //       });
  // }
}

// class LatLngBounds {
//   final double minLat;
//   final double maxLat;
//   final double minLong;
//   final double maxLong;
//   LatLngBounds(this.minLat, this.maxLat, this.minLong, this.maxLong);
// }
// LatLngBounds? getLatLongBounds(List<List<double>> latLongList) {
//   if (latLongList.isEmpty) {
//     return null;
//   }
//   double minLat = latLongList[0][0];
//   double maxLat = latLongList[0][0];
//   double minLong = latLongList[0][1];
//   double maxLong = latLongList[0][1];
//   for (var latLong in latLongList) {
//     double lat = latLong[0];
//     double long = latLong[1];
//     minLat = (lat < minLat) ? lat : minLat;
//     maxLat = (lat > maxLat) ? lat : maxLat;
//     minLong = (long < minLong) ? long : minLong;
//     maxLong = (long > maxLong) ? long : maxLong;
//   }
//   return LatLngBounds(minLat, maxLat, minLong, maxLong);
// }

LatLngBounds? getLatLongBoundsFromLatLngList(List<LatLng> latLongList) {
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
  // return LatLngBounds(minLat, maxLat, minLong, maxLong);
  return LatLngBounds(
      southwest: LatLng(minLat, minLong), northeast: LatLng(maxLat, maxLong));
}
// void main() {
//   List<List<double>> coordinates = [
//     [37.7749, -122.4194], // San Francisco, CA
//     [34.0522, -118.2437], // Los Angeles, CA
//     [40.7128, -74.0060],  // New York City, NY
//   ];
//   LatLngBounds bounds = getLatLongBounds(coordinates);
//   print("Latitude Bounds: (${bounds.minLat}, ${bounds.maxLat})");
//   print("Longitude Bounds: (${bounds.minLong}, ${bounds.maxLong})");
// }

double calculateZoomLevel(LatLngBounds bounds, Size screenSize) {
  final double GLOBE_WIDTH = 256; // Constant for Google Maps
  final double ZOOM_MAX = 21; // Maximum zoom level
  final double ZOOM_MIN = 1; // Minimum zoom level

  double ne = bounds.northeast.longitude;
  double sw = bounds.southwest.longitude;
  double lngDiff = ne - sw;

  double latFraction = (sin(degreesToRadians(bounds.northeast.latitude)) -
          sin(degreesToRadians(bounds.southwest.latitude))) /
      2;

  double lngFraction = ((ne < sw) ? (ne + 360 - sw) : lngDiff) / 360;

  double latZoom = zoom(latFraction, screenSize.height, GLOBE_WIDTH);
  double lngZoom = zoom(lngFraction, screenSize.width, GLOBE_WIDTH);

  double result = min(min(latZoom, lngZoom), ZOOM_MAX);
  result = max(result, ZOOM_MIN);

  return result;
}

double degreesToRadians(double degrees) {
  return degrees * pi / 180;
}

double zoom(double fraction, double mapDimension, double globeWidth) {
  return log(mapDimension / (fraction * globeWidth)) / ln2;
}
