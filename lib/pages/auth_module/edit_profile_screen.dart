import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_app_driver/constants/api_keys.dart';
import 'package:connect_app_driver/functions/custom_time_functions.dart';
import 'package:connect_app_driver/functions/pick_image_newest.dart';
import 'package:connect_app_driver/functions/print_function.dart';
import 'package:connect_app_driver/provider/new_firebase_auth_provider.dart';
import 'package:connect_app_driver/services/firebase_services/firebase_service.dart';
import 'package:connect_app_driver/widget/custom_image.dart';
import 'package:connect_app_driver/widget/custom_text.dart';
import 'package:connect_app_driver/widget/show_snackbar.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/global_data.dart';
import '../../constants/my_colors.dart';
import '../../constants/my_image_url.dart';
import '../../constants/sized_box.dart';
import '../../functions/validation_functions.dart';
import '../../services/custom_navigation_services.dart';
import '../../widget/custom_appbar.dart';
import '../../widget/custom_scaffold.dart';
import '../../widget/custom_text_field.dart';
import '../../widget/custom_button.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailAddressController =
      TextEditingController(text: userData?.email);
  TextEditingController nameController =
      TextEditingController(text: userData?.fullName);
  TextEditingController mobileNumberController =
      TextEditingController(text: userData?.phone);
  TextEditingController dobController = TextEditingController(
      text:
          CustomTimeFunctions.formatDateMonthAndYear(userData?.dob?.toDate()));
  ValueNotifier<DateTime?> dob = ValueNotifier(userData?.dob?.toDate());
  ValueNotifier<String> selectedCountryCode =
      ValueNotifier(userData?.phoneCode ?? defaultCountryCode);
  ValueNotifier<File?> selectedImageNoti = ValueNotifier(null);
  ValueNotifier<bool> mobileTextFieldEnabledNotifier =
      ValueNotifier(userData?.phoneWithCode == null ? true : false);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        titleText: 'Edit Profile',
      ),
      bottomNavigationBar: Consumer<FirebaseAuthProvider>(
          builder: (context, firebaseAuthProvider, child) {
        return CustomButton(
          text: "Save",
          height: 50,
          verticalMargin: 20,
          horizontalMargin: globalHorizontalPadding,
          onTap: () async {
            if (formKey.currentState!.validate()) {
              Map<String, dynamic> request = {
                ApiKeys.fullName: nameController.text,
                // ApiKeys.e: nameController.text,
              };
              if (dob.value != null) {
                request[ApiKeys.dob] = Timestamp.fromDate(dob.value!);
              }

              if (mobileTextFieldEnabledNotifier.value &&
                  mobileNumberController.text.isNotEmpty) {
                request[ApiKeys.phone] = mobileNumberController.text;
                request[ApiKeys.phone_code] = selectedCountryCode.value;
                request[ApiKeys.phone_with_code] =
                    '${selectedCountryCode.value}${mobileNumberController.text}';
                mobileTextFieldEnabledNotifier.value = false;
              }
              try {
                await firebaseAuthProvider.editProfileEmail(request);
                showSnackbar("Your profile has been updated successfully");
                CustomNavigation.pop(context);
              } catch (e) {
                myCustomPrintStatement("Error while updating profile $e");
              }

              // CustomNavigation.pop( context);
            }
          },
        );
      }),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: globalHorizontalPadding, vertical: 15),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Consumer<FirebaseAuthProvider>(
                  builder: (context, firebaseAuthProvider, child) =>
                      ValueListenableBuilder(
                    valueListenable: selectedImageNoti,
                    builder: (context, selectImageValue, child) => Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CustomImage(
                          height: 120,
                          width: 120,
                          imageUrl: userData?.profileImage ??
                              MyImagesUrl.profileImage,
                          image: selectImageValue,
                          borderRadius: 100,
                          fileType: selectImageValue == null
                              ? userData?.profileImage != null
                                  ? CustomFileType.network
                                  : CustomFileType.asset
                              : CustomFileType.file,
                        ),
                        InkWell(
                          onTap: () async {
                            var data = await cameraImagePicker(context);
                            if (data != null) {
                              selectedImageNoti.value = data;
                              var request = {
                                ApiKeys.profileImage:
                                    await FirebaseService.uploadImageAndGetUrl(
                                        selectedImageNoti.value!.path),
                              };
                              firebaseAuthProvider.editProfileEmail(request);
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 6, bottom: 8),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: MyColors.blackColor,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: MyColors.whiteColor, width: 0.8)),
                            child: const Icon(
                              Icons.edit,
                              size: 14,
                              color: MyColors.whiteColor,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                vSizedBox8,
                CustomTextField(
                  controller: nameController,
                  hintText: "Full Name",
                  validator: (val) {
                    return ValidationFunction.requiredValidation(val!);
                  },
                ),
                vSizedBox2,
                CustomTextField(
                  controller: emailAddressController,
                  hintText: "Email",
                  enabled: false,
                  keyboardType: TextInputType.emailAddress,
                  suffix: const Icon(
                    Icons.email_outlined,
                    size: 20,
                    color: MyColors.enabledTextFieldBorderColor,
                  ),
                  validator: (val) {
                    return ValidationFunction.emailValidation(val);
                  },
                ),
                vSizedBox2,
                // InputTextFieldWidget(
                //   controller:mobileNoController,
                //   hintText: "Phone Number",
                //   inputFormatters: [
                //     LengthLimitingTextInputFormatter(10),
                //     FilteringTextInputFormatter.digitsOnly
                //   ],
                //   suffix: Padding(
                //     padding: const EdgeInsets.all(16),
                //     child: Image.asset(MyImagesUrl.phoneOutline01,width: 18,color: MyColors.enabledTextFieldBorderColor,),
                //   ),
                //   validator: (val) =>
                //       ValidationFunction.mobileNumberValidation(val),
                //   keyboardType: TextInputType.number,
                // ),
                ValueListenableBuilder(
                    valueListenable: selectedCountryCode,
                    builder: (context, value, child) {
                      return ValueListenableBuilder(
                          valueListenable: mobileTextFieldEnabledNotifier,
                          builder: (context,
                              mobileTextFieldEnabledNotifierValue, child) {
                            return CustomTextField(
                              controller: mobileNumberController,
                              borderRadius: 15,
                              enabled: mobileTextFieldEnabledNotifierValue,
                              keyboardType: TextInputType.number,
                              hintText: "Mobile No.",
                              validator: (val) {
                                if (emailAddressController.text.isEmpty) {
                                  return ValidationFunction
                                      .mobileNumberValidation(val);
                                }
                                return null;
                              },
                              suffix: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Image.asset(
                                  MyImagesUrl.phoneOutline01,
                                  width: 18,
                                  color: MyColors.enabledTextFieldBorderColor,
                                ),
                              ),
                              prefix: InkWell(
                                onTap: () {
                                  showCountryPicker(
                                    context: context,
                                    showPhoneCode: true,
                                    onSelect: (value) {
                                      selectedCountryCode.value =
                                          value.phoneCode;
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
                                            size: 20,
                                            color: MyColors.whiteColor),
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
                          });
                    }),
                vSizedBox2,
                CustomTextField(
                  controller: dobController,
                  hintText: "Enter Date of Birth",
                  readOnly: true,
                  onTap: () async {
                    DateTime? date = await showDatePicker(
                        context: context,
                        firstDate:
                            DateTime.now().subtract(Duration(days: 365 * 85)),
                        lastDate:
                            DateTime.now().subtract(Duration(days: 365 * 15)));
                    if (date != null) {
                      dob.value = date;
                      dobController.text =
                          CustomTimeFunctions.formatDateMonthAndYear(date);
                    }
                  },
                  suffix: Padding(
                    padding: const EdgeInsets.all(16),
                    child: CustomText.bodyText2(
                      "DOB",
                      fontSize: 15,
                    ),
                  ),
                  // suffixText: 'DOB',
                  validator: (val) =>
                      ValidationFunction.requiredValidation(val!),
                ),
                vSizedBox2,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
