import 'dart:async';
import 'package:connect_app_driver/constants/global_error_constants.dart';
import 'package:connect_app_driver/widget/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:provider/provider.dart';
import 'package:connect_app_driver/constants/global_data.dart';
import '../../constants/my_colors.dart';
import '../../constants/sized_box.dart';
import '../../provider/new_firebase_auth_provider.dart';
import '../../widget/custom_appbar.dart';
import '../../widget/custom_scaffold.dart';
import '../../widget/custom_text.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import '../../widget/custom_button.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String phoneNumber;
  const VerifyOtpScreen({Key? key, required this.phoneNumber})
      : super(key: key);

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  OtpFieldController otpFieldController = OtpFieldController();
  final formKey = GlobalKey<FormState>();
  ValueNotifier<String?> filledOtp = ValueNotifier(null);

  ValueNotifier<int> counter = ValueNotifier(45);

  Timer? timer;

  countDown() {
    timer = Timer.periodic(const Duration(seconds: 1), (timerCount) {
      if (counter.value != 0) {
        counter.value--;
        print(counter.value);
      } else {
        print('cancel');
        timerCount.cancel();
      }
    });
  }

  @override
  void initState() {
    countDown();

    WidgetsBinding.instance.addPostFrameCallback((callBack) {
      var firebaseAuthProvider =
          Provider.of<FirebaseAuthProvider>(context, listen: false);
      firebaseAuthProvider.sendOtpFromTwilio(
        phoneWithCode: widget.phoneNumber,
      );
    });

    super.initState();
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        titleText: 'OTP Verification',
      ),
      body: Consumer<FirebaseAuthProvider>(
          builder: (context, firebaseAuthProvider, child) {
        // firebaseAuthProvider.correctOtp = '123456';
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: globalHorizontalPadding, vertical: 20),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText.headingLarge(
                      "OTP",
                    ),
                    vSizedBox,
                    CustomText.heading(
                      "Please enter the OTP sent on your Number.",
                      fontWeight: FontWeight.w400,
                    ),
                    vSizedBox4,
                    OTPTextField(
                      length: 6,
                      width: MediaQuery.of(context).size.width,
                      fieldWidth: (MediaQuery.of(context).size.width / 6) - 16,
                      controller: otpFieldController,
                      style: const TextStyle(
                          fontSize: 18, color: MyColors.whiteColor),
                      textFieldAlignment: MainAxisAlignment.center,
                      fieldStyle: FieldStyle.box,
                      contentPadding: EdgeInsets.all(11),
                      outlineBorderRadius: 15,
                      spaceBetween: 10,
                      otpFieldStyle: OtpFieldStyle(
                          focusBorderColor: Colors.blue,
                          borderColor: MyColors.blackColor,
                          disabledBorderColor:
                              MyColors.disabledTextFieldBorderColor,
                          enabledBorderColor:
                              MyColors.enabledTextFieldBorderColor,
                          backgroundColor: MyColors.fillColor),
                      onChanged: (val) {
                        // filledOtp.value = val;

                        print('the filled otp is $val');
                      },
                      onCompleted: (pin) {
                        filledOtp.value = pin;
                        print("Completed: " + pin);
                      },
                    ),
                    vSizedBox,
                    CustomButton(
                      text: "Submit",
                      height: 50,
                      verticalMargin: 30,
                      onTap: () async {
                        // return;
                        unFocusKeyBoard();
                        if (filledOtp.value != null) {
                          if (filledOtp.value!.length == 6) {
                            firebaseAuthProvider
                                .verifyOtpFromTwilio(filledOtp.value!);
                          }
                        } else {
                          showSnackbar(GlobalErrorConstants.otpNotFilled);
                        }
                        return;
                      },
                    ),
                    vSizedBox,
                    Align(
                      alignment: Alignment.center,
                      child: ValueListenableBuilder(
                        valueListenable: counter,
                        builder: (context, value, child) => TextButton(
                          onPressed: () {
                            if (value == 0) {
                              ///commented to check
                              // firebaseAuthProvider.sendOtp('+919340223515');
                              firebaseAuthProvider.sendOtpFromTwilio(
                                  phoneWithCode: widget.phoneNumber);
                            }
                            //
                            // print('lksdjf ${timer?.isActive}');
                            // return;
                            if (timer!.isActive) {
                            } else {
                              counter.value = 45;
                              countDown();
                            }
                          },
                          child: CustomText.bodyText2(
                            value == 0 ? "Resend" : "Resend in ${value}s",
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                            color: MyColors.whiteColor,
                          ),
                        ),
                      ),
                    ),
                    vSizedBox2,
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
