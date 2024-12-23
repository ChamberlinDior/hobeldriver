import 'package:connect_app_driver/constants/language_en.dart';
import 'package:connect_app_driver/constants/my_colors.dart';
import 'package:connect_app_driver/constants/sized_box.dart';
import 'package:connect_app_driver/functions/calculateDistanceBetweenTwoPoints.dart';
import 'package:connect_app_driver/functions/custom_number_formatters.dart';
import 'package:connect_app_driver/functions/custom_time_functions.dart';
import 'package:connect_app_driver/provider/live_booking_provider.dart';
import 'package:connect_app_driver/widget/custom_button.dart';
import 'package:connect_app_driver/widget/custom_image.dart';
import 'package:connect_app_driver/widget/custom_rich_text.dart';
import 'package:connect_app_driver/widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widget/app_specific/custom_stepper.dart';
import '../../widget/custom_rating.dart';

class PaymentSummaryScreen extends StatelessWidget {
  const PaymentSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LiveBookingProvider>(
      builder: (context, liveBooking, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Center(
            child: CustomText.heading(
              "Payment Summary",
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomRichText(
                  firstText: calculateTotalDistanceFromList(
                          latLngList:
                              liveBooking.incomingBookingRequest!.coveredPath,
                          returnInMeter: false)
                      .toStringAsFixed(2),
                  firstTextFontSize: 16,
                  firstTextFontWeight: FontWeight.w500,
                  secondText: " Km"),
              hSizedBox05,
              CustomText.headingSmall(
                "\u2022",
                textAlign: TextAlign.end,
              ),
              hSizedBox05,
              CustomRichText(
                  firstText: CustomTimeFunctions.getDetailedDifference(
                    liveBooking.incomingBookingRequest!.rideStatedTime!
                        .toDate(),
                    liveBooking.incomingBookingRequest!.rideCompletedTime!
                        .toDate(),
                  ),
                  firstTextFontSize: 16,
                  firstTextFontWeight: FontWeight.w500,
                  secondText: " min"),
            ],
          ),
          vSizedBox05,
          Align(
            alignment: AlignmentDirectional.topEnd,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Divider(),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: CustomText.heading(
                        "Total customer need to pay:",
                        fontSize: 16,
                        color: MyColors.redColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Expanded(
                      child: CustomText.heading(
                        '${CustomNumberFormatters.formatNumberInCommasEnWithCurrencyWithoutDecimals(liveBooking.incomingBookingRequest!.totalBookingAmount)}  ',
                        fontSize: 16,
                        color: MyColors.redColor,
                        fontWeight: FontWeight.w700,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
                // const Divider(),
                // Row(
                //   children: [
                //     Expanded(
                //       flex: 2,
                //       child: CustomText.heading(
                //         "Admin Commission (${liveBooking.incomingBookingRequest!.commissionPercent}%):",
                //         fontSize: 15,
                //       ),
                //     ),
                //     Expanded(
                //       child: CustomText.heading(
                //         '-${CustomNumberFormatters.formatNumberInCommasEnWithCurrencyWithoutDecimals(liveBooking.incomingBookingRequest!.commissionPrice)} ',
                //         fontSize: 15,
                //         fontWeight: FontWeight.w700,
                //         textAlign: TextAlign.right,
                //       ),
                //     ),
                //   ],
                // ),
                const Divider(),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: CustomText.heading(
                        "Your Earning:",
                        fontSize: 15,
                        color: MyColors.greenColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Expanded(
                      child: CustomText.heading(
                        '${CustomNumberFormatters.formatNumberInCommasEnWithCurrencyWithoutDecimals(liveBooking.incomingBookingRequest!.driverEarning)} ',
                        fontSize: 15,
                        color: MyColors.greenColor,
                        fontWeight: FontWeight.w700,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
                const Divider(),
              ],
            ),
          ),
          vSizedBox,
          Row(
            children: [
              CustomImage(
                imageUrl: liveBooking.customerDetail!.profileImage!,
                height: 50,
                width: 50,
                borderRadius: 30,
              ),
              hSizedBox,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText.bodyText2(
                    liveBooking.customerDetail!.fullName,
                    fontWeight: FontWeight.w500,
                  ),
                  Row(
                    children: [
                      CustomRating(
                        rating: liveBooking.customerDetail!.averageRating,
                      ),
                      hSizedBox02,
                      CustomText.smallText(
                        ' ${liveBooking.customerDetail!.averageRating} (${liveBooking.customerDetail!.totalReviewCount} ${translate("Reviews")})',
                        fontSize: 10,
                        color: MyColors.color969696,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Divider(
            color: MyColors.dividerColor,
            height: 40,
          ),
          CustomStepper(
            steps: [
              StepData(
                title: "Picked Up From",
                subtitle: liveBooking.incomingBookingRequest!.startDestination,
                isCurrent: true,
              ),
              StepData(
                title: 'Destination',
                subtitle: liveBooking.incomingBookingRequest!.endDestination,
              ),
            ],
          ),
          vSizedBox2,
          CustomButton(
            height: 50,
            text: 'Cash Received',
            onTap: () {
              liveBooking.cashRecived();
            },
          ),
        ],
      ),
    );
  }
}
