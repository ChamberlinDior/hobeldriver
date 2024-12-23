import 'package:connect_app_driver/constants/my_colors.dart';
import 'package:connect_app_driver/constants/sized_box.dart';
import 'package:connect_app_driver/provider/bottom_sheet_provider.dart';
import 'package:connect_app_driver/provider/schedule_booking_provider.dart';
import 'package:connect_app_driver/themes/custom_text_styles.dart';
import 'package:connect_app_driver/widget/custom_button.dart';
import 'package:connect_app_driver/widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../functions/custom_number_formatters.dart';

class PlaceYourBid extends StatefulWidget {
  const PlaceYourBid({super.key});

  @override
  State<PlaceYourBid> createState() => _PlaceYourBidState();
}

class _PlaceYourBidState extends State<PlaceYourBid> {
  ValueNotifier<double> widthNotifier = ValueNotifier(100);

  TextEditingController priceController = TextEditingController(text: '18.00');
  ValueNotifier<double> priceNotier = ValueNotifier(100);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        var liveBookingProvider =
            Provider.of<ScheduleBookingProvider>(context, listen: false);
        priceController.text =
            CustomNumberFormatters.formatNumberInCommasENWithoutDecimals(
                liveBookingProvider
                    .incomingSceduledBookingRequest!.driverEarning);
        priceNotier.value =
            liveBookingProvider.incomingSceduledBookingRequest!.driverEarning;
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ScheduleBookingProvider>(
        builder: (context, liveBooking, child) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText.heading('Place your Bid'),
                vSizedBox05,
                CustomText.smallText(
                    'You can accept suggested price below or select a lower or higher price.'),
                vSizedBox3,
                Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText.heading(
                        'FCFA',
                        fontSize: 34,
                      ),
                      hSizedBox05,
                      Flexible(
                        child: IntrinsicWidth(
                          child: TextFormField(
                            controller: priceController,
                            onChanged: (val) {
                              String numberWithoutComma =
                                  val.replaceAll(",", "");

                              priceNotier.value = double.parse(
                                  numberWithoutComma.isEmpty
                                      ? '0'
                                      : numberWithoutComma);
                            },
                            keyboardType:
                                const TextInputType.numberWithOptions(),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              hintText: '0',
                              hintStyle: CustomTextStyle.textFieldHint.copyWith(
                                  fontSize: 40, color: MyColors.whiteColor70),
                              border: InputBorder.none,
                            ),
                            style: CustomTextStyle.textFieldText.copyWith(
                                fontSize: 40, color: MyColors.whiteColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                vSizedBox05,
                Align(
                  alignment: Alignment.center,
                  child: CustomText.bodyText1(
                    'Suggested Price',
                    color: MyColors.blueColor,
                  ),
                ),
                vSizedBox3,
                Center(
                  child: Wrap(
                    spacing: 10,
                    children: [
                      CustomButton(
                        text: "-1000",
                        onTap: () {
                          priceController.text = CustomNumberFormatters
                              .formatNumberInCommasENWithoutDecimals(liveBooking
                                      .incomingSceduledBookingRequest!
                                      .driverEarning -
                                  1000);
                          priceNotier.value = liveBooking
                                  .incomingSceduledBookingRequest!
                                  .driverEarning -
                              1000;
                        },
                        isFlexible: true,
                        borderRadius: 50,
                        height: 50,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: MyColors.colorD9D9D9,
                        textColor: MyColors.whiteColor,
                        verticalPadding: 8,
                        horizontalPadding: 13,
                      ),
                      CustomButton(
                        text: "-500",
                        onTap: () {
                          priceController.text = CustomNumberFormatters
                                  .formatNumberInCommasENWithoutDecimals(
                                      liveBooking
                                              .incomingSceduledBookingRequest!
                                              .driverEarning -
                                          500)
                              .toString();
                          priceNotier.value = liveBooking
                                  .incomingSceduledBookingRequest!
                                  .driverEarning -
                              500;
                        },
                        isFlexible: true,
                        borderRadius: 50,
                        height: 50,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: MyColors.colorD9D9D9,
                        textColor: MyColors.whiteColor,
                        verticalPadding: 8,
                        horizontalPadding: 13,
                      ),
                      CustomButton(
                        text: "+500",
                        onTap: () {
                          priceController.text = CustomNumberFormatters
                                  .formatNumberInCommasENWithoutDecimals(
                                      liveBooking
                                              .incomingSceduledBookingRequest!
                                              .driverEarning +
                                          500)
                              .toString();
                          priceNotier.value = liveBooking
                                  .incomingSceduledBookingRequest!
                                  .driverEarning +
                              500;
                        },
                        isFlexible: true,
                        borderRadius: 50,
                        height: 50,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: MyColors.colorD9D9D9,
                        textColor: MyColors.whiteColor,
                        verticalPadding: 8,
                        horizontalPadding: 13,
                      ),
                      CustomButton(
                        text: "+1000",
                        onTap: () {
                          priceController.text = CustomNumberFormatters
                                  .formatNumberInCommasENWithoutDecimals(
                                      liveBooking
                                              .incomingSceduledBookingRequest!
                                              .driverEarning +
                                          1000)
                              .toString();
                          priceNotier.value = liveBooking
                                  .incomingSceduledBookingRequest!
                                  .driverEarning +
                              1000;
                        },
                        isFlexible: true,
                        borderRadius: 50,
                        height: 50,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: MyColors.colorD9D9D9,
                        textColor: MyColors.whiteColor,
                        verticalPadding: 8,
                        horizontalPadding: 13,
                      ),
                    ],
                  ),
                ),
                vSizedBox2,
                Consumer<BottomSheetProvider>(
                    builder: (context, bottomSheetProviderValue, _) {
                  return Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          height: 50,
                          text: 'Place',
                          horizontalMargin: 10,
                          verticalMargin: 0,
                          onTap: () {
                            liveBooking.setBidToincomingRideRequest(
                                priceNotier.value.toString());
                            bottomSheetProviderValue.removePage();
                          },
                        ),
                      ),
                      Expanded(
                        child: CustomButton(
                          height: 50,
                          text: 'Cancel',
                          horizontalMargin: 10,
                          verticalMargin: 0,
                          onTap: () {
                            bottomSheetProviderValue.removePage();
                          },
                          isSolid: false,
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ));
  }
}
