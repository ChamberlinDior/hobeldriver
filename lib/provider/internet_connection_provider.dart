import 'dart:async';

import 'package:connect_app_driver/constants/language_en.dart';
import 'package:connect_app_driver/functions/print_function.dart';
import 'package:connect_app_driver/functions/showCustomDialog.dart';
import 'package:connect_app_driver/services/custom_navigation_services.dart';
import 'package:connect_app_driver/widget/custom_button.dart';
import 'package:connect_app_driver/widget/show_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/sized_box.dart';

class InternetConnectionProvider extends ChangeNotifier {
  int isDialogShow = 0;

  final Connectivity connectivity = Connectivity();

  ValueNotifier<bool> isConnect = ValueNotifier(false);

  late StreamSubscription streamSubscription;
  // getNetworkConnectionType();
  // streamSubscription =        checkNetworkConnection();

  initializeInternetStream() async {
    myCustomLogStatements('Initializing internet connection checker');
    Future.delayed(const Duration(seconds: 2)).then((value) {
      streamSubscription = checkNetworkConnection();
    });
  }

  static Future<bool> internetConnectionCheckerMethod() async {
    bool result = await InternetConnectionChecker().hasConnection;
    return result;
  }

  Future<void> getNetworkConnectionType() async {
    try {
      List<ConnectivityResult> connectivityResult;
      connectivityResult = await connectivity.checkConnectivity();
      // return updateConnectionState(connectivityResult);
    } on PlatformException catch (e) {
      showSnackbar('Somee went rwppds fs');
    }
  }

  BuildContext? context;

  StreamSubscription checkNetworkConnection() {
    bool networkConnection = false;
    return connectivity.onConnectivityChanged.listen((event) async {
      myCustomPrintStatement('sdfdkasjl ${event}');
      networkConnection = await internetConnectionCheckerMethod();
      if (networkConnection) {
        isConnect.value = true;
        if (isDialogShow == 1) {
          // Get.back();
          // try{
          //   CustomNavigation.pop(MyGlobalKeys.navigatorKey.currentState!.context);
          // }catch(e){
          //   myCustomPrintStatement('Error in catch block');
          // }
        }
      } else {
        isConnect.value = false;
        isDialogShow = 1;
        // showInternetConnectionDialog();
        //CD.commonAndroidNoInternetDialog();
        // CM.noInternet();
      }
      // return updateConnectionState(event);
    });
  }

  showInternetConnectionDialog() async {
    return showCustomDialog(child: const InternetConnectionDialog());
  }

  // void updateConnectionState(List<ConnectivityResult> result) {
  //
  //   switch (result) {
  //     case ConnectivityResult.wifi:
  //       notifyListeners();
  //       break;
  //     case ConnectivityResult.mobile:
  //       notifyListeners();
  //       break;
  //     case ConnectivityResult.none:
  //       notifyListeners();
  //       break;
  //     default:
  //       showSnackbar('Network Error! Failed to get Network Status');
  //       break;
  //   }
  // }
}

class InternetConnectionDialog extends StatelessWidget {
  const InternetConnectionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<InternetConnectionProvider>(builder: (context, icp, child) {
      return ValueListenableBuilder<bool>(
          valueListenable: icp.isConnect,
          builder: (context, value, child) {
            if (icp.isConnect.value == true) {
              try {
                CustomNavigation.pop(context);
              } catch (e) {
                myCustomPrintStatement('sdfka');
              }
            }
            return PopScope(
              canPop: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // SubHeadingText(translate('internetConnectionIsNotAvailable')),
                  vSizedBox2,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      vSizedBox05,
                      CustomButton(
                        text: translate('Ok'),
                        isFlexible: true,
                        height: 40,
                        onTap: () {
                          try {
                            var internetProvider =
                                Provider.of<InternetConnectionProvider>(context,
                                    listen: false);
                            if (internetProvider.isConnect.value) {
                              CustomNavigation.pop(context);
                            }
                            // if(Platform.isIOS){
                            //   launchUrl(Uri.parse(defaultAppSettingModal.updateUrlIos));
                            // }else{
                            //   launchUrl(Uri.parse(defaultAppSettingModal.updateUrlAndroid));
                            // }
                          } catch (e) {
                            showSnackbar(
                                'Some Error, please update from store');
                          }
                        },
                      ),
                    ],
                  )
                ],
              ),
            );
          });
    });
  }
}
