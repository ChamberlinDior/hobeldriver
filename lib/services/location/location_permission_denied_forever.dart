import 'package:connect_app_driver/constants/sized_box.dart';
import 'package:connect_app_driver/widget/custom_button.dart';
import 'package:connect_app_driver/widget/custom_text.dart';
import 'package:flutter/cupertino.dart';

import '../custom_navigation_services.dart';

// ignore: must_be_immutable
class LocationPermissionDeniedForever extends StatelessWidget {
  final Function() onTap;
  bool isForceLocationPermission;
  LocationPermissionDeniedForever(
      {super.key,
      required this.onTap,
      required this.isForceLocationPermission});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomText.bodyText1(
            "Holeb Chauffeur requires location access even when the app is running in the background for accurate tracking and service. Please allow location permission to access the app's full functionality. Without this permission, the app cannot operate properly. Open the app settings to enable the required permissions."),
        vSizedBox,
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (!isForceLocationPermission)
              CustomButton(
                text: 'Cancel',
                isFlexible: true,
                onTap: () {
                  CustomNavigation.pop(context);
                },
                fontSize: 15,
                isSolid: false,
                horizontalPadding: 14,
                height: 45,
                verticalMargin: 10,
              ),
            hSizedBox2,
            CustomButton(
              text: 'Open app settings',
              isFlexible: true,
              onTap: onTap,
              fontSize: 15,
              horizontalPadding: 14,
              height: 45,
              verticalMargin: 0,
            ),
          ],
        )
      ],
    );
  }
}
