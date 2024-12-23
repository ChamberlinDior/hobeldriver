// ignore_for_file: deprecated_member_use, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_app_driver/constants/api_keys.dart';
import 'package:connect_app_driver/constants/global_data.dart';
import 'package:connect_app_driver/constants/global_keys.dart';
import 'package:connect_app_driver/constants/language_en.dart';
import 'package:connect_app_driver/constants/my_colors.dart';
import 'package:connect_app_driver/constants/my_image_url.dart';
import 'package:connect_app_driver/constants/sized_box.dart';
import 'package:connect_app_driver/constants/types/booking_status.dart';
import 'package:connect_app_driver/functions/calculateDistanceBetweenTwoPoints.dart';
import 'package:connect_app_driver/functions/custom_number_formatters.dart';
import 'package:connect_app_driver/functions/custom_time_functions.dart';
import 'package:connect_app_driver/functions/print_function.dart';
import 'package:connect_app_driver/modal/booking_modal.dart';
import 'package:connect_app_driver/modal/user_modal.dart';
import 'package:connect_app_driver/pages/view_module/conversation_screen.dart';
import 'package:connect_app_driver/pages/view_module/rate_us_screen.dart';
import 'package:connect_app_driver/provider/live_booking_provider.dart';
import 'package:connect_app_driver/services/custom_navigation_services.dart';
import 'package:connect_app_driver/services/firebase_services/firebase_cloud_messaging_v1.dart';
import 'package:connect_app_driver/services/firebase_services/firebase_collections.dart';
import 'package:connect_app_driver/widget/custom_appbar.dart';
import 'package:connect_app_driver/widget/custom_button.dart';
import 'package:connect_app_driver/widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class BookingDetails extends StatefulWidget {
  final BookingModal booking;
  const BookingDetails({required this.booking, super.key});

  @override
  State<BookingDetails> createState() => _BookingDetailsState();
}

class _BookingDetailsState extends State<BookingDetails> {
  late BookingModal booking;
  Map? rating;
  UserModal? customer;
  ValueNotifier<Map<String, Marker>> bookingDetailMarker = ValueNotifier({});
  ValueNotifier<bool> showGoToPickupNoti = ValueNotifier(false);
  ValueNotifier<GoogleMapController>? mapController;
  ValueNotifier<bool> loaderShowNoti = ValueNotifier(false);
  @override
  void initState() {
    booking = widget.booking;
    getdata();
    super.initState();
  }

  getdata() async {
    if (booking.bookingStatus != BookingStatus.rideCompleted) {
      var b = await FirebaseCollections.liveBookings.doc(booking.id).get();
      if (b.exists) {
        booking = BookingModal.fromJson(b.data() as Map, b.id);
      }
    } else {
      var b = await FirebaseCollections.bookingHistory.doc(booking.id).get();
      if (b.exists) {
        booking = BookingModal.fromJson(b.data() as Map, b.id);
      }
    }
    if (!booking.startRide) {
      showGoToPickupNoti.value = true;
    }
    myCustomPrintStatement(booking);
    var d = await FirebaseCollections.users.doc(booking.requestedBy).get();
    myCustomPrintStatement('-------${d.data()}');
    if (d.exists) {
      customer = UserModal.fromJson(d.data() as Map, d.id);
      setState(() {});
    }
    var dista = await calculateTotalDistanceFromList(
        latLngList: booking.coveredPath, returnInMeter: false);

    myCustomLogStatements("the final distance is ${jsonEncode(List.generate(
      booking.coveredPath.length,
      (index) => {
        'latitude': booking.coveredPath[index].latitude,
        'longitude': booking.coveredPath[index].longitude
      },
    ))}");
    myCustomPrintStatement("the final distance is $dista");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          isBackIcon: true,
          titleText: "Booking Details",
          titleFontSize: 18,
          titleFontWeight: FontWeight.w600,
        ),
        bottomNavigationBar: Consumer<LiveBookingProvider>(
          builder: (context, liveBookingProvider, child) =>
              ValueListenableBuilder(
            valueListenable: showGoToPickupNoti,
            builder: (context, showButton, child) => userData!.isOnline &&
                    showButton &&
                    (liveBookingProvider.incomingBookingRequest == null ||
                        liveBookingProvider
                                .incomingBookingRequest!.bookingStatus ==
                            BookingStatus.pending) &&
                    booking.bookingStatus == BookingStatus.acceptedByDriver &&
                    booking.isScheduled &&
                    customer != null
                ? ValueListenableBuilder(
                    valueListenable: loaderShowNoti,
                    builder: (context, showLoader, child) => CustomButton(
                          text: "Go to Pick-Up",
                          color: MyColors.yellowColor,
                          height: 50,
                          load: showLoader,
                          horizontalMargin: 15,
                          onTap: () async {
                            loaderShowNoti.value = true;
                            var distance = calculateDistanceFromCurrentLocation(
                                booking.startDestinationLatLng.latitude,
                                booking.startDestinationLatLng.latitude);
                            var time = ((distance / 1000) / 25).ceil();
                            myCustomPrintStatement("time is that $time");
                            String notiMessage = translate(
                                    "Your driver for your booking today at BOOKING_TIME is arriving within 10 mins. And passenger ride tracking is activated.")
                                .replaceAll("10", time.toString())
                                .replaceFirst(
                                    "BOOKING_TIME",
                                    CustomTimeFunctions.formatDateInHHMM(
                                        booking.scheduledTime.toDate()));
                            String title = translate(
                                    "Driver Nearing Pick-Up – 10 Minutes Away")
                                .replaceAll("10", time.toString());

                            await FirebaseCloudMessagingV1()
                                .sendPushNotificationsWithFirebaseCollectInsertion(
                                    deviceIds: customer!.deviceTokens,
                                    data: {"screen": "driver_nearing_pick_up"},
                                    body: notiMessage,
                                    title: title,
                                    reciverUserId: customer!.userId);
                            await FirebaseCollections.liveBookings
                                .doc(booking.id)
                                .update({
                              ApiKeys.updatedAt: Timestamp.now(),
                              ApiKeys.startRide: true,
                            });

                            CustomNavigation.pop(
                                MyGlobalKeys.navigatorKey.currentContext!);
                            CustomNavigation.pop(
                                MyGlobalKeys.navigatorKey.currentContext!);
                            Future.delayed(const Duration(seconds: 3), () {
                              liveBookingProvider.onDriverLocationChange();
                              myCustomPrintStatement(
                                  "run when do data is here");
                            });
                          },
                        ))
                : Container(
                    height: 1,
                  ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 6,
                            color: MyColors.lightdark.withOpacity(0.09)),
                      ]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (booking.isScheduled == false &&
                          booking.bookingStatus != BookingStatus.rideCompleted)
                        Row(
                          children: [
                            // GlowingOverscrollIndicator(axisDirection: AxisDirection.right, color: Colors.green),
                            CustomText.headingSmall(
                              "Running",
                              style: const TextStyle(color: Colors.blue),
                            ),
                            hSizedBox,
                            const Expanded(
                                child: LinearProgressIndicator(
                              color: Colors.blue,
                            )),
                          ],
                        ),
                      if (booking.isScheduled == true)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            children: [
                              const Icon(Icons.watch_later_outlined),
                              hSizedBox,
                              CustomText.headingSmall(
                                "Scheduled on ",
                                style: const TextStyle(
                                    color: MyColors.yellowColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic),
                              ),
                              CustomText.headingSmall(
                                  CustomTimeFunctions
                                      .formatDateIndayDateMonthAtTime(
                                          (booking.scheduledTime).toDate()),
                                  style: const TextStyle(
                                      color: MyColors.yellowColor,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 12))
                            ],
                          ),
                        ),
                      // if(booking!['requestTime']!=null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText.heading(
                            "ID :${booking.bookingRefrenceId}",
                            fontSize: 11,
                          ),
                          CustomText.heading(
                            CustomTimeFunctions.formatDayDateMonthAndYear(
                                booking.createdAt.toDate()),
                            fontSize: 11,
                          ),
                        ],
                      ),
                      vSizedBox,
                      vSizedBox05,
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: BookingStatus.getColor(
                                  booking.bookingStatus)),
                          child: CustomText.heading(
                              BookingStatus.getName(booking.bookingStatus),
                              fontSize: 12,
                              color: MyColors.whiteColor),
                        ),
                      ),
                      vSizedBox,
                      Row(
                        children: [
                          Column(
                            children: [
                              CircleAvatar(
                                radius: 10,
                                backgroundColor:
                                    MyColors.whiteColor.withOpacity(0.1),
                                child: const Icon(
                                  Icons.circle,
                                  color: MyColors.whiteColor,
                                  size: 14,
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.only(top: 2.5, bottom: 1),
                                width: 3,
                                height: 44,
                                color: MyColors.whiteColor.withOpacity(0.6),
                              ),
                              Image.asset(MyImagesUrl.endDestinationIcon,
                                  scale: 4,
                                  height: 30,
                                  width: 30,
                                  color: Theme.of(context)
                                              .scaffoldBackgroundColor ==
                                          Colors.white
                                      ? null
                                      : MyColors.whiteColor)
                            ],
                          ),
                          hSizedBox,
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText.bodyText1(
                                  booking.startDestination,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                                const Divider(
                                  height: 38,
                                ),
                                CustomText.bodyText1(
                                  booking.endDestination,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      vSizedBox2,
                      if (customer != null)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText.heading(
                              "Your Rider:",
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                CustomText.heading(
                                  CustomNumberFormatters
                                      .formatNumberInCommasEnWithCurrencyWithoutDecimals(
                                          booking.totalBookingAmount),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: MyColors.greenColor,
                                ),
                              ],
                            )
                          ],
                        ),
                      vSizedBox,
                      if (customer != null)
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 23,
                              backgroundImage: CachedNetworkImageProvider(
                                customer!.profileImage!,
                              ),
                            ),
                            hSizedBox,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomText.heading(
                                        customer!.fullName,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          RatingBar(
                                            initialRating:
                                                customer!.averageRating,
                                            itemSize: 12,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            ignoreGestures: true,
                                            ratingWidget: RatingWidget(
                                              full: Image.asset(
                                                MyImagesUrl.star,
                                                color: MyColors.yellowColor,
                                              ),
                                              half: Image.asset(
                                                MyImagesUrl.star,
                                                color: MyColors.yellowColor,
                                              ),
                                              empty: Image.asset(
                                                MyImagesUrl.star,
                                                color: MyColors.whiteColor
                                                    .withOpacity(0.5),
                                              ),
                                            ),
                                            itemPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 1.0),
                                            onRatingUpdate: (rating) {},
                                          ),
                                          CustomText.heading(
                                            " ${customer!.averageRating} (${customer!.totalReviewCount} ${translate("Reviews")})",
                                            fontSize: 11,
                                            color: MyColors.whiteColor70
                                                .withOpacity(0.5),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            if (booking.bookingStatus ==
                                BookingStatus.rideCompleted)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                    color: MyColors.lightdark,
                                    borderRadius: BorderRadius.circular(15)),
                                child: CustomText.heading(
                                  "#${booking.paymentMode}",
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: MyColors.whiteColor,
                                ),
                              ),
                            if (customer != null &&
                                booking.bookingStatus !=
                                    BookingStatus.rideCompleted &&
                                booking.isScheduled == true)
                              GestureDetector(
                                onTap: () {
                                  CustomNavigation.push(
                                      context: context,
                                      screen: ConversationScreen(
                                        bookingId: widget.booking.id,
                                        userModal: customer!,
                                      ));
                                },
                                child: CircleAvatar(
                                  radius: 18,
                                  backgroundColor: MyColors.whiteColor,
                                  child: Padding(
                                    padding: const EdgeInsets.all(9),
                                    child: Image.asset(
                                      MyImagesUrl.chat,
                                    ),
                                  ),
                                ),
                              ),
                            if (customer != null &&
                                booking.bookingStatus !=
                                    BookingStatus.rideCompleted &&
                                booking.isScheduled == true)
                              hSizedBox,
                            if (customer != null &&
                                booking.bookingStatus !=
                                    BookingStatus.rideCompleted &&
                                booking.isScheduled == true)
                              GestureDetector(
                                onTap: () async {
                                  var url = "tel:${customer!.phoneWithCode}";
                                  if (await canLaunch(url)) {
                                    await launch(url);
                                  }
                                },
                                child: CircleAvatar(
                                  radius: 18,
                                  backgroundColor: MyColors.whiteColor,
                                  child: Padding(
                                    padding: const EdgeInsets.all(9),
                                    child: Image.asset(
                                      MyImagesUrl.phoneOutline,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      vSizedBox,
                      if (booking.ratingByDriver == null &&
                          booking.bookingStatus == BookingStatus.rideCompleted)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: CustomButton(
                              text: "Rate",
                              height: 30,
                              width: 60,
                              fontSize: 14,
                              verticalPadding: 0,
                              onTap: () async {
                                await CustomNavigation.push(
                                    context: context,
                                    screen: RateUsScreen(
                                      bookingDetails: widget.booking,
                                      ratingToUserDetails: customer!,
                                    ));
                                getdata();
                              }),
                        ),

                      if (booking.ratingByDriver != null)
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: MyColors.lightWhiteColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RatingBar(
                                initialRating:
                                    booking.ratingByDriver!['rating'],
                                ignoreGestures: true,
                                itemSize: 16,
                                direction: Axis.horizontal,
                                allowHalfRating: false,
                                itemCount: 5,
                                ratingWidget: RatingWidget(
                                  full: Image.asset(
                                    MyImagesUrl.star,
                                    color: MyColors.yellowColor,
                                  ),
                                  half: Image.asset(
                                    MyImagesUrl.star,
                                    color: MyColors.yellowColor,
                                  ),
                                  empty: Image.asset(
                                    MyImagesUrl.star,
                                    color: MyColors.whiteColor.withOpacity(0.6),
                                  ),
                                ),
                                itemPadding:
                                    const EdgeInsets.symmetric(horizontal: 1.0),
                                onRatingUpdate: (rating) {},
                              ),
                              vSizedBox05,
                              CustomText.heading(
                                booking.ratingByDriver!['review'],
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                              ),
                            ],
                          ),
                        ),
                      if (booking.ratingByCustomer != null) vSizedBox2,
                      if (booking.ratingByCustomer != null)
                        CustomText.heading(
                          "Rating From Customer:",
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      if (booking.ratingByCustomer != null) vSizedBox05,
                      if (booking.ratingByCustomer != null)
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: MyColors.lightWhiteColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RatingBar(
                                initialRating:
                                    booking.ratingByCustomer!['rating'],
                                ignoreGestures: false,
                                itemSize: 16,
                                direction: Axis.horizontal,
                                allowHalfRating: false,
                                itemCount: 5,
                                ratingWidget: RatingWidget(
                                  full: Image.asset(
                                    MyImagesUrl.star,
                                    color: MyColors.yellowColor,
                                  ),
                                  half: Image.asset(
                                    MyImagesUrl.star,
                                    color: MyColors.yellowColor,
                                  ),
                                  empty: Image.asset(
                                    MyImagesUrl.star,
                                    color: MyColors.whiteColor.withOpacity(0.3),
                                  ),
                                ),
                                itemPadding:
                                    const EdgeInsets.symmetric(horizontal: 1.0),
                                onRatingUpdate: (rating) {},
                              ),
                              vSizedBox05,
                              CustomText.heading(
                                booking.ratingByCustomer!['review'],
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                              ),
                            ],
                          ),
                        ),
                      if (booking.bookingStatus == BookingStatus.rideCompleted)
                        vSizedBox,
                      if (booking.bookingStatus == BookingStatus.rideCompleted)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Divider(),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: CustomText.heading(
                                    "Total Amount:",
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Expanded(
                                  child: CustomText.heading(
                                    '${CustomNumberFormatters.formatNumberInCommasEnWithCurrencyWithoutDecimals(booking.totalBookingAmount)}  ',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: CustomText.heading(
                                    "Service Fee paid by customer (SERVICE_FEE%):"
                                        .replaceFirst(
                                            "SERVICE_FEE",
                                            booking.serviceFeeInPercent
                                                .toString()),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Expanded(
                                  child: CustomText.heading(
                                    '-${CustomNumberFormatters.formatNumberInCommasEnWithCurrencyWithoutDecimals(booking.serviceFeeInPrice)}  ',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: CustomText.heading(
                                    "Ride Amount:",
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Expanded(
                                  child: CustomText.heading(
                                    '${CustomNumberFormatters.formatNumberInCommasEnWithCurrencyWithoutDecimals(booking.totalBookingAmount - booking.serviceFeeInPrice)}  ',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: CustomText.heading(
                                    "Admin Commission (ADMIN_COMMISSION%):"
                                        .replaceAll(
                                            "ADMIN_COMMISSION",
                                            booking.commissionPercent
                                                .toString()),
                                    fontSize: 15,
                                  ),
                                ),
                                Expanded(
                                  child: CustomText.heading(
                                    '-${CustomNumberFormatters.formatNumberInCommasEnWithCurrencyWithoutDecimals(booking.commissionPrice)} ',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: CustomText.heading(
                                    "Your Earning:",
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Expanded(
                                  child: CustomText.heading(
                                    '${CustomNumberFormatters.formatNumberInCommasEnWithCurrencyWithoutDecimals(booking.driverEarning)} ',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                            vSizedBox,
                            if (booking.paymentMode.toLowerCase() == "cash" &&
                                booking.serviceFeeInPrice > 0)
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                                decoration: BoxDecoration(
                                  color: MyColors.lightWhiteColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: CustomText.heading(
                                  "Note :- Admin commission and service fee have been deducted from your wallet because the customer paid you directly in cash.",
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: MyColors.yellowColor,
                                ),
                              )
                          ],
                        )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
