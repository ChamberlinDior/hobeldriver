// import 'package:connect_app_driver/constants/my_colors.dart';
// import 'package:connect_app_driver/constants/my_image_url.dart';
// import 'package:connect_app_driver/constants/sized_box.dart';
// import 'package:connect_app_driver/pages/bottom_sheet/place_your_bid.dart';
// import 'package:connect_app_driver/provider/bottom_sheet_provider.dart';
// import 'package:connect_app_driver/widget/custom_image.dart';
// import 'package:connect_app_driver/widget/custom_rating.dart';
// import 'package:connect_app_driver/widget/custom_rich_text.dart';
// import 'package:connect_app_driver/widget/custom_text.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../constants/screen_names.dart';
// import '../../widget/app_specific/custom_stepper.dart';
// import '../../widget/custom_button.dart';

// class ScheduledRide extends StatelessWidget {
//   const ScheduledRide({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             CustomText.headingSmall(
//               'Scheduled Ride',
//               fontWeight: FontWeight.w600,
//             ),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: MyColors.redColor)),
//               child: CustomText.headingSmall(
//                 '1:59',
//                 color: MyColors.redColor,
//               ),
//             )
//           ],
//         ),
//         vSizedBox2,
//         Row(
//           children: [
//             const CustomImage(
//               imageUrl: MyImagesUrl.img02,
//               fileType: CustomFileType.asset,
//               height: 50,
//               width: 50,
//               borderRadius: 30,
//             ),
//             hSizedBox,
//             Expanded(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       CustomText.bodyText2(
//                         'John Smith',
//                         fontWeight: FontWeight.w500,
//                       ),
//                       Row(
//                         children: [
//                           CustomRating(),
//                           hSizedBox02,
//                           CustomText.smallText(
//                             '(50 Reviews)',
//                             fontSize: 10,
//                             color: MyColors.color969696,
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             GestureDetector(
//               onTap: () {
//                 // CustomNavigation.push(context: context, screen: const ConversationScreen());
//               },
//               child: CircleAvatar(
//                 radius: 18,
//                 backgroundColor: MyColors.whiteColor,
//                 child: Padding(
//                   padding: const EdgeInsets.all(9),
//                   child: Image.asset(
//                     MyImagesUrl.chat,
//                   ),
//                 ),
//               ),
//             ),
//             hSizedBox,
//             GestureDetector(
//               onTap: () async {
//                 // CustomNavigation.push(context: context, screen: const RideSuccessScreen());
//                 //  var url =
//                 //               "tel: +${liveBookingProvider.customerDetail?.phoneWithCode}";
//                 //           if (await canLaunch(url)) {
//                 //             await launch(url);
//                 //           }
//               },
//               child: CircleAvatar(
//                 radius: 18,
//                 backgroundColor: MyColors.whiteColor,
//                 child: Padding(
//                   padding: const EdgeInsets.all(9),
//                   child: Image.asset(
//                     MyImagesUrl.phoneOutline,
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//         Divider(
//           color: MyColors.dividerColor,
//           height: 40,
//         ),
//         CustomText.headingSmall(
//           'Schedule Ride',
//           fontWeight: FontWeight.w600,
//         ),
//         vSizedBox2,
//         Row(
//           children: [
//             Image.asset(
//               MyImagesUrl.calender,
//               width: 24,
//             ),
//             hSizedBox,
//             CustomRichText(
//                 firstText: 'Scheduled on :-',
//                 firstTextFontWeight: FontWeight.w700,
//                 secondText: '04 june 2024',
//                 secondTextFontWeight: FontWeight.w400)
//           ],
//         ),
//         vSizedBox,
//         Row(
//           children: [
//             Image.asset(
//               MyImagesUrl.timeIcon,
//               width: 24,
//             ),
//             hSizedBox,
//             CustomRichText(
//                 firstText: 'Pickup Time:-',
//                 firstTextFontWeight: FontWeight.w700,
//                 secondText: '06:21 pm',
//                 secondTextFontWeight: FontWeight.w400)
//           ],
//         ),
//         vSizedBox,
//         Row(
//           children: [
//             Image.asset(
//               MyImagesUrl.seatIcon,
//               width: 24,
//             ),
//             hSizedBox,
//             CustomRichText(
//                 firstText: 'Booking of Seats :-',
//                 firstTextFontWeight: FontWeight.w700,
//                 secondText: '1 seat only',
//                 secondTextFontWeight: FontWeight.w400)
//           ],
//         ),
//         Divider(
//           color: MyColors.dividerColor,
//           height: 40,
//         ),
//         CustomStepper(
//           steps: [
//             StepData(
//               title: '4min (1.6mi) away',
//               subtitle: '70-A Braj Vihar Colony, Indore',
//               isCurrent: true,
//             ),
//             StepData(
//               title: '13min (10mi) trip',
//               subtitle: '315, Pukhraj Corporate, Inore',
//             ),
//           ],
//         ),
//         vSizedBox2,
//         Consumer<BottomSheetProvider>(
//             builder: (context, bottomSheetProviderValue, _) {
//           return Row(
//             children: [
//               Expanded(
//                 child: CustomButton(
//                   height: 50,
//                   text: 'Place bid',
//                   horizontalMargin: 10,
//                   onTap: () {
//                     bottomSheetProviderValue.addPage(PlaceYourBid(),
//                         screenName: ScreenNames.PlaceYourBid);
//                   },
//                 ),
//               ),
//               Expanded(
//                 child: CustomButton(
//                   height: 50,
//                   text: 'Reject',
//                   horizontalMargin: 10,
//                   onTap: () {
//                     bottomSheetProviderValue.removePage();
//                   },
//                   isSolid: false,
//                 ),
//               ),
//             ],
//           );
//         }),
//       ],
//     );
//   }
// }
