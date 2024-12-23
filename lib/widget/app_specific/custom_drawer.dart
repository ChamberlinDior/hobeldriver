import 'package:connect_app_driver/pages/auth_module/ride_setting_screen.dart';
import 'package:connect_app_driver/pages/auth_module/terms_page.dart';
import 'package:connect_app_driver/pages/view_module/contact_us_screen.dart';
import 'package:connect_app_driver/pages/view_module/my_profile_screen.dart';
import 'package:connect_app_driver/pages/view_module/scheduled_ride_screen.dart';
import 'package:connect_app_driver/provider/admin_settings_provider.dart';
import 'package:connect_app_driver/provider/booking_history_provider.dart';
import 'package:connect_app_driver/provider/new_firebase_auth_provider.dart';
import 'package:connect_app_driver/services/custom_navigation_services.dart';
import 'package:connect_app_driver/widget/custom_image.dart';
import 'package:connect_app_driver/widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/global_data.dart';
import '../../constants/my_colors.dart';
import '../../constants/my_image_url.dart';
import '../../constants/sized_box.dart';
import '../../pages/auth_module/change_password_screen.dart';
import '../../pages/view_module/my_wallet_screen.dart';
import '../../pages/view_module/ride_history_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: MyColors.blackColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50, bottom: 25),
                child: Row(
                  children: [
                    Consumer<FirebaseAuthProvider>(
                      builder: (context, firebaseAuthProvider, child) => Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CustomImage(
                            height: 70,
                            width: 70,
                            imageUrl: userData?.profileImage ??
                                MyImagesUrl.profileImage,
                            // image: selectImageValue,
                            borderRadius: 100,
                            fileType: userData?.profileImage != null
                                ? CustomFileType.network
                                : CustomFileType.asset,
                          ),
                          InkWell(
                            onTap: () async {
                              CustomNavigation.pop(context);
                              CustomNavigation.push(
                                  context: context,
                                  screen: const MyProfileScreen());
                              //   var data =
                              //   await cameraImagePicker(context);
                              //   if (data != null) {
                              //     selectedImageNoti.value = data;
                              //     var request = {
                              //       ApiKeys.profileImage: await FirebaseService.uploadImageAndGetUrl(selectedImageNoti.value!.path),
                              //     };
                              //     firebaseAuthProvider.editProfile(request);
                              //   }
                            },
                            child: Container(
                              margin:
                                  const EdgeInsets.only(right: 6, bottom: 8),
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: MyColors.blackColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: MyColors.whiteColor, width: 0.8)),
                              child: const Icon(
                                Icons.edit,
                                size: 14,
                                color: MyColors.whiteColor,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    hSizedBox,
                    Expanded(
                      child: Consumer<FirebaseAuthProvider>(
                          builder: (context, firebaseAuthProvider, child) {
                        return CustomText.bodyText1(
                          '${userData?.fullName}',
                        );
                      }),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      rowCard(
                        onTap: () {
                          var bookingProvider =
                              Provider.of<BookingHistoryProvider>(context,
                                  listen: false);
                          bookingProvider.getScheduleBookingHistory();
                          CustomNavigation.pop(context);
                          CustomNavigation.push(
                              context: context,
                              screen: const ScheduledRideScreen());
                        },
                        icons: MyImagesUrl.calenderFill,
                        name: 'Scheduled Ride',
                      ),
                      rowCard(
                        onTap: () {
                          var bookingProvider =
                              Provider.of<BookingHistoryProvider>(context,
                                  listen: false);
                          bookingProvider.getCurrentBookingHistory();
                          bookingProvider.getPastBookingHistory();
                          CustomNavigation.pop(context);
                          CustomNavigation.push(
                              context: context,
                              screen: const RideHistoryScreen());
                        },
                        icons: MyImagesUrl.ticket,
                        name: 'Ride History',
                      ),
                      rowCard(
                        onTap: () {
                          CustomNavigation.pop(context);
                          CustomNavigation.push(
                              context: context,
                              screen: const MyProfileScreen());
                        },
                        icons: MyImagesUrl.user,
                        name: 'My Profile',
                      ),
                      rowCard(
                        onTap: () {
                          CustomNavigation.pop(context);
                          CustomNavigation.push(
                              context: context, screen: const MyWalletScreen());
                        },
                        icons: MyImagesUrl.wallet,
                        name: 'My Earnings',
                      ),
                      rowCard(
                        onTap: () {
                          CustomNavigation.pop(context);
                          CustomNavigation.push(
                              context: context,
                              screen: const ChangePasswordScreen());
                        },
                        icons: MyImagesUrl.lock,
                        name: 'Change Password',
                      ),
                      rowCard(
                        onTap: () {
                          CustomNavigation.pop(context);
                          // CustomNavigation.push(
                          //     context: context, screen: const PrivacyPolicyScreen());
                          CustomNavigation.push(
                              context: context,
                              screen: const RideSettingScreen());
                        },
                        icons: MyImagesUrl.settingIcon,
                        name: 'Ride Settings',
                      ),
                      rowCard(
                        onTap: () {
                          CustomNavigation.pop(context);
                          // CustomNavigation.push(
                          //     context: context, screen: const PrivacyPolicyScreen());
                          CustomNavigation.push(
                              context: context,
                              screen: const TermsAndConditionsPage());
                        },
                        icons: MyImagesUrl.privacyTip,
                        name: 'Privacy Policy',
                      ),
                      rowCard(
                        onTap: () {
                          CustomNavigation.pop(context);
                          // CustomNavigation.push(
                          //     context: context, screen: const PrivacyPolicyScreen());
                          CustomNavigation.push(
                              context: context,
                              screen: const ContactUsScreen());
                        },
                        icons: MyImagesUrl.contactUsIcon,
                        name: 'Contact us',
                      ),
                      Consumer<AdminSettingsProvider>(
                        builder: (context, value, child) => value
                                .defaultAppSettingModal.hideOnSubmit
                            ? rowCard(
                                onTap: () {
                                  var firebaseAuthProvider =
                                      Provider.of<FirebaseAuthProvider>(context,
                                          listen: false);
                                  firebaseAuthProvider.deleteAccount(context);
                                },
                                icons: MyImagesUrl.deleteIcon,
                                name: 'Delete my account',
                              )
                            : Container(),
                      ),
                      // const Spacer(),
                      GestureDetector(
                        onTap: () {
                          // var provider =
                          //     Provider.of<AuthProvider>(context, listen: false);
                          // provider.logoutPopup(context);
                          var firebaseAuthProvider =
                              Provider.of<FirebaseAuthProvider>(context,
                                  listen: false);
                          firebaseAuthProvider.logout(context);
                        },
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: MyColors.whiteColor,
                              child: Image.asset(
                                MyImagesUrl.logout,
                                width: 23,
                              ),
                            ),
                            hSizedBox,
                            hSizedBox05,
                            CustomText.bodyText1(
                              'Logout',
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ),
                          ],
                        ),
                      ),
                      vSizedBox2
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

class rowCard extends StatelessWidget {
  final String name;
  final String icons;
  final Function()? onTap;

  rowCard(
      {Key? key, required this.name, required this.icons, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(),
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: MyColors.whiteColor,
                      child: Image.asset(icons,
                          width: 23, color: MyColors.blackColor),
                    ),
                    hSizedBox,
                    hSizedBox05,
                    CustomText.bodyText1(
                      name,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(
            color: MyColors.whiteColor.withOpacity(0.3),
          )
        ],
      ),
    );
  }
}
