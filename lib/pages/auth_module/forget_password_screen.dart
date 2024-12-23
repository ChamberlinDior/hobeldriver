import 'package:connect_app_driver/pages/auth_module/signup_screen.dart';
import 'package:connect_app_driver/provider/new_firebase_auth_provider.dart';
import 'package:connect_app_driver/services/custom_navigation_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:connect_app_driver/constants/global_data.dart';
import '../../constants/my_colors.dart';
import '../../constants/sized_box.dart';
import '../../functions/validation_functions.dart';
import '../../widget/custom_appbar.dart';
import '../../widget/custom_scaffold.dart';
import '../../widget/custom_text.dart';
import '../../widget/custom_text_field.dart';
import '../../widget/custom_button.dart';

class ForgetScreen extends StatefulWidget {
  const ForgetScreen({Key? key}) : super(key: key);

  @override
  State<ForgetScreen> createState() => _ForgetScreenState();
}

class _ForgetScreenState extends State<ForgetScreen> {
  TextEditingController emailAddress = TextEditingController();
  final formKey = GlobalKey<FormState>();
  ValueNotifier<bool> visibility = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        titleText: 'Forgot Password',
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 18.0),
        child: GestureDetector(
          onTap: () {
            CustomNavigation.pop(context);
            CustomNavigation.push(
                context: context, screen: const SignUpScreen());
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText.bodyText2(
                "You don’t have an account?",
              ),hSizedBox05,
              CustomText.bodyText2(
                "Signup",
                fontWeight: FontWeight.w700,
                color: MyColors.whiteColor,
                decoration: TextDecoration.underline,
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
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
                    "Forgot your \npassword",
                  ),
                  vSizedBox,
                  CustomText.heading(
                    "Please enter your registered\nemail id.",
                    fontWeight: FontWeight.w400,
                  ),
                  vSizedBox4,
                  CustomTextField(
                    controller: emailAddress,
                    obscureText: false,
                    hintText: "Email ID",
                    validator: (val) {
                      return ValidationFunction.emailValidation(val);
                    },
                    keyboardType: TextInputType.emailAddress,
                  ),
                  vSizedBox,
                  Consumer<FirebaseAuthProvider>(
                      builder: (context, firebaseAuthProvider, child) {
                    return CustomButton(
                      text: "Send",
                      height: 50,
                      verticalMargin: 30,
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          // CustomNavigation.pop(context);
                          firebaseAuthProvider
                              .forgetPassword(emailAddress.text);
                        }
                      },
                    );
                  }),
                  vSizedBox4,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
