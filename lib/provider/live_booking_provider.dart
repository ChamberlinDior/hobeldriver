import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_app_driver/constants/api_keys.dart';
import 'package:connect_app_driver/constants/global_data.dart';
import 'package:connect_app_driver/constants/language_en.dart';
import 'package:connect_app_driver/constants/my_image_url.dart';
import 'package:connect_app_driver/constants/types/booking_status.dart';
import 'package:connect_app_driver/functions/calculateDistanceBetweenTwoPoints.dart';
import 'package:connect_app_driver/functions/custom_number_formatters.dart';
import 'package:connect_app_driver/functions/print_function.dart';
import 'package:connect_app_driver/modal/booking_modal.dart';
import 'package:connect_app_driver/modal/user_modal.dart';
import 'package:connect_app_driver/pages/bottom_sheet/booking_accepted.dart';
import 'package:connect_app_driver/pages/bottom_sheet/complete_ride.dart';
import 'package:connect_app_driver/pages/bottom_sheet/payment_summary.dart';
import 'package:connect_app_driver/pages/view_module/rate_us_screen.dart';
import 'package:connect_app_driver/provider/booking_history_provider.dart';
import 'package:connect_app_driver/provider/bottom_sheet_provider.dart';
import 'package:connect_app_driver/provider/google_map_provider.dart';
import 'package:connect_app_driver/provider/schedule_booking_provider.dart';
import 'package:connect_app_driver/services/custom_navigation_services.dart';
import 'package:connect_app_driver/services/firebase_services/firebase_cloud_messaging_v1.dart';
import 'package:connect_app_driver/services/firebase_services/firebase_collections.dart';
import 'package:connect_app_driver/services/google_map_services/custom_map_keys.dart';
import 'package:connect_app_driver/services/google_map_services/google_map_services.dart';
import 'package:connect_app_driver/services/shared_preference_services/shared_preference_services.dart';
import 'package:connect_app_driver/services/twilio/twilio_api_services.dart';
import 'package:connect_app_driver/widget/show_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../constants/global_keys.dart';
import '../constants/screen_names.dart';
import '../pages/bottom_sheet/waiting_for_driver_screen.dart';
import 'location_provider.dart';

class LiveBookingProvider extends ChangeNotifier {
  BookingModal? incomingBookingRequest;

  final geo = GeoFlutterFire();
  double radius = 50;
  UserModal? customerDetail;
  StreamSubscription<QuerySnapshot<Object?>>? currentBookingListener;
  Stream<List<DocumentSnapshot>>? incomingBookingRequestStream;
  StreamSubscription<List<DocumentSnapshot<Object?>>>?
      nearbyBookingsStreamListener;
  bool fakeLocationStarted = false;
  bool loadAcceptButton = false;
  listenForCurrentBooking() async {
    myCustomPrintStatement('Started listening for live bookings');
    Stream<QuerySnapshot<Object?>> listen = FirebaseCollections.liveBookings
        .where(ApiKeys.acceptedBy, isEqualTo: userData!.userId)
        .orderBy(
          ApiKeys.createdAt,
        )
        .snapshots();
    var googleMapProvider = Provider.of<GoogleMapProvider>(
        MyGlobalKeys.navigatorKey.currentContext!,
        listen: false);
    Provider.of<ScheduleBookingProvider>(
            MyGlobalKeys.navigatorKey.currentContext!,
            listen: false)
        .listenForScheduledBookingRequests();
    currentBookingListener = listen.listen((data) async {
      myCustomPrintStatement('live booking is listened ${data.docs.length} ');
      var bottomSheetProvider = Provider.of<BottomSheetProvider>(
          MyGlobalKeys.navigatorKey.currentContext!,
          listen: false);
      if (data.docs.isEmpty) {
        resetAllBookingData();
        listenForIncomingBookingRequests();
      } else {
        // cancelIncomingBookingRequestStream();
        // showSnackbar('The bookings are ${data.docs.length}');
        try {
          myCustomPrintStatement('Starting loop   ${data.docs.length}');
          if (incomingBookingRequest != null &&
              -1 ==
                  data.docs.indexWhere(
                      (element) => element.id == incomingBookingRequest!.id)) {
            resetAllBookingData();
            listenForIncomingBookingRequests();
          }
          for (int i = 0; i < data.docs.length; i++) {
            if (data.docs[i].exists) {
              Map<String, dynamic> check =
                  data.docs[i].data() as Map<String, dynamic>;
              DateTime scheduleTime =
                  (check[ApiKeys.scheduledTime] as Timestamp).toDate();
              DateTime currentTime = DateTime.now();
              int difference = scheduleTime.difference(currentTime).inMinutes;
              myCustomPrintStatement(
                  "different ----------------------------- $difference   ${check[ApiKeys.bookingStatus]}");
              if (check[ApiKeys.startRide] &&
                  check[ApiKeys.bookingStatus] >=
                      BookingStatus.acceptedByDriver) {
                incomingBookingRequest =
                    BookingModal.fromJson(check, data.docs[i].id);

                myCustomPrintStatement("booking-------------------$check");
                // setBookingStream();
                if (customerDetail == null && incomingBookingRequest != null) {
                  await getCustomerDetails();
                }
                googleMapProvider.coveredPathLatLngList =
                    await SharedPreferenceServices.getPathFromLocalStorage();
                if (!runOnLiveLocation) {
                  googleMapProvider.tempRouteNavigation();
                }
                if (incomingBookingRequest!.bookingStatus ==
                        BookingStatus.acceptedByDriver ||
                    incomingBookingRequest!.bookingStatus ==
                        BookingStatus.driverReachedToPickup) {
                  bottomSheetProvider.pushAndPopUntil(BookingAccepted(),
                      screenName: ScreenNames.BookingAccepted);
                } else if (incomingBookingRequest!.bookingStatus >=
                        BookingStatus.rideStarted &&
                    incomingBookingRequest!.bookingStatus <=
                        BookingStatus.reachedToDestination) {
                  bottomSheetProvider.pushAndPopUntil(const CompleteRide(),
                      screenName: ScreenNames.CompleteRide);
                } else if (incomingBookingRequest!.bookingStatus ==
                    BookingStatus.rideCompleted) {
                  bottomSheetProvider.pushAndPopUntil(
                      const PaymentSummaryScreen(),
                      screenName: ScreenNames.PaymentSummaryPage);
                } else {
                  bottomSheetProvider.pushAndPopUntil(
                      const NewIncomingRideRequest(),
                      screenName: ScreenNames.NewIncomingRideRequest);
                }
                if (check[ApiKeys.bookingStatus] <
                    BookingStatus.rideCompleted) {
                  createPolyLinePathAccordingToBookingStatus();
                }
              }

              // booking = data.docs[0].data() as Map;

              //
              // if(booking!['status']==2){
              //   MapServices.createUpdateMarker('customer', LatLng(booking!['pickLat'], booking!['pickLng']));
              // }
            }

            // var modalMap = data.docs.first.data() as Map;
            // var modal = BookingModal.fromJson(modalMap, data.docs.first.id);
            // incomingBookingRequest = modal;
            // if (customerDetail == null) {
            //   await getCustomerDetails();
            // }
            // if (!runOnLiveLocation) {
            //   googleMapProvider.tempRouteNavigation();
            // }
            // await createPolyLinePathAccordingToBookingStatus();
            // // /

            notifyListeners();
          }
          if (incomingBookingRequest == null) {
            resetAllBookingData();
            listenForIncomingBookingRequests();
          }
        } catch (e) {
          myCustomPrintStatement(
              "Error in catch block 3463 active booking modal issue $e");
        }
      }
      notifyListeners();
    });
  }

  listenForIncomingBookingRequests() async {
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
    myCustomPrintStatement('Started listening for live bookings in driver');

    myLocationProvider.checkPermission(navigateMap: true);

    myCustomPrintStatement(
        'Started searching nearby drivers with location  ${myLocationProvider.latitude}...${myLocationProvider.longitude}');

    try {
      var snapshotDocument = FirebaseCollections.liveBookings
          .where(ApiKeys.bookingStatus, isEqualTo: BookingStatus.pending)
          .where(ApiKeys.isScheduled, isEqualTo: false)
          .where(ApiKeys.vehicle_type,
              isEqualTo: userData!.vehicleModal!.vehicle_type);

      var center = geo.point(
          latitude: myLocationProvider.latitude,
          longitude: myLocationProvider.longitude);
      // var center = GeoFirePoint(
      //     myLocationProvider.latitude, myLocationProvider.longitude);
      myCustomPrintStatement(
          'Started searching nearby drivers with location center :--- $center ');

      incomingBookingRequestStream = geo
          .collection(collectionRef: snapshotDocument)
          .within(center: center, radius: radius, field: ApiKeys.startGeoPoint);

      nearbyBookingsStreamListener =
          incomingBookingRequestStream?.listen((data) {
        myCustomPrintStatement(
            'live booking request is listened ${data.length}  ${center.latitude}...${center.longitude}');

        if (data.isEmpty) {
          if (incomingBookingRequest != null &&
              incomingBookingRequest!.bookingStatus == BookingStatus.pending) {
            resetAllBookingData();
          }
        } else {
          // showSnackbar('The bookings are ${data.docs.length}');
          try {
            myCustomPrintStatement('Starting loop   ${data.length}');
            if (incomingBookingRequest == null && userData!.isOnline == true) {
              for (int i = 0; i < data.length; i++) {
                var modalMap = data[i].data() as Map;
                var modal = BookingModal.fromJson(modalMap, data[i].id);
                if (modal.rejectedBy.contains(userData!.userId)) {
                  myCustomLogStatements('Skipping ....${modal.id}...$i');
                } else {
                  myCustomLogStatements(
                      'setting ....${modal.id}...$i...also stopping loop');

                  incomingBookingRequest = modal;
                  break;
                }
              }

              if (incomingBookingRequest != null && customerDetail == null) {
                getCustomerDetails();
              }
              bottomSheetProvider.pushAndPopUntil(
                  const NewIncomingRideRequest(),
                  screenName: ScreenNames.NewIncomingRideRequest);
              notifyListeners();
            } else {
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

  cancelIncomingBookingRequestStream() {
    nearbyBookingsStreamListener?.cancel();
  }

  acceptIncomingBookingRequest() async {
    loadAcceptButton = true;
    notifyListeners();
    var customer = customerDetail!;
    var bookingD = incomingBookingRequest!;
    var bookingRef = FirebaseCollections.liveBookings.doc(bookingD.id);
    try {
      var results =
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
          FirebaseCloudMessagingV1()
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
          var isSchedule = incomingBookingRequest?.isScheduled;

          Future.delayed(const Duration(seconds: 5), () {
            if (incomingBookingRequest == null) {
              listenForCurrentBooking();
            }
            if (isSchedule == false) {
              onDriverLocationChange();
            }
            myCustomPrintStatement("run when do data is here");
          });
        } else {
          var bottomSheetProvider = Provider.of<BottomSheetProvider>(
              MyGlobalKeys.navigatorKey.currentContext!,
              listen: false);
          bottomSheetProvider.pushAndPopUntil(const NewIncomingRideRequest(),
              screenName: ScreenNames.NewIncomingRideRequest);
          bottomSheetProvider.measureChildSize();
          showSnackbar(
              "Oops! You lost this booking because another driver accepted it first.");
        }
      }, maxAttempts: 1);
      myCustomPrintStatement("data is that ${results}");
      loadAcceptButton = false;
      notifyListeners();
    } catch (e) {
      loadAcceptButton = false;
      notifyListeners();
    }
  }

  startRide() async {
    var customer = customerDetail!;
    await FirebaseCollections.liveBookings
        .doc(incomingBookingRequest!.id)
        .update({
      ApiKeys.bookingStatus: BookingStatus.rideStarted,
      ApiKeys.rideStartedTime: Timestamp.now(),
    });
    if (runOnLiveLocation == false) {
      var googleMapProvider = Provider.of<GoogleMapProvider>(
          MyGlobalKeys.navigatorKey.currentContext!,
          listen: false);
      googleMapProvider.fakeLoctionPause = false;
      googleMapProvider.notifyListeners();
    }
    FirebaseCloudMessagingV1()
        .sendPushNotificationsWithFirebaseCollectInsertion(
      deviceIds: customer.deviceTokens,
      data: {},
      otherDetails: {},
      body: translate(
              "Your ride has been started. Enjoy your ride with captain DRIVER_NAME")
          .replaceAll("DRIVER_NAME", userData!.fullName),
      // "Your ride has been started. Enjoy your ride with captain ${userData!.fullName}.",
      title: translate("Ride Started"),
      reciverUserId: customer.userId,
    );
  }

  completeRide() async {
    var customer = customerDetail!;
    var googleMap = Provider.of<GoogleMapProvider>(
        MyGlobalKeys.navigatorKey.currentContext!,
        listen: false);
    var previousBooking = incomingBookingRequest!;

// final price calculation

    previousBooking.rideCompletedTime = Timestamp.now();
    previousBooking.bookingStatus = BookingStatus.rideCompleted;
    previousBooking.coveredPath =
        previousBooking.coveredPath + googleMap.coveredPathLatLngList;
    var waitingTime = previousBooking.rideStatedTime!
        .toDate()
        .difference(previousBooking.reachedTime!.toDate())
        .inSeconds;
    var totalCoverDistance = calculateTotalDistanceFromList(
        latLngList: previousBooking.coveredPath, returnInMeter: false);
    var totalTimeTaken = previousBooking.rideCompletedTime!
        .toDate()
        .difference(previousBooking.rideStatedTime!.toDate())
        .inSeconds;
    myCustomPrintStatement(
        "total distance covered $totalCoverDistance waiting charge $waitingTime totalTime taken $totalTimeTaken");

    previousBooking.waitingTimeInMinutes = waitingTime >
            previousBooking.selectedVehicleDetails.freeWaitingMinutes * 60
        ? ((waitingTime -
                previousBooking.selectedVehicleDetails.freeWaitingMinutes *
                    60) /
            60)
        : 0;
    var finalPrice = calculatePrice(
        vehicleBasePrice:
            previousBooking.selectedVehicleDetails.vehicleBasePrice,
        perKmPrice: previousBooking.selectedVehicleDetails.perKmPrice,
        distance: totalCoverDistance,
        waitingChargePerMinute:
            previousBooking.selectedVehicleDetails.waitingChargePerMinute,
        waitingTimeInMinutes: waitingTime >
                (previousBooking.selectedVehicleDetails.freeWaitingMinutes * 60)
            ? ((waitingTime -
                    (previousBooking.selectedVehicleDetails.freeWaitingMinutes *
                        60)) /
                60)
            : 0,
        minutes: (previousBooking.rideStatedTime!
                    .toDate()
                    .difference(previousBooking.rideCompletedTime!.toDate())
                    .inSeconds /
                60)
            .abs(),
        perMinCharge: previousBooking.selectedVehicleDetails.perMinCharge);
    myCustomPrintStatement("total distance covered $finalPrice");

    previousBooking.serviceFeeInPrice =
        finalPrice > previousBooking.totalBookingAmount
            ? 0
            : (finalPrice * previousBooking.serviceFeeInPercent) / 100;
    previousBooking.totalBookingAmount =
        finalPrice + previousBooking.serviceFeeInPrice;
    previousBooking.commissionPrice =
        (finalPrice * previousBooking.commissionPercent) / 100;
    previousBooking.driverEarning =
        finalPrice - previousBooking.commissionPrice;
    myCustomLogStatements(
        "new booking data is that ${previousBooking.toJson()}");
    await FirebaseCollections.liveBookings
        .doc(previousBooking.id)
        .update(previousBooking.addBookingRequestJson());
    googleMap.coveredPathLatLngList = [];
    googleMap.fakeLoctionPause = true;
    googleMap.notifyListeners();
    await SharedPreferenceServices.savePathToLocalStorage([]);
    await FirebaseCloudMessagingV1()
        .sendPushNotificationsWithFirebaseCollectInsertion(
      deviceIds: customer.deviceTokens,
      data: {},
      otherDetails: {},
      body: translate("Your ride has been completed."),
      title: translate("Ride Completed"),
      reciverUserId: customer.userId,
    );
  }

  cashRecived() async {
    var previousBooking = incomingBookingRequest!;

    var customer = customerDetail!;
// final price calculation

    await FirebaseCollections.bookingHistory
        .doc(previousBooking.id)
        .set(previousBooking.addBookingRequestJson());
    var totalCommissionWithServiceFee =
        previousBooking.commissionPrice + previousBooking.serviceFeeInPrice;
    if (userData!.walletEarnings >= totalCommissionWithServiceFee) {
      if (totalCommissionWithServiceFee > 0) {
        await FirebaseCollections.users.doc(userData!.userId).update({
          ApiKeys.walletEarnings:
              FieldValue.increment((totalCommissionWithServiceFee * -1))
        });
        // await FirebaseCollections.walletHistory(userData!.userId).doc().set({
        //   "bookingRef": previousBooking.id,
        //   "amount": totalCommissionWithServiceFee.toString(),
        //   "text": "Admin commission deducted",
        //   "action": "debit",
        //   "time": DateTime.now()
        // });
      }
    } else {
      await FirebaseCollections.users.doc(userData!.userId).update({
        ApiKeys.walletEarnings:
            userData!.walletEarnings - totalCommissionWithServiceFee
      });
    }
    await FirebaseCollections.liveBookings.doc(previousBooking.id).delete();
    resetAllBookingData();
    pushToRateScreen(
        previousBooking: previousBooking, customerDetails: customer);
  }

  getCustomerDetails() async {
    var cutomerData = await FirebaseCollections.users
        .doc(incomingBookingRequest!.requestedBy)
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

  createPolyLinePathAccordingToBookingStatus() async {
    var googleMapProvider = Provider.of<GoogleMapProvider>(
        MyGlobalKeys.navigatorKey.currentContext!,
        listen: false);
    var myLocationProvider = Provider.of<MyLocationProvider>(
        MyGlobalKeys.navigatorKey.currentContext!,
        listen: false);
    double distance = 0;
    if (googleMapProvider.polyLines.isNotEmpty) {
      var points = googleMapProvider.polyLines.first.points;
      var target =
          LatLng(myLocationProvider.latitude, myLocationProvider.longitude);
      int index =
          GoogleMapServices.getNearestLatLngIndexFromLatLngList(points, target);
      distance = calculateDistance(target.latitude, target.longitude,
          points[index].latitude, points[index].longitude);

      myCustomLogStatementsWithLogs(
          "the min distance is  Distance is that ${distance}");
    }
    if ((!await googleMapProvider
                .checkPolyLineExistOrNot(CustomMapKeys.pickupPathPolyline) ||
            distance > 0.45) &&
        incomingBookingRequest != null &&
        incomingBookingRequest!.bookingStatus < BookingStatus.rideStarted) {
      if (await googleMapProvider
          .checkPolyLineExistOrNot(CustomMapKeys.mainPathPolyline)) {
        googleMapProvider.removePolyline(CustomMapKeys.mainPathPolyline);
      }
      var googleMapPathModal =
          await GoogleMapServices.getGoogleMapPathModalBetweenCoordinates(
        startPoint:
            LatLng(myLocationProvider.latitude, myLocationProvider.longitude),
        destination: incomingBookingRequest!.startDestinationLatLng,
      );
      myCustomPrintStatement("path is that ${googleMapPathModal.path}");
      googleMapProvider.addPolyLine(
          polylineId: CustomMapKeys.pickupPathPolyline,
          points: googleMapPathModal.path);
      googleMapProvider.addMarker(
        latLng: incomingBookingRequest!.startDestinationLatLng,
        infowindow: null,
        markerId: CustomMapKeys.fromMarker,
        icon: MyImagesUrl.startLocationList,
      );
    } else if ((!await googleMapProvider.checkPolyLineExistOrNot(
                CustomMapKeys.pickUpToDropPathPolyLine) ||
            distance > 0.45) &&
        incomingBookingRequest != null) {
      if (await googleMapProvider
          .checkPolyLineExistOrNot(CustomMapKeys.pickupPathPolyline)) {
        googleMapProvider.removePolyline(CustomMapKeys.pickupPathPolyline);
      }
      googleMapProvider.addMarker(
          latLng: incomingBookingRequest!.endDestinationLatLng,
          infowindow: null,
          markerId: CustomMapKeys.whereToMarker,
          icon: MyImagesUrl.endLocationList);
      var googleMapPathModal =
          await GoogleMapServices.getGoogleMapPathModalBetweenCoordinates(
        startPoint:
            LatLng(myLocationProvider.latitude, myLocationProvider.longitude),
        destination: incomingBookingRequest!.endDestinationLatLng,
      );
      myCustomLogStatements("path is that ${googleMapPathModal.path}");
      googleMapProvider.addPolyLine(
          polylineId: CustomMapKeys.pickUpToDropPathPolyLine,
          points: googleMapPathModal.path);
      googleMapProvider.removeMarker(CustomMapKeys.fromMarker);
    }
  }

  resetAllBookingData() async {
    var bottomSheetProvider = Provider.of<BottomSheetProvider>(
        MyGlobalKeys.navigatorKey.currentContext!,
        listen: false);
    var googleMapProvider = Provider.of<GoogleMapProvider>(
        MyGlobalKeys.navigatorKey.currentContext!,
        listen: false);
    googleMapProvider.removeAllMarkers();
    googleMapProvider.removeAllPolyLines();
    googleMapProvider.coveredPathLatLngList = [];
    await SharedPreferenceServices.savePathToLocalStorage([]);
    bottomSheetProvider.pushAndPopUntil(
      const NewIncomingRideRequest(),
      screenName: ScreenNames.NewIncomingRideRequest,
    );
    customerDetail = null;
    incomingBookingRequest = null;

    notifyListeners();
  }

  onDriverLocationChange() async {
    var googleMap = Provider.of<GoogleMapProvider>(
        MyGlobalKeys.navigatorKey.currentContext!,
        listen: false);
    var myLocationProvider = Provider.of<MyLocationProvider>(
        MyGlobalKeys.navigatorKey.currentContext!,
        listen: false);
    createPolyLinePathAccordingToBookingStatus();
    if (incomingBookingRequest != null) {
      if (incomingBookingRequest!.bookingStatus >= BookingStatus.rideStarted) {
        googleMap.coveredPathLatLngList.add(
            LatLng(myLocationProvider.latitude, myLocationProvider.longitude));
        await SharedPreferenceServices.savePathToLocalStorage(
            googleMap.coveredPathLatLngList);
      }
      if (incomingBookingRequest!.bookingStatus ==
          BookingStatus.acceptedByDriver) {
        var distance = calculateDistanceFromCurrentLocation(
            incomingBookingRequest!.startDestinationLatLng.latitude,
            incomingBookingRequest!.startDestinationLatLng.longitude);

        if (distance <= 0.1 &&
            incomingBookingRequest!.bookingStatus ==
                BookingStatus.acceptedByDriver) {
          incomingBookingRequest!.bookingStatus =
              BookingStatus.driverReachedToPickup;
          await FirebaseCollections.liveBookings
              .doc(incomingBookingRequest!.id)
              .update({
            ApiKeys.bookingStatus: BookingStatus.driverReachedToPickup,
            ApiKeys.reachedTime: Timestamp.now()
          });
          incomingBookingRequest!.bookingStatus =
              BookingStatus.driverReachedToPickup;
          List sendNotificationTo =
              customerDetail == null ? [] : customerDetail!.deviceTokens;
          if (runOnLiveLocation == false) {
            googleMap.fakeLoctionPause = true;
            googleMap.notifyListeners();
          }

          await FirebaseCloudMessagingV1()
              .sendPushNotificationsWithFirebaseCollectInsertion(
            deviceIds: sendNotificationTo,
            data: {
              'screen': 'driver_reached',
            },
            body: translate(
                    "DRIVER_NAME has arrived at your pickup location. Please meet your captian at the pickup point.")
                .replaceAll("DRIVER_NAME", userData!.fullName),
            title: translate("Meet Your Captian"),
            reciverUserId: customerDetail!.userId,
          );
          await FirebaseCloudMessagingV1()
              .sendPushNotificationsWithFirebaseCollectInsertion(
            deviceIds: userData!.deviceTokens,
            data: {
              'screen': 'driver_reached',
            },
            body: translate(
                "You have arrived at the pickup location. Please wait for the passenger and contact them"),
            title: translate("Meet Your Passenger"),
            reciverUserId: userData!.userId,
          );
        }
      } else if (incomingBookingRequest!.bookingStatus ==
          BookingStatus.rideStarted) {
        var distance = calculateDistanceFromCurrentLocation(
            incomingBookingRequest!.endDestinationLatLng.latitude,
            incomingBookingRequest!.endDestinationLatLng.longitude);
        if (distance <= 0.1) {
          await FirebaseCollections.liveBookings
              .doc(incomingBookingRequest!.id)
              .update({
            ApiKeys.bookingStatus: BookingStatus.reachedToDestination,
            ApiKeys.updatedAt: Timestamp.now(),
            ApiKeys.coveredPath: List.generate(
                  incomingBookingRequest!.coveredPath.length,
                  (index) => {
                    ApiKeys.latitude:
                        incomingBookingRequest!.coveredPath[index].latitude,
                    ApiKeys.longitude:
                        incomingBookingRequest!.coveredPath[index].longitude,
                  },
                ) +
                List.generate(
                  googleMap.coveredPathLatLngList.length,
                  (index) => {
                    ApiKeys.latitude:
                        googleMap.coveredPathLatLngList[index].latitude,
                    ApiKeys.longitude:
                        googleMap.coveredPathLatLngList[index].longitude,
                  },
                ),
          });
          googleMap.coveredPathLatLngList = [];
          await SharedPreferenceServices.savePathToLocalStorage([]);
          incomingBookingRequest!.bookingStatus =
              BookingStatus.reachedToDestination;
          List sendNotificationTo = customerDetail!.deviceTokens;

          await FirebaseCloudMessagingV1()
              .sendPushNotificationsWithFirebaseCollectInsertion(
            deviceIds: sendNotificationTo,
            data: {
              'screen': 'reached_to_destination',
            },
            body: translate(
                "Your driver has arrived at the drop-off location. Please proceed to your destination."),
            title: translate("Destination Reached"),
            reciverUserId: customerDetail!.userId,
          );
          await FirebaseCloudMessagingV1()
              .sendPushNotificationsWithFirebaseCollectInsertion(
            deviceIds: userData!.deviceTokens,
            data: {
              'screen': 'reached_to_destination',
            },
            body: translate(
                "You have reached the destination. Please inform the passenger."),
            title: translate("Destination Reached"),
            reciverUserId: userData!.userId,
          );
        }
      } else {
        if (googleMap.coveredPathLatLngList.length > 30) {
          await FirebaseCollections.liveBookings
              .doc(incomingBookingRequest!.id)
              .update({
            ApiKeys.updatedAt: Timestamp.now(),
            ApiKeys.coveredPath: List.generate(
                  incomingBookingRequest!.coveredPath.length,
                  (index) => {
                    ApiKeys.latitude:
                        incomingBookingRequest!.coveredPath[index].latitude,
                    ApiKeys.longitude:
                        incomingBookingRequest!.coveredPath[index].longitude,
                  },
                ) +
                List.generate(
                  googleMap.coveredPathLatLngList.length,
                  (index) => {
                    ApiKeys.latitude:
                        googleMap.coveredPathLatLngList[index].latitude,
                    ApiKeys.longitude:
                        googleMap.coveredPathLatLngList[index].longitude,
                  },
                ),
          });
          googleMap.coveredPathLatLngList = [];
          await SharedPreferenceServices.savePathToLocalStorage([]);
        }
      }
    }
  }

  double calculatePrice({
    double minutes = 0,
    double perMinCharge = 0,
    required double vehicleBasePrice,
    double waitingChargePerMinute = 0,
    double waitingTimeInMinutes = 0,
    required double perKmPrice,
    required double distance,
  }) {
    double estimatedPrice = 0;
    estimatedPrice = vehicleBasePrice +
        (minutes * perMinCharge) +
        (waitingTimeInMinutes * waitingChargePerMinute) +
        (distance * perKmPrice);

    myCustomLogStatements(
        "Price is that $estimatedPrice -- waiting minutes --$waitingTimeInMinutes -- delayminutes ${minutes} round Price ${CustomNumberFormatters.formatNumberInCommasENWithoutDecimals(estimatedPrice)} distance $distance");

    return estimatedPrice;
  }

  pushToRateScreen(
      {required BookingModal previousBooking,
      required UserModal customerDetails}) {
    CustomNavigation.push(
        context: MyGlobalKeys.navigatorKey.currentContext!,
        screen: RateUsScreen(
          bookingDetails: previousBooking,
          ratingToUserDetails: customerDetails,
        ));
    Provider.of<BookingHistoryProvider>(
            MyGlobalKeys.navigatorKey.currentContext!,
            listen: false)
        .fetchTodaysHistory();
  }
}
