
import 'package:flutter/material.dart';

import '../constants/app_font.dart';
import '../constants/my_colors.dart';

class CustomAppThemes{

 static ThemeData darkTheme = ThemeData(
     brightness: Brightness.dark,

     bottomSheetTheme: const BottomSheetThemeData(
         backgroundColor: MyColors.blackColor
     ),
     scaffoldBackgroundColor: MyColors.blackColor,
     fontFamily: Fonts.defaultFont);
 static ThemeData lightTheme = ThemeData(
     brightness: Brightness.light,
     bottomSheetTheme: const BottomSheetThemeData(
         backgroundColor: MyColors.whiteColor
     ),
     scaffoldBackgroundColor: MyColors.blackColor,
     fontFamily: Fonts.defaultFont);
}