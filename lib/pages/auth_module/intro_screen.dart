

// import 'package:connect_app_driver/pages/auth_module/login_screen.dart';
// import 'package:connect_app_driver/pages/auth_module/select_user_screen.dart';
// import 'package:connect_app_driver/widget/custom_text.dart';
// import 'package:flutter/material.dart';
// import 'package:connect_app_driver/constants/my_colors.dart';
// import 'package:connect_app_driver/constants/my_image_url.dart';
// import 'package:connect_app_driver/constants/sized_box.dart';
// import '../../services/custom_navigation_services.dart';
// import '../../widget/custom_button.dart';
// import '../../widget/custom_scaffold.dart';

// class IntroScreen extends StatefulWidget {
//   const IntroScreen({Key? key}) : super(key: key);

//   @override
//   State<IntroScreen> createState() => _IntroScreenState();
// }

// class _IntroScreenState extends State<IntroScreen> {
//   @override
//   Widget build(BuildContext context) {

//     return CustomScaffold(
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 30),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset(MyImagesUrl.introImg01,
//             width: MediaQuery.of(context).size.width*0.7,
//             ),
//             vSizedBox4,
//             // const SubHeadingText('Get There, On time ',
//             // fontSize: 24,
//             // fontWeight: FontWeight.w600,),
//             CustomText.heading('Drive Free, Earn More',
//               fontSize: 24,
//               fontWeight: FontWeight.w600,
//             ),
//             vSizedBox,
//             CustomText.heading('Enjoy the freedom to choose your hours and maximize your earnings anytime.',
//               fontSize: 15,
//               textAlign: TextAlign.center,
//               fontWeight: FontWeight.w400,),
//             //  Row(
//             //   crossAxisAlignment: CrossAxisAlignment.center,
//             //   mainAxisAlignment: MainAxisAlignment.center,
//             //   children: [
//             //     CustomText.heading('with our ',
//             //       fontSize: 15,
//             //       fontWeight: FontWeight.w400,),
//             //     CustomText.heading('Connect',
//             //       fontSize: 15,
//             //       color: MyColors.whiteColor,
//             //       fontWeight: FontWeight.w700,),
//             //     CustomText.heading(' app.',
//             //       fontSize: 15,
//             //       fontWeight: FontWeight.w400,),
//             //   ],
//             // ),
//             vSizedBox,
//             CustomButton(
//               height: 65,
//               fontSize: 20,
//               fontWeight: FontWeight.w500,
//               onTap: (){
//                 CustomNavigation.pushAndRemoveUntil(context: context, screen: const LoginPage());
//               },
//               verticalMargin: 35,
//               text: "Let's Get Started!",

//             ),


//           ],
//         ),
//       ),

//     );
//   }
// }
