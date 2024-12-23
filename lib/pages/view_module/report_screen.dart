// import 'package:connect_app_driver/widget/custom_text.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../constants/global_data.dart';
// import '../../constants/my_colors.dart';
// import '../../constants/my_image_url.dart';
// import '../../constants/sized_box.dart';
// import '../../provider/bottom_sheet_provider.dart';
// import '../../services/custom_navigation_services.dart';
// import '../../widget/app_specific/dotted_border_container.dart';
// import '../../widget/custom_appbar.dart';
// import '../../widget/custom_image.dart';
// import '../../widget/custom_scaffold.dart';
// import '../../widget/old_custom_text.dart';
// import '../../widget/custom_text_field.dart';
// import '../../widget/custom_button.dart';
// import '../../widget/show_snackbar.dart';
// import 'home_screen.dart';

// class ReportScreen extends StatefulWidget {
//   const ReportScreen({Key? key}) : super(key: key);

//   @override
//   State<ReportScreen> createState() => _ReportScreenState();
// }

// class _ReportScreenState extends State<ReportScreen> {
//   TextEditingController reportController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return CustomScaffold(
//       appBar: CustomAppBar(
//         isBackIcon: true,
//         titleText: 'Report',
//         actions: const [
//           CustomImage(
//             height: 45,
//             width: 45,
//             imageUrl: MyImagesUrl.profileImage,
//             borderRadius: 100,
//             fileType: CustomFileType.asset,
//           ),
//           hSizedBox,
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(
//             horizontal: globalHorizontalPadding, vertical: 10),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             CustomText.heading(
//               'Complaint against Customer',
//               fontSize: 22,
//             ),
//             vSizedBox,
//             CustomText.bodyText2(
//               'Enter your complaint below in the given box ',
//               fontSize: 14,
//               fontWeight: FontWeight.w400,
//             ),
//             vSizedBox4,
//             CustomPaint(
//               painter: DottedBorderPainter(
//                 color: MyColors.whiteColor,
//                 strokeWidth: 2,
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 1),
//                 child: CustomTextField(
//                   maxLines: 6,
//                   fillColor: MyColors.blackColor,
//                   borderColor: Colors.transparent,
//                   controller: reportController,
//                   hintText: "Type here...",
//                 ),
//               ),
//             ),
//             vSizedBox,
//             CustomButton(
//               height: 50,
//               onTap: () {
//                 if(reportController.text.isNotEmpty){
//                   var provider=Provider.of<BottomSheetProvider>(context,listen: false);
//                   provider.removePageUntil();
//                   CustomNavigation.popUntil(context, (route)=>route.isFirst);
//                 }else{
//                   showSnackbar('Required**');
//                 }
//               },
//               verticalMargin: 20,
//               text: "Submit",
//             ),
//             Align(
//               alignment: Alignment.center,
//               child:   TextButton(
//                 onPressed: () {
//                   CustomNavigation.pop(context);
//                 },
//                 child: CustomText.bodyText1(
//                   "Cancel",
//                   color: MyColors.whiteColor,
//                   decoration: TextDecoration.underline,
//                 ),
//               )
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
