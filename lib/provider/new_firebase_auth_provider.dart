// ignore_for_file: unused_local_variable

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_app_driver/constants/api_keys.dart';
import 'package:connect_app_driver/constants/types/approval_status.dart';
import 'package:connect_app_driver/constants/types/user_type.dart';
import 'package:connect_app_driver/modal/general_setting_modal.dart';
import 'package:connect_app_driver/pages/auth_module/add_vehicle_details_screen.dart';
import 'package:connect_app_driver/pages/auth_module/mobile_number_screen.dart';
import 'package:connect_app_driver/pages/auth_module/verification_screen.dart';
import 'package:connect_app_driver/pages/auth_module/verify_otp_screen.dart';
import 'package:connect_app_driver/pages/view_module/home_screen.dart';
import 'package:connect_app_driver/provider/battery_optimization_permission_provider.dart';
import 'package:connect_app_driver/provider/location_update_provider.dart';
import 'package:connect_app_driver/services/custom_navigation_services.dart';
import 'package:connect_app_driver/services/firebase_services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:connect_app_driver/constants/global_error_constants.dart';
import 'package:connect_app_driver/functions/print_function.dart';
import 'package:connect_app_driver/functions/showCustomDialog.dart';
import 'package:connect_app_driver/provider/location_provider.dart';
import 'package:connect_app_driver/widget/custom_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/global_data.dart';
import '../constants/global_keys.dart';
import '../constants/my_image_url.dart';
import '../constants/sized_box.dart';
import '../functions/easyLoadingConfigSetup.dart';
import '../functions/validation_functions.dart';
import '../modal/user_modal.dart';
import '../modal/vehicle_type_modal.dart';
import '../pages/auth_module/login_screen.dart';
import '../services/firebase_services/firebase_push_notifications.dart';
import '../services/firebase_services/firebase_collections.dart';
import '../services/shared_preference_services/shared_preference_services.dart';
import '../widget/common_alert_dailog.dart';
import '../widget/custom_button.dart';
import '../widget/custom_text.dart';
import '../widget/show_snackbar.dart';
import 'admin_settings_provider.dart';
import 'app_language_provider.dart';
import 'google_map_provider.dart';
import 'internet_connection_provider.dart';

bool isVerifyScreenActive = false;

class FirebaseAuthProvider with ChangeNotifier {
  // User? currentUser;

  FirebaseAuth firebaseInstance = FirebaseAuth.instance;
  StreamSubscription<DocumentSnapshot>? userFirestoreStream;
  // String _verificationId = '';
  // bool _isCodeSent = false;
  String? correctOtp;

  /// ***********used code********

  static editProfile(Map<String, dynamic> request) {
    FirebaseCollections.users.doc(userData!.userId).update(request);
  }

  // bool verifyOtpLoad = false;
  verifyOtpFromTwilio(
    String otp,
  ) async {
    if (otp == correctOtp) {
      // verifyOtpLoad = true;
      showLoading();
      correctOtp = null;
      await setMobileVerificationToTrue();
      userNavigationAfterLogin();
      hideLoading();
    } else {
      print('the toppsdf ${otp}....==${correctOtp}');
      showSnackbar(GlobalErrorConstants.incorrectOtp);
    }
  }

  // verifyOtp(String otp)async{
  //
  //   try {
  //     final AuthCredential credential = PhoneAuthProvider.credential(
  //       verificationId: _verificationId,
  //       smsCode: otp,
  //     );
  //
  //
  //
  //
  //     UserCredential? userCredential;
  //     if(firebaseInstance.currentUser==null){
  //   userCredential = await firebaseInstance
  //           .signInWithCredential(credential);
  //       // firebaseInstance.
  //     }else{
  //   try{
  //     userCredential = await firebaseInstance.currentUser!.linkWithCredential(credential);
  //   }catch(e){
  //     print('Error in catch block 356 $e');
  //     // userCredential =  firebaseInstance.currentUser.u!;
  //   }
  //
  //     }
  //     await setMobileVerificationToTrue();
  //
  //     if (userCredential?.user != null || firebaseInstance.currentUser!=null) {
  //       userNavigationAfterLogin();
  //       print('Successfully signed in');
  //     }
  //   } catch (e) {
  //     print('Failed to sign in: $e');
  //   }
  // }

  createAccount(Map<String, dynamic> request, {required Map files}) async {
    showLoading();

    await firebaseInstance.signOut();
    for (int i = 0; i < files.length; i++) {
      var path = await FirebaseService.uploadImageAndGetUrl(
          (files[files.keys.toList()[i]] as File).path);
      request[files.keys.toList()[i]] = path;
    }

    print('The request for creating account is ${request}');

    UserCredential? credential;
    try {
      credential = await firebaseInstance.createUserWithEmailAndPassword(
        email: request[ApiKeys.email],
        password: request[ApiKeys.password],
      );
      request['uid'] = credential.user!.uid;
      request['createdAt'] = Timestamp.now();
      myCustomPrintStatement(
          'about to set data to uuid ${request['uid']}...,${request}');
      await FirebaseCollections.users.doc(credential.user!.uid).set(request);
    } catch (e) {
      request['uid'] = firebaseInstance.currentUser!.uid;
      request['createdAt'] = Timestamp.now();
      myCustomPrintStatement('about to set data $e ');
      myCustomPrintStatement('the uird ${request['uid']}');
      await FirebaseCollections.users
          .doc(firebaseInstance.currentUser!.uid)
          .update(request);
    }

    if (credential?.user != null || firebaseInstance.currentUser != null) {
      userNavigationAfterLogin();
      myCustomPrintStatement('about to create session');
      await createUpdateSessionOrEndSession(
          userId: userData!.userId,
          isSessionEnded: false,
          isSessionStarted: true);
      // await getAndUpdateUserModal();
      // pushAndRemoveUntil(context: context, screen: BottomBar());
    }
    // print('the user is ${firebaseInstance.}')
    hideLoading();
    // sendOtp(request[ApiKeys.phone_with_code]);
  }

  sendOtpFromTwilio({
    required String phoneWithCode,
  }) async {
    correctOtp = '123456';
    // correctOtp = await TwilioApiServices.sendOtp( phoneWithCode: phoneWithCode);
    notifyListeners();
  }
  // sendOtp(String phoneNumber){
  //   showLoading();
  //   firebaseInstance.verifyPhoneNumber(
  //     // phoneNumber: '+${919691728976}',
  //     phoneNumber: '+${phoneNumber}',
  //     verificationCompleted: (PhoneAuthCredential credential) async {
  //       // var abc = await firebaseInstance.signInWithCredential(credential);
  //       setMobileVerificationToTrue();
  //       print('the abc is verification complete');
  //       // print('the abc is $abc');
  //       hideLoading();
  //     },
  //     verificationFailed: (FirebaseAuthException e) {
  //       if (e.code == 'invalid-phone-number') {
  //         print('The provided phone number is not valid. ');
  //       }
  //       showSnackbar('There was some error in sending otp. $e');
  //       print('the exxxx is $e');
  //       hideLoading();
  //     },
  //     codeSent: (String verificationId, int? resendToken) {
  //       _verificationId = verificationId;
  //       _isCodeSent = true;
  //       print('the code is sent');
  //       hideLoading();
  //     },
  //     codeAutoRetrievalTimeout: (String verificationId) {
  //       // _verificationId = verificationId;
  //       hideLoading();
  //       print('the code auto retrieval');
  //     },
  //   );
  // }

  setMobileVerificationToTrue() async {
    Map<String, dynamic> request = {ApiKeys.isMobileVerified: true};
    print('the user id is ${userData?.userId} and ${userData?.fullData}');
    await FirebaseCollections.users.doc(userData!.userId).update(request);
  }

  setEmailVerificationToTrue(String uid) async {
    Map<String, dynamic> request = {ApiKeys.isEmailVerified: true};
    print('the user id is ${uid}');
    await FirebaseCollections.users.doc(uid).update(request);
  }

  // getVehicleTypes()async{
  //   var snapshot = await FirebaseCollections.vehicleTypesCollection.get();
  //   if(snapshot.docs.isNotEmpty){
  //     vehicleTypesList = List.generate((snapshot.docs).length, (index){
  //       var data = (snapshot.docs)[index].data() as Map;
  //       vehicleTypesMap[data['id']] = data;
  //       return data;
  //     });
  //   }
  //   print('the vehile list is $vehicleTypesList');
  //   print('the vehile map is $vehicleTypesMap');
  //   notifyListeners();
  // }
  getVehicleTypes() async {
    var snapshot = await FirebaseCollections.vehicleTypesCollection.get();
    var general = await FirebaseCollections.adminSettingsCollection
        .doc('generalSettings')
        .get();
    if (general.exists) {
      var data = general.data() as Map<String, dynamic>;
      generalSettings = GeneralSettingModal.fromJson(data);
    }
    if (snapshot.docs.isNotEmpty) {
      vehicleTypesList = List.generate((snapshot.docs).length, (index) {
        var data = (snapshot.docs)[index].data() as Map;
        var modal = VehicleTypeModal.fromJson(data);
        vehicleTypesMap[data['id']] = modal;
        return modal;
      });
    }
    print('the vehile list is $vehicleTypesList');
    print('the vehile map is $vehicleTypesMap');
    notifyListeners();
  }

  splashAuthentication(context) async {
    await FirebasePushNotifications.initializeFirebaseNotifications();
    getVehicleTypes();
    myCustomPrintStatement('in splash authentication');
    // await AdminSettingsProvider.updateDefaultAppSettingsToFirebase();
    var adminSettingsProvider =
        Provider.of<AdminSettingsProvider>(context, listen: false);

    Provider.of<InternetConnectionProvider>(context, listen: false)
        .initializeInternetStream();
    await adminSettingsProvider.getDefaultAppSettings();
    await Permission.notification.request();
    sharedPreference = await SharedPreferences.getInstance();
    var locationProvider = Provider.of<MyLocationProvider>(
        MyGlobalKeys.navigatorKey.currentContext!,
        listen: false);
    var latLng = SharedPreferenceServices.getLocation();
    print('the last saved location is $latLng');
    locationProvider.latitude = latLng.latitude;
    locationProvider.longitude = latLng.longitude;
    var googleMapProvider = Provider.of<GoogleMapProvider>(
        MyGlobalKeys.navigatorKey.currentContext!,
        listen: false);
    if (latLng.latitude != 0 && latLng.longitude != 0) {
      googleMapProvider.initialMapLocation = latLng;
      myCustomLogStatements(
          "initialMapLocation splash authentication ------ ${DateTime.now()}  $latLng");
    }
    var appLanguageProvider =
        Provider.of<AppLanguageProvider>(context, listen: false);
    appLanguageProvider.initializeLanguage();

    /// commented to check 01-07-24
    /// here to write splash functions
    userNavigationAfterLogin();
  }

  bool googleLoad = false;
  showGoogleLoading() {
    googleLoad = true;
    notifyListeners();
  }

  hideGoogleLoading() {
    googleLoad = false;
    notifyListeners();
  }

  signInWithGoogle(BuildContext context) async {
    showGoogleLoading();

    // UserSocialLoginDetailModal? userData=await SocialLoginServices.signInWithGoogle();
    try {
      GoogleSignIn googleSignIn;
      if (Platform.isAndroid) {
        googleSignIn = GoogleSignIn();
      } else {
        ///1 replace client id for android...currently working client id of Simplix
        googleSignIn = GoogleSignIn(
            clientId:
                "603468115777-rmrtsspbvt1vu3kr35g2eonuhofiip9h.apps.googleusercontent.com");
      }
      googleSignIn.signOut();

      GoogleSignInAccount? googleAccount = await googleSignIn.signIn();
      if (googleAccount != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final UserCredential userCredential =
            await firebaseInstance.signInWithCredential(credential);
        await getAndUpdateUserModal(socialLogin: true);
        await setEmailVerificationToTrue(firebaseInstance.currentUser!.uid);
        userNavigationAfterLogin();
      } else {
        showSnackbar('Something went wrong');
      }

      hideGoogleLoading();
    } catch (e) {
      hideGoogleLoading();
      myCustomLogStatements("error is that $e");
    }
  }

  bool facebookLoad = false;
  showFacebookLoading() {
    facebookLoad = true;
    notifyListeners();
  }

  hideFacebookLoading() {
    facebookLoad = false;
    notifyListeners();
  }

  signInWithFacebook(BuildContext context) async {
    showFacebookLoading();

    // UserSocialLoginDetailModal? userData=await SocialLoginServices.facebookLogin();
    final facebookAuth = FacebookAuth.instance;
    facebookAuth.logOut();
    LoginResult facebookLoginResult = await facebookAuth.login();

    // GoogleSignInAccount? googleAccount = await googleSignIn.signIn();
    if (facebookLoginResult.status == LoginStatus.success) {
      final AccessToken? accessToken = facebookLoginResult.accessToken;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: accessToken!.token,
        idToken: (await facebookAuth.getUserData())['id'],
      );
      final UserCredential userCredential =
          await firebaseInstance.signInWithCredential(credential);
      await getAndUpdateUserModal(socialLogin: true);
      await setEmailVerificationToTrue(firebaseInstance.currentUser!.uid);
      userNavigationAfterLogin();
    } else {
      showSnackbar('The facebook account is invalid!');
    }

    hideFacebookLoading();
  }

  userNavigationAfterLogin() async {
    User? currentUser = firebaseInstance.currentUser;
    myCustomPrintStatement(
        'userNavigationAfterLogin my user is ${firebaseInstance.currentUser}');
    if (currentUser == null) {
      CustomNavigation.pushAndRemoveUntil(
          context: MyGlobalKeys.navigatorKey.currentContext!,
          screen: const LoginPage());
    } else {
      bool result = await getAndUpdateUserModal(shouldNotify: false);

      print('the user data is ${userData?.fullData}');

      if (result == false) {
        CustomNavigation.pushAndRemoveUntil(
            context: MyGlobalKeys.navigatorKey.currentContext!,
            screen: const LoginPage());
        showSnackbar('No account created. Please Signup first');
      } else if (userData!.userType == UserType.user) {
        await signOutUser();
        showSnackbar(GlobalErrorConstants.invalidUser, seconds: 5);
      } else {
        if (userData!.isBlocked == true) {
          await signOutUser();
          showSnackbar(GlobalErrorConstants.accountBlocked, seconds: 6);
        } else if (userData?.vehicleModal == null) {
          // safsdfasf
          await CustomNavigation.pushAndRemoveUntil(
              context: MyGlobalKeys.navigatorKey.currentContext!,
              screen: AddVehicleDetails());
        } else {
          setUserListener(currentUser.uid);
          if (userData!.isMobileVerified == false) {
            try {
              await FirebaseAuth.instance.currentUser!.reload();
              if (isVerifyScreenActive == true) {
                showSnackbar('The otp could not be verified!');
              } else {
                if (userData!.phone == null) {
                  CustomNavigation.pushAndRemoveUntil(
                      context: MyGlobalKeys.navigatorKey.currentContext!,
                      screen: const MobileNumberScreen());
                } else {
                  isVerifyScreenActive = true;
                  await CustomNavigation.pushAndRemoveUntil(
                      context: MyGlobalKeys.navigatorKey.currentContext!,
                      screen: VerifyOtpScreen(
                        phoneNumber: userData!.phone!,
                      ));
                  isVerifyScreenActive = false;
                }
              }
            } catch (e) {
              myCustomLogStatements('Error in catch block 3462 $e');
              showSnackbar('Error in catch block 3462...logging out $e');
              CustomNavigation.pushAndRemoveUntil(
                  context: MyGlobalKeys.navigatorKey.currentContext!,
                  screen: const LoginPage());
            }
          } else if (userData!.approvalStatus == ApprovalStatus.approved) {
            createUpdateSessionOrEndSession(
                userId: userData!.userId,
                isSessionEnded: false,
                isSessionStarted: true);
            correctOtp = null;

            var locationUpdateProvider = Provider.of<LocationUpdateProvider>(
                MyGlobalKeys.navigatorKey.currentContext!,
                listen: false);
            locationUpdateProvider.updateLocationToFirebaseTimer();

            FirebasePushNotifications.updateDeviceToken();

            ///The user is properly Logged in condition
            CustomNavigation.pushAndRemoveUntil(
                context: MyGlobalKeys.navigatorKey.currentContext!,
                screen: const HomeScreen());
            try {
              await FirebaseAuth.instance.currentUser!.reload();
              setUserListener(currentUser.uid);
            } catch (e) {
              CustomNavigation.pushAndRemoveUntil(
                  context: MyGlobalKeys.navigatorKey.currentContext!,
                  screen: const LoginPage());
              showSnackbar('Login session expired, you must log in again');
            }
          } else {
            if (userData!.approvalStatus == ApprovalStatus.rejected) {
              showSnackbar('Your account request is rejected by admin');
              CustomNavigation.pushAndRemoveUntil(
                  context: MyGlobalKeys.navigatorKey.currentContext!,
                  screen: const LoginPage());
            } else {
              /// userData!.approvalStatus==ApprovalStatus.pending
              verificationScreenActive = true;
              await CustomNavigation.pushAndRemoveUntil(
                  context: MyGlobalKeys.navigatorKey.currentContext!,
                  screen: const VerificationScreen());
              verificationScreenActive = false;
              notifyListeners();
            }
          }
        }
      }
    }
    notifyListeners();
  }

  bool verificationScreenActive = false;

  Future signup(BuildContext context, Map request) async {
    // await showLoading();

    try {
      // final credential = await FirebaseAuth.instance
      //     .createUserWithEmailAndPassword(
      //   email: request['email'],
      //   password: request['password'],
      // );
      final credential = await firebaseInstance.createUserWithEmailAndPassword(
        email: request['email'],
        password: request['password'],
      );
      request['uid'] = credential.user!.uid;
      request['createdAt'] = Timestamp.now();
      myCustomPrintStatement('about to set data');
      await FirebaseCollections.users.doc(credential.user!.uid).set(request);
      myCustomPrintStatement('about to create my auth listener');
      if (credential.user != null) {
        await userNavigationAfterLogin();

        // await getAndUpdateUserModal();
        // pushAndRemoveUntil(context: context, screen: BottomBar());
      }
      myCustomPrintStatement('about to hide load');
      await hideLoading();
    } on FirebaseAuthException catch (e) {
      await hideLoading();
      if (e.code == 'weak-password') {
        showSnackbar('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showSnackbar(GlobalErrorConstants.accountAlreadyExist);
      }
      return "";
    } catch (e) {
      await hideLoading();
      return "";
    }
  }

  Future<bool> getAndUpdateUserModal(
      {bool shouldNotify = true, bool socialLogin = false}) async {
    await showLoading();
    var querySnapshot = await FirebaseCollections.users
        .doc(firebaseInstance.currentUser!.uid.toString())
        .get();
    // firebaseInstance.
    await hideLoading();
    if (querySnapshot.exists) {
      userData = UserModal.fromJson(
          querySnapshot.data() as Map<String, dynamic>, querySnapshot.id);
      if (shouldNotify) {
        notifyListeners();
      }

      return true;
    } else {
      /// commented to check 02-07-2024
      if (socialLogin == true) {
        var request = {
          ApiKeys.profileImage: firebaseInstance.currentUser?.photoURL ??
              ApiKeys.dummyProfileImage,
          ApiKeys.fullName: firebaseInstance.currentUser?.displayName,
          ApiKeys.email: firebaseInstance.currentUser?.email,
          ApiKeys.phone: firebaseInstance.currentUser?.phoneNumber,
          ApiKeys.isMobileVerified: false,
          ApiKeys.isEmailVerified: true,
          ApiKeys.isOnline: true,
          ApiKeys.isBlocked: false,
          ApiKeys.userType: UserType.driver,
          ApiKeys.approvalStatus: ApprovalStatus.pending,
          ApiKeys.deviceTokens: [],
          ApiKeys.createdAt: Timestamp.now()
        };
        await FirebaseCollections.users
            .doc(firebaseInstance.currentUser!.uid)
            .set(request);
        return true;
      } else {
        ///TODO commented to check 03-07-2024 uncomment it at the end
        // await signOutUser();
        return false;
      }
    }
    return false;
  }

  login({required String emailId, required String password}) async {
    myCustomPrintStatement('dsfsd');
    easyLoadingConfigSetup();
    await showLoading();
    try {
      final credential = await firebaseInstance.signInWithEmailAndPassword(
          email: emailId, password: password);

      print('the credentials are $credential');

      if (credential.user != null) {
        await userNavigationAfterLogin();
      }
      await hideLoading();

      // return credential.user!.uid;
    } on FirebaseAuthException catch (e) {
      await hideLoading();
      myCustomPrintStatement("login checked-----------${e.code}");
      if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'invalid-credential') {
        showSnackbar('${e.code}');
        // showSnackbar('Invalid credentials.');
      }
      // return "";
    }
  }

  forgetPassword(String email) async {
    firebaseInstance.sendPasswordResetEmail(email: email);

    CustomNavigation.pop(MyGlobalKeys.navigatorKey.currentContext!);
    await Future.delayed(Duration(milliseconds: 200));
    showSnackbar(GlobalErrorConstants.passwordResetLinkSent);
  }

  // forgotPassword(context) async {
  //   await showCommonAlertDialog(context,
  //       successIcon: true,
  //       headingText: 'Success',
  //       message:
  //       'We have sent you the password reset link on your registered email. Please check your mail.',
  //       actions: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.end,
  //           children: [
  //             RoundEdgedButton(
  //                 text: 'Ok',
  //                 width: 100,
  //                 height: 40,
  //                 onTap: () async {
  //                   popPage(context: context);
  //                   popPage(context: context);
  //                 }),
  //             hSizedBox,
  //           ],
  //         ),
  //       ]);
  // }

  static BuildContext getContext(contex) {
    return MyGlobalKeys.navigatorKey.currentContext ?? contex;
  }

  Future editProfileEmail(request,
      {BuildContext? context, String? emailId}) async {
    myCustomPrintStatement('editttt ${request}');
    try {
      if (emailId != null && emailId != userData!.email) {
        myCustomPrintStatement(
            'Updating email...${FirebaseAuth.instance.currentUser}');
        final _formKey = GlobalKey<FormState>();
        ValueNotifier<bool> visibility = ValueNotifier(true);
        TextEditingController password = TextEditingController();
        await showCustomDialog(
            height: 250,
            child: Container(
              child: Column(
                children: [
                  CustomText.heading(
                    'Please enter your password to continue',
                    textAlign: TextAlign.center,
                  ),
                  vSizedBox,
                  Form(
                    key: _formKey,
                    child: ValueListenableBuilder(
                      valueListenable: visibility,
                      builder: (_, value, __) => CustomTextField(
                          controller: password,
                          headingText: null,
                          obscureText: value,
                          keyboardType: TextInputType.emailAddress,
                          validator: (val) =>
                              ValidationFunction.passwordValidation(val),
                          // textFieldUnderline: true,
                          // filledColor: MyColors.whiteColor,
                          hintText: 'Enter your password',
                          contentPaddingVertical: 10,
                          // prefix: Image.asset(
                          //   MyImagesUrl.passwordIcon,
                          //   scale: 11,
                          // ),
                          suffix: IconButton(
                            onPressed: () {
                              visibility.value = !value;
                            },
                            icon: Icon(
                              value
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: 19,
                            ),
                          )),
                    ),
                  ),
                  vSizedBox2,
                  CustomButton(
                    text: 'Continue',
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        CustomNavigation.pop(
                            MyGlobalKeys.navigatorKey.currentContext!);
                        // popPage(
                        //     context: MyGlobalKeys.navigatorKey.currentContext!);
                      }
                    },
                  ),
                ],
              ),
            ));
        myCustomPrintStatement('the password is ${password.text}');
        // UserCredential userCredential = await firebaseInstance.signInWithEmailAndPassword(email: 'rohit@gmail.com', password: password.text);
        // UserCredential userCredential = await firebaseInstance.signInWithEmailAndPassword(email: userData!.email, password: password.text);

        AuthCredential authCredential = EmailAuthProvider.credential(
            email: userData!.email, password: password.text);
        myCustomPrintStatement(
            'updating email with user credential $authCredential');
        await FirebaseAuth.instance.currentUser
            ?.reauthenticateWithCredential(authCredential);
        await FirebaseAuth.instance.currentUser!
            .verifyBeforeUpdateEmail(emailId);
        showSnackbar(
            'We have sent email verification link to ${emailId}. It will be automatically updated once you verify the email');
      }
    } catch (e) {
      myCustomPrintStatement('Error in catch block $e');
    }
    await showLoading();

    myCustomPrintStatement('the firebase request is ${request}');
    await FirebaseCollections.users
        .doc(firebaseInstance.currentUser!.uid)
        .update(request);
    await getAndUpdateUserModal();
    // if (context != null) {
    //   CustomNavigation.pop(context);
    // }
  }

  deleteAccount(context) async {
    correctOtp = null;
    await showCommonAlertDailog(
      context,
      imageUrl: MyImagesUrl.deleteIcon,
      headingText: 'Are you sure ?',
      message: 'You want to delete your account',
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
              text: "Cancel ",
              isSolid: false,
              isFlexible: true,
              onTap: () {
                CustomNavigation.pop(context);
              },
            ),
            hSizedBox2,
            CustomButton(
                text: 'Delete',
                isFlexible: true,
                onTap: () async {
                  // logout(context);
                  await signOutUser();
                  CustomNavigation.pushAndRemoveUntil(
                      context: context, screen: const LoginPage());
                }),
            hSizedBox,
          ],
        ),
      ],
    );
  }

  logout(context) async {
    correctOtp = null;
    await showCommonAlertDailog(
      context,
      imageUrl: MyImagesUrl.logout,
      headingText: 'Are you sure?',
      message: 'You want to Logout',
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
              text: "Cancel",
              isSolid: false,
              width: 100,
              onTap: () {
                CustomNavigation.pop(context);
              },
            ),
            hSizedBox2,
            CustomButton(
                text: 'Logout',
                width: 100,
                onTap: () async {
                  // logout(context);
                  await signOutUser();
                  CustomNavigation.pushAndRemoveUntil(
                      context: context, screen: const LoginPage());
                }),
            hSizedBox,
          ],
        ),
      ],
    );
  }

  Future signOutUser() async {
    await showLoading();

    ///TODO ise optimize karna hai
    await FirebaseCollections.users
        .doc(userData!.userId)
        .update({ApiKeys.isOnline: false});
    try {
      try {
        var locationUpdateProvider = Provider.of<LocationUpdateProvider>(
            MyGlobalKeys.navigatorKey.currentContext!,
            listen: false);
        locationUpdateProvider.cancelTimer();
      } catch (e) {
        myCustomPrintStatement('Error in catch block 3333 $e');
      }
      var token = await FirebasePushNotifications.getToken();
      if (token != null) {
        List data = userData!.deviceTokens.toSet().toList();
        myCustomLogStatements('the token is $token and device ids are $data');
        if (data.contains(token)) {
          myCustomLogStatements('token access is now revoked');
          data.remove(token);
        }
        await FirebaseCollections.users
            .doc(userData!.userId)
            .update({ApiKeys.deviceTokens: data});
      }
    } catch (e) {
      print('Error in catch block $e');
    }
    await firebaseInstance.signOut();
    // firebaseInstancecurrentUser=null;
    if (userData != null) {
      createUpdateSessionOrEndSession(
          userId: userData!.userId, isSessionEnded: true);
    }

    userData = null;
    await hideLoading();
    if (userFirestoreStream != null) {
      userFirestoreStream!.cancel();
      userFirestoreStream = null;
    }
    correctOtp = null;

    userNavigationAfterLogin();
  }

  /********copied work*************/

  StreamSubscription<User?>? firebaseUserStreamSubscription;
  Stream<User?>? firebaseUserStream;

  setUserListener(id) {
    userFirestoreStream?.cancel();
    userFirestoreStream = null;
    if (userFirestoreStream == null) {
      Stream<DocumentSnapshot<Object?>> firestoreUserCollection =
          FirebaseCollections.users.doc(id).snapshots();
      try {
        firebaseUserStream = FirebaseAuth.instance.userChanges();

        firebaseUserStreamSubscription = firebaseUserStream!.listen((event) {
          if (event != null) {
            myCustomPrintStatement(
                'event is listened from firebase.......${event!.email}....${userData?.email}');
            if (event.email != null &&
                userData != null &&
                userData!.email != event.email) {
              Map<String, dynamic> request = {"email": event.email};
              FirebaseCollections.users
                  .doc(userData!.userId)
                  .update(request)
                  .then((value) => getAndUpdateUserModal());
            }
          } else {
            myCustomPrintStatement('Error in catch block 3462 event is null');
          }
        });
      } catch (e) {}
      userFirestoreStream = firestoreUserCollection.listen((event) async {
        // myCustomPrintStatement(
        // "event listenitn -$isVerifyScreenActive-------------------- ${event.data()}");
        if (event.exists == false) {
          await signOutUser();
        } else {
          Map data = event.data() as Map;

          try {
            userData = UserModal.fromJson(data, event.id);
            notifyListeners();
          } catch (e) {
            myCustomPrintStatement('Error in catch block 43524 $e');
          }
          if (data[ApiKeys.isBlocked] == true) {
            await signOutUser();
            showSnackbar(GlobalErrorConstants.accountBlocked, seconds: 6);
          }
        }
      });
    }
  }

  Future<bool> sendPasswordResetLink(context, email) async {
    myCustomPrintStatement("email ---------------$email");

    await showLoading();
    try {
      // var fireAuth = FirebaseAuth.instance;

      await firebaseInstance.sendPasswordResetEmail(
        email: email,
      );

      myCustomPrintStatement('slkdfjl......');
      await hideLoading();

      // forgotPassword(context);
      return true;
      // showSnackbar("Password reset link has been sent to your email");
      // return true;
    } on FirebaseAuthException catch (e) {
      await hideLoading();
      myCustomPrintStatement("error-----------------------" + e.toString());
      if (e.code == "user-not-found") {
        showSnackbar("Email not found");
      } else if (e.code == "invalid-email") {
        showSnackbar("Invalid email");
      }
      return false;

      // return false;
    } catch (e) {
      myCustomPrintStatement('slkdfjl $e');
      return false;
    }
  }

  Future<bool> changePassword(BuildContext context,
      {required String oldpassword, required String newpassword}) async {
    String email = userData!.email;

    await showLoading();

    try {
      UserCredential userCredential =
          await firebaseInstance.signInWithEmailAndPassword(
        email: email,
        password: oldpassword,
      );

      myCustomPrintStatement("user credenticals  ${userCredential.user}");

      return userCredential.user!.updatePassword(newpassword).then((_) async {
        showSnackbar("Successfully changed password");

        await hideLoading();
        CustomNavigation.pop(context);
        myCustomPrintStatement('snackbaropen');
        showSnackbar('Password changed successfully.');
        myCustomPrintStatement('before returning true');
        return true;
      }).catchError((error) async {
        myCustomPrintStatement(
            "Password can't be changed" + error.code.toString());
        await hideLoading();
        // if(error=='')
        if (error.code.toString() == "weak-password") {
          showSnackbar('Password should be atlease 6 character');
        }
        myCustomPrintStatement(
            "Password can't be changed" + error.code.toString());
        return false;
        //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
      });
    } on FirebaseAuthException catch (e) {
      await hideLoading();
      if (e.code == 'user-not-found') {
        myCustomPrintStatement('No user found for that email.');
      } else if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        showSnackbar('Your current password  is incorrect.');
      }
      return false;
    }
  }

  Future<bool> isPhoneNumberUnique(String phoneWithCode) async {
    var snapshots = await FirebaseCollections.users
        .where(ApiKeys.phone_with_code, isEqualTo: phoneWithCode)
        .get();
    if (snapshots.docs.isEmpty) {
      return true;
    }
    return false;
  }

  Future<bool> isEmailUnique(String email) async {
    var snapshots = await FirebaseCollections.users
        .where(ApiKeys.email, isEqualTo: email)
        .get();
    if (snapshots.docs.isEmpty) {
      return true;
    }
    return false;
  }

  Future<bool> checkUniqueValidation({
    required String phoneNumber,
    required String email,
  }) async {
    showLoading();
    if (await isEmailUnique(email)) {
      if (await isPhoneNumberUnique(phoneNumber)) {
        hideLoading();
        return true;
      }

      showSnackbar(GlobalErrorConstants.accountAlreadyExistNumber);
    } else {
      showSnackbar(GlobalErrorConstants.accountAlreadyExist);
    }
    hideLoading();
    return false;
  }

  Future showLoading() async {
    if (!EasyLoading.isShow) {
      await EasyLoading.show(status: null, maskType: EasyLoadingMaskType.black);
    }
  }

  Future hideLoading() async {
    if (EasyLoading.isShow) {
      await EasyLoading.dismiss();
    }
  }

  Future createSession({required String userId}) async {
    Map<String, dynamic> data = {
      "sessionStartTime": Timestamp.now(),
      "sessionEndTime": Timestamp.now(),
      'isSessionActive': true,
    };
    myCustomPrintStatement('Adding session to user collection');
    await FirebaseCollections.sessionCollection(userId)
        .doc((data['sessionStartTime'] as Timestamp)
            .millisecondsSinceEpoch
            .toString())
        .set(data);
  }

  contactUsFunction({required String comment}) async {
    await FirebaseCollections.contactUs.doc().set({
      "name": userData!.fullName,
      "phoneNumber": userData!.phoneWithCode,
      "emailId": userData!.email,
      "comment": comment,
      "isDriver": true,
      "isRead": false,
      ApiKeys.requestedBy: userData!.userId,
      ApiKeys.createdAt: Timestamp.now()
    });

    showSnackbar(
        "Thank you for contacting us! We’ll get back to you within 24 hours.");
  }

  Future createUpdateSessionOrEndSession({
    required String userId,
    bool isSessionEnded = true,
    bool isSessionStarted = false,
    bool isSessionPaused = false,
    bool isSessionActive = false,
  }) async {
    return;
    try {
      bool destroyAndCreateNewSession = false;
      myCustomPrintStatement('inside creating session with userId ${userId}');
      Map<String, dynamic> data = {
        // "sessionStartTime": DateTime.now(),
        "sessionEndTime": Timestamp.now(),
        'isSessionActive': isSessionActive,
        'sessionPaused': isSessionPaused,
      };
      if ((await FirebaseCollections.users.doc(userId).get()).exists == false) {
        return;
      }
      var snapshots = await FirebaseCollections.sessionCollection(userId)
          .where('isSessionActive', isEqualTo: true)
          .get();
      myCustomPrintStatement('the snapshot length is ${snapshots.docs.length}');
      if (snapshots.docs.isEmpty) {
        await createSession(userId: userId);
      } else {
        int lastUpdatedInMinutes = 0;
        for (int i = 0; i < snapshots.docs.length; i++) {
          Map dd = snapshots.docs[i].data() as Map;
          if (dd['sessionPaused'] == true) {
            Timestamp timeEnd = dd['sessionEndTime'];
            lastUpdatedInMinutes =
                timeEnd.toDate().difference(DateTime.now()).inMinutes;
            myCustomPrintStatement(
                'firebase the last updated minutes are minutes $lastUpdatedInMinutes...${timeEnd.toDate()}....${DateTime.now()}');
            if (lastUpdatedInMinutes > 2) {
              // Map<String,dynamic> temp = {
              //   // "sessionStartTime": DateTime.now(),
              //   "sessionEndTime": Timestamp.now(),
              //   'isSessionActive': false,
              // };
              // FirebaseCollections.sessionCollection(userId).doc(snapshots.docs[i].id).update(temp);
              destroyAndCreateNewSession = true;
            } else {
              myCustomPrintStatement(
                  'firebase creating new session as the sesison is paused from 2 minutes $lastUpdatedInMinutes');
            }
          }

          FirebaseCollections.sessionCollection(userId)
              .doc(snapshots.docs[i].id)
              .update(data);
        }
        if (destroyAndCreateNewSession) {
          await createSession(userId: userId);
        }
      }
    } catch (e) {
      myCustomPrintStatement('Error in catch block $e');
    }
  }
}
