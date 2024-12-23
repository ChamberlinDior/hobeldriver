import 'package:connect_app_driver/functions/common_function.dart';
import 'package:connect_app_driver/provider/new_firebase_auth_provider.dart';
import 'package:connect_app_driver/widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:connect_app_driver/widget/custom_button.dart';
import 'package:flutter/services.dart';
import '../constants/global_data.dart';
import '../constants/my_colors.dart';
import '../constants/my_image_url.dart';
import '../constants/sized_box.dart';
import '../provider/auth_provider.dart';
import 'old_custom_text.dart';
import 'package:provider/provider.dart';
// ignore: must_be_immutable
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  Color? bgColor;
  Color? titleColor;
  String? titleText;
  Widget? title;
  Widget? leading;
  double? toolbarHeight;
  Widget? subTitleWidget;
  double? titleFontSize;
  bool centerTitle;
  bool isBackIcon;
  bool isNotificationIcon;
  bool bottomCurve;
  bool showBottomBorder;
  String? leadingIcon;
  FontWeight? titleFontWeight;
  double? leadingWidth;
  PreferredSizeWidget? bottom;
  Function()? onPressed;
  List<Widget>? actions;

  CustomAppBar({
    super.key,
    this.bgColor,
    this.titleColor,
    this.titleText,
    this.actions,
    this.bottom,
    this.title,
    this.titleFontWeight,
    this.onPressed,
    this.leadingWidth=globalHorizontalPadding,
    this.titleFontSize,
    this.subTitleWidget,
    this.showBottomBorder = true,
    this.centerTitle = false,
    this.bottomCurve = false,
    this.isBackIcon = true,
    this.isNotificationIcon = false,
    this.toolbarHeight = 65.0,
    this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      toolbarHeight: toolbarHeight,
      title: title ??
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: centerTitle
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText.appbarText(
                titleText ?? '',
                fontSize: titleFontSize,
                color: titleColor,
                fontWeight: titleFontWeight,
              ),
              subTitleWidget != null ? vSizedBox02 : Container(),
              subTitleWidget ?? Container()
            ],
          ),
      backgroundColor: bgColor ?? MyColors.transparent,
      centerTitle: centerTitle,
      automaticallyImplyLeading: isBackIcon,
      titleSpacing: 0,
      leadingWidth: (isBackIcon&&Navigator.canPop(context)) ? 50 : leadingWidth,
      leading: (isBackIcon&&Navigator.canPop(context))
          ? IconButton(
              onPressed: onPressed ??
                  () {
                    unFocusKeyBoard();
                    Navigator.pop(context);
                  },
              icon: Icon(Icons.arrow_back_ios_new,size: 20,color:titleColor?? MyColors.whiteColor,)
            )
          : leading ?? Container(),
      actions: actions ??
          [
            if (isNotificationIcon)
              Consumer<FirebaseAuthProvider>(
                  builder: (context, ap, child) {
                    return GestureDetector(
                      onTap: () async {
                        // push(context: context, screen: const NotificationScreen());
                      },
                      child: Stack(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 6, top: 10, left: 6),
                            child: ImageIcon(
                              AssetImage(MyImagesUrl.logout),
                              size: 22,
                            ),
                          ),
                          if(userData!.unreadNotificationsCount!=0)
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                height: 16,
                                width: 16,
                                decoration:BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.red
                                ),
                                child: Center(
                                  child: ParagraphText('${userData!.unreadNotificationsCount}', textAlign: TextAlign.center,color: Colors.white,fontSize: 7,),
                                ),
                              ),
                            )
                        ],
                      ),
                    );
                  }
              ),
              // GestureDetector(
              //   onTap: () async {
              //     push(context: context, screen: const NotificationScreen());
              //   },
              //   child: Image.asset(
              //     MyImagesUrl.notification,
              //     width: 25,
              //     color: Colors.black,
              //   ),
              // ),
            // if (isEdit)
            //   GestureDetector(
            //     onTap: () async {
            //       push(context: context, screen: const NotificationScreen());
            //     },
            //     child: Image.asset(
            //       MyImagesUrl.edit,
            //       width: 20,
            //     ),
            //   ),
            hSizedBox2,
          ],
      bottom: bottom,
      shape: bottomCurve
          ? const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      )
          : null,
      // systemOverlayStyle: ,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight!);
}
