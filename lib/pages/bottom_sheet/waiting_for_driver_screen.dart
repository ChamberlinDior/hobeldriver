// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_app_driver/constants/global_keys.dart';
import 'package:connect_app_driver/constants/screen_names.dart';
import 'package:connect_app_driver/constants/types/booking_status.dart';
import 'package:connect_app_driver/functions/calculateDistanceBetweenTwoPoints.dart';
import 'package:connect_app_driver/functions/custom_time_functions.dart';
import 'package:connect_app_driver/functions/print_function.dart';
import 'package:connect_app_driver/modal/booking_modal.dart';
import 'package:connect_app_driver/pages/bottom_sheet/place_your_bid.dart';
import 'package:connect_app_driver/provider/booking_history_provider.dart';
import 'package:connect_app_driver/provider/live_booking_provider.dart';
import 'package:connect_app_driver/provider/location_provider.dart';
import 'package:connect_app_driver/services/custom_navigation_services.dart';
import 'package:connect_app_driver/services/firebase_services/firebase_service.dart';
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
import 'booking_accepted.dart';

class NewIncomingRideRequest extends StatefulWidget {
  const NewIncomingRideRequest({super.key});

  @override
  State<NewIncomingRideRequest> createState() => _NewIncomingRideRequestState();
}

class _NewIncomingRideRequestState extends State<NewIncomingRideRequest> {
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
        "this is called Adding page ... NewIncomingRideRequest....");
    var liveBookingProvider =
        Provider.of<LiveBookingProvider>(context, listen: false);
    if (liveBookingProvider.incomingBookingRequest != null) {
      pickDistanceAndTime.value =
          await GoogleMapServices.getGoogleMapPathModalBetweenCoordinates(
              startPoint: LatLng(provider.latitude, provider.longitude),
              destination: LatLng(
                  liveBookingProvider
                      .incomingBookingRequest!.startDestinationLatLng.latitude,
                  liveBookingProvider.incomingBookingRequest!
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
        Consumer<LiveBookingProvider>(
            builder: (context, liveBookingProvider, child) {
          if (liveBookingProvider.incomingBookingRequest == null) {
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
                  onTap: () async {
                    // var result = await FirebaseCollections.bookingHistory
                    //     .doc('3cbAvIUZq1C575V8ElRM')
                    //     .get();
                    // if (result.exists) {
                    //   var dttt = result.data() as Map;
                    //   FirebaseCollections.liveBookings
                    //       .doc('harshTest')
                    //       .set(dttt);
                    //   myCustomLogStatements(
                    //       "result is this ${jsonEncode(dttt['coveredPath'])}");
                    //   return;
                    // }
                    // var list = [
                    //   {"latitude": 50.6229553, "longitude": 3.0984999},
                    //   {"latitude": 50.6231509, "longitude": 3.0990085},
                    //   {"latitude": 50.623237, "longitude": 3.0993228},
                    //   {"latitude": 50.6233951, "longitude": 3.0991703},
                    //   {"latitude": 50.6234618, "longitude": 3.098886},
                    //   {"latitude": 50.6233106, "longitude": 3.0983223},
                    //   {"latitude": 50.6231307, "longitude": 3.0976844},
                    //   {"latitude": 50.6229044, "longitude": 3.0970327},
                    //   {"latitude": 50.6226698, "longitude": 3.0963323},
                    //   {"latitude": 50.6224254, "longitude": 3.0956507},
                    //   {"latitude": 50.6221886, "longitude": 3.0949544},
                    //   {"latitude": 50.6219602, "longitude": 3.094254},
                    //   {"latitude": 50.6217911, "longitude": 3.0936445},
                    //   {"latitude": 50.6217942, "longitude": 3.0931986},
                    //   {"latitude": 50.621911, "longitude": 3.0928977},
                    //   {"latitude": 50.6220012, "longitude": 3.0925816},
                    //   {"latitude": 50.6221138, "longitude": 3.0923576},
                    //   {"latitude": 50.6222432, "longitude": 3.0921821},
                    //   {"latitude": 50.6222737, "longitude": 3.0921074},
                    //   {"latitude": 50.6222595, "longitude": 3.0920821},
                    //   {"latitude": 50.6222351, "longitude": 3.0920773}
                    // ];
                    // var distance = calculateTotalDistanceFromList(
                    //     latLngList: List.generate(
                    //   list.length,
                    //   (index) => LatLng(
                    //       list[index]['latitude']!, list[index]['longitude']!),
                    // ));
                    // myCustomLogStatements("dtat is breif ${distance}");
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
              if (liveBookingProvider.incomingBookingRequest != null &&
                  liveBookingProvider.incomingBookingRequest!.isScheduled)
                Row(
                  children: [
                    CustomText.headingSmall(
                      'Schedule Ride',
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              if (liveBookingProvider.incomingBookingRequest != null &&
                  liveBookingProvider.incomingBookingRequest!.isScheduled)
                vSizedBox,
              if (liveBookingProvider.incomingBookingRequest != null &&
                  liveBookingProvider.incomingBookingRequest!.isScheduled)
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
                            (liveBookingProvider
                                    .incomingBookingRequest!.scheduledTime)
                                .toDate()),
                        secondTextFontWeight: FontWeight.w400)
                  ],
                ),
              if (liveBookingProvider.incomingBookingRequest != null &&
                  liveBookingProvider.incomingBookingRequest!.isScheduled)
                vSizedBox,
              if (liveBookingProvider.incomingBookingRequest != null &&
                  liveBookingProvider.incomingBookingRequest!.isScheduled)
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
                            (liveBookingProvider
                                    .incomingBookingRequest!.scheduledTime)
                                .toDate()),
                        secondTextFontWeight: FontWeight.w400)
                  ],
                ),
              if (liveBookingProvider.incomingBookingRequest != null &&
                  liveBookingProvider.incomingBookingRequest!.isScheduled)
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
                        "${liveBookingProvider.incomingBookingRequest?.driverBufferEarning == liveBookingProvider.incomingBookingRequest?.driverEarning ? '' : '${CustomNumberFormatters.formatNumberInCommasENWithoutDecimals(liveBookingProvider.incomingBookingRequest?.driverEarning)} - '}${CustomNumberFormatters.formatNumberInCommasEnWithCurrencyWithoutDecimals(liveBookingProvider.incomingBookingRequest?.driverBufferEarning)}",
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

                                      // '${(calculateDistanceFromCurrentLocation(liveBookingProvider.incomingBookingRequest!.startDestinationLatLng.latitude, liveBookingProvider.incomingBookingRequest!.startDestinationLatLng.longitude) * (60 / 20)).ceil()} min',
                                      color: MyColors.blackColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            CustomText.bodyText1(
                              '${liveBookingProvider.incomingBookingRequest?.startDestination}',
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
                                    "${liveBookingProvider.incomingBookingRequest!.rideApproxDistanceTraveled.toStringAsFixed(1)} Km",
                                    // "${calculateDistance(liveBookingProvider.incomingBookingRequest!.startDestinationLatLng.latitude, liveBookingProvider.incomingBookingRequest!.startDestinationLatLng.longitude, liveBookingProvider.incomingBookingRequest!.endDestinationLatLng.latitude, liveBookingProvider.incomingBookingRequest!.endDestinationLatLng.longitude)} Km",
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
                                    '${liveBookingProvider.incomingBookingRequest!.rideApproxMinute} min',
                                    color: MyColors.blackColor,
                                  ),
                                ),
                              ],
                            ),
                            CustomText.bodyText1(
                              '${liveBookingProvider.incomingBookingRequest?.endDestination}',
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
                  Expanded(
                    child: CustomButton(
                      verticalMargin: 10,
                      text: 'Accept',
                      load: liveBookingProvider.loadAcceptButton,
                      verticalPadding: 10,
                      borderRadius: 10,
                      onTap: () {
                        liveBookingProvider.acceptIncomingBookingRequest();

                        // var request = {
                        //   ApiKeys.updatedAt: Timestamp.now(),
                        //   ApiKeys.acceptedBy: userData!.userId,
                        //   ApiKeys.bookingStatus: BookingStatus.acceptedByDriver,
                        //   ApiKeys.bookingOtp: TwilioApiServices.generateOtp(6),
                        // };
                        // FirebaseCollections.liveBookings
                        //     .doc(liveBookingProvider.incomingBookingRequest!.id)
                        //     .update(request);
                        // FirebaseCloudMessagingV1().sendPushNotifications(deviceIds: userData!.deviceTokens, data: {}, body: 'klsfjadls', title: 'sdf');
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
                  var liveBookingProvider =
                      Provider.of<LiveBookingProvider>(context, listen: false);

                  var request = {
                    ApiKeys.updatedAt: Timestamp.now(),
                    ApiKeys.rejectedBy:
                        FieldValue.arrayUnion([userData!.userId]),
                  };
                  FirebaseCollections.liveBookings
                      .doc(liveBookingProvider.incomingBookingRequest!.id)
                      .update(request);
                  liveBookingProvider.resetAllBookingData();
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

Future<List<bool>> showCancelReasonBottomSheet(
    {required BookingModal bookingModal}) async {
  List<String> cancelReasonList = [
    "Rider isn't here",
    "Wrong address shown",
    "Don't charge rider",
    "Rider ask to cancel",
    "To many riders",
    "To much luggage",
    "Vehicle issue",
    "Unaccompanied minor",
    "No car seat",
  ];
  List<String> beforeCancelReasonList = [
    "Accept trip by accident",
    "Problem with pickup route",
    "Made a wrong turn",
    "Pickup isn't worth it",
    "Not safe to pick up",
    "Vehicle issue",
    "Unaccompanied minor",
    "Other",
  ];
  return await showModalBottomSheet(
      context: MyGlobalKeys.navigatorKey.currentContext!,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        CustomNavigation.pop(context, [false]);
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                    Expanded(
                      child: CustomText.bodyText1(
                        "Cancel Ride?",
                        fontSize: 20,
                        textAlign: TextAlign.center,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
                const Divider(),
                CustomText.bodyText1(
                  "Why do you want to cancel?",
                  fontSize: 18,
                  textAlign: TextAlign.start,
                  fontWeight: FontWeight.w500,
                ),
                vSizedBox,
                ListView.builder(
                  itemCount: bookingModal.bookingStatus == 1
                      ? beforeCancelReasonList.length
                      : cancelReasonList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () async {
                          await Provider.of<BookingHistoryProvider>(context,
                                  listen: false)
                              .cancelScheduleRide(
                                  reason: bookingModal.bookingStatus ==
                                          BookingStatus.acceptedByDriver
                                      ? beforeCancelReasonList[index]
                                      : cancelReasonList[index],
                                  bookingModal: bookingModal);
                          CustomNavigation.pop(context, [true]);
                        },
                        child: CustomText.bodyText1(
                          bookingModal.bookingStatus ==
                                  BookingStatus.acceptedByDriver
                              ? beforeCancelReasonList[index]
                              : cancelReasonList[index],
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const Divider(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      });
}
