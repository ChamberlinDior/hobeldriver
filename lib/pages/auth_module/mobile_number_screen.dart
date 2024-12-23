import 'package:connect_app_driver/constants/api_keys.dart';
import 'package:connect_app_driver/services/firebase_services/firebase_collections.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/global_data.dart';
import '../../constants/my_colors.dart';
import '../../constants/sized_box.dart';
import '../../functions/validation_functions.dart';
import '../../provider/new_firebase_auth_provider.dart';
import '../../widget/custom_appbar.dart';
import '../../widget/custom_scaffold.dart';
import '../../widget/custom_text.dart';
import '../../widget/custom_text_field.dart';
import '../../widget/custom_button.dart';

class MobileNumberScreen extends StatefulWidget {
  const MobileNumberScreen({super.key});

  @override
  State<MobileNumberScreen> createState() => _MobileNumberScreenState();
}

class _MobileNumberScreenState extends State<MobileNumberScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController mobileNumberController = TextEditingController();
  ValueNotifier<String> selectedCountryCode = ValueNotifier(defaultCountryCode);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        titleText: 'Verify Phone Number',
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
                    "Verify Phone Number",
                  ),
                  vSizedBox,
                  CustomText.headingSmall(
                    "Enter your phone number",
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
                            return ValidationFunction.mobileNumberValidation(
                                val);
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
                  Consumer<FirebaseAuthProvider>(
                      builder: (context, firebaseAuthProvider, child) {
                    return CustomButton(
                        text: "Continue",
                        height: 50,
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            var request = {
                              ApiKeys.phone: mobileNumberController.text,
                              ApiKeys.phone_code: selectedCountryCode.value,
                              ApiKeys.phone_with_code:
                                  '${selectedCountryCode.value}${mobileNumberController.text}',
                            };
                            await FirebaseCollections.users
                                .doc(firebaseAuthProvider
                                    .firebaseInstance.currentUser!.uid)
                                .update(request);
                            firebaseAuthProvider.userNavigationAfterLogin();
                          }
                        });
                  }),
                  vSizedBox2,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
