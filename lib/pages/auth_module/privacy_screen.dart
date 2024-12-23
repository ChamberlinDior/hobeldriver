// import 'package:connect_app_driver/widget/custom_text.dart';
// import 'package:flutter/material.dart';
//
// import '../../constants/global_data.dart';
// import '../../constants/my_colors.dart';
// import '../../constants/my_image_url.dart';
// import '../../constants/sized_box.dart';
// import '../../widget/custom_appbar.dart';
// import '../../widget/custom_scaffold.dart';
// import '../../widget/old_custom_text.dart';
//
//
// class PrivacyPolicyScreen extends StatefulWidget {
//   const PrivacyPolicyScreen({super.key});
//
//   @override
//   State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
// }
//
// class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return CustomScaffold(
//       appBar:  CustomAppBar(
//         titleText: "Privacy Policy",
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: globalHorizontalPadding,vertical: 2),
//                 child: Column(
//                   children: [
//                     for (int i = 0; i < 6; i++)
//                       Column(
//                         children: [
//                           CustomText.bodyText2(
//                             "${i + 1}. Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
//                             fontSize: 15,
//                             fontWeight: FontWeight.w600,
//                           ),
//                           vSizedBox05,
//                            CustomText.bodyText2(
//                             "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,",
//                             fontSize: 14,
//                             fontWeight: FontWeight.w400,
//                           ),
//                           vSizedBox2,
//                         ],
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
