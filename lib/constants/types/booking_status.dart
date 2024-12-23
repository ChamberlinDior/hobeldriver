import 'package:connect_app_driver/constants/my_colors.dart';
import 'package:flutter/material.dart';

class BookingStatus {
  static const int pending = 0;
  static const int acceptedByDriver = 1;
  static const int driverReachedToPickup = 2;
  static const int rideStarted = 3;
  static const int reachedToDestination = 4;
  static const int rideCompleted = 5;
  static const int rideCancled = 8;
  static const int noOneResponded = 9;

  static String getName(int status, {int? secsLeft}) {
    switch (status) {
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.acceptedByDriver:
        return 'Accepted';
      case BookingStatus.driverReachedToPickup:
        return 'Reached To Pickup';
      case BookingStatus.rideStarted:
        return 'Ride Started';
      case BookingStatus.reachedToDestination:
        return 'Destination Reached';
      case BookingStatus.rideCompleted:
        return 'Ride Completed';
      case BookingStatus.rideCancled:
        return 'Cancelled';
      case BookingStatus.noOneResponded:
        return 'No One Responded';
      default:
        return 'Pending';
    }
  }

  static Color getColor(int status, {int? secsLeft}) {
    switch (status) {
      case BookingStatus.pending:
        return MyColors.yellowColor;
      case BookingStatus.acceptedByDriver:
        return MyColors.lightGreenColor;
      case BookingStatus.reachedToDestination:
        return MyColors.redColor;
      case BookingStatus.driverReachedToPickup:
        return MyColors.primaryColor.withOpacity(0.6);
      case BookingStatus.rideCompleted:
        return MyColors.greenColor;
      case BookingStatus.rideCancled:
        return MyColors.redColor;
      case BookingStatus.noOneResponded:
        return MyColors.redColor;
      default:
        return MyColors.yellowColor;
    }
  }

  static getBgColor(int status) {
    return getColor(status).computeLuminance() > 0.5
        ? MyColors.blackColor
        : MyColors.whiteColor;
  }
}
