import 'package:flutter/material.dart';

import '../constants/my_colors.dart';
import 'custom_gesture_detector.dart';
import 'old_custom_text.dart';

class TabHeadingContainer extends StatelessWidget {
  final bool active;
  final Function() onTap;
  final String text;
  const TabHeadingContainer({required this.active, required this.text, required this.onTap,super.key});

  @override
  Widget build(BuildContext context) {
    return CustomGestureDetector(
      onTap: onTap,
      borderRadiusDouble: 20,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 6,vertical: 5),
        padding: const EdgeInsets.symmetric(
            horizontal: 14, vertical: 9,),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: active
                ? MyColors.primaryColor
                : MyColors.greyColor),
        child: MainHeadingText(
         text,
          fontSize: 13,
          color:active
              ? MyColors.whiteColor
              : MyColors.blackColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
