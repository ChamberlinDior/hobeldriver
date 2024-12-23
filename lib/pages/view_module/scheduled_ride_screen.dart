// ignore_for_file: use_build_context_synchronously

import 'package:connect_app_driver/constants/global_data.dart';
import 'package:connect_app_driver/constants/language_en.dart';
import 'package:connect_app_driver/constants/my_colors.dart';
import 'package:connect_app_driver/constants/my_image_url.dart';
import 'package:connect_app_driver/constants/sized_box.dart';
import 'package:connect_app_driver/constants/types/ride_type_status.dart';
import 'package:connect_app_driver/functions/custom_number_formatters.dart';
import 'package:connect_app_driver/functions/custom_time_functions.dart';
import 'package:connect_app_driver/pages/bottom_sheet/waiting_for_driver_screen.dart';
import 'package:connect_app_driver/pages/view_module/booking_detail_screen.dart';
import 'package:connect_app_driver/provider/booking_history_provider.dart';
import 'package:connect_app_driver/widget/custom_button.dart';
import 'package:connect_app_driver/widget/custom_image.dart';
import 'package:connect_app_driver/widget/custom_paginated_list_view.dart';
import 'package:connect_app_driver/widget/custom_scaffold.dart';
import 'package:connect_app_driver/widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/types/booking_status.dart';
import '../../services/custom_navigation_services.dart';
import '../../widget/app_specific/custom_stepper.dart';
import '../../widget/custom_appbar.dart';
import '../../widget/custom_rating.dart';
import '../../widget/custom_rich_text.dart';

class ScheduledRideScreen extends StatefulWidget {
  const ScheduledRideScreen({super.key});

  @override
  State<ScheduledRideScreen> createState() => _ScheduledRideScreenState();
}

class _ScheduledRideScreenState extends State<ScheduledRideScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        isBackIcon: true,
        titleText: 'Scheduled Ride',
      ),
      body: Column(
        children: [
          Consumer<BookingHistoryProvider>(
            builder: (context, bookingHistory, child) => Expanded(
              child: CustomPaginatedListView(
                padding: const EdgeInsets.symmetric(
                    horizontal: globalHorizontalPadding),
                itemCount: bookingHistory.scheduleBookingList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      CustomNavigation.push(
                          context: context,
                          screen: BookingDetails(
                              booking:
                                  bookingHistory.scheduleBookingList[index]));
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                          color: MyColors.whiteColor,
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: CustomText.smallText(
                                  '${translate("Booking ID:")}#${bookingHistory.scheduleBookingList[index].bookingRefrenceId}',
                                  color: MyColors.blackColor,
                                  fontSize: 11,
                                ),
                              ),
                              CustomButton(
                                text: BookingStatus.getName(bookingHistory
                                    .scheduleBookingList[index].bookingStatus),
                                horizontalPadding: 8,
                                verticalPadding: 2,
                                verticalMargin: 0,
                                isFlexible: true,
                                fontSize: 12,
                                color: BookingStatus.getColor(bookingHistory
                                    .scheduleBookingList[index].bookingStatus),
                              )
                            ],
                          ),
                          vSizedBox,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        MyImagesUrl.calender,
                                        width: 23,
                                        color: MyColors.blackColor,
                                      ),
                                      hSizedBox05,
                                      hSizedBox02,
                                      CustomRichText(
                                        firstText: 'Scheduled on :-',
                                        firstTextFontSize: 12,
                                        firstTextFontWeight: FontWeight.w700,
                                        firstTextColor: MyColors.blackColor,
                                        secondText: CustomTimeFunctions
                                            .formatDayDateMonthAndYear(
                                                bookingHistory
                                                    .scheduleBookingList[index]
                                                    .scheduledTime
                                                    .toDate()),
                                        secondTextFontSize: 12,
                                        secondTextFontWeight: FontWeight.w400,
                                        secondTextColor: MyColors.blackColor,
                                      ),
                                    ],
                                  ),
                                  vSizedBox,
                                  Row(
                                    children: [
                                      Image.asset(
                                        MyImagesUrl.timeIcon,
                                        width: 23,
                                        color: MyColors.blackColor,
                                      ),
                                      hSizedBox05,
                                      hSizedBox02,
                                      CustomRichText(
                                        firstText: 'Pickup Time:-',
                                        firstTextFontSize: 12,
                                        firstTextFontWeight: FontWeight.w700,
                                        firstTextColor: MyColors.blackColor,
                                        secondText: CustomTimeFunctions
                                            .formatDateInHHMM(bookingHistory
                                                .scheduleBookingList[index]
                                                .scheduledTime
                                                .toDate()),
                                        secondTextFontSize: 12,
                                        secondTextFontWeight: FontWeight.w400,
                                        secondTextColor: MyColors.blackColor,
                                      ),
                                    ],
                                  ),
                                  vSizedBox,
                                  Row(
                                    children: [
                                      Image.asset(
                                        MyImagesUrl.seatIcon,
                                        width: 23,
                                        color: MyColors.blackColor,
                                      ),
                                      hSizedBox05,
                                      hSizedBox02,
                                      CustomRichText(
                                        firstText: 'Booking of Seats :-',
                                        firstTextFontSize: 12,
                                        firstTextFontWeight: FontWeight.w700,
                                        firstTextColor: MyColors.blackColor,
                                        secondText: bookingHistory
                                                    .scheduleBookingList[index]
                                                    .rideType ==
                                                RideTypeStatus.private
                                            ? "All available"
                                            : '1 seat only',
                                        secondTextFontSize: 12,
                                        secondTextFontWeight: FontWeight.w400,
                                        secondTextColor: MyColors.blackColor,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              if (bookingHistory.scheduleBookingList[index]
                                      .bookingStatus !=
                                  BookingStatus.rideCancled)
                                CustomButton(
                                  text: 'Cancel',
                                  onTap: () async {
                                    var res = await showCancelReasonBottomSheet(
                                      bookingModal: bookingHistory
                                          .scheduleBookingList[index],
                                    );
                                    if (res.first) {
                                      var bookingProvider =
                                          Provider.of<BookingHistoryProvider>(
                                              context,
                                              listen: false);
                                      bookingProvider
                                          .getScheduleBookingHistory();
                                    }
                                  },
                                  horizontalPadding: 10,
                                  verticalPadding: 7,
                                  verticalMargin: 0,
                                  isFlexible: true,
                                  fontSize: 12,
                                  borderRadius: 10,
                                  color: MyColors.redColor01,
                                  textColor: MyColors.whiteColor,
                                )
                            ],
                          ),
                          vSizedBox,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText.smallText(
                                'Amount :',
                                color: MyColors.blackColor,
                                fontSize: 15,
                              ),
                              CustomText.heading(
                                CustomNumberFormatters
                                    .formatNumberInCommasEnWithCurrencyWithoutDecimals(
                                        bookingHistory
                                            .scheduleBookingList[index]
                                            .driverEarning),
                                color: MyColors.blackColor,
                                fontWeight: FontWeight.w800,
                              ),
                            ],
                          ),
                          vSizedBox,
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 15),
                            decoration: BoxDecoration(
                                color: MyColors.blackColor,
                                borderRadius: BorderRadius.circular(15)),
                            child: CustomStepper(
                              steps: [
                                StepData(
                                  title: 'Pickup',
                                  subtitle: bookingHistory
                                      .scheduleBookingList[index]
                                      .startDestination,
                                  isCurrent: true,
                                ),
                                StepData(
                                  title: 'Destination',
                                  subtitle: bookingHistory
                                      .scheduleBookingList[index]
                                      .endDestination,
                                ),
                              ],
                            ),
                          ),
                          vSizedBox,
                          if (index == -1)
                            CustomButton(
                              text: 'Check Drivers Bids',
                              horizontalPadding: 15,
                              onTap: () {
                                // CustomNavigation.push(
                                //     context: context,
                                //     screen: const DriverBidsScreen());
                              },
                              verticalPadding: 7,
                              verticalMargin: 0,
                              isFlexible: true,
                              fontSize: 13,
                              borderRadius: 10,
                              textColor: MyColors.whiteColor,
                              color: MyColors.blackColor,
                            ),
                          if (index == -1)
                            Row(
                              children: [
                                const CustomImage(
                                  imageUrl: MyImagesUrl.img02,
                                  fileType: CustomFileType.asset,
                                  height: 45,
                                  width: 45,
                                  borderRadius: 30,
                                ),
                                hSizedBox05,
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CustomText.bodyText2(
                                            'John Smith',
                                            color: MyColors.blackColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          Row(
                                            children: [
                                              const CustomRating(),
                                              CustomText.smallText(
                                                '(50 Reviews)',
                                                fontSize: 10,
                                                color: MyColors.blackColor50,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // CustomNavigation.push(
                                    //     context: context,
                                    //     screen: const ConversationScreen());
                                  },
                                  child: CircleAvatar(
                                    radius: 16,
                                    backgroundColor: const Color(0xFFEAEAEA),
                                    child: Padding(
                                      padding: const EdgeInsets.all(9),
                                      child: Image.asset(
                                        MyImagesUrl.chat,
                                      ),
                                    ),
                                  ),
                                ),
                                hSizedBox,
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor: const Color(0xFFEAEAEA),
                                  child: Padding(
                                    padding: const EdgeInsets.all(9),
                                    child: Image.asset(
                                      MyImagesUrl.phoneOutline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
