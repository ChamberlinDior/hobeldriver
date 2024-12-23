import 'package:connect_app_driver/provider/bank_provider.dart';
import 'package:connect_app_driver/provider/battery_optimization_permission_provider.dart';
import 'package:connect_app_driver/provider/booking_history_provider.dart';
import 'package:connect_app_driver/provider/chat_provider.dart';
import 'package:connect_app_driver/provider/google_map_provider.dart';
import 'package:connect_app_driver/provider/internet_connection_provider.dart';
import 'package:connect_app_driver/provider/live_booking_provider.dart';
import 'package:connect_app_driver/provider/location_update_provider.dart';
import 'package:connect_app_driver/provider/new_firebase_auth_provider.dart';
import 'package:connect_app_driver/provider/schedule_booking_provider.dart';
import 'package:connect_app_driver/provider/term_provider.dart';
import 'package:connect_app_driver/themes/app_themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:connect_app_driver/provider/admin_settings_provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'constants/global_keys.dart';
import 'pages/auth_module/splash_screen.dart';
import 'provider/app_language_provider.dart';
import 'package:provider/provider.dart';

import 'provider/bottom_sheet_provider.dart';
import 'provider/location_provider.dart';
import 'provider/notifications_provider.dart';

void changeStatusBarColor({
  Color statusBarColor = Colors.transparent,
  Color navigationBarColor = Colors.transparent,
}) {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarIconBrightness:
        statusBarColor == Colors.white ? Brightness.dark : Brightness.light,
    systemNavigationBarIconBrightness:
        navigationBarColor == Colors.white ? Brightness.dark : Brightness.light,
    systemNavigationBarColor: statusBarColor, // NAVIGATION  BAR COLOR
    statusBarColor: navigationBarColor, // STATUS BAR COLOR
  ));
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  changeStatusBarColor(
      navigationBarColor: Colors.black, statusBarColor: Colors.black);

  await Firebase.initializeApp();
  FlutterBackgroundService().configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: true,
        isForegroundMode: true, // This ensures the app runs in the background
        initialNotificationTitle: "Holeb Chauffeur",
        initialNotificationContent: "Tracking location in the background",
      ),
      iosConfiguration: IosConfiguration());
  FlutterBackgroundService().startService();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => AppLanguageProvider(),
    ),
    // ChangeNotifierProvider(create: (context) => AuthProvider(),),
    ChangeNotifierProvider(
      create: (context) => AdminSettingsProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => MyLocationProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => NotificationsProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => BottomSheetProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => FirebaseAuthProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => ChatProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => InternetConnectionProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => TermsProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => BankProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => LocationUpdateProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => GoogleMapProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => LiveBookingProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => ScheduleBookingProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => BookingHistoryProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => BatteryOptimizationProvider(),
    ),
  ], child: const MyApp()));
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) {
  WidgetsFlutterBinding.ensureInitialized();

  // You can implement your background logic here, such as location updates.
  FlutterBackgroundService().on("start").listen((event) {
    // This is where we can handle events from the background service.
    print("Background Service Data Received: $event");
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Holeb  Chauffeur',
      theme: CustomAppThemes.darkTheme,
      debugShowCheckedModeBanner: false,
      navigatorKey: MyGlobalKeys.navigatorKey,
      home: const SplashScreen(),
      builder: EasyLoading.init(),
    );
  }
}
