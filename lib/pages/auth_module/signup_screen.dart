import 'package:connect_app_driver/constants/api_keys.dart';
import 'package:connect_app_driver/constants/types/ride_type_status.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/global_data.dart';
import '../../constants/my_colors.dart';
import '../../constants/sized_box.dart';
import '../../constants/types/approval_status.dart';
import '../../constants/types/user_type.dart';
import '../../functions/validation_functions.dart';
import '../../provider/new_firebase_auth_provider.dart';
import '../../services/custom_navigation_services.dart';
import '../../widget/custom_appbar.dart';
import '../../widget/custom_scaffold.dart';
import '../../widget/custom_text.dart';
import '../../widget/custom_text_field.dart';
import '../../widget/custom_button.dart';
import 'add_vehicle_details_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  ValueNotifier<String> selectedCountryCode = ValueNotifier(defaultCountryCode);
  TextEditingController password = TextEditingController();
  ValueNotifier<bool> visibility = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        titleText: 'Sign Up',
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: globalHorizontalPadding, vertical: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText.headingLarge(
                    "Driver Sign Up",
                  ),
                  // vSizedBox,
                  // CustomText.headingSmall(
                  //   "Sign Up with Social media",
                  // ),
                  // vSizedBox2,
                  // Consumer<FirebaseAuthProvider>(
                  //     builder: (context, firebaseAuthProvider, child) {
                  //   return CustomButton(
                  //     onTap: () {
                  //       firebaseAuthProvider.signInWithFacebook(context);
                  //     },
                  //     load: firebaseAuthProvider.facebookLoad,
                  //     borderRadius: 10,
                  //     height: 53,
                  //     text: "Continue with Facebook",
                  //     color: const Color(0xFF2c84f4),
                  //     prefix: Padding(
                  //       padding: const EdgeInsets.only(left: 5.0, right: 7),
                  //       child: Image.asset(
                  //         MyImagesUrl.facebook,
                  //         width: 26,
                  //       ),
                  //     ),
                  //     fontSize: 18,
                  //     textAlign: TextAlign.start,
                  //     textColor: MyColors.whiteColor,
                  //     fontWeight: FontWeight.w500,
                  //     verticalMargin: 8,
                  //   );
                  // }),
                  // vSizedBox,
                  // Consumer<FirebaseAuthProvider>(
                  //     builder: (context, firebaseAuthProvider, child) {
                  //   return CustomButton(
                  //     height: 53,
                  //     borderRadius: 10,
                  //     text: "Continue with Google",
                  //     onTap: () {
                  //       firebaseAuthProvider.signInWithGoogle(context);
                  //     },
                  //     load: firebaseAuthProvider.googleLoad,
                  //     textColor: MyColors.blackColor.withOpacity(
                  //       0.5,
                  //     ),
                  //     color: MyColors.whiteColor,
                  //     prefix: Padding(
                  //       padding: const EdgeInsets.only(left: 5.0, right: 5),
                  //       child: Image.asset(
                  //         MyImagesUrl.google,
                  //         width: 30,
                  //       ),
                  //     ),
                  //     verticalMargin: 8,
                  //     fontSize: 18,
                  //     textAlign: TextAlign.start,
                  //     fontWeight: FontWeight.w500,
                  //   );
                  // }),
                  // vSizedBox2,
                  // Row(
                  //   children: [
                  //     const Expanded(
                  //       child: Divider(),
                  //     ),
                  //     hSizedBox,
                  //     CustomText.smallText(
                  //       "Or",
                  //       fontWeight: FontWeight.w300,
                  //       fontSize: 15,
                  //     ),
                  //     hSizedBox,
                  //     const Expanded(
                  //       child: Divider(),
                  //     )
                  //   ],
                  // ),
                  vSizedBox2,
                  CustomText.headingSmall(
                    "Please enter the details for signup.",
                    fontWeight: FontWeight.w400,
                  ),
                  vSizedBox2,
                  CustomTextField(
                    controller: nameController,
                    hintText: "Full Name",
                    textCapitalization: TextCapitalization.words,
                    validator: (val) {
                      return ValidationFunction.requiredValidation(val!);
                    },
                  ),
                  vSizedBox2,
                  CustomTextField(
                    controller: emailAddressController,
                    hintText: "Email ID",
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) {
                      return ValidationFunction.emailValidation(val);
                    },
                  ),
                  vSizedBox2,
                  ValueListenableBuilder(
                      valueListenable: selectedCountryCode,
                      builder: (context, value, child) {
                        return CustomTextField(
                          controller: mobileNumberController,
                          borderRadius: 15,
                          keyboardType: TextInputType.number,
                          hintText: "Mobile No.",
                          validator: (val) {
                            if (emailAddressController.text.isEmpty) {
                              return ValidationFunction.mobileNumberValidation(
                                  val);
                            }
                            return null;
                          },
                          prefix: InkWell(
                            onTap: () {
                              showCountryPicker(
                                context: context,
                                showPhoneCode: true,
                                onSelect: (value) {
                                  selectedCountryCode.value = value.phoneCode;
                                },
                              );
                            },
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: IntrinsicHeight(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  CustomText.textFieldText(
                                    "+$value",
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 4),
                                    child: Icon(Icons.keyboard_arrow_down,
                                        size: 20, color: MyColors.whiteColor),
                                  ),
                                  const VerticalDivider(
                                    width: 2,
                                    indent: 8,
                                    endIndent: 8,
                                    color: MyColors.whiteColor,
                                  ),
                                  const SizedBox(width: 10),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                  vSizedBox2,
                  ValueListenableBuilder(
                    valueListenable: visibility,
                    builder: (_, value, __) => CustomTextField(
                      controller: password,
                      obscureText: value,
                      hintText: "Password",
                      validator: (val) =>
                          ValidationFunction.passwordValidation(val),
                      keyboardType: TextInputType.emailAddress,
                      suffix: IconButton(
                        onPressed: () {
                          visibility.value = !value;
                        },
                        icon: Icon(
                          !value
                              ? Icons.visibility_rounded
                              : Icons.visibility_off_rounded,
                          color: MyColors.enabledTextFieldBorderColor,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  vSizedBox2,
                  Consumer<FirebaseAuthProvider>(
                      builder: (context, firebaseAuthProvider, child) {
                    return CustomButton(
                      text: "Next",
                      height: 50,
                      onTap: () async {
                        // var r = TwilioApiServices.generateOtp(6);
                        // print(';sdf asdf $r');
                        // firebaseAuthProvider.sendOtpFromTwilio(phoneWithCode: '919340223515');
                        // return;
                        if (formKey.currentState!.validate()) {
                          unFocusKeyBoard();
                          Map<String, dynamic> request = {
                            ApiKeys.fullName: nameController.text,
                            ApiKeys.email: emailAddressController.text,
                            ApiKeys.phone: mobileNumberController.text,
                            ApiKeys.phone_code: selectedCountryCode.value,
                            ApiKeys.password: password.text,
                            ApiKeys.phone_with_code:
                                '${selectedCountryCode.value}${mobileNumberController.text}',
                            ApiKeys.isMobileVerified: false,
                            ApiKeys.isOnline: true,
                            ApiKeys.profileImage: ApiKeys.dummyProfileImage,
                            ApiKeys.isEmailVerified: false,
                            ApiKeys.isBlocked: false,
                            ApiKeys.userType: UserType.driver,
                            ApiKeys.approvalStatus: ApprovalStatus.pending,
                            ApiKeys.deviceTokens: [],
                            ApiKeys.rideTypes: [RideTypeStatus.private],
                          };

                          if (await firebaseAuthProvider.checkUniqueValidation(
                              email: request[ApiKeys.email]!,
                              phoneNumber: request[ApiKeys.phone_with_code]!)) {
                            CustomNavigation.push(
                                context: context,
                                screen: AddVehicleDetails(
                                  request: request,
                                ));
                          }
                        }
                      },
                    );
                  }),
                  vSizedBox2,
                  GestureDetector(
                    onTap: () {
                      CustomNavigation.pop(context);
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText.bodyText2(
                          "Already have an account? ",
                        ),
                        CustomText.bodyText2(
                          "Sign In",
                          fontWeight: FontWeight.w700,
                          color: MyColors.whiteColor,
                          decoration: TextDecoration.underline,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
