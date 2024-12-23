// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_app_driver/constants/api_keys.dart';
import 'package:connect_app_driver/constants/global_data.dart';
import 'package:connect_app_driver/constants/my_colors.dart';
import 'package:connect_app_driver/constants/my_image_url.dart';
import 'package:connect_app_driver/constants/sized_box.dart';
import 'package:connect_app_driver/constants/types/ride_type_status.dart';
import 'package:connect_app_driver/functions/print_function.dart';
import 'package:connect_app_driver/services/custom_navigation_services.dart';
import 'package:connect_app_driver/services/firebase_services/firebase_collections.dart';
import 'package:connect_app_driver/services/location_suggestion_services/location_suggestion_services.dart';
import 'package:connect_app_driver/widget/custom_appbar.dart';
import 'package:connect_app_driver/widget/custom_button.dart';
import 'package:connect_app_driver/widget/custom_scaffold.dart';
import 'package:connect_app_driver/widget/custom_text.dart';
import 'package:connect_app_driver/widget/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RideSettingScreen extends StatefulWidget {
  const RideSettingScreen({super.key});

  @override
  State<RideSettingScreen> createState() => _RideSettingScreenState();
}

class _RideSettingScreenState extends State<RideSettingScreen> {
  ValueNotifier<List> setedRideTypeNotify = ValueNotifier(List.generate(
    userData!.rideTypes.length,
    (index) => userData!.rideTypes[index],
  ));
  LocationSuggestionServices fromServices = LocationSuggestionServices(
    hintText: 'Current Location',
    prefixImage: MyImagesUrl.myLocation,
  );
  LocationSuggestionServices whereToServices = LocationSuggestionServices();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        if (userData!.sharedRideDetailsModal != null) {
          var dateTime1 =
              userData!.sharedRideDetailsModal!.lastUpdated.toDate();
          var dateTime2 = DateTime.now();
          if (dateTime1.year == dateTime2.year &&
              dateTime1.month == dateTime2.month &&
              dateTime1.day == dateTime2.day) {
            fromServices.latLngValueNotifier.value =
                userData!.sharedRideDetailsModal!.startDestinationLatLng;
            fromServices.searchController.text =
                userData!.sharedRideDetailsModal!.startDestination;
            whereToServices.searchController.text =
                userData!.sharedRideDetailsModal!.endDestination;
            whereToServices.latLngValueNotifier.value =
                userData!.sharedRideDetailsModal!.endDestinationLatLng;
          }
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        titleText: 'Ride Settings',
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: ValueListenableBuilder(
          valueListenable: setedRideTypeNotify,
          builder: (context, setedRideType, child) => SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText.headingSmall("Set your ride types"),
                Row(
                  children: [
                    CustomButton(
                      text: RideTypeStatus.getName(RideTypeStatus.private),
                      horizontalPadding: 14,
                      onTap: () {
                        if (!setedRideType.contains(RideTypeStatus.private)) {
                          setedRideTypeNotify.value.add(RideTypeStatus.private);
                        } else {
                          setedRideTypeNotify.value
                              .remove(RideTypeStatus.private);
                        }
                        setedRideTypeNotify.notifyListeners();
                      },
                      height: 42,
                      borderRadius: 15,
                      suffix: setedRideType.contains(RideTypeStatus.private)
                          ? const Icon(
                              Icons.done,
                              size: 20,
                              color: MyColors.blackColor,
                            )
                          : null,
                      isFlexible: true,
                      isSolid: setedRideType.contains(RideTypeStatus.private)
                          ? true
                          : false,
                    ),
                    CustomButton(
                      text: RideTypeStatus.getName(RideTypeStatus.shared),
                      horizontalPadding: 14,
                      onTap: () {
                        if (!setedRideType.contains(RideTypeStatus.shared)) {
                          setedRideTypeNotify.value.add(RideTypeStatus.shared);
                        } else {
                          setedRideTypeNotify.value
                              .remove(RideTypeStatus.shared);
                        }
                        setedRideTypeNotify.notifyListeners();
                      },
                      height: 42,
                      borderRadius: 15,
                      horizontalMargin: 18,
                      suffix: setedRideType.contains(RideTypeStatus.shared)
                          ? const Icon(
                              Icons.done,
                              size: 20,
                              color: MyColors.blackColor,
                            )
                          : null,
                      isFlexible: true,
                      isSolid: setedRideType.contains(RideTypeStatus.shared)
                          ? true
                          : false,
                    ),
                    CustomButton(
                      text: RideTypeStatus.getName(RideTypeStatus.hourly),
                      horizontalPadding: 14,
                      onTap: () {
                        showSnackbar("Comming Soon");
                        // if (!setedRideType.contains(RideTypeStatus.hourly)) {
                        //   setedRideTypeNotify.value.add(RideTypeStatus.hourly);
                        // } else {
                        //   setedRideTypeNotify.value
                        //       .remove(RideTypeStatus.hourly);
                        // }
                        // setedRideTypeNotify.notifyListeners();
                      },
                      height: 42,
                      borderRadius: 15,
                      suffix: setedRideType.contains(RideTypeStatus.hourly)
                          ? const Icon(
                              Icons.done,
                              size: 20,
                              color: MyColors.blackColor,
                            )
                          : null,
                      isFlexible: true,
                      isSolid: setedRideType.contains(RideTypeStatus.hourly)
                          ? true
                          : false,
                    ),
                  ],
                ),
                if (setedRideType.contains(RideTypeStatus.shared))
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText.headingSmall("Set your ride route"),
                      vSizedBox2,
                      fromServices.showTextField(),
                      vSizedBox,
                      fromServices.getPredictionsDropdown(),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 20, top: 0, bottom: 5),
                        child: Container(
                          height: 35,
                          width: 2,
                          color: MyColors.whiteColor,
                        ),
                      ),
                      whereToServices.showTextField(),
                      vSizedBox2,
                      whereToServices.getPredictionsDropdown(),
                      CustomButton(
                        text: "Update",
                        onTap: () async {
                          if (fromServices.searchController.text.isEmpty &&
                              fromServices.latLngValueNotifier.value ==
                                  const LatLng(22.70040, 75.875)) {
                            showSnackbar("Please enter start point");
                          } else if (whereToServices
                                  .searchController.text.isEmpty &&
                              whereToServices.latLngValueNotifier.value ==
                                  const LatLng(22.70040, 75.875)) {
                            showSnackbar("Please enter end point");
                          } else {
                            myCustomPrintStatement(
                                "datat is that ${whereToServices.latLngValueNotifier.value} ${whereToServices.searchController.text} from ${fromServices.latLngValueNotifier.value}");
                            Map dataUpdate = {
                              ApiKeys.startGeoPoint: GeoFirePoint(
                                      fromServices
                                          .latLngValueNotifier.value.latitude,
                                      fromServices
                                          .latLngValueNotifier.value.longitude)
                                  .data,
                              ApiKeys.endGeoPoint: GeoFirePoint(
                                      whereToServices
                                          .latLngValueNotifier.value.latitude,
                                      whereToServices
                                          .latLngValueNotifier.value.longitude)
                                  .data,
                              ApiKeys.startDestination:
                                  fromServices.searchController.text,
                              ApiKeys.endDestination:
                                  whereToServices.searchController.text,
                              ApiKeys.lastUpdated: Timestamp.now()
                            };
                            await FirebaseCollections.users
                                .doc(userData!.userId)
                                .update({
                              ApiKeys.rideTypes: setedRideType,
                              ApiKeys.sharedRideConfig: dataUpdate
                            });
                            showSnackbar("Updated successfully");
                            CustomNavigation.pop(context);
                          }
                        },
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
