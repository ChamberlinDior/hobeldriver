// import 'package:connect_app_driver/constants/global_data.dart';
// import 'package:connect_app_driver/constants/my_colors.dart';
// import 'package:connect_app_driver/constants/my_image_url.dart';
// import 'package:connect_app_driver/constants/sized_box.dart';
// import 'package:connect_app_driver/widget/custom_button.dart';
// import 'package:connect_app_driver/widget/custom_image.dart';
// import 'package:connect_app_driver/widget/custom_scaffold.dart';
// import 'package:connect_app_driver/widget/custom_text.dart';
// import 'package:flutter/material.dart';
// import '../../constants/types/booking_status.dart';
// import '../../widget/app_specific/custom_stepper.dart';
// import '../../widget/custom_appbar.dart';
// import '../../widget/custom_rating.dart';
// import '../../widget/custom_rich_text.dart';

// class DriverBidsScreen extends StatefulWidget {
//   const DriverBidsScreen({super.key});

//   @override
//   State<DriverBidsScreen> createState() => _DriverBidsScreenState();
// }

// class _DriverBidsScreenState extends State<DriverBidsScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return CustomScaffold(
//       appBar: CustomAppBar(
//         isBackIcon: true,
//         titleText: 'Scheduled Ride',
//       ),
//       body: Padding(
//         padding:
//             const EdgeInsets.symmetric(horizontal: globalHorizontalPadding),
//         child: Column(
//           children: [
//             Container(
//               margin: const EdgeInsets.symmetric(vertical: 10),
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//               decoration: BoxDecoration(
//                   color: MyColors.whiteColor,
//                   borderRadius: BorderRadius.circular(15)),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       CustomText.smallText(
//                         'Booking ID:#1526544',
//                         color: MyColors.blackColor,
//                         fontSize: 11,
//                       ),
//                       CustomButton(
//                         text: BookingStatus.getName(BookingStatus.pending),
//                         horizontalPadding: 8,
//                         verticalPadding: 2,
//                         verticalMargin: 0,
//                         isFlexible: true,
//                         fontSize: 12,
//                         color: BookingStatus.getColor(BookingStatus.pending),
//                       )
//                     ],
//                   ),
//                   vSizedBox,
//                   Row(
//                     children: [
//                       Image.asset(
//                         MyImagesUrl.calender,
//                         width: 23,
//                         color: MyColors.blackColor,
//                       ),
//                       hSizedBox05,
//                       hSizedBox02,
//                       CustomRichText(
//                         firstText: 'Scheduled on:- ',
//                         firstTextFontSize: 12,
//                         firstTextFontWeight: FontWeight.w700,
//                         firstTextColor: MyColors.blackColor,
//                         secondText: '04 june 2024',
//                         secondTextFontSize: 12,
//                         secondTextFontWeight: FontWeight.w400,
//                         secondTextColor: MyColors.blackColor,
//                       ),
//                     ],
//                   ),
//                   vSizedBox,
//                   Row(
//                     children: [
//                       Image.asset(
//                         MyImagesUrl.timeIcon,
//                         width: 23,
//                         color: MyColors.blackColor,
//                       ),
//                       hSizedBox05,
//                       hSizedBox02,
//                       CustomRichText(
//                         firstText: 'Pickup Time:- ',
//                         firstTextFontSize: 12,
//                         firstTextFontWeight: FontWeight.w700,
//                         firstTextColor: MyColors.blackColor,
//                         secondText: '06:21 pm',
//                         secondTextFontSize: 12,
//                         secondTextFontWeight: FontWeight.w400,
//                         secondTextColor: MyColors.blackColor,
//                       ),
//                     ],
//                   ),
//                   vSizedBox,
//                   // Container(
//                   //   padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 15),
//                   //   decoration: BoxDecoration(
//                   //       color: MyColors.blackColor,
//                   //       borderRadius: BorderRadius.circular(15)
//                   //   ),
//                   //   child: Column(
//                   //     children: [1,2,].map((step) {
//                   //       int index = [1,2].indexOf(step);
//                   //       return StepItem(
//                   //         step: StepData(
//                   //           title: '4min (1.6mi) away',
//                   //           subtitle: '70-A Braj Vihar Colony, Indore',
//                   //           isCurrent: true,
//                   //         ),
//                   //         isLast: index == [1,2].length - 1,
//                   //       );
//                   //     }).toList(),
//                   //   ),
//                   // ),
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 12, vertical: 15),
//                     decoration: BoxDecoration(
//                         color: MyColors.blackColor,
//                         borderRadius: BorderRadius.circular(15)),
//                     child: CustomStepper(
//                       steps: [
//                         StepData(
//                           title: 'Pickup',
//                           subtitle: '70-A Braj Vihar Colony, Indore',
//                           isCurrent: true,
//                         ),
//                         StepData(
//                           title: 'Destination',
//                           subtitle: '315, Pukhraj Corporate, Inore',
//                         ),
//                       ],
//                     ),
//                   ),
//                   vSizedBox,
//                 ],
//               ),
//             ),
//             Expanded(
//                 child: ListView.builder(
//               itemCount: 3,
//               itemBuilder: (context, index) {
//                 return Container(
//                   margin: const EdgeInsets.symmetric(vertical: 10),
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//                   decoration: BoxDecoration(
//                       color: MyColors.color121212,
//                       borderRadius: BorderRadius.circular(15)),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           const CustomImage(
//                             imageUrl: MyImagesUrl.img02,
//                             fileType: CustomFileType.asset,
//                             height: 50,
//                             width: 50,
//                             borderRadius: 30,
//                           ),
//                           hSizedBox,
//                           Expanded(
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     CustomText.bodyText2(
//                                       'John Smith',
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                     Row(
//                                       children: [
//                                         const CustomRating(
//                                           disableColor: MyColors.whiteColor,
//                                         ),
//                                         CustomText.smallText(
//                                           ' (50 Reviews)',
//                                           fontSize: 10,
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                           CustomText.heading(
//                             '\$225',
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ],
//                       ),
//                       vSizedBox,
//                       Row(
//                         children: [
//                           CustomButton(
//                             text: 'Accept',
//                             horizontalPadding: 15,
//                             onTap: () {},
//                             verticalPadding: 6,
//                             verticalMargin: 5,
//                             isFlexible: true,
//                             fontSize: 13,
//                             borderRadius: 10,
//                           ),
//                           hSizedBox,
//                           CustomButton(
//                             text: 'Reject',
//                             horizontalPadding: 15,
//                             onTap: () {},
//                             verticalPadding: 6,
//                             verticalMargin: 5,
//                             isFlexible: true,
//                             fontSize: 13,
//                             borderRadius: 10,
//                             textColor: MyColors.whiteColor,
//                             color: MyColors.redColor01,
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ))
//           ],
//         ),
//       ),
//     );
//   }
// }
