import 'dart:io';

import 'package:connect_app_driver/constants/api_keys.dart';
import 'package:connect_app_driver/functions/pick_image_newest.dart';
import 'package:connect_app_driver/input_formatters/UpperCaseTextFormatter.dart';
import 'package:connect_app_driver/services/firebase_services/firebase_service.dart';
import 'package:connect_app_driver/widget/custom_image.dart';
import 'package:connect_app_driver/widget/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import '../../constants/global_data.dart';
import '../../constants/my_colors.dart';
import '../../constants/my_image_url.dart';
import '../../constants/sized_box.dart';
import '../../functions/validation_functions.dart';
import '../../provider/new_firebase_auth_provider.dart';
import '../../widget/custom_appbar.dart';
import '../../widget/custom_dropdown.dart';
import '../../widget/custom_scaffold.dart';
import '../../widget/custom_text.dart';
import '../../widget/custom_text_field.dart';
import '../../widget/custom_button.dart';

// ignore: must_be_immutable
class AddVehicleDetails extends StatefulWidget {
  Map<String, dynamic>? request;
  AddVehicleDetails({Key? key, this.request}) : super(key: key);

  @override
  State<AddVehicleDetails> createState() => _AddVehicleDetailsState();
}

class _AddVehicleDetailsState extends State<AddVehicleDetails> {
  final formKey = GlobalKey<FormState>();
  TextEditingController licenseNumberController = TextEditingController();
  TextEditingController vehicleNumberController = TextEditingController();
  TextEditingController insuranceNumberController = TextEditingController();
  // ValueNotifier<String> selectedCountryCode = ValueNotifier(defaultCountryCode);
  TextEditingController vehicleModalController = TextEditingController();
  ValueNotifier<Map?> selectVehicleTypeNotifier = ValueNotifier(null);
  ValueNotifier<File?> selectLicenceImageNoti = ValueNotifier(null);
  List vehicleList = List.generate(
    vehicleTypesList.length,
    (index) => vehicleTypesList[index].toJson(),
  );
// List<Map<dynamic, dynamic>> list=[
//   {'title':'Car'},
//   {'title':'Auto'},
//   {'title':'Two wheeler'},
//   ];

  @override
  void initState() {
    // TODO: implement initState
    isVerifyScreenActive = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        titleText: 'Fill details to complete your account',
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: globalHorizontalPadding, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText.headingSmall(
                  "Please enter vehicle details.",
                ),
                vSizedBox2,
                CustomTextField(
                  controller: vehicleNumberController,
                  hintText: "Vehicle Number",
                  inputFormatters: [
                    UpperCaseTextFormatter(),
                  ],
                  textCapitalization: TextCapitalization.characters,
                  validator: (val) {
                    return ValidationFunction.requiredValidation(val!);
                  },
                ),
                vSizedBox2,
                CustomTextField(
                  controller: licenseNumberController,
                  hintText: "License Number",
                  inputFormatters: [
                    UpperCaseTextFormatter(),
                  ],
                  textCapitalization: TextCapitalization.characters,
                  validator: (val) {
                    return ValidationFunction.requiredValidation(val);
                  },
                ),
                vSizedBox2,
                CustomTextField(
                  controller: insuranceNumberController,
                  borderRadius: 15,
                  hintText: "Insurance Number",
                  textCapitalization: TextCapitalization.characters,
                  inputFormatters: [
                    UpperCaseTextFormatter(),
                  ],
                  keyboardType: TextInputType.name,
                  validator: (val) =>
                      ValidationFunction.requiredValidation(val),
                ),
                vSizedBox2,
                ValueListenableBuilder(
                    valueListenable: selectVehicleTypeNotifier,
                    builder: (context, selectedVehicle, _) {
                      return CustomDropdownButton(
                        singleSelectedItem: selectedVehicle,
                        items: vehicleList,
                        validatorSingle: (val) =>
                            ValidationFunction.requiredValidation(val),
                        hint: "Choose Vehicle Type",
                        selectedItemString: selectedVehicle?['title'],
                        itemMapKey: 'title',
                        isMultiSelect: false,
                        onChangedSingle: (p0) {
                          selectVehicleTypeNotifier.value = p0;
                          print('sd fslk ${selectVehicleTypeNotifier.value}');
                        },
                      );
                    }),
                vSizedBox2,
                CustomTextField(
                  controller: vehicleModalController,
                  hintText: "Vehicle Modal",
                  textCapitalization: TextCapitalization.words,
                  validator: (val) =>
                      ValidationFunction.requiredValidation(val),
                ),
                vSizedBox2,
                ValueListenableBuilder(
                    valueListenable: selectLicenceImageNoti,
                    builder: (context, imageValue, _) {
                      return GestureDetector(
                        onTap: () async {
                          var img = await cameraImagePicker(context,
                              cropStyle: CropStyle.rectangle,
                              aspectRatio:
                                  CropAspectRatio(ratioX: 7, ratioY: 5));
                          if (img != null) {
                            selectLicenceImageNoti.value = img;
                          }
                        },
                        child: Container(
                          height: 160,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Color(0xFF484848),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                  color: MyColors.enabledTextFieldBorderColor)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (imageValue != null)
                                Expanded(
                                  child: CustomImage(
                                    imageUrl: '',
                                    image: imageValue,
                                    fileType: CustomFileType.file,
                                    height: 160,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    borderRadius: 15,
                                  ),
                                ),
                              if (imageValue == null)
                                Image.asset(
                                  MyImagesUrl.upload,
                                  height: 70,
                                ),
                              if (imageValue == null)
                                CustomText.bodyText1(
                                  height: 1,
                                  "Upload License",
                                ),
                            ],
                          ),
                        ),
                      );
                    }),
                vSizedBox2,
                Consumer<FirebaseAuthProvider>(
                    builder: (context, firebaseAuthProvider, child) {
                  // firebaseAuthProvider.hideLoading();

                  return CustomButton(
                    text: "Next",
                    height: 50,
                    onTap: () async {
                      // firebaseAuthProvider.getVehicleTypes();
                      // return;
                      if (formKey.currentState!.validate()) {
                        if (selectLicenceImageNoti.value != null) {
                          Map<String, dynamic> request = {
                            ApiKeys.vehicle_no: vehicleNumberController.text,
                            ApiKeys.license_number:
                                licenseNumberController.text,
                            // ApiKeys.insu: vehicleNumberController.text,
                            ApiKeys.insurance_number:
                                insuranceNumberController.text,
                            ApiKeys.vehicle_type:
                                selectVehicleTypeNotifier.value!['id'],
                            ApiKeys.vehicle_model: vehicleModalController.text,
                          };
                          if (widget.request == null) {
                            request[ApiKeys.driving_license_image] =
                                await FirebaseService.uploadImageAndGetUrl(
                                    selectLicenceImageNoti.value!.path);
                            await firebaseAuthProvider
                                .editProfileEmail(request);
                            firebaseAuthProvider.userNavigationAfterLogin();
                          } else {
                            widget.request!.addAll(request);
                            print(
                                'the request for signup is ${widget.request}');
                            await firebaseAuthProvider
                                .createAccount(widget.request!, files: {
                              ApiKeys.driving_license_image:
                                  selectLicenceImageNoti.value,
                            });
                          }
                          // CustomNavigation.push(context: context, screen: const VerifyOtpScreen());
                        } else {
                          showSnackbar('Please select Image');
                        }
                      }
                    },
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
