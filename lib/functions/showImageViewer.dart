import 'package:connect_app_driver/constants/global_keys.dart';
import 'package:connect_app_driver/constants/sized_box.dart';
import 'package:connect_app_driver/functions/showCustomDialog.dart';
import 'package:connect_app_driver/services/custom_navigation_services.dart';
import 'package:connect_app_driver/widget/custom_button.dart';
import 'package:flutter/material.dart';
import '../widget/custom_image.dart';

showImageViewer({
  required String imageUrl,
  required CustomFileType fileType,

})async{
  return showCustomDialog(
    height: 440,
    verticalPadding: 10,
    verticalInsetPadding: 0,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(onTap:(){
              CustomNavigation.pop(MyGlobalKeys.navigatorKey.currentContext!);
            },
              behavior: HitTestBehavior.opaque,child: const Padding(
              padding: EdgeInsets.all(4.0),
              child: Icon(Icons.close),
            ),
            )
          ],
        ),
        vSizedBox05,
        CustomImage(
          imageUrl: imageUrl,
          fileType: fileType,
          height: 300,
          width: double.infinity,
          borderRadius: 8,

        ),
        CustomButton(text: 'Ok', onTap: (){
          CustomNavigation.pop(MyGlobalKeys.navigatorKey.currentContext!);
        },)
      ],
    )
  );
}