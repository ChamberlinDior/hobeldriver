import 'package:connect_app_driver/themes/custom_text_styles.dart';
import 'package:connect_app_driver/widget/custom_appbar.dart';
import 'package:connect_app_driver/widget/custom_text.dart';
import 'package:flutter/material.dart';

import '../../widget/app_specific/current_booking.dart';
import '../../widget/app_specific/past_booking.dart';

class RideHistoryScreen extends StatefulWidget {
  const RideHistoryScreen({super.key});

  @override
  State<RideHistoryScreen> createState() => _RideHistoryScreenState();
}

class _RideHistoryScreenState extends State<RideHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: 'Ride History',
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
                indicator: const UnderlineTabIndicator(),
                indicatorSize: TabBarIndicatorSize.tab,
                labelStyle: CustomTextStyle.labelStyle,
                unselectedLabelStyle: CustomTextStyle.unSelectedLabelStyle,
                dividerColor: const Color(0xff999999),
                dividerHeight: 2,
                padding: const EdgeInsets.only(bottom: 10),
                labelPadding: const EdgeInsets.only(bottom: 10, top: 20),
                tabs: [
                  CustomText.headingSmall('Current Booking'),
                  CustomText.headingSmall('Past Booking'),
                ]),
            const Expanded(
              child: TabBarView(
                children: [
                  CurrentBooking(),
                  PastBooking(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
