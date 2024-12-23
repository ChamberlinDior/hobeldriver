// import 'package:flutter/material.dart';
// import 'package:connect_app_driver/widget/custom_button.dart';
//
// import '../constants/global_keys.dart';
// import '../constants/my_colors.dart';
// import '../constants/sized_box.dart';
// import 'old_custom_text.dart';
//
//
// Future<bool?>  showCustomConfirmationDialog(
//     {
//       required String headingMessage,
//       String? description,
//
//     }
//     )async{
//   return await showDialog(
//       context: MyGlobalKeys.navigatorKey.currentContext!,
//       builder: (context) {
//         return Dialog(
//           insetPadding: EdgeInsets.symmetric(horizontal: 24),
//           child: Container(
//             padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SubHeadingText(
//                   headingMessage,
//                   color: Colors.red,
//                   fontSize: 22,
//                 ),
//                 vSizedBox,
//                 if(description!=null)
//                   ParagraphText( description),
//                 if(description!=null)
//                   vSizedBox2,
//                 vSizedBox2,
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     CustomButton(
//                       text: 'No',
//                       verticalPadding: 0,
//                       // horizontalPadding: 0,
//                       height: 36,
//                       width: 100,
//                       color: MyColors.primaryColor,
//                       isSolid: false,
//                       onTap: () {
//                         Navigator.pop(MyGlobalKeys.navigatorKey.currentContext!);
//                       },
//                     ),
//                     hSizedBox2,
//                     CustomButton(
//                       text: 'Yes',
//                       verticalPadding: 0,
//                       height: 36,
//                       width: 100,
//                       color: MyColors.primaryColor,
//                       onTap: () {
//                         Navigator.pop(MyGlobalKeys.navigatorKey.currentContext!, true);
//                       },
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           ),
//         );
//       });
// }


import 'package:flutter/material.dart';
import '../constants/global_keys.dart';
import '../constants/sized_box.dart';
import 'custom_button.dart';
import 'custom_text.dart';

Future<bool?> showCustomConfirmationDialog({
  String? headingMessage,
  String? description,
  String okButtonText = 'Yes',
  String cancelButtonText = 'Cancel',
  String? headingImage,
  IconData? headingIcon,
  Color? headingImageColor,
  double? imageHeight,
  // BuildContext? context
}) async {
  return await showDialog(
      context: MyGlobalKeys.navigatorKey.currentContext!,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(
            horizontal: 36,
          ),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // vSizedBox,
                // Text('dfgsdfg'),
                if (headingImage != null)
                  Image.asset(
                    headingImage,
                    fit: BoxFit.cover,
                    color: headingImageColor,
                    height: imageHeight ?? 70,
                  ),
                if (headingIcon != null)
                  Icon(
                    headingIcon,
                    color: headingImageColor,
                    size: imageHeight ?? 70,
                  ),
                if (headingImage != null) vSizedBox2,
                if (headingMessage != '')
                  CustomText.heading(
                    headingMessage ?? 'Are you sure?',
                    // color: Colors.white,
                    fontSize: 20,
                  ),
                vSizedBox,
                if (description != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child:  CustomText.bodyText1(
                      description,
                      textAlign: TextAlign.center,
                      fontSize: 18,
                    ),
                  ),
                if (description != null) vSizedBox,
                vSizedBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // RoundEdgedButton(
                    //   text:cancelButtonText,
                    //   verticalPadding: 0,
                    //   height: 36,
                    //   width: 100,
                    //   isSolid: false,
                    //   color: MyColors.primaryColor,
                    //   onTap: () {
                    //     Navigator.pop(context);
                    //   },
                    // ),
                    CustomButton(text: cancelButtonText,isSolid: false,width: 100,onTap: (){
                      Navigator.pop(context, false);
                    },),

                    // InkWell(
                    //   onTap: () {
                    //     Navigator.pop(context, false);
                    //   },
                    //   child: CustomText.buttonText(
                    //     cancelButtonText,
                    //     // color: Colors.black54,
                    //     // fontSize: 18,
                    //   ),
                    // ),
                    hSizedBox,
                    CustomButton(
                      text: okButtonText,
                      // verticalPadding: 0,
                      width: 100,
                      // isFlexible: true,
                      // height: 36,
                      // width: 100,
                      verticalMargin: 0,
                      onTap: () {
                        Navigator.pop(context, true);
                      },
                    ),
                    // RoundEdgedButton(
                    //   text: 'Yes',
                    //   verticalPadding: 0,
                    //   height: 36,
                    //   width: 100,
                    //   isSolid: false,
                    //   color: Colors.red,
                    //   onTap: () {
                    //     Navigator.pop(MyGlobalKeys.navigatorKey.currentContext!, true);
                    //   },
                    // ),
                  ],
                ),
                // vSizedBox
              ],
            ),
          ),
        );
      });
}
