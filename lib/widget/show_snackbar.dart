import 'package:connect_app_driver/constants/my_colors.dart';
import 'package:connect_app_driver/widget/custom_text.dart';
import 'package:flutter/material.dart';

import '../constants/global_keys.dart';

showSnackbar(String text, {int? seconds, BuildContext? context}) {
  ScaffoldMessenger.of(context ?? MyGlobalKeys.navigatorKey.currentContext!)
      .showSnackBar(SnackBar(
    content: CustomText.smallText(
      text,
      color: MyColors.blackColor,
    ),
    duration: Duration(seconds: seconds ?? 2),
    // margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    // behavior: SnackBarBehavior.floating,
  ));
}
