import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_app_driver/constants/api_keys.dart';
import 'package:connect_app_driver/constants/global_data.dart';
import 'package:connect_app_driver/constants/global_keys.dart';
import 'package:connect_app_driver/constants/types/booking_status.dart';
import 'package:connect_app_driver/functions/easyLoadingConfigSetup.dart';
import 'package:connect_app_driver/functions/print_function.dart';
import 'package:connect_app_driver/modal/booking_modal.dart';
import 'package:connect_app_driver/modal/user_modal.dart';
import 'package:connect_app_driver/provider/live_booking_provider.dart';
import 'package:connect_app_driver/services/firebase_services/firebase_cloud_messaging_v1.dart';
import 'package:connect_app_driver/services/firebase_services/firebase_collections.dart';
import 'package:connect_app_driver/widget/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookingHistoryProvider extends ChangeNotifier {
  bool bookingHistoryLoader = false;
  bool currentBookingLoader = false;
  bool scheduleBookingLoader = false;
  List<BookingModal> pastBookingList = [];
  List<BookingModal> currentBookingList = [];
  List<BookingModal> scheduleBookingList = [];
  double todayIncome = 0.0;
  double todayTotalEarningWithoutCommission = 0.0;
  int totalTodaybookingCount = 0;
  double lastTripIncome = 0.0;
  double lastTripEarningWithOutCommission = 0.0;
  Timestamp? lastTripTime;
  getPastBookingHistory() async {
    bookingHistoryLoader = true;
    notifyListeners();
    var res = await FirebaseCollections.bookingHistory
        .where(ApiKeys.acceptedBy, isEqualTo: userData!.userId)
        .orderBy(ApiKeys.rideCompletedTime, descending: true)
        .get();
    myCustomPrintStatement("dhhjhgjdfhgjj fdgkjdfkj ${res.docs.length}");
    pastBookingList = List.generate(res.docs.length, (index) {
      var data = res.docs[index].data() as Map;
      return BookingModal.fromJson(data, res.docs[index].id);
    }).toList();
    bookingHistoryLoader = false;
    notifyListeners();
  }

  getCurrentBookingHistory() async {
    currentBookingLoader = true;
    notifyListeners();
    var res = await FirebaseCollections.liveBookings
        .where(ApiKeys.acceptedBy, isEqualTo: userData!.userId)
        .orderBy(ApiKeys.scheduledTime, descending: false)
        .get();

    currentBookingList = List.generate(res.docs.length, (index) {
      var data = res.docs[index].data() as Map;
      return BookingModal.fromJson(data, res.docs[index].id);
    }).toList();
    currentBookingLoader = false;
    notifyListeners();
  }

  getScheduleBookingHistory() async {
    scheduleBookingLoader = true;
    notifyListeners();
    var res = await FirebaseCollections.liveBookings
        .where(ApiKeys.acceptedBy, isEqualTo: userData!.userId)
        .where(ApiKeys.isScheduled, isEqualTo: true)
        .orderBy(ApiKeys.scheduledTime, descending: false)
        .get();

    scheduleBookingList = List.generate(res.docs.length, (index) {
      var data = res.docs[index].data() as Map;
      return BookingModal.fromJson(data, res.docs[index].id);
    }).toList();
    scheduleBookingLoader = false;
    notifyListeners();
  }

  cancelScheduleRide(
      {required String reason, required BookingModal bookingModal}) async {
    showLoading();
    UserModal? customerDetails;
    if (bookingModal.requestedBy.isNotEmpty) {
      var userData =
          await FirebaseCollections.users.doc(bookingModal.requestedBy).get();
      if (userData.exists) {
        myCustomPrintStatement("driver data is that ${userData.data() as Map}");

        customerDetails = UserModal.fromJson(
            userData.data() as Map, bookingModal.requestedBy);
        notifyListeners();
        myCustomPrintStatement("cutomer details---------------------updated");
      }
    }
    Map<String, dynamic> request = {};
    bookingModal.bookingStatus = BookingStatus.rideCancled;
    request.addAll(bookingModal.toJson());
    request[ApiKeys.rejectReason] = reason;
    request[ApiKeys.bookingStatus] = BookingStatus.rideCancled;
    request[ApiKeys.cancelledBy] = userData!.userId;
    notifyListeners();

    try {
      await FirebaseCollections.cancelledBookings
          .doc(bookingModal.id)
          .set(request);
      await FirebaseCollections.liveBookings.doc(bookingModal.id).delete();

      if (customerDetails != null) {
        await FirebaseCloudMessagingV1().sendPushNotifications(
            deviceIds: customerDetails.deviceTokens,
            data: {},
            body:
                "Your ${bookingModal.isScheduled ? "scheduled " : ""}ride has been cancelled by captain ${userData!.fullName}",
            title:
                "${bookingModal.isScheduled ? "Scheduled " : ""}Ride Cancelled");
      }
      Provider.of<LiveBookingProvider>(
              MyGlobalKeys.navigatorKey.currentContext!,
              listen: false)
          .resetAllBookingData();
    } catch (e) {
      showSnackbar('Could not cancel ride $e');
    }
    hideLoading();
  }

  Future<void> fetchTodaysHistory() async {
    // Get the current date
    DateTime today = DateTime.now();

    // Construct timestamps for the start and end of today
    DateTime startOfToday = DateTime(today.year, today.month, today.day);
    DateTime endOfToday =
        DateTime(today.year, today.month, today.day, 23, 59, 59);
    // Convert DateTime objects to Firestore Timestamps
    Timestamp startTimestamp = Timestamp.fromDate(startOfToday);
    Timestamp endTimestamp = Timestamp.fromDate(endOfToday);

    try {
      // Query Firestore collection "bookingHistory"
      var res = await FirebaseCollections.bookingHistory
          .where(ApiKeys.acceptedBy, isEqualTo: userData!.userId)
          .where(ApiKeys.rideCompletedTime,
              isGreaterThanOrEqualTo:
                  startTimestamp) // Filter documents with endTime >= startOfToday
          .where(ApiKeys.rideCompletedTime,
              isLessThanOrEqualTo:
                  endTimestamp) // Filter documents with endTime <= endOfToday
          .orderBy(ApiKeys.rideCompletedTime, descending: true)
          .get();
      double totalTodayIncome = 0.0;
      lastTripIncome = 0.0;
      lastTripEarningWithOutCommission = 0.0;
      todayTotalEarningWithoutCommission = 0.0;
      totalTodaybookingCount = 0;
      lastTripTime = null;
      if (res.docs.isNotEmpty) {
        totalTodaybookingCount = res.docs.length;
        var firstTime = res.docs.first.data() as Map;
        lastTripIncome =
            double.parse(firstTime[ApiKeys.totalBookingAmount].toString());
        lastTripEarningWithOutCommission =
            double.parse(firstTime[ApiKeys.driverEarning].toString());

        lastTripTime = firstTime[ApiKeys.rideCompletedTime];
        for (var i = 0; i < res.docs.length; i++) {
          var docData = res.docs[i].data() as Map;
          totalTodayIncome +=
              double.parse(docData[ApiKeys.totalBookingAmount].toString());
          todayTotalEarningWithoutCommission +=
              double.parse(docData[ApiKeys.driverEarning].toString());
        }
      }
      // Loop through the documents and do something with them
      myCustomPrintStatement(
          "My today bokking list lastTripIncome $lastTripIncome ${res.docs.length}  total income $totalTodayIncome");
      todayIncome = double.parse(
          totalTodayIncome > 0 ? totalTodayIncome.toStringAsFixed(2) : "0.0");
      notifyListeners();
    } catch (e) {
      myCustomPrintStatement("Error fetching todays history: $e");
    }
  }
}
