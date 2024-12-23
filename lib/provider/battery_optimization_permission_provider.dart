import 'package:connect_app_driver/constants/global_keys.dart';
import 'package:connect_app_driver/constants/sized_box.dart';
import 'package:connect_app_driver/functions/print_function.dart';
import 'package:connect_app_driver/functions/showCustomDialog.dart';
import 'package:connect_app_driver/services/custom_navigation_services.dart';
import 'package:connect_app_driver/widget/custom_button.dart';
import 'package:connect_app_driver/widget/custom_text.dart';
import 'package:connect_app_driver/widget/old_custom_text.dart';
import 'package:disable_battery_optimization/disable_battery_optimization.dart';
import 'package:flutter/material.dart';

class BatteryOptimizationProvider extends ChangeNotifier {
  askForPermission() async {
    bool? isBatteryOptimizationDisabled =
        await DisableBatteryOptimization.isBatteryOptimizationDisabled;
    myCustomLogStatements(
        "BatteryOptimization setting $isBatteryOptimizationDisabled");
    if (isBatteryOptimizationDisabled != true) {
      await await showCustomDialog(
          // height: 210,
          verticalInsetPadding: 20,
          // ignore: deprecated_member_use
          child: WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText.bodyText1(
                    "Holeb Chauffeur needs access to your location, even when the app is in the background. Please disable battery optimization to ensure the app functions properly. Otherwise, you may experience issues with fare calculation if your location is not updated correctly."),
                vSizedBox,
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  CustomButton(
                    text: "Continue",
                    horizontalPadding: 25,
                    width: 120,
                    verticalMargin: 0,
                    fontSize: 12,
                    height: 40,
                    onTap: () {
                      CustomNavigation.pop(
                          MyGlobalKeys.navigatorKey.currentContext!);
                      DisableBatteryOptimization
                          .showDisableBatteryOptimizationSettings();
                    },
                  )
                ])
              ],
            ),
          ));
    }
  }
}
