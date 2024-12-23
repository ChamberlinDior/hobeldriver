import 'package:connect_app_driver/functions/print_function.dart';
import 'package:connect_app_driver/provider/location_provider.dart';
import 'package:connect_app_driver/widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:connect_app_driver/constants/global_data.dart';
import 'package:connect_app_driver/constants/my_image_url.dart';
import 'package:connect_app_driver/pages/auth_module/signup_screen.dart';
import '../../constants/my_colors.dart';
import '../../constants/sized_box.dart';
import '../../functions/validation_functions.dart';
import '../../provider/new_firebase_auth_provider.dart';
import '../../services/custom_navigation_services.dart';
import '../../widget/custom_appbar.dart';
import '../../widget/custom_scaffold.dart';
import '../../widget/custom_text_field.dart';
import '../../widget/custom_button.dart';
import 'forget_password_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with WidgetsBindingObserver {
  TextEditingController emailAddress = TextEditingController(
      // text: 'manish.1webwiders@gmail.com'
      );
  TextEditingController password = TextEditingController(
      // text: '123456'
      );
  final loginFormKey = GlobalKey<FormState>();
  ValueNotifier<bool> visibility = ValueNotifier(true);
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      var locationProvider =
          Provider.of<MyLocationProvider>(context, listen: false);
      await locationProvider.checkPermission(navigateMap: true);
    });
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    myCustomLogStatements("called when app is closed outside");
    if (state == AppLifecycleState.resumed) {
      var mylocation = Provider.of<MyLocationProvider>(context, listen: false);
      if (!mylocation.isLocationServiceDialogOpen) {
        myCustomLogStatements("called when app is closed inside");
        mylocation.ask();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        titleText: 'Login',
        isBackIcon: false,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 18.0),
        child: GestureDetector(
          onTap: () {
            CustomNavigation.push(
              context: context,
              screen: const SignUpScreen(),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText.bodyText2(
                "You don’t have an account?",
              ),
              hSizedBox05,
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
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: globalHorizontalPadding,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: loginFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText.headingLarge(
                  "Log in",
                ),
                vSizedBox,
                CustomText.headingSmall(
                  "Enter your login details",
                ),
                vSizedBox3,
                CustomTextField(
                  controller: emailAddress,
                  obscureText: false,
                  hintText: "Email ID",
                  validator: (val) {
                    return ValidationFunction.emailValidation(val);
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
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
                    builder: (context, fireabseAuthPovider, child) {
                  return CustomButton(
                    height: 50,
                    text: "Log in",
                    onTap: () {
                      if (loginFormKey.currentState!.validate()) {
                        // if(emailAddress.text=='test@gmail.com'){
                        //   CustomNavigation.pushAndRemoveUntil(context: context, screen: const HomeScreen());
                        // }else{
                        // }

                        fireabseAuthPovider.login(
                            password: password.text,
                            emailId: emailAddress.text);
                      }
                    },
                  );
                }),
                vSizedBox2,
                GestureDetector(
                  onTap: () {
                    CustomNavigation.push(
                      context: context,
                      screen: const ForgetScreen(),
                    );
                  },
                  child: Align(
                    alignment: Alignment.center,
                    child: CustomText.bodyText2(
                      "Forgot Password ?",
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                      color: MyColors.whiteColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                // vSizedBox3,
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
                // vSizedBox3,
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
                vSizedBox2,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
