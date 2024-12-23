import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_app_driver/constants/api_keys.dart';
import 'package:connect_app_driver/functions/print_function.dart';
import 'package:connect_app_driver/modal/driver_bid_modal.dart';
import 'package:connect_app_driver/modal/vehicle_type_modal.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class BookingModal {
  String id;
  LatLng startDestinationLatLng;
  LatLng endDestinationLatLng;
  String startDestination;
  Map startGeoPoint;
  Map endGeoPoint;
  String endDestination;
  String bookingRefrenceId;
  String requestedBy;
  double totalBookingAmount;
  double totalBufferBookingAmount;
  double commissionPercent;
  double commissionPrice;
  double serviceFeeInPercent;
  double serviceFeeInPrice;
  double serviceFeeBufferPrice;
  String? appliedCoupon;
  double appliedCouponDiscountAmount;
  double driverEarning;
  double driverBufferEarning;
  String vehicle_type;
  VehicleTypeModal selectedVehicleDetails;
  int bookingStatus;
  int rideApproxMinute;
  double waitingTimeInMinutes;
  double rideApproxDistanceTraveled;
  Timestamp createdAt;
  Timestamp? rideStatedTime;
  Timestamp? reachedTime;

  Timestamp? rideCompletedTime;
  Timestamp updatedAt;
  Map? ratingByDriver;
  Map? ratingByCustomer;
  int rideType;
  bool isScheduled;
  bool startRide;
  Timestamp scheduledTime;
  String paymentMode;
  List rejectedBy;
  String? acceptedBy;
  String? bookingOtp;
  List<DriverBidModal> driverBids;
  List<LatLng> coveredPath;
  BookingModal({
    required this.id,
    required this.startDestinationLatLng,
    required this.endDestinationLatLng,
    required this.startGeoPoint,
    required this.endGeoPoint,
    required this.startDestination,
    required this.endDestination,
    required this.bookingRefrenceId,
    required this.driverEarning,
    required this.driverBufferEarning,
    required this.requestedBy,
    required this.totalBookingAmount,
    required this.totalBufferBookingAmount,
    required this.commissionPercent,
    required this.commissionPrice,
    required this.serviceFeeInPercent,
    required this.serviceFeeInPrice,
    required this.serviceFeeBufferPrice,
    required this.appliedCoupon,
    required this.appliedCouponDiscountAmount,
    required this.vehicle_type,
    required this.selectedVehicleDetails,
    required this.bookingStatus,
    required this.waitingTimeInMinutes,
    required this.rideApproxDistanceTraveled,
    required this.rideApproxMinute,
    required this.rideType,
    required this.isScheduled,
    required this.startRide,
    required this.driverBids,
    required this.scheduledTime,
    required this.createdAt,
    required this.coveredPath,
    this.rideCompletedTime,
    this.rideStatedTime,
    this.reachedTime,
    this.ratingByCustomer,
    this.ratingByDriver,
    required this.updatedAt,
    required this.rejectedBy,
    required this.paymentMode,
    required this.acceptedBy,
    required this.bookingOtp,
  });

  factory BookingModal.fromJson(Map json, String id) {
    var start = (json[ApiKeys.startDestinationLatLng] as GeoPoint);
    var end = (json[ApiKeys.endDestinationLatLng] as GeoPoint);
myCustomLogStatements("json[ApiKeys.driverBids] ${json[ApiKeys.driverBids]}");
    return BookingModal(
      id: id,
      // id: json[ApiKeys.id],
      // startDestinationLatLng: LatLng(
      //     double.tryParse(json[ApiKeys.startDestinationLatitude].toString()) ??
      //         0,
      //     double.tryParse(json[ApiKeys.startDestinationLongitude].toString()) ??
      //         0),
      // endDestinationLatLng: LatLng(
      //     double.tryParse(json[ApiKeys.endDestinationLatitude].toString()) ?? 0,
      //     double.tryParse(json[ApiKeys.endDestinationLongitude].toString()) ??
      //         0),
      ratingByDriver: json[ApiKeys.ratingByDriver],
      ratingByCustomer: json[ApiKeys.ratingByCustomer],
      startGeoPoint: json[ApiKeys.startGeoPoint],
      endGeoPoint: json[ApiKeys.endGeoPoint],
      startDestinationLatLng: LatLng(start.latitude, start.longitude),
      endDestinationLatLng: LatLng(end.latitude, end.longitude),
      startDestination: json[ApiKeys.startDestination],
      endDestination: json[ApiKeys.endDestination],
      bookingRefrenceId: json[ApiKeys.bookingRefrenceId] ?? '',
      requestedBy: json[ApiKeys.requestedBy],
      totalBookingAmount:
          double.tryParse(json[ApiKeys.totalBookingAmount].toString()) ?? 0.0,
      totalBufferBookingAmount:
          double.tryParse(json[ApiKeys.totalBufferBookingAmount].toString()) ??
              0.0,
      commissionPercent:
          double.tryParse(json[ApiKeys.commissionPercent].toString()) ?? 0.0,
      commissionPrice:
          double.tryParse(json[ApiKeys.commissionPrice].toString()) ?? 0.0,
      driverEarning:
          double.tryParse(json[ApiKeys.driverEarning].toString()) ?? 0.0,
      driverBufferEarning:
          double.tryParse(json[ApiKeys.driverBufferEarning].toString()) ?? 0.0,
      serviceFeeInPrice:
          double.tryParse(json[ApiKeys.serviceFeeInPrice].toString()) ?? 0.0,
      serviceFeeBufferPrice:
          double.tryParse(json[ApiKeys.serviceFeeBufferPrice].toString()) ??
              0.0,
      serviceFeeInPercent:
          double.tryParse(json[ApiKeys.serviceFeeInPercent].toString()) ?? 0.0,
      appliedCoupon: json[ApiKeys.appliedCoupon],
      appliedCouponDiscountAmount: double.tryParse(
              json[ApiKeys.appliedCouponDiscountAmount].toString()) ??
          0,
      vehicle_type: json[ApiKeys.vehicle_type],
      selectedVehicleDetails:
          VehicleTypeModal.fromJson(json[ApiKeys.selectedVehicleDetails]),
      bookingStatus: json[ApiKeys.bookingStatus],
      rideApproxMinute: json[ApiKeys.rideApproxMinute] ?? 0,
      rideApproxDistanceTraveled: double.parse(
          (json[ApiKeys.rideApproxDistanceTraveled] ?? 0).toString()),
      waitingTimeInMinutes:
          double.parse((json[ApiKeys.waitingTimeInMinutes] ?? 0).toString()),
      rideType: json[ApiKeys.rideType],
      scheduledTime: json[ApiKeys.scheduledTime],
      rejectedBy: json[ApiKeys.rejectedBy] ?? [],
      isScheduled: json[ApiKeys.isScheduled],
      startRide: json[ApiKeys.startRide] ?? true,
      driverBids: json[ApiKeys.driverBids] == null
          ? []
          : List.generate(
              json[ApiKeys.driverBids].length,
              (index) =>
                  DriverBidModal.fromJson(json[ApiKeys.driverBids][index]),
            ),
      coveredPath: json[ApiKeys.coveredPath] == null
          ? []
          : List.generate(
              json[ApiKeys.coveredPath].length,
              (index) => LatLng(
                json[ApiKeys.coveredPath][index][ApiKeys.latitude],
                json[ApiKeys.coveredPath][index][ApiKeys.longitude],
              ),
            ),
      createdAt: json[ApiKeys.createdAt],
      updatedAt: json[ApiKeys.updatedAt] ?? json[ApiKeys.createdAt],
      rideStatedTime: json[ApiKeys.rideStartedTime] ?? json[ApiKeys.createdAt],
      reachedTime: json[ApiKeys.reachedTime] ?? json[ApiKeys.createdAt],
      rideCompletedTime:
          json[ApiKeys.rideCompletedTime] ?? json[ApiKeys.createdAt],
      paymentMode: json[ApiKeys.paymentMode],
      acceptedBy: json[ApiKeys.acceptedBy],
      bookingOtp: json[ApiKeys.bookingOtp].toString(),
    );
  }

  Map<String, dynamic> addBookingRequestJson() {
    return {
      // ApiKeys.startDestinationLatitude: startDestinationLatLng.latitude,
      // ApiKeys.startDestinationLongitude: startDestinationLatLng.longitude,
      // ApiKeys.endDestinationLatitude: endDestinationLatLng.latitude,
      // ApiKeys.endDestinationLongitude: endDestinationLatLng.longitude,
      ApiKeys.startGeoPoint: startGeoPoint,
      ApiKeys.endGeoPoint: endGeoPoint,
      ApiKeys.startDestinationLatLng: GeoPoint(
          startDestinationLatLng.latitude, startDestinationLatLng.longitude),
      ApiKeys.endDestinationLatLng: GeoPoint(
          endDestinationLatLng.latitude, endDestinationLatLng.longitude),
      ApiKeys.startDestination: startDestination,
      ApiKeys.driverBids: List.generate(
        driverBids.length,
        (index) => driverBids[index].toJson(),
      ),
      ApiKeys.coveredPath: List.generate(
          coveredPath.length,
          (index) => {
                ApiKeys.latitude: coveredPath[index].latitude,
                ApiKeys.longitude: coveredPath[index].longitude,
              }),
      ApiKeys.endDestination: endDestination,
      ApiKeys.bookingRefrenceId: bookingRefrenceId,
      ApiKeys.requestedBy: requestedBy,
      ApiKeys.driverEarning: driverEarning,
      ApiKeys.driverBufferEarning: driverBufferEarning,
      ApiKeys.totalBookingAmount: totalBookingAmount,
      ApiKeys.totalBufferBookingAmount: totalBufferBookingAmount,
      ApiKeys.commissionPercent: commissionPercent,
      ApiKeys.commissionPrice: commissionPrice,
      ApiKeys.serviceFeeInPercent: serviceFeeInPercent,
      ApiKeys.serviceFeeInPrice: serviceFeeInPrice,
      ApiKeys.serviceFeeBufferPrice: serviceFeeBufferPrice,
      ApiKeys.appliedCoupon: appliedCoupon,
      ApiKeys.appliedCouponDiscountAmount: appliedCouponDiscountAmount,
      ApiKeys.vehicle_type: vehicle_type,
      ApiKeys.selectedVehicleDetails: selectedVehicleDetails.toJson(),
      ApiKeys.bookingStatus: bookingStatus,
      ApiKeys.rideApproxMinute: rideApproxMinute,
      ApiKeys.waitingTimeInMinutes: waitingTimeInMinutes,
      ApiKeys.rideApproxDistanceTraveled: rideApproxDistanceTraveled,
      ApiKeys.rejectedBy: rejectedBy,
      ApiKeys.acceptedBy: acceptedBy,
      ApiKeys.createdAt: createdAt,
      ApiKeys.rideStartedTime: rideStatedTime,
      ApiKeys.reachedTime: reachedTime,
      ApiKeys.rideCompletedTime: rideCompletedTime,
      ApiKeys.updatedAt: updatedAt,
      ApiKeys.rideType: rideType,
      ApiKeys.scheduledTime: scheduledTime,
      ApiKeys.isScheduled: isScheduled,
      ApiKeys.startRide: startRide,
      ApiKeys.paymentMode: paymentMode,
    };
  }

  Map<String, dynamic> toJson() {
    var request = addBookingRequestJson();
    request.addAll({ApiKeys.id: id});
    return request;
  }
}
