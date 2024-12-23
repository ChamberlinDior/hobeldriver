import 'dart:io';

import 'package:connect_app_driver/constants/api_keys.dart';
import 'package:connect_app_driver/constants/global_data.dart';
import 'package:connect_app_driver/constants/sized_box.dart';
import 'package:connect_app_driver/functions/pick_image_newest.dart';
import 'package:connect_app_driver/pages/auth_module/edit_profile_screen.dart';
import 'package:connect_app_driver/provider/new_firebase_auth_provider.dart';
import 'package:connect_app_driver/services/custom_navigation_services.dart';
import 'package:connect_app_driver/services/firebase_services/firebase_service.dart';
import 'package:connect_app_driver/widget/custom_appbar.dart';
import 'package:connect_app_driver/widget/custom_button.dart';
import 'package:connect_app_driver/widget/custom_scaffold.dart';
import 'package:connect_app_driver/widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/my_colors.dart';
import '../../constants/my_image_url.dart';
import '../../widget/custom_image.dart';
import '../../widget/custom_rich_text.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  ValueNotifier<File?> selectImageNoti = ValueNotifier(null);
  ValueNotifier<File?> selectRegistrationImageNoti = ValueNotifier(null);
  ValueNotifier<File?> selectedLicenseNotifier = ValueNotifier(null);
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        titleText: 'My Profile',
        actions: [
          CustomButton(
            onTap: () {
              CustomNavigation.push(
                  context: context, screen: const EditProfileScreen());
            },
            text: 'Edit Profile',
            isFlexible: true,
            borderRadius: 8,
            fontSize: 12,
            horizontalPadding: 15,
            horizontalMargin: 10,
            verticalPadding: 5,
          )
        ],
      ),
      body: Consumer<FirebaseAuthProvider>(
          builder: (context, firebaseAuthProvider, child) {
        return SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: globalHorizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                vSizedBox2,
                Row(
                  children: [
                    ValueListenableBuilder(
                      valueListenable: selectImageNoti,
                      builder: (context, selectImageValue, child) => Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CustomImage(
                            height: 80,
                            width: 80,
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
                                selectImageNoti.value = data;
                                var request = {
                                  ApiKeys.profileImage: await FirebaseService
                                      .uploadImageAndGetUrl(
                                          selectImageNoti.value!.path),
                                };
                                firebaseAuthProvider.editProfileEmail(request);
                              }
                            },
                            child: Container(
                              margin:
                                  const EdgeInsets.only(right: 6, bottom: 8),
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
                    hSizedBox,
                    hSizedBox05,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                MyImagesUrl.userOutline,
                                width: 15,
                              ),
                              hSizedBox,
                              Expanded(
                                  child: CustomText.smallText(
                                '${userData?.fullName}',
                              ))
                            ],
                          ),
                          vSizedBox05,
                          Row(
                            children: [
                              Image.asset(
                                MyImagesUrl.email,
                                width: 15,
                              ),
                              hSizedBox,
                              Expanded(
                                  child: CustomText.smallText(
                                '${userData?.email}',
                              ))
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                vSizedBox2,
                CustomText.heading(
                  'Vehicle Details',
                ),
                vSizedBox2,
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  margin: const EdgeInsets.only(
                    top: 10,
                  ),
                  decoration: BoxDecoration(
                      color: const Color(0xFF848484),
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText.bodyText2(
                                  'Vehicle Model',
                                  fontWeight: FontWeight.w500,
                                ),
                                vSizedBox02,
                                CustomText.bodyText2(
                                  '${userData?.vehicleModal!.vehicle_model}',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                ),
                              ],
                            ),
                          ),
                          CustomImage(
                            imageUrl: vehicleTypesMap[
                                    userData!.vehicleModal!.vehicle_type]!
                                .image,
                            fileType: vehicleTypesMap[
                                    userData!.vehicleModal!.vehicle_type]!
                                .fileType,
                          ),
                          // Image.asset(getVehicleImage(userData?.vehicle_type), height: 40,)
                        ],
                      ),
                      vSizedBox,
                      CustomText.heading(
                        '${userData?.vehicleModal!.vehicle_no}',
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                      CustomText.bodyText1(
                        '(${userData?.vehicleModal!.license_number})',
                      ),
                      vSizedBox,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Flexible(
                            child: CustomRichText(
                              firstText: 'Vehicle Type:',
                              firstTextFontSize: 14,
                              firstTextFontWeight: FontWeight.w300,
                              firstTextColor: MyColors.whiteColor,
                              secondText:
                                  '\n${vehicleTypesMap[userData!.vehicleModal!.vehicle_type]!.title}',
                              secondTextFontSize: 16,
                              secondTextFontWeight: FontWeight.w700,
                              secondTextColor: MyColors.whiteColor,
                            ),
                          ),
                          Flexible(
                            child: CustomRichText(
                              firstText: 'Insurance Number',
                              firstTextFontSize: 14,
                              firstTextFontWeight: FontWeight.w300,
                              firstTextColor: MyColors.whiteColor,
                              secondText:
                                  '\n${userData?.vehicleModal!.insurance_number}',
                              secondTextFontSize: 16,
                              secondTextFontWeight: FontWeight.w700,
                              secondTextColor: MyColors.whiteColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                vSizedBox2,
                CustomText.heading(
                  'Documents:-',
                ),
                vSizedBox,
                CustomText.headingSmall(
                  'Driving Licence',
                  fontWeight: FontWeight.w600,
                ),
                vSizedBox,
                ValueListenableBuilder(
                    valueListenable: selectedLicenseNotifier,
                    builder: (context, imageValue, _) {
                      return GestureDetector(
                        onTap: () async {
                          var res = await cameraImagePicker(context);
                          if (res != null) {
                            selectedLicenseNotifier.value = res;
                          }
                        },
                        child: Container(
                          height: 160,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: const Color(0xFF484848),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                  color: MyColors.enabledTextFieldBorderColor)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (imageValue != null ||
                                  userData?.vehicleModal!
                                          .driving_license_image !=
                                      null)
                                Expanded(
                                  child: CustomImage(
                                    imageUrl: userData?.vehicleModal!
                                            .driving_license_image ??
                                        '',
                                    image: imageValue,
                                    fileType: userData?.vehicleModal!
                                                .driving_license_image !=
                                            null
                                        ? CustomFileType.network
                                        : CustomFileType.file,
                                    height: 160,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    borderRadius: 15,
                                  ),
                                )
                              else
                                Column(
                                  children: [
                                    Image.asset(
                                      MyImagesUrl.upload,
                                      height: 70,
                                    ),
                                    CustomText.bodyText1(
                                      height: 1,
                                      "Upload Driving License",
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      );
                    }),
                vSizedBox2,
                CustomText.headingSmall(
                  'Vehicle Registration',
                  fontWeight: FontWeight.w600,
                ),
                vSizedBox,
                ValueListenableBuilder(
                    valueListenable: selectRegistrationImageNoti,
                    builder: (context, imageValue, _) {
                      return GestureDetector(
                        onTap: () async {
                          var res = await cameraImagePicker(context);
                          if (res != null) {
                            selectRegistrationImageNoti.value = res;
                          }
                        },
                        child: Container(
                          height: 160,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: const Color(0xFF484848),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                  color: MyColors.enabledTextFieldBorderColor)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (imageValue != null ||
                                  userData?.vehicleModal!
                                          .vehicleRegistrationImage !=
                                      null)
                                Expanded(
                                  child: CustomImage(
                                    imageUrl: userData?.vehicleModal!
                                            .vehicleRegistrationImage ??
                                        '',
                                    image: imageValue,
                                    fileType: userData?.vehicleModal!
                                                .vehicleRegistrationImage !=
                                            null
                                        ? CustomFileType.network
                                        : CustomFileType.file,
                                    height: 160,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    borderRadius: 15,
                                  ),
                                )
                              else
                                Column(
                                  children: [
                                    Image.asset(
                                      MyImagesUrl.upload,
                                      height: 70,
                                    ),
                                    CustomText.bodyText1(
                                      height: 1,
                                      "Upload Registration",
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      );
                    }),
                vSizedBox2,
                CustomButton(
                  height: 50,
                  onTap: () async {
                    Map<String, dynamic> request = {};
                    await firebaseAuthProvider.showLoading();
                    if (selectRegistrationImageNoti.value != null) {
                      request[ApiKeys.vehicleRegistrationImage] =
                          await FirebaseService.uploadImageAndGetUrl(
                              selectRegistrationImageNoti.value!.path);
                    }
                    if (selectedLicenseNotifier.value != null) {
                      request[ApiKeys.driving_license_image] =
                          await FirebaseService.uploadImageAndGetUrl(
                              selectedLicenseNotifier.value!.path);
                    }
                    await firebaseAuthProvider.showLoading();
                    if (request.isNotEmpty) {
                      firebaseAuthProvider.editProfileEmail(request);
                    }
                    CustomNavigation.pop(context);
                  },
                  text: 'Save',
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
