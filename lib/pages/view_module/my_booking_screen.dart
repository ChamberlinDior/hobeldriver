// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:connect_app_driver/constants/global_data.dart';
// import 'package:connect_app_driver/pages/view_module/rate_us_screen.dart';
//
// import '../../constants/my_colors.dart';
// import '../../constants/my_image_url.dart';
// import '../../constants/sized_box.dart';
// import '../../functions/navigation_functions.dart';
// import '../../widget/custom_appbar.dart';
// import '../../widget/custom_circular_image.dart';
// import '../../widget/old_custom_text.dart';
// import '../../widget/custom_button.dart';
//
// class MyBookingScreen extends StatefulWidget {
//   const MyBookingScreen({Key? key}) : super(key: key);
//
//   @override
//   State<MyBookingScreen> createState() => _MyBookingScreenState();
// }
//
// class _MyBookingScreenState extends State<MyBookingScreen> {
//   ValueNotifier<int> defaultController=ValueNotifier(0);
//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder(
//       valueListenable: defaultController,
//       builder: (context, value, child) =>
//           DefaultTabController(
//             length: 4,
//             initialIndex: value,
//             child: CustomScaffold(
//
//               appBar: CustomAppBar(
//                 toolbarHeight:100,
//                 titleText: 'My Bookings',
//                 bottom:     TabBar(
//                   isScrollable: false,
//                   indicatorColor: MyColors.primaryColor,
//                   indicatorSize: TabBarIndicatorSize.tab,
//                   labelColor: MyColors.primaryColor,
//                   dividerHeight: 2,
//                   labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, ),
//                   labelPadding: const EdgeInsets.only(top: 12.0, left: 20, right: 20, bottom: 8),
//                   unselectedLabelColor: MyColors.blackColor,
//                   unselectedLabelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, fontFamily: 'poppins',),
//                   tabs:const [
//                     Text('Current Booking'),
//                     Text('Past Booking')
//                   ],
//                 ),
//               ),
//               body: TabBarView(
//                 children: [
//                   currentBooking(),
//                   pastBooking(),
//                 ],
//               ),
//
//             ),
//           ),
//     );
//
//   }
//   currentBooking(){
//     return Column(
//       children: [
//         Expanded(
//           child: ListView.builder(
//               itemCount: 2,
//               padding: const EdgeInsets.symmetric(horizontal: globalHorizontalPadding,vertical: 20),
//               itemBuilder: (context,index)=>
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 14,vertical: 14),
//                     margin: const EdgeInsets.only(bottom: 15),
//                     decoration: BoxDecoration(
//                       color:MyColors.blackThemeColorWithOpacity(0.09),
//                       // color: Color(0xFFE9E9E9),
//                       border: Border.all(color: MyColors.blackThemeColorWithOpacity(0.1)),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Column(
//                       children: [
//                         const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             ParagraphText('Booking ID:#1526544',
//                               fontSize: 12,
//                               fontWeight: FontWeight.w400,),
//                             ParagraphText('04-12-2023, 06:21pm',
//                               fontSize: 12,
//                               fontWeight: FontWeight.w400,),
//                           ],
//                         ),
//                         vSizedBox2,
//                         Row(
//                           children: [
//                             Column(
//                               children: [
//                                 CircleAvatar(
//                                     radius: 9,
//                                     backgroundColor: MyColors.primaryColor.withOpacity(0.35),
//                                     child: const Icon(Icons.circle,size: 14,color: MyColors.primaryColor,)),
//                                 Container(
//                                   margin: const EdgeInsets.symmetric(vertical: 4),
//                                   width: 3,
//                                   height: 40,
//                                   color:MyColors.blackThemeColor(),
//                                 ),
//                                 Image.asset(MyImagesUrl.location01,width: 24,color:  MyColors.blackThemeColor(),)
//                               ],
//                             ),hSizedBox,
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 ParagraphText('70-A Braj Vihar Colony, Indore',
//                                   fontSize: 13,
//                                   color: MyColors.blackThemeColorWithOpacity(0.5),
//                                   textAlign: TextAlign.center,
//                                   fontWeight: FontWeight.w400,),
//                                 vSizedBox5,
//                                 ParagraphText('70-A Braj Vihar Colony, Indore',
//                                   fontSize: 13,
//                                   color: MyColors.blackThemeColorWithOpacity(0.5),
//                                   textAlign: TextAlign.center,
//                                   fontWeight: FontWeight.w400,),
//                               ],)
//                           ],
//                         ),
//                         vSizedBox2,
//                         const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             ParagraphText('Your Driver:',
//                               fontSize: 15,
//                               fontWeight: FontWeight.w400,),
//                             ParagraphText('\$25USD',
//                               fontSize: 15,
//                               fontWeight: FontWeight.w400,),
//                           ],
//                         ),
//                         vSizedBox2,
//                         Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 6),
//                           decoration: BoxDecoration(
//                             color: MyColors.textFillThemeColor(),
//                             border: Border.all(color: MyColors.blackThemeColorWithOpacity(0.1)),
//                             borderRadius: BorderRadius.circular(14),
//                           ),
//                           child: Row(
//                             children: [
//                               const CustomCircularImage(
//                                 height: 50,
//                                 width: 50,
//                                 imageUrl:  MyImagesUrl.profileImage,
//                                 borderRadius: 100,
//                                 fileType: CustomFileType.asset,
//                               ),
//                               hSizedBox,
//                               Expanded(
//                                 child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         const   ParagraphText('John Smith',
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w500,),
//                                         Row(
//                                           children: [
//                                             RatingBar(
//                                               initialRating: 2.0,
//                                               minRating: 1,
//                                               ignoreGestures: false,
//                                               direction: Axis.horizontal,
//                                               allowHalfRating: true,
//                                               itemCount: 5,
//                                               itemSize: 11,
//                                               ratingWidget: RatingWidget(
//                                                 full:Image.asset( MyImagesUrl.star,color: const Color(0xFFFBBC04),),
//                                                 half:Image.asset( MyImagesUrl.star),
//                                                 empty:Image.asset( MyImagesUrl.star,color:MyColors.blackThemeColorWithOpacity(0.4),),
//                                               ),
//                                               onRatingUpdate: (rating) {
//                                               },
//                                             ),
//                                             vSizedBox05,
//                                             ParagraphText(' (50 Reviews)',
//                                               fontSize: 10,
//                                               color: MyColors.blackThemeColorWithOpacity(0.3),
//                                               fontWeight: FontWeight.w400,),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                     const Column(
//                                       crossAxisAlignment: CrossAxisAlignment.end,
//                                       children: [
//                                         ParagraphText('MP09ZZ9876',
//                                           fontSize: 13,
//                                           fontWeight: FontWeight.w400,),
//                                         ParagraphText('CASH',
//                                           fontSize: 13,
//                                           fontWeight: FontWeight.w400,),
//                                       ],)
//
//                                   ],
//                                 ),
//                               ),
//
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                   )),
//         )
//       ],
//     );
//   }
//   pastBooking(){
//     return Column(
//       children: [
//         Expanded(
//           child: ListView.builder(
//               itemCount: 2,
//               padding: const EdgeInsets.symmetric(horizontal: globalHorizontalPadding,vertical: 20),
//               itemBuilder: (context,index)=>
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 14,vertical: 14),
//                     margin: const EdgeInsets.only(bottom: 15),
//                     decoration: BoxDecoration(
//                       color:MyColors.blackThemeColorWithOpacity(0.09),
//                       // color: Color(0xFFE9E9E9),
//                       border: Border.all(color: MyColors.blackThemeColorWithOpacity(0.1)),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Column(
//                       children: [
//                         const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             ParagraphText('Booking ID:#1526544',
//                               fontSize: 12,
//                               fontWeight: FontWeight.w400,),
//                             ParagraphText('04-12-2023, 06:21pm',
//                               fontSize: 12,
//                               fontWeight: FontWeight.w400,),
//                           ],
//                         ),
//                         vSizedBox2,
//                         Row(
//                           children: [
//                             Column(
//                               children: [
//                                 CircleAvatar(
//                                     radius: 9,
//                                     backgroundColor: MyColors.primaryColor.withOpacity(0.35),
//                                     child: const Icon(Icons.circle,size: 14,color: MyColors.primaryColor,)),
//                                 Container(
//                                   margin: const EdgeInsets.symmetric(vertical: 4),
//                                   width: 3,
//                                   height: 40,
//                                   color:MyColors.blackThemeColor(),
//                                 ),
//                                 Image.asset(MyImagesUrl.location01,width: 24,color:  MyColors.blackThemeColor(),)
//                               ],
//                             ),hSizedBox,
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 ParagraphText('70-A Braj Vihar Colony, Indore',
//                                   fontSize: 13,
//                                   color: MyColors.blackThemeColorWithOpacity(0.5),
//                                   textAlign: TextAlign.center,
//                                   fontWeight: FontWeight.w400,),
//                                 vSizedBox5,
//                                 ParagraphText('70-A Braj Vihar Colony, Indore',
//                                   fontSize: 13,
//                                   color: MyColors.blackThemeColorWithOpacity(0.5),
//                                   textAlign: TextAlign.center,
//                                   fontWeight: FontWeight.w400,),
//                               ],)
//                           ],
//                         ),
//                         vSizedBox2,
//                         const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             ParagraphText('Your Driver:',
//                               fontSize: 15,
//                               fontWeight: FontWeight.w400,),
//                             ParagraphText('\$25USD',
//                               fontSize: 15,
//                               fontWeight: FontWeight.w400,),
//                           ],
//                         ),
//                         vSizedBox2,
//                         Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 6),
//                           decoration: BoxDecoration(
//                             color: MyColors.textFillThemeColor(),
//                             border: Border.all(color: MyColors.blackThemeColorWithOpacity(0.1)),
//                             borderRadius: BorderRadius.circular(14),
//                           ),
//                           child: Row(
//                             children: [
//                               const CustomCircularImage(
//                                 height: 50,
//                                 width: 50,
//                                 imageUrl:  MyImagesUrl.profileImage,
//                                 borderRadius: 100,
//                                 fileType: CustomFileType.asset,
//                               ),
//                               hSizedBox,
//                               Expanded(
//                                 child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         const   ParagraphText('John Smith',
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w500,),
//                                         Row(
//                                           children: [
//                                             RatingBar(
//                                               initialRating: 2.0,
//                                               minRating: 1,
//                                               ignoreGestures: false,
//                                               direction: Axis.horizontal,
//                                               allowHalfRating: true,
//                                               itemCount: 5,
//                                               itemSize: 11,
//                                               ratingWidget: RatingWidget(
//                                                 full:Image.asset( MyImagesUrl.star,color: const Color(0xFFFBBC04),),
//                                                 half:Image.asset( MyImagesUrl.star),
//                                                 empty:Image.asset( MyImagesUrl.star,color:MyColors.blackThemeColorWithOpacity(0.4),),
//                                               ),
//                                               onRatingUpdate: (rating) {
//                                               },
//                                             ),
//                                             vSizedBox05,
//                                             ParagraphText(' (50 Reviews)',
//                                               fontSize: 10,
//                                               color: MyColors.blackThemeColorWithOpacity(0.3),
//                                               fontWeight: FontWeight.w400,),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                     const Column(
//                                       crossAxisAlignment: CrossAxisAlignment.end,
//                                       children: [
//                                         ParagraphText('MP09ZZ9876',
//                                           fontSize: 13,
//                                           fontWeight: FontWeight.w400,),
//                                         ParagraphText('CASH',
//                                           fontSize: 13,
//                                           fontWeight: FontWeight.w400,),
//                                       ],)
//
//                                   ],
//                                 ),
//                               ),
//
//                             ],
//                           ),
//                         ),
//                         vSizedBox,
//                         Align(
//                           alignment: Alignment.centerLeft,
//                           child: RoundEdgedButton(
//                             width: 60,
//                             height: 30,
//                             borderRadius: 7,
//                             onTap: (){
//                               pushAndRemoveUntil(context: context, screen: const RateUsScreen());
//                             },
//                             verticalMargin: 8,
//                             text: "Rate",
//
//                           ),
//                         ),
//                       ],
//                     ),
//                   )),
//         )
//       ],
//     );
//   }
// }
