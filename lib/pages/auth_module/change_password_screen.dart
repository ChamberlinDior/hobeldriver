import 'package:connect_app_driver/provider/new_firebase_auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/global_data.dart';
import '../../constants/my_colors.dart';
import '../../constants/sized_box.dart';
import '../../functions/validation_functions.dart';
import '../../widget/custom_appbar.dart';
import '../../widget/custom_scaffold.dart';
import '../../widget/custom_text_field.dart';
import '../../widget/custom_button.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  ValueNotifier<bool> oldPasswordVisibility = ValueNotifier(true);
  ValueNotifier<bool> newPasswordVisibility = ValueNotifier(true);
  ValueNotifier<bool> confirmPasswordVisibility = ValueNotifier(true);
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        titleText: 'Change Password',
      ),
      bottomNavigationBar: Consumer<FirebaseAuthProvider>(
          builder: (context, firebaseAuthProvider, child) {
        return CustomButton(
          text: "Save",
          verticalMargin: 20,
          height: 50,
          horizontalMargin: globalHorizontalPadding,
          onTap: () {
            if (formKey.currentState!.validate()) {
              firebaseAuthProvider.changePassword(context,
                  oldpassword: oldPasswordController.text,
                  newpassword: newPasswordController.text);
              // CustomNavigation.pop( context);
            }
          },
        );
      }),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: globalHorizontalPadding, vertical: 18),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                ValueListenableBuilder(
                  valueListenable: oldPasswordVisibility,
                  builder: (_, value, __) => CustomTextField(
                    controller: oldPasswordController,
                    hintText: "Old Password",
                    validator: (val) {
                      return ValidationFunction.passwordValidation(val);
                    },
                    obscureText: value,
                    suffix: IconButton(
                      onPressed: () {
                        oldPasswordVisibility.value = !value;
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
                ValueListenableBuilder(
                  valueListenable: newPasswordVisibility,
                  builder: (_, value, __) => CustomTextField(
                    controller: newPasswordController,
                    hintText: "Enter New Password",
                    validator: (val) {
                      return ValidationFunction.passwordValidation(val);
                    },
                    obscureText: value,
                    suffix: IconButton(
                      onPressed: () {
                        newPasswordVisibility.value = !value;
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
                ValueListenableBuilder(
                  valueListenable: confirmPasswordVisibility,
                  builder: (_, value, __) => CustomTextField(
                    controller: confirmPassController,
                    hintText: "Confirm New Password",
                    validator: (val) =>
                        ValidationFunction.confirmPasswordValidation(
                            val, newPasswordController.text),
                    obscureText: value,
                    suffix: IconButton(
                      onPressed: () {
                        confirmPasswordVisibility.value = !value;
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
