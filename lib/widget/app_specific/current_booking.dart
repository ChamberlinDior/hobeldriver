import 'package:connect_app_driver/constants/global_data.dart';
import 'package:connect_app_driver/constants/language_en.dart';
import 'package:connect_app_driver/constants/my_colors.dart';
import 'package:connect_app_driver/constants/types/booking_status.dart';
import 'package:connect_app_driver/constants/types/ride_type_status.dart';
import 'package:connect_app_driver/functions/custom_time_functions.dart';
import 'package:connect_app_driver/provider/booking_history_provider.dart';
import 'package:connect_app_driver/widget/custom_button.dart';
import 'package:connect_app_driver/widget/custom_paginated_list_view.dart';
import 'package:connect_app_driver/widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/my_image_url.dart';
import '../../constants/sized_box.dart';
import '../../functions/custom_number_formatters.dart';
import '../custom_rich_text.dart';
import 'custom_stepper.dart';

class CurrentBooking extends StatelessWidget {
  const CurrentBooking({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer<BookingHistoryProvider>(
            builder: (context, bookingHistory, child) => Expanded(
                    child: CustomPaginatedListView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: globalHorizontalPadding),
                  itemCount: bookingHistory.currentBookingList.length,
                  onLoadMore: () async {
                    print("lodad more called");
                  },
                  wantLoadMore: false,
                  isLastPage: false,
                  // load: true,
                  itemBuilder: (context, index) {
                    return Container(
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: CustomText.smallText(
                                  '${translate("Booking ID:")} #${bookingHistory.currentBookingList[index].bookingRefrenceId}',
                                  color: MyColors.blackColor,
                                  fontSize: 11,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  CustomButton(
                                    text: BookingStatus.getName(bookingHistory
                                        .currentBookingList[index]
                                        .bookingStatus),
                                    horizontalPadding: 8,
                                    verticalPadding: 2,
                                    verticalMargin: 0,
                                    isFlexible: true,
                                    fontSize: 12,
                                    color: BookingStatus.getColor(bookingHistory
                                        .currentBookingList[index]
                                        .bookingStatus),
                                    textColor: bookingHistory
                                                .currentBookingList[index]
                                                .bookingStatus !=
                                            BookingStatus.pending
                                        ? MyColors.whiteColor
                                        : MyColors.blackColor,
                                  ),
                                  vSizedBox05,
                                  CustomButton(
                                    text: bookingHistory
                                            .currentBookingList[index]
                                            .isScheduled
                                        ? 'Scheduled'
                                        : 'Immediate',
                                    horizontalPadding: 8,
                                    verticalPadding: 2,
                                    verticalMargin: 0,
                                    isFlexible: true,
                                    fontSize: 12,
                                    textColor: MyColors.whiteColor,
                                    color: MyColors.blackColor,
                                  )
                                ],
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
                                  if (bookingHistory
                                      .currentBookingList[index].isScheduled)
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
                                              .formatDateInDateMonthNameyear(
                                                  bookingHistory
                                                      .currentBookingList[index]
                                                      .scheduledTime
                                                      .toDate()),
                                          secondTextFontSize: 12,
                                          secondTextFontWeight: FontWeight.w400,
                                          secondTextColor: MyColors.blackColor,
                                        ),
                                      ],
                                    ),
                                  if (bookingHistory
                                      .currentBookingList[index].isScheduled)
                                    vSizedBox,
                                  if (bookingHistory
                                      .currentBookingList[index].isScheduled)
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
                                                  .currentBookingList[index]
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
                                                    .currentBookingList[index]
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

                              // CustomButton(
                              //   text: 'Cancel',
                              //   onTap: () {

                              //   },
                              //   horizontalPadding: 10,
                              //   verticalPadding: 7,
                              //   verticalMargin: 0,
                              //   isFlexible: true,
                              //   fontSize: 12,
                              //   borderRadius: 10,
                              //   color: MyColors.redColor01,
                              //   textColor: MyColors.whiteColor,
                              // )
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
                                        bookingHistory.currentBookingList[index]
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
                                      .currentBookingList[index]
                                      .startDestination,
                                  isCurrent: true,
                                ),
                                StepData(
                                  title: 'Destination',
                                  subtitle: bookingHistory
                                      .currentBookingList[index].endDestination,
                                ),
                              ],
                            ),
                          ),
                          vSizedBox,
                          if (false == true)
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
                          // if (index.isOdd)
                          //   Row(
                          //     children: [
                          //       const CustomImage(
                          //         imageUrl: MyImagesUrl.img02,
                          //         fileType: CustomFileType.asset,
                          //         height: 45,
                          //         width: 45,
                          //         borderRadius: 30,
                          //       ),
                          //       hSizedBox05,
                          //       Expanded(
                          //         child: Row(
                          //           mainAxisAlignment:
                          //               MainAxisAlignment.spaceBetween,
                          //           children: [
                          //             Column(
                          //               crossAxisAlignment:
                          //                   CrossAxisAlignment.start,
                          //               children: [
                          //                 CustomText.bodyText2(
                          //                   'John Smith',
                          //                   color: MyColors.blackColor,
                          //                   fontWeight: FontWeight.w500,
                          //                 ),
                          //                 Row(
                          //                   children: [
                          //                     const CustomRating(),
                          //                     CustomText.smallText(
                          //                       '(50 Reviews)',
                          //                       fontSize: 10,
                          //                       color: MyColors.blackColor50,
                          //                     ),
                          //                   ],
                          //                 ),
                          //               ],
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          //       GestureDetector(
                          //         onTap: () {
                          //           CustomNavigation.push(
                          //               context: context,
                          //               screen: const ConversationScreen());
                          //         },
                          //         child: CircleAvatar(
                          //           radius: 16,
                          //           backgroundColor: const Color(0xFFEAEAEA),
                          //           child: Padding(
                          //             padding: const EdgeInsets.all(9),
                          //             child: Image.asset(
                          //               MyImagesUrl.chat,
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //       hSizedBox,
                          //       CircleAvatar(
                          //         radius: 16,
                          //         backgroundColor: const Color(0xFFEAEAEA),
                          //         child: Padding(
                          //           padding: const EdgeInsets.all(9),
                          //           child: Image.asset(
                          //             MyImagesUrl.phoneOutline,
                          //           ),
                          //         ),
                          //       ),
                          //       // hSizedBox,
                          //       // CustomText.heading('\$225',
                          //       //   fontSize: 18,
                          //       //   fontWeight: FontWeight.w600,
                          //       //   color: MyColors.blackColor,),
                          //     ],
                          //   ),
                        ],
                      ),
                    );
                  },
                ))),
      ],
    );
  }
}
