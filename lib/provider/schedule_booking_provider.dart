import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_app_driver/constants/api_keys.dart';
import 'package:connect_app_driver/constants/global_data.dart';
import 'package:connect_app_driver/constants/global_keys.dart';
import 'package:connect_app_driver/constants/language_en.dart';
import 'package:connect_app_driver/constants/screen_names.dart';
import 'package:connect_app_driver/constants/types/booking_status.dart';
import 'package:connect_app_driver/functions/print_function.dart';
import 'package:connect_app_driver/modal/booking_modal.dart';
import 'package:connect_app_driver/modal/user_modal.dart';
import 'package:connect_app_driver/pages/bottom_sheet/incomming_scheduled_booking_request.dart';
import 'package:connect_app_driver/pages/bottom_sheet/waiting_for_driver_screen.dart';
import 'package:connect_app_driver/provider/bottom_sheet_provider.dart';
import 'package:connect_app_driver/provider/location_provider.dart';
import 'package:connect_app_driver/services/firebase_services/firebase_cloud_messaging_v1.dart';
import 'package:connect_app_driver/services/firebase_services/firebase_collections.dart';
import 'package:connect_app_driver/services/twilio/twilio_api_services.dart';
import 'package:connect_app_driver/widget/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:provider/provider.dart';

class ScheduleBookingProvider extends ChangeNotifier {
  BookingModal? incomingSceduledBookingRequest;
  Stream<List<DocumentSnapshot>>? incomingScheduledBookingRequestStream;
  final geo = GeoFlutterFire();
  double radius = 50;
  UserModal? customerDetail;
  bool loadOnAccept = false;
  restScheduledBookingData() {
    var bottomSheetProvider = Provider.of<BottomSheetProvider>(
        MyGlobalKeys.navigatorKey.currentContext!,
        listen: false);
    customerDetail = null;
    incomingSceduledBookingRequest = null;
    bottomSheetProvider.removeSpecificPage(
        screenName: ScreenNames.NewSceduledIncomingRideRequest);
  }

  StreamSubscription<List<DocumentSnapshot<Object?>>>?
      sceduledBookingsStreamListener;
  listenForScheduledBookingRequests() async {
    if (userData!.isOnline) {
      var bottomSheetProvider = Provider.of<BottomSheetProvider>(
          MyGlobalKeys.navigatorKey.currentContext!,
          listen: false);
      bottomSheetProvider.pushAndPopUntil(const NewIncomingRideRequest(),
          screenName: ScreenNames.NewIncomingRideRequest);
      bottomSheetProvider.measureChildSize();
    }
    var myLocationProvider = Provider.of<MyLocationProvider>(
        MyGlobalKeys.navigatorKey.currentContext!,
        listen: false);
    if (myLocationProvider.latitude == 0 || myLocationProvider.latitude == 0) {
      await myLocationProvider.updateLatLong();
    }
    var bottomSheetProvider = Provider.of<BottomSheetProvider>(
        MyGlobalKeys.navigatorKey.currentContext!,
        listen: false);
    // bottomSheetProvider
    myCustomPrintStatement(
        'Started listening for Scheduled bookings in driver');

    myLocationProvider.checkPermission(navigateMap: true);

    myCustomPrintStatement(
        'Started searching nearby drivers with location  ${myLocationProvider.latitude}...${myLocationProvider.longitude}');

    try {
      var snapshotDocument = FirebaseCollections.liveBookings
          .where(ApiKeys.bookingStatus, isEqualTo: BookingStatus.pending)
          .where(ApiKeys.isScheduled, isEqualTo: true)
          .where(ApiKeys.vehicle_type,
              isEqualTo: userData!.vehicleModal!.vehicle_type);

      var center = geo.point(
          latitude: myLocationProvider.latitude,
          longitude: myLocationProvider.longitude);
      // var center = GeoFirePoint(
      //     myLocationProvider.latitude, myLocationProvider.longitude);
      myCustomPrintStatement(
          'Started searching nearby drivers with location center :--- $center ');

      incomingScheduledBookingRequestStream = geo
          .collection(collectionRef: snapshotDocument)
          .within(center: center, radius: radius, field: ApiKeys.startGeoPoint);

      sceduledBookingsStreamListener =
          incomingScheduledBookingRequestStream?.listen((data) {
        myCustomPrintStatement(
            'live booking request is listened ${data.length}  ${center.latitude}...${center.longitude}');

        if (data.isEmpty) {
          if (incomingSceduledBookingRequest != null &&
              incomingSceduledBookingRequest!.bookingStatus ==
                  BookingStatus.pending) {
            restScheduledBookingData();
          }
        } else {
          // showSnackbar('The bookings are ${data.docs.length}');
          try {
            myCustomPrintStatement('Starting loop   ${data.length}');
            if (incomingSceduledBookingRequest == null &&
                userData!.isOnline == true) {
              for (int i = 0; i < data.length; i++) {
                var modalMap = data[i].data() as Map;
                var modal = BookingModal.fromJson(modalMap, data[i].id);
                if (modal.rejectedBy.contains(userData!.userId) ||
                    -1 !=
                        modal.driverBids.indexWhere(
                          (element) => element.userId == userData!.userId,
                        )) {
                  myCustomLogStatements(
                      'Skipping scheduled booking....${modal.id}...$i');
                } else {
                  myCustomLogStatements(
                      'setting scheduled booking....${modal.id}...$i...also stopping loop');

                  incomingSceduledBookingRequest = modal;
                  break;
                }
              }

              // activeBooking = BookingModal.fromJson(data.first.data() as Map, data.docs.first.id);
              // bottomSheetProvider.isOfflineNoti.value = false;
              if (incomingSceduledBookingRequest != null &&
                  customerDetail == null) {
                getCustomerDetails();
                bottomSheetProvider.addPage(
                    const NewIncomingScheduleRideRequest(),
                    screenName: ScreenNames.NewSceduledIncomingRideRequest);
              }
              notifyListeners();
            } else {
              var datatobe = data.where(
                (element) => element.id == incomingSceduledBookingRequest?.id,
              );
              if (datatobe.isNotEmpty) {
                var modalMap = datatobe.first.data() as Map;
                incomingSceduledBookingRequest =
                    BookingModal.fromJson(modalMap, datatobe.first.id);
              }
              myCustomPrintStatement(
                  "booking is not null ====>>>>> ALREADY HAVE A BOOKING");
            }
          } catch (e) {
            myCustomPrintStatement(
                "Error in catch block 3463 active booking modal issue $e");
          }
        }
        notifyListeners();
      });
    } catch (e) {
      myCustomPrintStatement(
          "Error in catch block 3463 active booking modal issue $e");
    }
  }

  acceptIncomingScheduleBookingRequest() async {
    loadOnAccept = true;
    notifyListeners();
    var customer = customerDetail!;
    var bookingD = incomingSceduledBookingRequest!;
    var bookingRef = FirebaseCollections.liveBookings
        .doc(incomingSceduledBookingRequest!.id);
    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot bookingSnapshot = await transaction.get(bookingRef);
        if (bookingSnapshot.exists &&
            bookingSnapshot[ApiKeys.bookingStatus] == BookingStatus.pending) {
          transaction.update(bookingRef, {
            ApiKeys.bookingStatus: BookingStatus.acceptedByDriver,
            ApiKeys.acceptedBy: userData!.userId,
            ApiKeys.acceptedTime: Timestamp.now(),
            ApiKeys.bookingOtp: TwilioApiServices.generateOtp(6).toString(),
          });
          await FirebaseCloudMessagingV1()
              .sendPushNotificationsWithFirebaseCollectInsertion(
            deviceIds: customer.deviceTokens,
            data: {},
            otherDetails: {},
            body: bookingD.isScheduled
                ? "Your booking has been scheduled."
                : translate(
                        "Your booking has been accepted by captain DRIVER_NAME. Captain will arrived soon.")
                    .replaceAll("DRIVER_NAME", userData!.fullName),
            title: translate("Booking Accepted"),
            reciverUserId: customer.userId,
          );
        } else {
          showSnackbar(
              "Oops! You lost this booking because another driver accepted it first.");
        }
      }, maxAttempts: 1);
      loadOnAccept = false;
      notifyListeners();
      restScheduledBookingData();
    } catch (e) {
      print("Firestore transaction error: $e");
      loadOnAccept = false;
      notifyListeners();
    }
    var bottomSheetProvider = Provider.of<BottomSheetProvider>(
        MyGlobalKeys.navigatorKey.currentContext!,
        listen: false);
    bottomSheetProvider.removeSpecificPage(
        screenName: ScreenNames.NewSceduledIncomingRideRequest);
    bottomSheetProvider.measureChildSize();
  }

  getCustomerDetails() async {
    var cutomerData = await FirebaseCollections.users
        .doc(incomingSceduledBookingRequest!.requestedBy)
        .get();
    if (cutomerData.exists) {
      myCustomPrintStatement(
          "Customer data is that ${cutomerData.data() as Map}");

      customerDetail =
          UserModal.fromJson(cutomerData.data() as Map, cutomerData.id);
      notifyListeners();
      myCustomPrintStatement("customer details---------------------updated");
    }
  }

  cancelScheduleIncomingBookingRequestStream() {
    sceduledBookingsStreamListener?.cancel();
  }

  setBidToincomingRideRequest(String bidPrice) async {
    if (incomingSceduledBookingRequest == null) {
      showSnackbar("Oops! The booking has expired. You’re too late.");
      return;
    }

    await FirebaseCollections.liveBookings
        .doc(incomingSceduledBookingRequest!.id)
        .update({
      ApiKeys.rejectedBy: FieldValue.arrayUnion([userData!.userId]),
      ApiKeys.driverBids: FieldValue.arrayUnion([
        {
          ApiKeys.createdAt: Timestamp.now(),
          ApiKeys.fullName: userData!.fullName,
          ApiKeys.rating: userData!.averageRating,
          ApiKeys.ratingCount: userData!.totalReviewCount,
          ApiKeys.profileImage: userData!.profileImage,
          ApiKeys.driverBids: double.parse(bidPrice),
          ApiKeys.userId: userData!.userId
        }
      ])
    });

    showSnackbar("Your bid has been placed successfully");
    restScheduledBookingData();
  }
}
