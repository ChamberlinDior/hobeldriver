import 'package:connect_app_driver/constants/sized_box.dart';
import 'package:connect_app_driver/provider/location_provider.dart';
import 'package:connect_app_driver/widget/custom_button.dart';
import 'package:connect_app_driver/widget/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class LocationServiceAlert extends StatelessWidget {
  final Function()? onTap;
  const LocationServiceAlert({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Consumer<MyLocationProvider>(
        builder: (context, myLocationProvider, child) {
      print(
          'the location status is ${myLocationProvider.isLocationServiceEnabled}');
      // if(myLocationProvider.isLocationServiceEnabled){
      //  WidgetsBinding.instance.addPostFrameCallback((callback){
      //
      //    CustomNavigation.pop(context);
      //  });
      // }
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText.bodyText1(
              "Location services are required for this feature. Please enable location services in your device settings."),
          vSizedBox,
          Align(
            alignment: Alignment.centerRight,
            child: CustomButton(
              text: 'Open app Location',
              isFlexible: true,
              onTap: onTap,
              fontSize: 15,
              horizontalPadding: 14,
              height: 45,
              verticalMargin: 10,
            ),
          )
        ],
      );
    });
  }
}
