// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_app_driver/constants/global_keys.dart';
import 'package:connect_app_driver/constants/screen_names.dart';
import 'package:connect_app_driver/functions/custom_time_functions.dart';
import 'package:connect_app_driver/functions/print_function.dart';
import 'package:connect_app_driver/pages/bottom_sheet/place_your_bid.dart';
import 'package:connect_app_driver/provider/live_booking_provider.dart';
import 'package:connect_app_driver/provider/location_provider.dart';
import 'package:connect_app_driver/provider/schedule_booking_provider.dart';
import 'package:connect_app_driver/services/google_map_services/google_map_path_modal.dart';
import 'package:connect_app_driver/services/google_map_services/google_map_services.dart';
import 'package:connect_app_driver/widget/custom_button.dart';
import 'package:connect_app_driver/widget/custom_rich_text.dart';
import 'package:connect_app_driver/widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../constants/api_keys.dart';
import '../../constants/global_data.dart';
import '../../constants/my_colors.dart';
import '../../constants/my_image_url.dart';
import '../../constants/sized_box.dart';
import '../../functions/custom_number_formatters.dart';
import '../../provider/bottom_sheet_provider.dart';
import '../../provider/new_firebase_auth_provider.dart';
import '../../services/firebase_services/firebase_collections.dart';

class NewIncomingScheduleRideRequest extends StatefulWidget {
  const NewIncomingScheduleRideRequest({super.key});

  @override
  State<NewIncomingScheduleRideRequest> createState() =>
      _NewIncomingScheduleRideRequestState();
}

class _NewIncomingScheduleRideRequestState
    extends State<NewIncomingScheduleRideRequest> {
  ValueNotifier<GoogleMapPathModal?> pickDistanceAndTime = ValueNotifier(null);
  @override
  void initState() {
    Provider.of<LiveBookingProvider>(
      MyGlobalKeys.navigatorKey.currentContext!,
      listen: false,
    ).addListener(getPathFromDriverLocationToPickup);
    super.initState();
  }

  @override
  void dispose() {
    // Don't forget to remove the listener
    Provider.of<LiveBookingProvider>(
      MyGlobalKeys.navigatorKey.currentContext!,
      listen: false,
    ).removeListener(getPathFromDriverLocationToPickup);
    super.dispose();
  }

  getPathFromDriverLocationToPickup() async {
    var provider = Provider.of<MyLocationProvider>(
        MyGlobalKeys.navigatorKey.currentContext!,
        listen: false);
    myCustomPrintStatement(
        "this is called Adding page ... NewIncomingScheduleRideRequest....");
    var liveBookingProvider =
        Provider.of<ScheduleBookingProvider>(context, listen: false);
    if (liveBookingProvider.incomingSceduledBookingRequest != null) {
      pickDistanceAndTime.value =
          await GoogleMapServices.getGoogleMapPathModalBetweenCoordinates(
              startPoint: LatLng(provider.latitude, provider.longitude),
              destination: LatLng(
                  liveBookingProvider.incomingSceduledBookingRequest!
                      .startDestinationLatLng.latitude,
                  liveBookingProvider.incomingSceduledBookingRequest!
                      .startDestinationLatLng.longitude));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        vSizedBox,
        Consumer<ScheduleBookingProvider>(
            builder: (context, liveBookingProvider, child) {
          if (liveBookingProvider.incomingSceduledBookingRequest == null) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                vSizedBox,
                const CircleAvatar(
                  radius: 30,
                  // backgroundColor: MyColors.greyWhiteThemeColor(),
                  backgroundColor: MyColors.greyColor,
                  backgroundImage: AssetImage(
                    MyImagesUrl.manPerson1,
                  ),
                ),
                vSizedBox2,
                CustomText.headingSmall(
                  'Searching rides nearby you....',
                  fontWeight: FontWeight.w500,
                ),
                // CustomText.headingSmall(
                //   'Searching driver nearby you',
                //   fontWeight: FontWeight.w400,
                //   fontSize: 13,
                // ),
                vSizedBox2,
                LinearProgressIndicator(
                  backgroundColor: MyColors.primaryColor.withOpacity(0.2),
                  color: MyColors.yellowColor,
                ),
                vSizedBox2,

                CustomButton(
                  width: double.infinity,
                  verticalMargin: 30,
                  text: 'Cancel',
                  onTap: () {
                    userData!.isOnline = false;
                    Map<String, dynamic> request = {
                      ApiKeys.isOnline: userData!.isOnline
                    };
                    FirebaseAuthProvider.editProfile(request);
                  },
                ),
                vSizedBox3,
              ],
            );
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (liveBookingProvider.customerDetail != null)
                CircleAvatar(
                  radius: 40,
                  // backgroundColor: MyColors.greyWhiteThemeColor(),
                  backgroundColor: MyColors.greyColor,
                  backgroundImage: NetworkImage(
                      liveBookingProvider.customerDetail!.profileImage ??
                          MyImagesUrl.profileImage),
                ),
              vSizedBox,
              if (liveBookingProvider.customerDetail != null)
                CustomText.headingSmall(
                  liveBookingProvider.customerDetail!.fullName,
                  fontWeight: FontWeight.w500,
                ),
              // CustomText.headingSmall(
              //   'Searching driver nearby you',
              //   fontWeight: FontWeight.w400,
              //   fontSize: 13,
              // ),
              vSizedBox2,
              LinearProgressIndicator(
                backgroundColor: MyColors.primaryColor.withOpacity(0.2),
                color: MyColors.yellowColor,
              ),
              vSizedBox2,
              if (liveBookingProvider.incomingSceduledBookingRequest != null &&
                  liveBookingProvider
                      .incomingSceduledBookingRequest!.isScheduled)
                Row(
                  children: [
                    CustomText.headingSmall(
                      'Schedule Ride',
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              if (liveBookingProvider.incomingSceduledBookingRequest != null &&
                  liveBookingProvider
                      .incomingSceduledBookingRequest!.isScheduled)
                vSizedBox,
              if (liveBookingProvider.incomingSceduledBookingRequest != null &&
                  liveBookingProvider
                      .incomingSceduledBookingRequest!.isScheduled)
                Row(
                  children: [
                    Image.asset(
                      MyImagesUrl.calender,
                      width: 24,
                    ),
                    hSizedBox,
                    CustomRichText(
                        firstText: 'Scheduled on :-',
                        firstTextFontWeight: FontWeight.w700,
                        secondText: CustomTimeFunctions.formatDateMonthAndYear(
                            (liveBookingProvider.incomingSceduledBookingRequest!
                                    .scheduledTime)
                                .toDate()),
                        secondTextFontWeight: FontWeight.w400)
                  ],
                ),
              if (liveBookingProvider.incomingSceduledBookingRequest != null &&
                  liveBookingProvider
                      .incomingSceduledBookingRequest!.isScheduled)
                vSizedBox,
              if (liveBookingProvider.incomingSceduledBookingRequest != null &&
                  liveBookingProvider
                      .incomingSceduledBookingRequest!.isScheduled)
                Row(
                  children: [
                    Image.asset(
                      MyImagesUrl.timeIcon,
                      width: 24,
                    ),
                    hSizedBox,
                    CustomRichText(
                        firstText: 'Pickup Time:-',
                        firstTextFontWeight: FontWeight.w700,
                        secondText: CustomTimeFunctions.formatDateInHHMM(
                            (liveBookingProvider.incomingSceduledBookingRequest!
                                    .scheduledTime)
                                .toDate()),
                        secondTextFontWeight: FontWeight.w400)
                  ],
                ),
              if (liveBookingProvider.incomingSceduledBookingRequest != null &&
                  liveBookingProvider
                      .incomingSceduledBookingRequest!.isScheduled)
                Divider(
                  color: MyColors.dividerColor,
                  height: 40,
                ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText.headingSmall(
                    'Route',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.wallet,
                        size: 30,
                      ),
                      hSizedBox,
                      CustomText.headingSmall(
                        "${liveBookingProvider.incomingSceduledBookingRequest?.driverBufferEarning == liveBookingProvider.incomingSceduledBookingRequest?.driverEarning ? '' : '${CustomNumberFormatters.formatNumberInCommasENWithoutDecimals(liveBookingProvider.incomingSceduledBookingRequest?.driverEarning)} - '}${CustomNumberFormatters.formatNumberInCommasEnWithCurrencyWithoutDecimals(liveBookingProvider.incomingSceduledBookingRequest?.driverBufferEarning)}",
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ],
                  ),
                ],
              ),
              vSizedBox,
              // if (tripProvider.booking != null)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      // Icon(
                      //   Icons.circle,
                      //   size: 15,
                      //   // color: MyColors.blackThemeColor(),
                      //   color: MyColors.whiteColor,
                      // ),
                      Image.asset(MyImagesUrl.startDestinationIcon,
                          height: 25, color: Colors.white),
                      vSizedBox05,
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        width: 3,
                        height: 70,
                        // // color: MyColors.blackThemeColor(),
                        color: MyColors.whiteColor,
                      ),
                      vSizedBox05,
                      Image.asset(MyImagesUrl.endDestinationIcon,
                          height: 25, color: Colors.white),
                      vSizedBox05,
                      // Icon(
                      //   Icons.square,
                      //   size: 15,
                      //   // color: MyColors.blackThemeColor(),
                      //   color: MyColors.whiteColor,
                      // ),
                    ],
                  ),
                  hSizedBox,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ValueListenableBuilder(
                              valueListenable: pickDistanceAndTime,
                              builder: (context, timeDistance, child) => Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText.bodyText1(
                                    "Pickup Location",
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2, horizontal: 10),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: MyColors.whiteColor),
                                        shape: BoxShape.rectangle,
                                        color: MyColors.whiteColor),
                                    child: CustomText.smallText(
                                      "${(timeDistance == null ? 0.0 : (timeDistance.distanceInMeters == 0 ? 100 : timeDistance.distanceInMeters) / 1000).toStringAsFixed(1)} Km",
                                      color: MyColors.blackColor,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2, horizontal: 10),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: MyColors.whiteColor),
                                        shape: BoxShape.rectangle,
                                        color: MyColors.whiteColor),
                                    child: CustomText.smallText(
                                      "${(timeDistance == null ? 0 : ((timeDistance.timeInSeconds == 0 ? 60 : timeDistance.timeInSeconds) / 60)).round()} min",

                                      // '${(calculateDistanceFromCurrentLocation(liveBookingProvider.incomingSceduledBookingRequest!.startDestinationLatLng.latitude, liveBookingProvider.incomingSceduledBookingRequest!.startDestinationLatLng.longitude) * (60 / 20)).ceil()} min',
                                      color: MyColors.blackColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            CustomText.bodyText1(
                              '${liveBookingProvider.incomingSceduledBookingRequest?.startDestination}',
                              fontSize: 13,
                              // color: MyColors
                              //     .blackThemeColorWithOpacity(0.5),
                              color: MyColors.whiteColor70,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                        vSizedBox3,
                        vSizedBox,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CustomText.bodyText1(
                                  'Drop Location',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 10),
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: MyColors.whiteColor),
                                      shape: BoxShape.rectangle,
                                      color: MyColors.whiteColor),
                                  child: CustomText.smallText(
                                    "${liveBookingProvider.incomingSceduledBookingRequest!.rideApproxDistanceTraveled.toStringAsFixed(1)} Km",
                                    // "${calculateDistance(liveBookingProvider.incomingSceduledBookingRequest!.startDestinationLatLng.latitude, liveBookingProvider.incomingSceduledBookingRequest!.startDestinationLatLng.longitude, liveBookingProvider.incomingSceduledBookingRequest!.endDestinationLatLng.latitude, liveBookingProvider.incomingSceduledBookingRequest!.endDestinationLatLng.longitude)} Km",
                                    color: MyColors.blackColor,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 10),
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: MyColors.whiteColor),
                                      shape: BoxShape.rectangle,
                                      color: MyColors.whiteColor),
                                  child: CustomText.smallText(
                                    '${liveBookingProvider.incomingSceduledBookingRequest!.rideApproxMinute} min',
                                    color: MyColors.blackColor,
                                  ),
                                ),
                              ],
                            ),
                            CustomText.bodyText1(
                              '${liveBookingProvider.incomingSceduledBookingRequest?.endDestination}',
                              fontSize: 13,
                              color: MyColors.whiteColor70,
                              // color: MyColors
                              //     .blackThemeColorWithOpacity(0.5),
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              vSizedBox2,
              Row(
                children: [
                  if (liveBookingProvider.incomingSceduledBookingRequest !=
                          null &&
                      liveBookingProvider
                          .incomingSceduledBookingRequest!.isScheduled &&
                      -1 ==
                          liveBookingProvider
                              .incomingSceduledBookingRequest!.driverBids
                              .indexWhere(
                            (element) => element.userId == userData!.userId,
                          ))
                    Expanded(
                      child: CustomButton(
                        text: 'Place Bid',
                        horizontalPadding: 15,
                        onTap: () {
                          var bottomBar = Provider.of<BottomSheetProvider>(
                              context,
                              listen: false);
                          bottomBar.addPage(const PlaceYourBid(),
                              screenName: ScreenNames.PlaceYourBid);
                        },
                        verticalPadding: 10,
                        verticalMargin: 5,
                        isSolid: false,
                        borderRadius: 10,
                        textColor: MyColors.whiteColor,
                        color: MyColors.blackColor,
                        borderColor: MyColors.whiteColor,
                      ),
                    ),
                  if (liveBookingProvider.incomingSceduledBookingRequest !=
                          null &&
                      liveBookingProvider
                          .incomingSceduledBookingRequest!.isScheduled &&
                      -1 ==
                          liveBookingProvider
                              .incomingSceduledBookingRequest!.driverBids
                              .indexWhere(
                            (element) => element.userId == userData!.userId,
                          ))
                    hSizedBox,
                  Expanded(
                    child: CustomButton(
                      verticalMargin: 10,
                      text: 'Accept',
                      load: liveBookingProvider.loadOnAccept,
                      verticalPadding: 10,
                      borderRadius: 10,
                      onTap: () {
                        liveBookingProvider
                            .acceptIncomingScheduleBookingRequest();
                      },
                    ),
                  ),
                ],
              ),
              vSizedBox,
              CustomButton(
                width: double.infinity,
                verticalMargin: 0,
                color: Colors.red,
                textColor: Colors.white,
                text: 'Reject',
                onTap: () async {
                  var request = {
                    ApiKeys.updatedAt: Timestamp.now(),
                    ApiKeys.rejectedBy:
                        FieldValue.arrayUnion([userData!.userId]),
                  };
                  FirebaseCollections.liveBookings
                      .doc(liveBookingProvider
                          .incomingSceduledBookingRequest!.id)
                      .update(request);
                  liveBookingProvider.restScheduledBookingData();
                },
              ),
              vSizedBox3,
            ],
          );
        }),
      ],
    );
  }
}
