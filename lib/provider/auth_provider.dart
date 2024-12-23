// import 'dart:async';
// import 'package:connect_app_driver/pages/auth_module/login_screen.dart';
// import 'package:connect_app_driver/pages/view_module/home_screen.dart';
// import 'package:connect_app_driver/provider/app_language_provider.dart';
// import 'package:connect_app_driver/widget/custom_bottom_sheet.dart';
// import 'package:connect_app_driver/widget/custom_gesture_detector.dart';
// import 'package:connect_app_driver/widget/old_custom_text.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:connect_app_driver/constants/api_keys.dart';
// import 'package:connect_app_driver/constants/global_keys.dart';
// import 'package:connect_app_driver/modal/response_modal.dart';
// import 'package:connect_app_driver/services/newest_webservices.dart';
// import '../constants/global_data.dart';
// import '../constants/my_colors.dart';
// import '../constants/my_image_url.dart';
// import '../constants/shared_preference_keys.dart';
// import '../constants/sized_box.dart';
// import 'package:flutter/material.dart';
// import 'dart:convert' as convert;
// import '../functions/print_function.dart';
// import '../modal/user_modal.dart';
// import '../pages/auth_module/intro_screen.dart';
// import '../services/api_urls.dart';
// import '../services/custom_navigation_services.dart';
// import '../services/firebase_push_notifications.dart';
// import '../services/firebase_services/firebase_push_notifications.dart';
// import '../widget/common_alert_dailog.dart';
// import '../widget/custom_button.dart';
// import '../widget/show_snackbar.dart';
// import 'location_provider.dart';
//
// class AuthProvider extends ChangeNotifier {
//   bool load = false;
//   // ValueNotifier<int> selectedLanguage = ValueNotifier(0);
//
//   void showLoading() {
//     load = true;
//     notifyListeners();
//   }
//
//   void hideLoading() {
//     load = false;
//     notifyListeners();
//   }
//
//   void userNavigationAfterLogin(BuildContext context) {
//     FirebasePushNotifications.updateDeviceToken();
//        if(userDataNotifier.value?.fullName==null || userDataNotifier.value?.userType==null){
//       CustomNavigation.pushAndRemoveUntil(context: context, screen: LoginPage());
//       // CustomNavigation.pushAndRemoveUntil(context: context, screen: PreSignUpScreen());
//     }
//     else{
//          CustomNavigation.pushAndRemoveUntil(context: context, screen: const HomeScreen());
//     }
//   }
//
//   Future<void> splashAuthentication(context) async {
//     // await Firebase.initializeApp(
//     //   options: DefaultFirebaseOptions.currentPlatform,
//     // );
//     // await FirebasePushNotifications.initializeFirebaseNotifications();
//     //var adminSettingsProvider =
//     //    Provider.of<AdminSettingsProvider>(context, listen: false);
//     //await AdminSettingsProvider.updateDefaultAppSettingsToFirebase();
//     //await adminSettingsProvider.getDefaultAppSettings();
//     await FirebasePushNotifications.initializeFirebaseNotifications();
//     sharedPreference = await SharedPreferences.getInstance();
//     var appLanguageProvider = Provider.of<AppLanguageProvider>(context, listen: false);
//     appLanguageProvider.initializeLanguage();
//     UserModal? result = await isLoggedIn();
//
//     if (result != null) {
//       userNavigationAfterLogin(context);
//     } else {
//       // CustomNavigation.pushAndRemoveUntil(context: context, screen: const HomeScreen());
//       CustomNavigation.pushAndRemoveUntil(context: context, screen: const IntroScreen());
//     }
//     // FirebasePushNotifications.handleNotificationsIfAppIsKilled();
//   }
//
//   Future<UserModal?> isLoggedIn() async {
//     String? userDataString =
//         sharedPreference.getString(SharedPreferenceKeys.userData);
//     if (userDataString != null) {
//       Map<String, dynamic> userData = convert.jsonDecode(userDataString);
//       userToken = sharedPreference.getString(SharedPreferenceKeys.userToken);
//       userDataNotifier.value = UserModal.fromJson(userData);
//       await updateUserData();
//       return userDataNotifier.value;
//     } else {
//       return null;
//     }
//   }
//
//   Future<void> updateUserDataInSharedPreference(
//       {required Map userData, String? token}) async {
//     String userDataString = convert.jsonEncode(userData);
//     userDataNotifier.value = UserModal.fromJson(userData);
//     await sharedPreference.setString(
//         SharedPreferenceKeys.userData, userDataString);
//     if (token != null) {
//       userToken = token;
//       await sharedPreference.setString(SharedPreferenceKeys.userToken, token);
//     }
//   }
//
//   Future<void> updateUserData() async {
//     var jsonResponse = await NewestWebServices.getResponse(
//         apiMethod: ApiMethod.get,
//         apiUrl: ApiUrls.getUserDetails,
//         request: {},
//         showSuccessMessage: false);
//     if (jsonResponse.status == 1) {
//       updateUserDataInSharedPreference(
//         userData: jsonResponse.data['user_info'],
//       );
//     }
//   }
//
//   Future<void> login(
//       // BuildContext context,
//       {required String email, String? phoneWithCode, required String password}) async {
//     showLoading();
//     var request = {'password': password};
//
//     if(phoneWithCode==null){
//       request[ApiKeys.email] = email;
//     }else{
//       request[ApiKeys.phone_with_code] = phoneWithCode;
//     }
//     var jsonResponse = await NewestWebServices.getResponse(
//         apiUrl: ApiUrls.login, request: request);
//     if (jsonResponse.status == 1) {
//       await updateUserDataInSharedPreference(
//           userData: jsonResponse.data[ApiKeys.user_info],
//           token: jsonResponse.data['token']);
//       // ignore: use_build_context_synchronously
//       userNavigationAfterLogin(MyGlobalKeys.navigatorKey.currentContext!);
//     }
//     hideLoading();
//   }
//
//   Future<void> signup(BuildContext context,
//       {required Map<String, dynamic> request}) async {
//     showLoading();
//
//     var response = await NewestWebServices.getResponse(
//         apiUrl: ApiUrls.getOtp, request: request, load: true);
//
//     if (response.status == 1) {
//       hideLoading();
//       bool? result =true;
//       ///Todo commeted
//
//       // bool? result = await CustomNavigation.push(
//       //     context: context,
//       //     screen: VerifyScreen(
//       //       correctOtp: response.data['otp'].toString(),
//       //       phone: request[ApiKeys.phone],
//       //       phoneCode: request[ApiKeys.phoneCode],
//       //     ));
//
//       if(result==true){
//         showLoading();
//         var jsonResponse = await NewestWebServices.getResponse(
//             apiUrl: ApiUrls.signup, request: request);
//         if (jsonResponse.status == 1) {
//           await updateUserDataInSharedPreference(
//               userData: jsonResponse.data[ApiKeys.user_info],
//               token: jsonResponse.data['token']);
//
//           // showSuccesfulRegistration();
//           // ignore: use_build_context_synchronously
//           userNavigationAfterLogin(context);
//         }
//       }else{
//
//       }
//     }
//
//     hideLoading();
//   }
//
//   Future showSuccesfulRegistration()async{
//     return  showSuccessPopup(
//       context: MyGlobalKeys.navigatorKey.currentContext!,
//       heading: "Congratulations!!",
//       subtitle:
//       "Your Registration has been completed Successfully. Admin will check your documents and will get back to you in 3-4 business days",
//       bottomWidget: Center(
//         child: CustomButton(
//           text: "OK",
//           fontSize: 18,
//           fontWeight: FontWeight.w600,
//           height: 50,
//           width: 90,
//           borderRadius: 10,
//           onTap: () {
//             // userType = UserTypeData.Driver;
//             // pushAndRemoveUntil(
//             //     context: MyGlobalKeys.navigatorKey.currentContext!,
//             //     screen: const BottomBarScreen());
//           },
//         ),
//       ),
//     );
//   }
//
//
//
//   Future<bool> checkUniqueness(BuildContext context,
//       {required String email, required String phoneNumberWithCode}) async {
//     showLoading();
//     var request = {ApiKeys.email: email, ApiKeys.phone_with_code: phoneNumberWithCode};
//     var jsonResponse = await NewestWebServices.getResponse(
//         apiUrl: ApiUrls.checkPhoneEmailUniqueness, request: request);
//     if (jsonResponse.status == 1) {
//       hideLoading();
//       return true;
//     }
//     hideLoading();
//     return false;
//
//   }
//
//
//
//
//   getCategoriesAndSubCategories()async{
//     var response =await NewestWebServices.getResponse(apiUrl: ApiUrls.getVehicleTypeList, request: {}, apiMethod: ApiMethod.get);
//     if(response.status==1){
//       globalCategoriesList = response.data[ApiKeys.data];
//     }
//
//     var subresponse =await NewestWebServices.getResponse(apiUrl: ApiUrls.getVehicleModelList, request: {}, apiMethod: ApiMethod.get);
//     if(subresponse.status==1){
//       globalSubCategoriesList = subresponse.data[ApiKeys.data];
//     }
//     notifyListeners();
//     // globalCategoriesList =
//   }
//
//
//   getPackageType()async{
//     var response =await NewestWebServices.getResponse(apiUrl: ApiUrls.getPackageTypeList, request: {}, apiMethod: ApiMethod.get);
//     if(response.status==1){
//       globalPackageTypeList = response.data[ApiKeys.data];
//     }
//
//     notifyListeners();
//     // globalCategoriesList =
//   }
//
//
//   Future<void> forgetPassword(BuildContext context,
//       {required String email}) async {
//     showLoading();
//     var request = {
//       'email': email,
//     };
//     var jsonResponse = await NewestWebServices.getResponse(
//         apiUrl: ApiUrls.forgetPassword,
//         request: request,
//         apiMethod: ApiMethod.post,
//         load: true);
//     if (jsonResponse.status == 1) {
//       // ignore: use_build_context_synchronously
//       CustomNavigation.pop( context);
//       showSnackbar(jsonResponse.message);
//     }
//     hideLoading();
//   }
//
//   Timer? intervalTimer;
//
//
//
//   ValueNotifier<int> unreadMessageCount = ValueNotifier(0);
//   ValueNotifier<int> unreadNotificationsCount = ValueNotifier(0);
//   intervalProviderToCheckBlockStatus()async{
//
//
//     var locationProvider = Provider.of<MyLocationProvider>(MyGlobalKeys.navigatorKey.currentContext!, listen: false);
//
//     intervalTimer?.cancel();
//     intervalTimer = Timer.periodic(Duration(seconds: 50), (timer) {
//       try{
//         Map<String, dynamic> request = {
//
//         };
//         if(locationProvider.latitude!=0){
//           request['latitude'] = locationProvider.latitude;
//           request['longitude'] = locationProvider.longitude;
//           request[ApiKeys.userType] = userDataNotifier.value?.userType;
//         }
//         NewestWebServices.getResponse(apiUrl: ApiUrls.interval, request: request, apiMethod: ApiMethod.put).then((value){
//           if(value.status==1){
//             // var bookingProvider =
//             // Provider.of<BookingProvider>(MyGlobalKeys.navigatorKey.currentContext!,
//             //     listen: false);
//             Map? bookingMap =value.data['latest_bookings'];
//             if(bookingMap!=null){
//             //   myCustomPrintStatement('The user has a new booking ... ${bookingProvider.hasNoBooking.value}  .... ${bookingProvider.isBookingDialogOpen}: ${bookingMap}');
//             //   bookingProvider.hasNoBooking.value = false;
//             //   if(bookingProvider.isBookingDialogOpen == false){
//             //     // bookingProvider.isBookingDialogOpen = true;
//             //     print('opening booking dialog');
//             //     BookingModal bookingModal = BookingModal.fromJson(bookingMap);
//             //     bookingProvider.showBookingPopup(bookingModal);
//             //   }
//             }else{
//               myCustomPrintStatement('The user has no booking');
//               // bookingProvider.hasNoBooking.value = true;
//               // bookingProvider.isBookingDialogOpen = false;
//             }
//             if(value.data['user_status']==1){
//               // unreadMessageCount.value = value.data['unread_message_count'];
//               unreadNotificationsCount.value = value.data['unread_notification_count'];
//
//             }
//             if(value.data['user_status']==2){
//               showSnackbar(value.message);
//               intervalTimer?.cancel();
//               logout(MyGlobalKeys.navigatorKey.currentContext!);
//             }
//
//           }else
//           if(value.data['user_status']==2){
//             showSnackbar(value.message);
//             intervalTimer?.cancel();
//             logout(MyGlobalKeys.navigatorKey.currentContext!);
//           }
//         });
//
//       }catch(e){
//
//       }
//     });
//
//   }
//
//   Future<bool> editProfileFunction({
//     required BuildContext context,
//     required Map<String, dynamic> request,
//     Map<String, dynamic>? files,
//   }) async {
//     showLoading();
//     ResponseModal response;
//
//     if (files == null) {
//       response = await NewestWebServices.getResponse(
//           apiUrl: ApiUrls.editProfile,
//           request: request,
//           apiMethod: ApiMethod.put,
//           showSuccessMessage: true);
//     } else {
//       print('the files are ${files}');
//       for(int i = 0;i<files.keys.length;i++){
//         // print('the files is ${files.keys.toList()[i]}');
//
//         request[files.keys.toList()[i]] = await NewestWebServices.uploadImageAndGetUrl(files[files.keys.toList()[i]].path);
//       }
//       // dead;
//       response = await NewestWebServices.getResponse(
//           apiUrl: ApiUrls.editProfile,
//           request: request,
//           apiMethod: ApiMethod.put,
//           showSuccessMessage: true);
//       // response = await NewestWebServices.postDataWithImageFunction(
//       //     apiUrl: ApiUrls.editProfile,
//       //     body: request,
//       //     files: files,
//       //     apiMethod: ApiMethod.post,
//       //     showSuccessMessage: true);
//     }
//
//     if (response.status == 1) {
//       FirebasePushNotifications.updateDeviceToken();
//       updateUserDataInSharedPreference(
//           userData: response.data[ApiKeys.user_info]);
//       // ignore: use_build_context_synchronously
//       CustomNavigation.pop( context);
//       hideLoading();
//       return true;
//     }
//
//     hideLoading();
//     return false;
//   }
//
//   Future<void> changePassword(
//     BuildContext context, {
//     required Map<String, dynamic> request,
//   }) async {
//     showLoading();
//     var response = await NewestWebServices.getResponse(
//       apiUrl: ApiUrls.changePassword,
//       request: request,
//       apiMethod: ApiMethod.patch,
//       showSuccessMessage: true,
//     );
//     if (response.status == 1) {
//       // ignore: use_build_context_synchronously
//       CustomNavigation.pop( context);
//     }
//     hideLoading();
//   }
//
//   Future<void> languageBottomsheet({required BuildContext context}) async {
//     await customBottomSheet(
//       context,
//       child: Consumer<AppLanguageProvider>(
//           builder: (context, appLanguageProvider, child) {
//             return SizedBox(
//               width: double.infinity,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   vSizedBox,
//                   for(int i = 0;i<languagesList.length;i++)
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 10),
//                     child: CustomGestureDetector(
//                         onTap: () {
//                           appLanguageProvider.changeAppLanguage(languagesList[i]);
//                         },
//                         borderRadiusDouble: 15,
//                         child: commonContainer(
//                             selected: selectedLanguageNotifier==languagesList[i], value: languagesList[i]['value'])),
//                   ),
//                   // vSizedBox,
//                   // CustomGestureDetector(
//                   //   onTap: () {
//                   //     selectedLanguage.value = 1;
//                   //   },
//                   //   borderRadius: 15,
//                   //   child: commonContainer(
//                   //       selected: selectedValue == 1, value: "Arabic"),
//                   // ),
//                   // vSizedBox,
//                   CustomButton(
//                     text: "Update",
//                     onTap: () {
//                       CustomNavigation.pop( context);
//                     },
//                     verticalMargin: 10,
//                     fontSize: 18,
//                     borderRadius: 15,
//                     fontWeight: FontWeight.w700,
//                     color: MyColors.primaryColor,
//                   ),
//                 ],
//               ),
//             );
//           }),
//       isHorizontalPadding: false,
//     );
//   }
//
//   Widget commonContainer({required bool selected, required String value}) {
//     return Container(
//       padding: const EdgeInsets.symmetric(
//           horizontal: globalHorizontalPadding, vertical: 16),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(15),
//         border: Border.all(
//           color: MyColors.blackColor50,
//           width: 1,
//         ),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           MainHeadingText(
//             value,
//             fontWeight: FontWeight.w600,
//             fontSize: 18,
//           ),
//           if (selected)
//             const Icon(
//               Icons.check_circle_sharp,
//               color: MyColors.primaryColor,
//             )
//           else
//             Container(
//               height: 18,
//               width: 18,
//               decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   border: Border.all(width: 1, color: MyColors.blackColor50)),
//             )
//         ],
//       ),
//     );
//   }
//
//   Future<void> contactUs(
//     BuildContext context, {
//     required Map<String, dynamic> request,
//   }) async {
//     showLoading();
//     var jsonResponse = await NewestWebServices.getResponse(
//       apiUrl: ApiUrls.contactUs,
//       request: request,
//       showSuccessMessage: true,
//     );
//     if (jsonResponse.status == 1) {
//       // ignore: use_build_context_synchronously
//       CustomNavigation.pop( context);
//     }
//     hideLoading();
//   }
//
//   Future<void> logoutPopup(context) async {
//     await showCommonAlertDailog(
//       context,
//       imageUrl: MyImagesUrl.logout,
//       headingText: 'Are you sure?',
//       message: 'You want to Logout',
//       actions: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CustomButton(
//               text: "Cancel",
//               isSolid: false,
//               width: 100,
//               onTap: () {
//                 CustomNavigation.pop( context);
//               },
//             ),
//             hSizedBox2,
//             CustomButton(
//                 text: 'Logout',
//                 width: 100,
//                 onTap: () async {
//                   logout(context);
//                 }),
//             hSizedBox,
//           ],
//         ),
//       ],
//     );
//   }
//
//   Future<void> logout(BuildContext context) async {
//     sharedPreference.clear();
//     intervalTimer?.cancel();
//     CustomNavigation.pushAndRemoveUntil(context: context, screen: const LoginPage());
//   }
// }
