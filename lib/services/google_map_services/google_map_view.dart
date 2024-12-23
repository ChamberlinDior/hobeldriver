// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:connect_app_driver/constants/global_data.dart';
import 'package:connect_app_driver/constants/global_keys.dart';
import 'package:connect_app_driver/functions/print_function.dart';
import 'package:connect_app_driver/provider/live_booking_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../provider/google_map_provider.dart';
import '../../widget/custom_scaffold.dart';

class GoogleMapView extends StatefulWidget {
  const GoogleMapView({super.key});

  @override
  State<GoogleMapView> createState() => _GoogleMapViewState();
}

class _GoogleMapViewState extends State<GoogleMapView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((val) {
      // var googleMapProvider = Provider.of<GoogleMapProvider>(context, listen: false);
      // googleMapProvider.startRoute();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      // appBar: CustomAppBar(),
      body: Consumer<GoogleMapProvider>(
          builder: (context, googleMapProvider, child) {
        myCustomPrintStatement(
            'the polylines are ${googleMapProvider.polyLines.length} and markers are ${googleMapProvider.markers.length}...${googleMapProvider.markers.firstOrNull?.position}');
        return Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: GoogleMap(
                    gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                      Factory<OneSequenceGestureRecognizer>(
                        () => EagerGestureRecognizer(),
                      ),
                    },
                    
                    initialCameraPosition:
                     CameraPosition(
                      // target: LatLng(
                      //     myLocationProvider.latitude, myLocationProvider.longitude),
                      target: googleMapProvider.initialMapLocation,
                      zoom: googleMapProvider.navigationZoom,
                    ),
                    myLocationEnabled: true,
                    
                    myLocationButtonEnabled: true,
                    padding: const EdgeInsets.only(top: 120, right: 10),
                    polylines: googleMapProvider.showAllPolyLines(),
                    markers: googleMapProvider.showAllMarkers(),
                    onTap: (position) {
                      myCustomPrintStatement('sfasdfasdf');
                      googleMapProvider
                          .customInfoWindowController.hideInfoWindow!();
                    },
                    onCameraMove: (position) {
                      myCustomPrintStatement(
                          'On camera move sfasdfasdf ${googleMapProvider.autoRecenter}');
                      if (position.zoom != googleMapProvider.navigationZoom) {
                        if (googleMapProvider.autoRecenter == true) {
                          googleMapProvider.autoRecenter = false;
                          Future.delayed(const Duration(milliseconds: 500))
                              .then((sdf) {
                            googleMapProvider.autoRecenter = false;
                            googleMapProvider.notifyListeners();
                          });

                          googleMapProvider.notifyListeners();
                        }
                      }
                      if (googleMapProvider
                              .customInfoWindowController.onCameraMove !=
                          null) {
                        googleMapProvider
                            .customInfoWindowController.onCameraMove!();
                      }
                    },
                    onCameraMoveStarted: () {
                      myCustomPrintStatement(
                          'On camera move started sfasdfasdf ${googleMapProvider.autoRecenter}');
                    },
                    onMapCreated: (GoogleMapController controller) async {
                      googleMapProvider.customInfoWindowController
                          .googleMapController = controller;
                      googleMapProvider.googleMapController = controller;
                      googleMapProvider.autoRecenter = true;

                      print('sdfaksjdhfkasfkjds $controller ${googleMapProvider.initialMapLocation}');
                      Future.delayed(const Duration(milliseconds: 500))
                          .then((sdf) {
                        googleMapProvider.autoRecenter = true;
                        googleMapProvider.notifyListeners();
                      });
                      if (userData!.isOnline) {
                        var liveBookingsProvider =
                            Provider.of<LiveBookingProvider>(
                                MyGlobalKeys.navigatorKey.currentContext!,
                                listen: false);
                        liveBookingsProvider.listenForCurrentBooking();
                        googleMapProvider.notifyListeners();
myCustomPrintStatement(
                          'On map create move started sfasdfasdf ');
                        // var bound = GoogleMapServices.getLatLongBoundsFromLatLngList(googleMapProvider.polyLines.first.points);
                        // if(bound!=null)
                        // googleMapProvider.googleMapController!.animateCamera(CameraUpdate.newLatLngBounds(bound, 40));
                      }
                    },
                    // fortyFiveDegreeImageryEnabled: true,

                    // scrollGesturesEnabled: ,
                  ),
                )
              ],
            ),

            // if(!googleMapProvider.autoRecenter)
            // Positioned(
            //   bottom: 10,
            //   right: 20,
            //   child: CustomButton(text: 'Recenter',onTap: (){
            //
            //     googleMapProvider.autoRecenter = true;
            //     googleMapProvider.notifyListeners();
            //   },
            //     width: 150,
            //     fontSize: 14,
            //     height: 40,
            //   ),
            // )
          ],
        );
      }),
    );
  }
}
