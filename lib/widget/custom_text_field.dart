// ignore_for_file: must_be_immutable

import 'package:connect_app_driver/constants/language_en.dart';
import 'package:connect_app_driver/themes/custom_text_styles.dart';
import 'package:connect_app_driver/widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/my_colors.dart';
import '../constants/sized_box.dart';

class CustomTextField extends StatelessWidget {
  final Function()? onTap;
  final TextEditingController controller;
  final double? width;
  final bool isCollapsed;
  final Color? focusedBorderColor;
  final BoxBorder? border;
  final double horizontalPadding;
  final bool obscureText;
  final int? maxLines;
  final int? maxLength;
  final Color? bgColor;
  final Color? fillColor;
  final Color? borderColor;
  final String hintText;
  final TextAlign textAlign;
  final Color? textColor;
  final String? headingText;
  final double? headingFontSize;
  final FontWeight? headingFontWeight;
  final double borderRadius;
  final double? fontSize;
  final double? hintTextFontSize;
  final Color? hintColor;
  final double verticalPadding;
  final double? contentPaddingVertical;
  final double? contentPaddingHorizonatly;
  final double? cursorHeight;
  final String? suffixText;
  final Widget? suffix;
  final Widget? prefix;
  final String? prefixText;
  TextInputType? keyboardType;
  final bool filled;
  final bool enabled;
  final bool readOnly;
  final bool enableInteractiveSelection;
  final bool? autofocus;
  final bool? showShadow;
  final FocusNode? focusNode;
  final TextCapitalization textCapitalization;
  final Function(String)? onChanged;
  final Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;

  final Color? headingColor;
  CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.width,
    this.isCollapsed = false,
    this.border,
    this.inputFormatters,
    this.contentPaddingHorizonatly,
    this.borderColor,
    this.maxLines,
    this.validator,
    this.maxLength,
    this.onSaved,
    this.fontSize,
    this.textColor,
    this.textCapitalization = TextCapitalization.none,
    this.hintTextFontSize,
    this.headingFontSize,
    this.headingText,
    this.headingFontWeight,
    this.cursorHeight,
    this.autofocus = false,
    this.readOnly = false,
    this.prefix,
    this.filled = true,
    this.contentPaddingVertical,
    this.horizontalPadding = 0,
    this.verticalPadding = 0,
    this.obscureText = false,
    this.fillColor,
    this.bgColor,
    this.hintColor,
    this.borderRadius = 15,
    this.keyboardType,
    this.onChanged,
    this.enabled = true,
    this.suffix,
    this.suffixText,
    this.focusedBorderColor,
    this.prefixText,
    this.focusNode,
    this.enableInteractiveSelection = true,
    this.onTap,
    this.textAlign = TextAlign.left,
    this.showShadow = false,
    this.headingColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isCollapsed ? null : width ?? MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: bgColor,
        border: border,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding, vertical: verticalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (headingText != null)
            CustomText.textFieldHeading(
              headingText!,
              color: headingColor ?? MyColors.secondaryColor,
              fontSize: headingFontSize,
              fontWeight: headingFontWeight,
            ),
          if (headingText != null) vSizedBox05,
          Stack(
            alignment: Alignment.topCenter,
            children: [
              if (showShadow!)
                Container(
                  height: 50,
                  width: isCollapsed
                      ? null
                      : width ?? MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding, vertical: verticalPadding),
                  decoration: BoxDecoration(
                      color: bgColor,
                      border: border,
                      borderRadius: BorderRadius.circular(borderRadius),
                      boxShadow: [
                        BoxShadow(
                            color: MyColors.blackColor.withOpacity(0.18),
                            blurRadius: 1.2,
                            spreadRadius: 0)
                      ]),
                ),
              GestureDetector(
                onTap: onTap,
                child: TextFormField(
                  cursorHeight: cursorHeight,
                  onChanged: onChanged,
                  onSaved: onSaved,
                  onTap: onTap,
                  autofocus: autofocus!,
                  validator: validator,
                  cursorColor: textColor == MyColors.blackColor
                      ? MyColors.blackColor
                      : MyColors.whiteColor,
                  readOnly: readOnly,
                  maxLength: maxLength,
                  focusNode: focusNode,
                  textAlign: textAlign,
                  controller: controller,
                  obscureText: obscureText,
                  // keyboardAppearance: KeyboardA,
                  textCapitalization: textCapitalization,
                  keyboardType: keyboardType,
                  maxLines: maxLines ?? 1,
                  // dragStartBehavior: DragStartBehavior.down,
                  style: CustomTextStyle.textFieldText.copyWith(
                      color: enabled ? textColor : hintColor,
                      height: cursorHeight != null ? 0.9 : null,
                      fontSize: fontSize),

                  textAlignVertical: TextAlignVertical.center,
                  textInputAction: TextInputAction.done,
                  inputFormatters: inputFormatters,
                  enabled: enabled,
                  decoration: InputDecoration(
                    enabled: enabled,
                    isDense: true,
                    counterText: '',
                    alignLabelWithHint: true,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    filled: filled,
                    fillColor: fillColor ?? MyColors.fillColor,
                    suffixIcon: suffix,
                    prefixIcon: prefix,
                    hintText: translate(hintText),
                    suffixText: translate(suffixText ?? ''),
                    prefixText: translate(prefixText ?? ''),
                    suffixStyle: const TextStyle(fontSize: 16),
                    prefixStyle: const TextStyle(
                      fontSize: 16,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: contentPaddingVertical ?? 15,
                      horizontal: contentPaddingHorizonatly ?? 22,
                    ),
                    hintStyle: CustomTextStyle.textFieldHint.copyWith(
                      color: hintColor,
                      fontSize: hintTextFontSize,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: borderColor ??
                              MyColors.enabledTextFieldBorderColor),
                      borderRadius: BorderRadius.circular(
                          borderRadius), // Set the border radius here
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: borderColor ??
                              MyColors.enabledTextFieldBorderColor),
                      borderRadius: BorderRadius.circular(
                          borderRadius), // Set the border radius here
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: borderColor ??
                              MyColors.disabledTextFieldBorderColor),
                      borderRadius: BorderRadius.circular(
                          borderRadius), // Set the border radius here
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: focusedBorderColor ?? Colors.blue,
                      ),
                      borderRadius: BorderRadius.circular(
                          borderRadius), // Set the border radius here
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: focusedBorderColor ?? Colors.blue),
                      borderRadius: BorderRadius.circular(
                          borderRadius), // Set the border radius here
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
