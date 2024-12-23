import 'package:connect_app_driver/constants/my_colors.dart';
import 'package:flutter/material.dart';

class WithdrawRequestStatus {
  static const int pending = 0;
  static const int accepted = 1;
  static const int rejected = 2;

  static String getName(int status, {int? secsLeft}) {
    switch (status) {
      case WithdrawRequestStatus.pending:
        return 'Pending';
      case WithdrawRequestStatus.accepted:
        return 'Accepted';
      case WithdrawRequestStatus.rejected:
        return 'Rejected';
     
      default:
        return 'Pending';
    }
  }

  static Color getColor(int status, {int? secsLeft}) {
    switch (status) {
      case WithdrawRequestStatus.pending:
        return MyColors.yellowColor;
      case WithdrawRequestStatus.accepted:
        return MyColors.lightGreenColor;
      case WithdrawRequestStatus.rejected:
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
