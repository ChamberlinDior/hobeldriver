import 'package:connect_app_driver/widget/custom_appbar.dart';
import 'package:connect_app_driver/widget/custom_button.dart';
import 'package:connect_app_driver/widget/custom_image.dart';
import 'package:connect_app_driver/widget/custom_scaffold.dart';
import 'package:flutter/material.dart';

import '../../constants/global_data.dart';
import '../../constants/my_colors.dart';
import '../../constants/my_image_url.dart';
import '../../constants/sized_box.dart';
import '../../widget/custom_rich_text.dart';
import '../../widget/custom_text.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        titleText: 'Notifications',
        actions: [
          TextButton(
          onPressed: (){
            // CustomNavigation.push(context: context, screen: const ReportScreen());
          },
          child:CustomText.bodyText2("Clear All",

            color: MyColors.redColor,
            decoration: TextDecoration.underline,

          ),)],
      ),
      body: Column(
        children: [
          Expanded(
              child:ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: globalHorizontalPadding),
                itemCount: 4,
                itemBuilder: (context, index){
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 10),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                        color: MyColors.whiteColor,
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: Row(
                      children: [
                        if(index.isOdd)
                       const CustomImage(imageUrl: MyImagesUrl.img02,
                       fileType: CustomFileType.asset,
                         height: 50,
                         width: 50,
                       ),
                        hSizedBox,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText.smallText( index.isOdd?'John Smith':'Ride Success',
                              fontWeight: FontWeight.w500,
                              color: MyColors.blackColor,
                              ),
                              if(index.isOdd)
                              CustomText.smallText('70-A Braj Vihar Colony, Indore',
                                color: MyColors.color969696,
                              ),
                              if(index.isEven)
                                CustomRichText(firstText: 'Payment Received ',
                                    firstTextColor: MyColors.color969696,
                                    firstTextFontSize: 13,
                                    secondText: '\$20',
                                  secondTextFontSize: 13,
                                  secondTextColor: MyColors.blackColor,
                                  secondTextFontWeight: FontWeight.w600,
                                )
                            ],
                          ),
                        ),
                        CustomButton(text: index.isOdd? 'View':'Go to wallet',
                        fontSize: 10,
                          isFlexible: true,
                          verticalPadding: 6,
                          horizontalPadding: 14,
                          borderRadius: 8,
                          textColor: MyColors.whiteColor,
                          color: MyColors.blackColor,
                          fontWeight: FontWeight.w600,

                        )
                      ],
                    ),
                  );
                },) )
        ],
      ),
    );
  }
}
