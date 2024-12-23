import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_app_driver/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:connect_app_driver/constants/global_keys.dart';
import 'package:connect_app_driver/constants/sized_box.dart';
import 'package:connect_app_driver/functions/print_function.dart';
import 'package:connect_app_driver/functions/showCustomDialog.dart';
// import 'package:connect_app_driver/modals/AdminSettingsModal.dart';
import 'package:connect_app_driver/modal/default_app_settings_modal.dart';
// import 'package:connect_app_driver/services/firebase_collections.dart';
import 'package:connect_app_driver/widget/custom_text.dart';
// import 'package:connect_app_driver/widget/round_edged_button.dart';
import 'package:connect_app_driver/widget/show_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminSettingsProvider extends ChangeNotifier {
  /// run it only once to initialize settings
  // await AdminSettingsProvider.updateDefaultAppSettingsToFirebase();
  /// add this in main function
  // var adminSettingsProvider= Provider.of<AdminSettingsProvider>(context, listen: false);
  // await adminSettingsProvider.getDefaultAppSettings();
  DefaultAppSettingModal defaultAppSettingModal = DefaultAppSettingModal(
    appVersionIos: 1,
    appVersionAndroid: 1,
    hardUpdateVersionIos: 1,
    hardUpdateVersionAndroid: 1,
    updatePopup: true,
    hideOnSubmit: false,
    googleApiKey: "AIzaSyDa_WTU2YPMH_fOPFZz-I9IhI2A9dIYTXI",
    updateUrlAndroid: '',
    updateUrlIos: '',
    updateMessage:
        'New Version is available, Please download latest version from store',
  );
  static final adminSettingCollection =
      FirebaseFirestore.instance.collection('adminSettings');
  static final defaultAppSettingsDocument =
      adminSettingCollection.doc('defaultDriverAppSettings');

  static const appVersionAndroid = 3;
  static const appVersionIos = 3;

  getDefaultAppSettings() async {
    var snapshot = await defaultAppSettingsDocument.get();

    myCustomPrintStatement('the app settings snapshot is $snapshot');
    if (snapshot.exists) {
      bool showPopup = false;
      try {
        defaultAppSettingModal =
            DefaultAppSettingModal.fromJson(snapshot.data() as Map);

        print('the snapshot is ${snapshot.data()}');
        if (defaultAppSettingModal.appVersionAndroid > appVersionAndroid &&
            Platform.isAndroid) {
          print('the snapshot true sd');
          showPopup = true;
        }
        if (defaultAppSettingModal.appVersionIos > appVersionIos &&
            Platform.isIOS) {
          print('the snapshot true sdsdf');
          showPopup = true;
        }

        if (showPopup) {
          await showUpdateDialog();
        }
        notifyListeners();
      } catch (e) {
        myCustomPrintStatement('Error in catch block in admin settings $e');
      }
    }
  }

  showUpdateDialog() async {
    return showCustomDialog(
        child: PopScope(
      // onPopInvoked: (value)async{
      //
      // },
      canPop: false,

      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText.bodyText1(defaultAppSettingModal.updateMessage),
            vSizedBox2,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if ((defaultAppSettingModal.hardUpdateVersionAndroid <=
                            appVersionAndroid &&
                        Platform.isAndroid) ||
                    (defaultAppSettingModal.hardUpdateVersionIos <=
                            appVersionIos &&
                        Platform.isIOS))
                  TextButton(
                      onPressed: () {
                        Navigator.pop(
                            MyGlobalKeys.navigatorKey.currentContext!);
                      },
                      child: CustomText.heading('Remind me later'))
                else
                  vSizedBox,
                CustomButton(
                  text: 'Update',
                  width: 100,
                  height: 40,
                  onTap: () {
                    try {
                      if (Platform.isIOS) {
                        launchUrl(
                            Uri.parse(defaultAppSettingModal.updateUrlIos));
                      } else {
                        launchUrl(
                            Uri.parse(defaultAppSettingModal.updateUrlAndroid));
                      }
                    } catch (e) {
                      showSnackbar('Some Error, please update from store');
                    }
                  },
                ),
              ],
            )
          ],
        ),
      ),
    ));
  }

  static updateDefaultAppSettingsToFirebase() async {
    var request = {
      'appVersionIos': 1,
      'appVersionAndroid': 1,
      'hardUpdateVersionAndroid': 1,
      'hardUpdateVersionIos': 1,
      'updatePopup': true,
      'hideOnSubmit': true,
      'updateUrlAndroid': 'https://www.instagram.com/manish.talreja.50',
      'updateUrlIos': 'https://www.instagram.com/manish.talreja.50',
      'googleApiKey': "AIzaSyDa_WTU2YPMH_fOPFZz-I9IhI2A9dIYTXI",
      'updateMessage':
          'New Version is available, Please download latest version from store',
      // 'googleApiKey': 'AIzaSyBgwFg2GYp7N3LPg1va6Wnr7upfoeku8f0',
    };
    var snapshot = await defaultAppSettingsDocument.get();
    if (snapshot.exists) {
      defaultAppSettingsDocument.update(request);
    } else {
      defaultAppSettingsDocument.set(request);
    }
  }
}


//
// import 'dart:io';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:connect_app_driver/constants/global_keys.dart';
// import 'package:connect_app_driver/constants/sized_box.dart';
// import 'package:connect_app_driver/functions/print_function.dart';
// import 'package:connect_app_driver/functions/showCustomDialog.dart';
// import 'package:connect_app_driver/services/api_urls.dart';
// import 'package:connect_app_driver/services/newest_webservices.dart';
// import 'package:connect_app_driver/widget/old_custom_text.dart';
// import 'package:connect_app_driver/widget/custom_button.dart';
// import 'package:connect_app_driver/widget/show_snackbar.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// import '../modal/default_app_settings_modal.dart';
// import '../services/google_map_services.dart';
//
// class AdminSettingsProvider extends ChangeNotifier {
//
//
//   /// run it only once to initialize settings
//   // await AdminSettingsProvider.updateDefaultAppSettingsToFirebase();
//   /// add this in main function
//   // var adminSettingsProvider= Provider.of<AdminSettingsProvider>(context, listen: false);
//   // await adminSettingsProvider.getDefaultAppSettings();
//
//   bool isFirebase = true;
//
//   DefaultAppSettingModal defaultAppSettingModal = DefaultAppSettingModal(
//     appVersionIos: 1,
//     appVersionAndroid: 1,
//     hardUpdateVersionIos: 1,
//     hardUpdateVersionAndroid: 1,
//     updatePopup: true,
//     googleApiKey: GoogleMapServices.googleMapApiKey,
//     updateUrlAndroid: '',
//     updateUrlIos: '',
//       updateMessage: 'New Version is available, Please download latest version from store',
//       autoCancelPaymentNotDoneInMin:5,
//   autoCancelProviderNotAcceptInMin:15,
//   autoCancelOnProviderNotArrivedInMin:120,
//   autoCancelOnUserNotAccept_ProviderArrivingInMin:45,
//   );
//   static final adminSettingCollection =
//       FirebaseFirestore.instance.collection('adminSettings');
//   static final defaultAppSettingsDocument =
//       adminSettingCollection.doc('defaultAppSettings');
//
//   static const appVersionAndroid = 1;
//   static const appVersionIos = 1;
//
//   getDefaultAppSettings() async {
//     bool showPopup = false;
//     Map? data;
//    if(isFirebase){
//      var snapshot = await defaultAppSettingsDocument.get();
//
//      myCustomPrintStatement('the app settings snapshot is $snapshot');
//      if (snapshot.exists) {
//        data = snapshot.data() as Map;
//
//      }
//    }else{
//      var response = await NewestWebServices.getResponse(apiUrl: ApiUrls.appSettings, request: {}, apiMethod: ApiMethod.get, customHeaders: {
//        'x-api-key': 'phgrew6SDGDF5ra1214er14wer64346rf'
//      });
//      if(response.status==1){
//        data = response.data;
//      }
//    }
//
//     try {
//       defaultAppSettingModal =
//           DefaultAppSettingModal.fromJson(data!);
//
//
//     print('the response for app settings is ${data}');
//     if (defaultAppSettingModal.appVersionAndroid > appVersionAndroid &&
//     Platform.isAndroid) {
//     print('the snapshot true sd');
//     showPopup = true;
//     }
//     if (defaultAppSettingModal.appVersionIos > appVersionIos &&
//     Platform.isIOS) {
//     print('the snapshot true sdsdf');
//     showPopup = true;
//     }
//     } catch (e) {
//     myCustomPrintStatement('Error in catch block in admin settings $e');
//     }
//
//     if (showPopup) {
//       await showUpdateDialog();
//     }
//   }
//
//   showUpdateDialog() async {
//     return showCustomDialog(
//       height: 230,
//         child: PopScope(
//       // onPopInvoked: (value)async{
//       //
//       // },
//       canPop: false,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           SubHeadingText(
//               defaultAppSettingModal.updateMessage),
//           vSizedBox2,
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               if ((defaultAppSettingModal.hardUpdateVersionAndroid <=
//                           appVersionAndroid &&
//                       Platform.isAndroid) ||
//                   (defaultAppSettingModal.hardUpdateVersionIos <=
//                           appVersionIos &&
//                       Platform.isIOS))
//                 TextButton(
//                     onPressed: () {
//                       Navigator.pop(MyGlobalKeys.navigatorKey.currentContext!);
//                     }, child: const SubHeadingText('Remind me later'))
//               else
//                 vSizedBox,
//               CustomButton(
//                 text: 'Update',
//                 width: 100,
//                 height: 40,
//                 onTap: () {
//                   try{
//                     if(Platform.isIOS){
//                       launchUrl(Uri.parse(defaultAppSettingModal.updateUrlIos));
//                     }else{
//                       launchUrl(Uri.parse(defaultAppSettingModal.updateUrlAndroid));
//                     }
//                   }catch(e){
//                     showSnackbar('Some Error, please update from store');
//                   }
//                 },
//               ),
//             ],
//           )
//         ],
//       ),
//     ));
//   }
//
//   static updateDefaultAppSettingsToFirebase() async {
//     var request = {
//       'appVersionIos': 1,
//       'appVersionAndroid': 1,
//       'hardUpdateVersionAndroid': 1,
//       'hardUpdateVersionIos': 1,
//       'updatePopup': true,
//       'updateUrlAndroid': 'https://www.instagram.com/manish.talreja.50',
//       'updateUrlIos': 'https://www.instagram.com/manish.talreja.50',
//       'googleApiKey': GoogleMapServices.googleMapApiKey,
//       'updateMessage': 'New Version is available, Please download latest version from store',
//       // 'googleApiKey': 'AIzaSyBgwFg2GYp7N3LPg1va6Wnr7upfoeku8f0',
//     };
//     var snapshot = await defaultAppSettingsDocument.get();
//     if (snapshot.exists) {
//       defaultAppSettingsDocument.update(request);
//     } else {
//       defaultAppSettingsDocument.set(request);
//     }
//   }
//
//
// }
