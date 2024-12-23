// ignore_for_file: deprecated_member_use

import 'package:connect_app_driver/constants/language_en.dart';
import 'package:connect_app_driver/constants/my_colors.dart';
import 'package:connect_app_driver/constants/my_image_url.dart';
import 'package:connect_app_driver/constants/sized_box.dart';
import 'package:connect_app_driver/constants/types/booking_status.dart';
import 'package:connect_app_driver/constants/types/ride_type_status.dart';
import 'package:connect_app_driver/functions/custom_time_functions.dart';
import 'package:connect_app_driver/pages/bottom_sheet/provide_otp.dart';
import 'package:connect_app_driver/pages/bottom_sheet/waiting_for_driver_screen.dart';
import 'package:connect_app_driver/pages/view_module/conversation_screen.dart';
import 'package:connect_app_driver/provider/live_booking_provider.dart';
import 'package:connect_app_driver/services/custom_navigation_services.dart';
import 'package:connect_app_driver/widget/custom_image.dart';
import 'package:connect_app_driver/widget/custom_rich_text.dart';
import 'package:connect_app_driver/widget/custom_text.dart';
import 'package:connect_app_driver/widget/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/screen_names.dart';
import '../../provider/bottom_sheet_provider.dart';
import '../../widget/custom_button.dart';
import '../../widget/custom_rating.dart';

// ignore: must_be_immutable
class BookingAccepted extends StatelessWidget {
  BookingAccepted({super.key});
  ValueNotifier<bool> buttonLoading = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    return Consumer<LiveBookingProvider>(
        builder: (context, liveBookingProvider, child) => liveBookingProvider
                    .incomingBookingRequest ==
                null
            ? Container()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomText.headingSmall(
                    'Booking Accepted',
                    fontWeight: FontWeight.w600,
                  ),
                  vSizedBox2,
                  if (liveBookingProvider.customerDetail != null)
                    Row(
                      children: [
                        CustomImage(
                          imageUrl: liveBookingProvider
                                  .customerDetail!.profileImage ??
                              MyImagesUrl.profileImage,
                          fileType: liveBookingProvider
                                      .customerDetail!.profileImage ==
                                  null
                              ? CustomFileType.asset
                              : CustomFileType.network,
                          height: 50,
                          width: 50,
                          borderRadius: 30,
                        ),
                        hSizedBox,
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText.bodyText2(
                                    liveBookingProvider
                                        .customerDetail!.fullName,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  Row(
                                    children: [
                                      CustomRating(
                                        rating: liveBookingProvider
                                            .customerDetail!.averageRating,
                                      ),
                                      hSizedBox02,
                                      CustomText.smallText(
                                        '${liveBookingProvider.customerDetail!.averageRating} (${liveBookingProvider.customerDetail!.totalReviewCount} ${translate("Reviews")})',
                                        fontSize: 10,
                                        color: MyColors.color969696,
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
                            CustomNavigation.push(
                                context: context,
                                screen: ConversationScreen(
                                  bookingId: liveBookingProvider
                                      .incomingBookingRequest!.id,
                                  userModal:
                                      liveBookingProvider.customerDetail!,
                                ));
                          },
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: MyColors.whiteColor,
                            child: Padding(
                              padding: const EdgeInsets.all(9),
                              child: Image.asset(
                                MyImagesUrl.chat,
                              ),
                            ),
                          ),
                        ),
                        hSizedBox,
                        GestureDetector(
                          onTap: () async {
                            // CustomNavigation.push(context: context, screen: const RideSuccessScreen());
                            var url =
                                "tel: +${liveBookingProvider.customerDetail?.phoneWithCode}";
                            if (await canLaunch(url)) {
                              await launch(url);
                            }
                          },
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: MyColors.whiteColor,
                            child: Padding(
                              padding: const EdgeInsets.all(9),
                              child: Image.asset(
                                MyImagesUrl.phoneOutline,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  Divider(
                    color: MyColors.dividerColor,
                    height: 40,
                  ),
                  if (liveBookingProvider
                              .incomingBookingRequest!.bookingStatus ==
                          BookingStatus.pending &&
                      liveBookingProvider.incomingBookingRequest!.isScheduled)
                    Row(
                      children: [
                        Image.asset(
                          MyImagesUrl.calender,
                          width: 24,
                        ),
                        hSizedBox,
                        CustomRichText(
                            firstText: 'Scheduled on :-',
                            firstTextFontWeight: FontWeight.w700,
                            secondText: CustomTimeFunctions
                                .formatDateInDateMonthNameyear(
                                    liveBookingProvider
                                        .incomingBookingRequest!.scheduledTime
                                        .toDate()),
                            secondTextFontWeight: FontWeight.w400)
                      ],
                    ),
                  if (liveBookingProvider
                              .incomingBookingRequest!.bookingStatus ==
                          BookingStatus.pending &&
                      liveBookingProvider.incomingBookingRequest!.isScheduled)
                    vSizedBox,
                  if (liveBookingProvider
                              .incomingBookingRequest!.bookingStatus ==
                          BookingStatus.pending &&
                      liveBookingProvider.incomingBookingRequest!.isScheduled)
                    Row(
                      children: [
                        Image.asset(
                          MyImagesUrl.timeIcon,
                          width: 24,
                        ),
                        hSizedBox,
                        CustomRichText(
                            firstText: 'Pickup Time:-',
                            firstTextFontWeight: FontWeight.w700,
                            secondText: CustomTimeFunctions.getTimeFromDate(
                                liveBookingProvider
                                    .incomingBookingRequest!.scheduledTime
                                    .toDate()),
                            secondTextFontWeight: FontWeight.w400)
                      ],
                    ),
                  if (liveBookingProvider
                              .incomingBookingRequest!.bookingStatus ==
                          BookingStatus.pending &&
                      liveBookingProvider.incomingBookingRequest!.isScheduled)
                    vSizedBox,
                  if (liveBookingProvider
                              .incomingBookingRequest!.bookingStatus ==
                          BookingStatus.pending &&
                      liveBookingProvider.incomingBookingRequest!.isScheduled)
                    Row(
                      children: [
                        Image.asset(
                          MyImagesUrl.seatIcon,
                          width: 24,
                        ),
                        hSizedBox,
                        CustomRichText(
                            firstText: 'Booking of Seats :-',
                            firstTextFontWeight: FontWeight.w700,
                            secondText: liveBookingProvider
                                        .incomingBookingRequest!.rideType ==
                                    RideTypeStatus.private
                                ? "All available"
                                : "1 seat",
                            secondTextFontWeight: FontWeight.w400)
                      ],
                    ),
                  vSizedBox,
                  Row(
                    children: [
                      Image.asset(MyImagesUrl.startDestinationIcon,
                          height: 25, color: Colors.white),
                      hSizedBox,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText.bodyText1(
                              "Pickup Location",
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                            CustomText.bodyText1(
                              '${liveBookingProvider.incomingBookingRequest?.startDestination}',
                              fontSize: 13,
                              // color: MyColors
                              //     .blackThemeColorWithOpacity(0.5),
                              color: MyColors.whiteColor70,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  vSizedBox3,
                  Consumer<LiveBookingProvider>(
                    builder: (context, liveBooking, child) =>
                        Consumer<BottomSheetProvider>(builder:
                            (context, bottomSheetProviderValue, child) {
                      return ValueListenableBuilder(
                        valueListenable: buttonLoading,
                        builder: (context, load, child) => CustomButton(
                          text: 'Start Ride',
                          load: load,
                          onTap: liveBooking
                                      .incomingBookingRequest!.bookingStatus ==
                                  BookingStatus.driverReachedToPickup
                              ? () {
                                  bottomSheetProviderValue.addPage(ProvideOTP(),
                                      screenName: ScreenNames.ProvideOTP);
                                }
                              : () async {
                                  buttonLoading.value = true;
                                  await liveBooking.onDriverLocationChange();
                                  if (liveBooking.incomingBookingRequest!
                                          .bookingStatus ==
                                      BookingStatus.driverReachedToPickup) {
                                    buttonLoading.value = false;
                                    bottomSheetProviderValue.addPage(
                                        ProvideOTP(),
                                        screenName: ScreenNames.ProvideOTP);
                                  } else {
                                    buttonLoading.value = false;
                                    showSnackbar(
                                        "You are not near the pickup location. Please proceed to the pickup location.");
                                  }
                                },
                          height: 50,
                          verticalMargin: 0,
                        ),
                      );
                    }),
                  ),
                  vSizedBox,
                  CustomButton(
                    text: 'Cancel Trip',
                    onTap: () async {
                      await showCancelReasonBottomSheet(
                        bookingModal:
                            liveBookingProvider.incomingBookingRequest!,
                      );
                    },
                    horizontalPadding: 10,
                    verticalPadding: 7,
                    height: 50,
                    color: MyColors.redColor01,
                    textColor: MyColors.whiteColor,
                  )
                ],
              ));
  }
}
