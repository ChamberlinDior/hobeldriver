// import 'package:flutter/material.dart';
// import 'package:connect_app_driver/services/api_urls.dart';
// import '../constants/my_colors.dart';
// import '../constants/my_image_url.dart';
// import '../constants/sized_box.dart';
// import 'custom_circular_image.dart';
// import 'old_custom_text.dart';
// import 'custom_button.dart';
//
// class SelectCategoryCard extends StatelessWidget {
//   final String? image;
//   final String? rating;
//   // final int ratingCount;
//   final String? subText;
//   final String titleText;
//   final double? titleFont;
//   final FontWeight? titleWeight;
//   final String? price;
//   final int? index;
//   final int? selectedIndex;
//   final Function() onTap;
//   const SelectCategoryCard(
//       {Key? key,
//         required this.image,
//         required this.onTap,
//         required this.titleText,
//          this.titleWeight,
//          // required this.ratingCount,
//          this.titleFont,
//          this.rating,
//          this.subText,
//          this.price,
//          this.selectedIndex,
//          this.index=-1})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return  GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 4),
//     decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(15),
//             color: selectedIndex == index
//                 ? MyColors.primaryColor.withOpacity(0.1)
//                 : MyColors.whiteColor,
//             border: Border.all(
//                 color: selectedIndex == index
//                     ? MyColors.primaryColor
//                     : MyColors.enabledTextFieldBorderColor)),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             if(rating!=null)
//             Row(mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Image.asset( MyImagesUrl.star,width: 12,),
//                 hSizedBox05,
//                  ParagraphText(
//                   '${rating!} (828k)',
//                   fontSize: 10,
//                   color: MyColors.blackColor,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ],
//             ),
//              CustomCircularImage(
//               fileType:image==null?CustomFileType.asset: CustomFileType.network,
//               imageUrl:image==null?MyImagesUrl.cleanerImg:ApiUrls.baseImageUrl+ image!,
//               width: 52,
//               height: 52,
//               borderRadius: 100,
//             ),
//              ParagraphText(
//               titleText,
//               maxLines: 2,
//               fontSize: titleFont??15,
//               textAlign: TextAlign.center,
//               color: MyColors.blackColor,
//               fontWeight:titleWeight?? FontWeight.w700,
//             ),
//             if(subText!=null)
//              ParagraphText(
//               subText!,
//               fontSize: 12,
//               textAlign: TextAlign.center,
//               color: MyColors.blackColor,
//               fontWeight: FontWeight.w400,
//             ),
//             if(price!=null)
//             Row(mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 RoundEdgedButton(
//                   height: 20,
//                   width: 60,
//                   text: "\$$price ",
//                   onTap: () {},
//                   verticalMargin: 0,
//                   verticalPadding: 0,
//                   horizontlyPadding: 0,
//                   fontSize: 12,
//                   fontWeight: FontWeight.w400,
//                   color: MyColors.primaryColor,
//                 ),
//                 hSizedBox05,
//                 RoundEdgedButton(
//                   height: 20,
//                   width: 50,
//                   text: "Book",
//                   onTap: () {},
//                   verticalMargin: 0,
//                   verticalPadding: 0,
//                   horizontlyPadding: 0,
//                   fontSize: 10,
//                   fontWeight: FontWeight.w600,
//                   color: MyColors.primaryColor,
//                 )
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//
//
//   }
// }