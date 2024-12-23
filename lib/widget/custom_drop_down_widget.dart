// import 'package:connect_app_driver/constants/global_data.dart';
// import 'package:flutter/material.dart';
// import '../constants/my_colors.dart';
// import '../constants/sized_box.dart';
// import 'old_custom_text.dart';
//
// class CustomDropDownField extends StatelessWidget {
//   final List itemsList;
//   final Color? hintColor;
//   final Color? headingTextColor;
//   final Color? borderColor;
//   final String hintText;
//   final bool enableShadow;
//   final bool isDense;
//   final bool textFieldUnderline;
//   final String? headingText;
//   final Map<String, dynamic>? selectedValue;
//   final double? headingFontSize;
//   final double borderRadius;
//   final double? boxHeight;
//   final double? horizontalPadding;
//   final double? verticalPadding;
//   final double? contentVerticalPadding;
//   final double? contentHorizontalPadding;
//   final Icon? icons;
//   final Widget? prefix;
//   final Widget? suffix;
//   final String popUpTextKey;
//   final String? Function(dynamic)? validator;
//   final Function(dynamic)? onChanged;
//
//  final  FontWeight? headingTextFontWeight;
//
//   const CustomDropDownField({
//     super.key,
//     required this.itemsList,
//     this.headingFontSize = 18,
//     this.enableShadow = false,
//     this.isDense = false,
//     this.textFieldUnderline = false,
//     this.borderRadius = 30,
//     this.borderColor,
//     this.icons,
//     this.boxHeight,
//     this.verticalPadding,
//     this.horizontalPadding,
//     this.contentVerticalPadding,
//     this.contentHorizontalPadding,
//     this.headingText,
//     required this.popUpTextKey,
//     this.hintColor,
//     this.prefix,
//     this.suffix,
//     this.headingTextColor = MyColors.secondaryColor,
//     this.selectedValue,
//     this.onChanged,
//     this.validator,
//     required this.hintText, this.headingTextFontWeight,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: horizontalPadding ?? 2),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.center,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           if (headingText != null)
//             SubHeadingText(
//               headingText!,
//               fontSize: headingFontSize,
//               color: headingTextColor,
//               fontWeight: headingTextFontWeight,
//             ),
//           if (headingText != null) vSizedBox05,
//           Stack(
//             alignment: Alignment.topCenter,
//             children: [
//               if (enableShadow)
//                 Container(
//                   height: 50,
//                   width: MediaQuery.of(context).size.width,
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(borderRadius),
//                       boxShadow: [
//                         BoxShadow(
//                             color: MyColors.blackColor.withOpacity(0.18),
//                             blurRadius: 2,
//                             spreadRadius: 0.6)
//                       ]),
//                 ),
//               DropdownButtonFormField(
//                 onChanged: onChanged,
//                 validator: validator,
//                 value: selectedValue,
//                 autovalidateMode: AutovalidateMode.onUserInteraction,
//                 alignment: Alignment.bottomCenter,
//                 isDense: true,
//                 decoration: InputDecoration(
//                   prefixIcon: prefix,
//                   alignLabelWithHint: true,
//                   isDense: isDense,
//                   suffixIcon: suffix,
//                   contentPadding: EdgeInsets.symmetric(
//                       horizontal: contentHorizontalPadding ?? 18,
//                       vertical: contentVerticalPadding ?? 18),
//                   hintText: hintText,
//                   hintStyle: TextStyle(
//                       color: MyColors.blackColor50,
//                       fontSize: 15,
//                       fontWeight: FontWeight.w500,
//                       fontFamily: fontFamily),
//                   // labelStyle: TextStyle(color: hintColor ?? MyColors.blackColor50, fontSize: 14,),
//                   border: OutlineInputBorder(
//                     borderSide:
//                         BorderSide(color: MyColors.enabledTextFieldBorderColor),
//                     borderRadius: BorderRadius.circular(
//                         borderRadius), // Set the border radius here
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                         color: borderColor ??
//                             MyColors.enabledTextFieldBorderColor),
//                     borderRadius: BorderRadius.circular(
//                         borderRadius), // Set the border radius here
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide:
//                         BorderSide(color: borderColor ?? Colors.blue, width: 2),
//                     borderRadius: BorderRadius.circular(
//                         borderRadius), // Set the border radius here
//                   ),
//                   focusedErrorBorder: OutlineInputBorder(
//                     borderSide:
//                         BorderSide(color: borderColor ?? MyColors.redColor),
//                     borderRadius: BorderRadius.circular(
//                         borderRadius), // Set the border radius here
//                   ),
//                   filled: true,
//                   fillColor: MyColors.whiteColor,
//                 ),
//                 isExpanded: true,
//                 dropdownColor: Colors.white,
//
//                 icon: icons ??
//                     Icon(
//                       Icons.keyboard_arrow_down,
//                       color: MyColors.blackColor50,
//                       size: 20,
//                     ),
//                 items: itemsList.map((value) {
//                   return DropdownMenuItem(
//                     value: value,
//                     child: Text(
//                       // '${value}',
//                       value[popUpTextKey],
//                       style: TextStyle(
//                           color: MyColors.lightdark,
//                           fontSize: 16,
//                           fontFamily: fontFamily),
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
