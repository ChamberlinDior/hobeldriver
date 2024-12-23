import 'package:connect_app_driver/constants/my_colors.dart';
import 'package:connect_app_driver/constants/sized_box.dart';
import 'package:connect_app_driver/provider/live_booking_provider.dart';
import 'package:connect_app_driver/widget/custom_text.dart';
import 'package:connect_app_driver/widget/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';

import '../../widget/custom_button.dart';

// ignore: must_be_immutable
class ProvideOTP extends StatelessWidget {
  ProvideOTP({
    super.key,
  });
  String otpValue = "";
  OtpFieldController otpFieldController = OtpFieldController();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText.bodyText1(
          'Enter The OTP provided by rider.',
        ),
        vSizedBox3,
        OTPTextField(
          length: 6,
          controller: otpFieldController,
          width: MediaQuery.of(context).size.width,
          fieldWidth: 45,
          style: const TextStyle(fontSize: 18, color: MyColors.whiteColor),
          textFieldAlignment: MainAxisAlignment.center,
          fieldStyle: FieldStyle.box,
          contentPadding: const EdgeInsets.all(11),
          outlineBorderRadius: 15,
          spaceBetween: 10,
          otpFieldStyle: OtpFieldStyle(
              focusBorderColor: Colors.blue,
              borderColor: MyColors.blackColor,
              disabledBorderColor: MyColors.disabledTextFieldBorderColor,
              enabledBorderColor: MyColors.enabledTextFieldBorderColor,
              backgroundColor: MyColors.fillColor),
          onChanged: (pin) {
            otpValue = pin;
          },
        ),
        vSizedBox3,
        Consumer<LiveBookingProvider>(
            builder: (context, liveBookingProvide, child) {
          return CustomButton(
            text: 'Continue',
            onTap: () {
              if (liveBookingProvide.incomingBookingRequest!.bookingOtp ==
                  otpValue) {
                liveBookingProvide.startRide();
              } else if (otpValue.isEmpty) {
                showSnackbar("Please enter the otp");
              } else if (otpValue.length < 6) {
                showSnackbar("Please enter the correct 6 digit otp");
              } else {
                otpFieldController.clear();
                otpValue = "";
                showSnackbar("Please enter the correct otp.");
              }
            },
            height: 50,
          );
        })
      ],
    );
  }
}
