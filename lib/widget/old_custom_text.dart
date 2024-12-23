import 'package:flutter/material.dart';

import '../constants/my_colors.dart';


class MainHeadingText extends StatelessWidget {
  final String text;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final TextAlign? textAlign;
  final double? height;
  final TextDecoration? decoration;

  const MainHeadingText(this.text,
      {Key? key,
      this.color,
      this.fontSize,
      this.fontWeight,
      this.fontFamily,
      this.textAlign,
      this.height, this.decoration})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
          color: color??MyColors.blackColor,
          fontWeight: fontWeight ?? FontWeight.w600,
          fontSize: fontSize ?? 40,
          // letterSpacing: 1,
          // wordSpacing: 1,
          // fontFamily:
          decoration: decoration,
          decorationColor: color,
          fontFamily: fontFamily??'Poppins-Regular',
          height: height??1.2),
    );
  }
}

class AppBarHeadingText extends StatelessWidget {
  final String text;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final TextAlign? textAlign;
  const AppBarHeadingText({
    Key? key,
    required this.text,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.fontFamily,
    this.textAlign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
          overflow: TextOverflow.ellipsis,
          color: color ?? MyColors.whiteColor,
          fontWeight: fontWeight ?? FontWeight.w400,
          fontSize: fontSize ?? 22,
          // fontFamily:
          fontFamily: fontFamily),
    );
  }
}

class SubHeadingText extends StatelessWidget {
  final String text;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final TextAlign textAlign;
  final bool underlined;
  final TextOverflow? overflow;
  const SubHeadingText(
    this.text, {
    Key? key,
    this.color=MyColors.blackColor,
    this.fontSize,
    this.fontWeight,
    this.fontFamily,
        this.overflow,
    this.textAlign = TextAlign.start,
    this.underlined = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        color: color,
        fontWeight: fontWeight ?? FontWeight.w400,
        fontSize: fontSize ?? 20,
        overflow: overflow,
        fontFamily: fontFamily,
        decoration: underlined ? TextDecoration.underline : null,
        decorationColor: color
      ),
    );
  }
}

class ParagraphText extends StatelessWidget {
  final String text;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final TextAlign? textAlign;
  final bool underlined;
  final double? lineHeight;
  final FontStyle? fontStyle;
  final int? maxLines;
  const ParagraphText(this.text,
      {Key? key,
      this.color,
      this.fontSize,
      this.fontWeight,
      this.fontFamily,
      this.textAlign,
        this.maxLines,
      this.underlined = false,
      this.lineHeight= 1.2,
      this.fontStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      textAlign: textAlign ?? TextAlign.start,
      style: TextStyle(
          color: color??MyColors.blackColor,
          fontWeight: fontWeight ?? FontWeight.w500,
          fontSize: fontSize ?? 15,
          height: lineHeight,
          fontFamily: fontFamily??"Poppins-Regular",
          fontStyle: fontStyle,

          // letterSpacing:0.4,
          // letterSpacing: 1,
          // wordSpacing: 1,
          decoration: underlined ? TextDecoration.underline : null,
          decorationColor: underlined ? color : null),
    );
  }
}
