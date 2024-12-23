// import 'package:flutter/material.dart';
// import '../../constants/my_image_url.dart';
// import '../../constants/sized_box.dart';
// import '../../services/custom_navigation_services.dart';
// import '../../widget/custom_button.dart';
// import '../../widget/custom_scaffold.dart';
// import '../../widget/custom_text.dart';
// import 'login_screen.dart';

// class SelectUserScreen extends StatefulWidget {
//   const SelectUserScreen({super.key});

//   @override
//   State<SelectUserScreen> createState() => _SelectUserScreenState();
// }

// class _SelectUserScreenState extends State<SelectUserScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return CustomScaffold(
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 18),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset(MyImagesUrl.introImg,
//               width: MediaQuery.of(context).size.width*0.8,
//             ),
//             vSizedBox4,
//             CustomText.heading('Choose who are you?',
//               fontWeight: FontWeight.w600,
//             ),
//             vSizedBox05,
//             CustomText.bodyText2('Please Select you are a Driver or User?',
//               fontSize: 15,),
//             CustomButton(
//               height: 65,
//               fontSize: 20,
//               fontWeight: FontWeight.w500,
//               onTap: (){
//                 CustomNavigation.push(context: context, screen: const LoginPage());
//               },
//               horizontalMargin: 28,
//               verticalMargin: 35,
//               text: "Rider",

//             ),
//             CustomButton(
//               height: 65,
//               fontSize: 20,
//               fontWeight: FontWeight.w500,
//               onTap: (){
//                 CustomNavigation.push(context: context, screen: const LoginPage());
//               },
//               horizontalMargin: 28,
//               isSolid: false,
//               verticalMargin: 0,
//               text: "Driver",
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
