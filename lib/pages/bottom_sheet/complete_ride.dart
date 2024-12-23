import 'package:connect_app_driver/constants/language_en.dart';
import 'package:connect_app_driver/constants/my_colors.dart';
import 'package:connect_app_driver/constants/sized_box.dart';
import 'package:connect_app_driver/provider/live_booking_provider.dart';
import 'package:connect_app_driver/widget/custom_button.dart';
import 'package:connect_app_driver/widget/custom_image.dart';
import 'package:connect_app_driver/widget/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widget/app_specific/custom_stepper.dart';
import '../../widget/custom_rating.dart';

class CompleteRide extends StatelessWidget {
  const CompleteRide({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LiveBookingProvider>(
      builder: (context, liveBooking, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
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
                title: 'Drop At',
                subtitle: liveBooking.incomingBookingRequest!.endDestination,
              ),
            ],
          ),
          vSizedBox2,
          CustomButton(
            height: 50,
            text: 'Complete Ride',
            onTap: () {
              liveBooking.completeRide();
            },
          )
        ],
      ),
    );
  }
}
