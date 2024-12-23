import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_app_driver/constants/api_keys.dart';
import 'package:connect_app_driver/constants/language_en.dart';
import 'package:connect_app_driver/functions/easyLoadingConfigSetup.dart';
import 'package:connect_app_driver/modal/booking_modal.dart';
import 'package:connect_app_driver/modal/user_modal.dart';
import 'package:connect_app_driver/services/firebase_services/firebase_cloud_messaging_v1.dart';
import 'package:connect_app_driver/services/firebase_services/firebase_collections.dart';
import 'package:connect_app_driver/widget/custom_image.dart';
import 'package:connect_app_driver/widget/show_snackbar.dart';
import 'package:flutter/material.dart';

import '../../constants/global_data.dart';
import '../../constants/my_colors.dart';
import '../../constants/sized_box.dart';
import '../../services/custom_navigation_services.dart';
import '../../widget/app_specific/dotted_border_container.dart';
import '../../widget/custom_appbar.dart';
import '../../widget/custom_rating.dart';
import '../../widget/custom_scaffold.dart';
import '../../widget/custom_text.dart';
import '../../widget/custom_text_field.dart';
import '../../widget/custom_button.dart';

class RateUsScreen extends StatefulWidget {
  final UserModal ratingToUserDetails;
  final BookingModal bookingDetails;
  const RateUsScreen(
      {super.key,
      required this.bookingDetails,
      required this.ratingToUserDetails});

  @override
  State<RateUsScreen> createState() => _RateUsScreenState();
}

class _RateUsScreenState extends State<RateUsScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController rateUsController = TextEditingController();
  double updatedRating = 5.0;
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        onPressed: () {
          CustomNavigation.popUntil(context, (route) => route.isFirst);
        },
        titleText: 'Back to home',
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: globalHorizontalPadding),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  vSizedBox,
                  CustomText.heading(
                    'Rate Customer!',
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                  vSizedBox,
                  CustomText.bodyText2(
                    'Your rating is most valuable for other users',
                    fontWeight: FontWeight.w400,
                  ),
                  vSizedBox,
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 18),
                    decoration: BoxDecoration(
                        color: MyColors.lightWhiteColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomImage(
                          imageUrl: widget.ratingToUserDetails.profileImage!,
                          height: 50,
                          width: 50,
                          borderRadius: 30,
                        ),
                        hSizedBox,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText.bodyText2(
                              widget.ratingToUserDetails.fullName,
                              fontWeight: FontWeight.w500,
                            ),
                            Row(
                              children: [
                                CustomRating(
                                  rating:
                                      widget.ratingToUserDetails.averageRating,
                                ),
                                hSizedBox02,
                                CustomText.smallText(
                                  ' ${widget.ratingToUserDetails.averageRating} (${widget.ratingToUserDetails.totalReviewCount} Reviews)',
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
                  vSizedBox,
                  CustomRating(
                    ignoreGestures: false,
                    rating: updatedRating,
                    itemSize: 42,
                    onRatingUpdate: (val) {
                      print("rating is this $val");
                      updatedRating = val;
                    },
                  ),
                  vSizedBox2,
                  CustomPaint(
                    painter: DottedBorderPainter(
                      color: MyColors.whiteColor,
                      strokeWidth: 2,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1),
                      child: CustomTextField(
                        maxLines: 6,
                        fillColor: MyColors.blackColor,
                        borderColor: Colors.transparent,
                        controller: rateUsController,
                        hintText: "Type here...",
                      ),
                    ),
                  ),
                  vSizedBox,
                  CustomButton(
                    height: 50,
                    onTap: () async {
                      if (rateUsController.text.isNotEmpty) {
                        await showLoading();

                        var request = {
                          "ratedBy": userData!.userId,
                          "ratedTo": widget.bookingDetails.requestedBy,
                          "review": rateUsController.text,
                          "rating": updatedRating,
                          "createdAt": Timestamp.now(),
                          "docID":
                              "${widget.bookingDetails.id}_${widget.bookingDetails.requestedBy}"
                        };
                        await FirebaseCollections.bookingHistory
                            .doc(widget.bookingDetails.id)
                            .update({"ratingByDriver": request});
                        await FirebaseCollections.rating
                            .doc(
                                "${widget.bookingDetails.id}_${widget.bookingDetails.requestedBy}")
                            .set(request);
                        var allRatings = await FirebaseCollections.rating
                            .where('ratedTo',
                                isEqualTo: widget.bookingDetails.requestedBy)
                            .get();
                        if (allRatings.docs.isNotEmpty) {
                          double sum = 0;
                          int count = 0;
                          for (int i = 0; i < allRatings.docs.length; i++) {
                            Map m = allRatings.docs[i].data() as Map;
                            sum = sum + m["rating"];
                            count = count + 1;
                          }
                          double avg =
                              double.parse((sum / count).toStringAsFixed(1));
                          await FirebaseCollections.users
                              .doc(widget.bookingDetails.requestedBy)
                              .update({
                            ApiKeys.rating: avg,
                            ApiKeys.ratingCount: count,
                          });
                          if (widget
                              .ratingToUserDetails.deviceTokens.isNotEmpty) {
                            await FirebaseCloudMessagingV1()
                                .sendPushNotificationsWithFirebaseCollectInsertion(
                                    deviceIds:
                                        widget.ratingToUserDetails.deviceTokens,
                                    data: {
                                      "screen": "rating",
                                      "bookingId": widget.bookingDetails.id
                                    },
                                    body: "Your driver has rated you for booking #12345"
                                        .replaceFirst("#12345",
                                            "#${widget.bookingDetails.bookingRefrenceId}"),
                                    title: translate("You've Been Rated"),
                                    reciverUserId:
                                        widget.ratingToUserDetails.userId);
                          }
                        }
                        hideLoading();
                        CustomNavigation.pop(context);
                      } else {
                        showSnackbar('Required**');
                      }
                    },
                    verticalMargin: 20,
                    text: "Submit",
                  ),
                  TextButton(
                    onPressed: () {
                      CustomNavigation.pop(context);
                    },
                    child: CustomText.bodyText1(
                      "Skip",
                      color: MyColors.whiteColor,
                      decoration: TextDecoration.underline,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
