import 'package:connect_app_driver/widget/custom_appbar.dart';
import 'package:connect_app_driver/widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:connect_app_driver/constants/global_data.dart';
import 'package:provider/provider.dart';
import '../../constants/my_colors.dart';
import '../../constants/my_image_url.dart';
import '../../constants/sized_box.dart';
import '../../provider/bottom_sheet_provider.dart';
import '../../services/custom_navigation_services.dart';
import '../../widget/app_specific/custom_stepper.dart';
import '../../widget/app_specific/dotted_border_container.dart';
import '../../widget/custom_rich_text.dart';
import '../../widget/custom_scaffold.dart';
import '../../widget/custom_button.dart';

class RideSuccessScreen extends StatefulWidget {
  const RideSuccessScreen({super.key});

  @override
  State<RideSuccessScreen> createState() => _RideSuccessScreenState();
}

class _RideSuccessScreenState extends State<RideSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: MyColors.blackColor.withOpacity(0.9),
      appBar: CustomAppBar(
        onPressed: () {
          var provider =
              Provider.of<BottomSheetProvider>(context, listen: false);
          provider.removePageUntil();
          CustomNavigation.popUntil(context, (route) => route.isFirst);
          // CustomNavigation.pop(context);
        },
        titleText: 'Back',
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: globalHorizontalPadding),
            child: Column(
              children: [
                Image.asset(
                  MyImagesUrl.rideSuccess,
                  width: MediaQuery.of(context).size.width / 1.9,
                ),
                vSizedBox3,
                CustomText.heading(
                  'Success Your Ride',
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
                vSizedBox05,
                CustomText.bodyText1(
                  'We hope you will enjoy your ride',
                  fontSize: 15,
                ),
                vSizedBox3,
                CustomText.bodyText2(
                  'ONLINE PAYMENT RECEIVED',
                ),
                vSizedBox,
                CustomRichText(
                  firstText: '\$25.00',
                  firstTextFontSize: 35,
                  firstTextColor: MyColors.whiteColor,
                  firstTextFontWeight: FontWeight.w400,
                  secondText: 'FCFA',
                  secondTextColor: MyColors.whiteColor,
                  secondTextFontSize: 20,
                  secondTextFontWeight: FontWeight.w400,
                ),
                vSizedBox3,
                // CustomPaint(
                //   painter: DottedBorderPainter(
                //     color: MyColors.whiteColor,
                //   ),
                //   child: Container(
                //   padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 15),
                //   decoration: BoxDecoration(
                //       color: MyColors.blackColor,
                //       borderRadius: BorderRadius.circular(15)
                //   ),
                //   child: Column(
                //     children: [1,2,3].map((step) {
                //       int index = [1,2,3].indexOf(step);
                //       return StepItem(
                //         step: StepData(
                //           title: '4min (1.6mi) away',
                //           subtitle: '70-A Braj Vihar Colony, Indore',
                //           isCurrent: true,
                //         ),
                //         isLast: index == [1,2,3].length - 1,
                //       );
                //     }).toList(),
                //   ),
                // )),
                CustomPaint(
                  painter: DottedBorderPainter(
                      color: MyColors.whiteColor, strokeWidth: 2, radius: 15),
                  child: Container(
                    margin: EdgeInsets.all(1),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                        color: MyColors.blackColor,
                        borderRadius: BorderRadius.circular(15)),
                    child: CustomStepper(
                      steps: [
                        StepData(
                          title: '4min (1.6mi) away',
                          subtitle: '70-A Braj Vihar Colony, Indore',
                          isCurrent: true,
                        ),
                        StepData(
                          title: '13min (10mi) trip',
                          subtitle: '315, Pukhraj Corporate, Inore',
                        ),
                      ],
                    ),
                  ),
                ),
                vSizedBox,
                CustomButton(
                  onTap: () {
                    // CustomNavigation.push(context: context, screen: const RateUsScreen());
                  },
                  height: 50,
                  verticalMargin: 20,
                  text: "Rate Customer",
                ),
                // TextButton(
                //   onPressed: () {
                //     CustomNavigation.push(
                //         context: context, screen: const ReportScreen());
                //   },
                //   child: CustomText.bodyText1(
                //     "Report",
                //     color: MyColors.whiteColor,
                //     decoration: TextDecoration.underline,
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
