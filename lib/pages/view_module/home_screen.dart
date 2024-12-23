// ignore_for_file: deprecated_member_use, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:connect_app_driver/constants/api_keys.dart';
import 'package:connect_app_driver/constants/language_en.dart';
import 'package:connect_app_driver/functions/custom_time_functions.dart';
import 'package:connect_app_driver/functions/print_function.dart';
import 'package:connect_app_driver/pages/bottom_sheet/waiting_for_driver_screen.dart';
import 'package:connect_app_driver/provider/battery_optimization_permission_provider.dart';
import 'package:connect_app_driver/provider/booking_history_provider.dart';
import 'package:connect_app_driver/provider/bottom_sheet_provider.dart';
import 'package:connect_app_driver/provider/internet_connection_provider.dart';
import 'package:connect_app_driver/provider/live_booking_provider.dart';
import 'package:connect_app_driver/provider/location_provider.dart';
import 'package:connect_app_driver/provider/location_update_provider.dart';
import 'package:connect_app_driver/services/google_map_services/google_map_view.dart';
import 'package:connect_app_driver/widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:keep_screen_on/keep_screen_on.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../constants/global_data.dart';
import '../../constants/my_colors.dart';
import '../../constants/my_image_url.dart';
import '../../constants/screen_names.dart';
import '../../constants/sized_box.dart';
import '../../functions/custom_number_formatters.dart';
import '../../main.dart';
import '../../provider/new_firebase_auth_provider.dart';
import '../../widget/app_specific/custom_drawer.dart';
import '../../widget/custom_image.dart';
import '../../widget/custom_scaffold.dart';
import '../../widget/show_snackbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  DateTime? timeBackPressed = DateTime.now();
  PageController pageController = PageController();
  AnimationController? _controller;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  late GoogleMapController googleMapController;
  // ValueNotifier<LatLngModal> currentLatLngNotifier =
  //     ValueNotifier(LatLngModal(lat: 22.699540, lng: 75.879750));

  ValueNotifier<bool> isShowPageViewNoti = ValueNotifier(false);

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      lowerBound: 0.5,
      duration: const Duration(seconds: 3),
    )..repeat();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        var locationProvider =
            Provider.of<MyLocationProvider>(context, listen: false);
        await locationProvider.checkPermission(navigateMap: true);
        KeepScreenOn.turnOn();
        Provider.of<BatteryOptimizationProvider>(context, listen: false)
            .askForPermission();
        Provider.of<BookingHistoryProvider>(context, listen: false)
            .fetchTodaysHistory();
      },
    );
    // var firebaseA = Provider.of<BottomSheetProvider>(context, listen: false);

    super.initState();
  }

  @override
  void dispose() {
    KeepScreenOn.turnOff();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    changeStatusBarColor(
        navigationBarColor: Colors.white, statusBarColor: Colors.white);

    return Consumer<InternetConnectionProvider>(
        builder: (context, internetConnectionValue, _) {
      return ValueListenableBuilder(
        valueListenable: internetConnectionValue.isConnect,
        builder: (context, isNetConnected, child) => CustomScaffold(
          scaffoldKey: _key,
          drawer: const CustomDrawer(),
          bottomNavigationBar: isNetConnected ? null : buildOfflineBar(),
          body: WillPopScope(
            onWillPop: () async {
              return await onWillPopInvoked();
            },
            child: SafeArea(
              child: Stack(
                children: [
                  const GoogleMapView(),
                  Positioned(
                    top: 18,
                    left: 18,
                    right: 18,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _key.currentState!.openDrawer();
                          },
                          child: Image.asset(
                            MyImagesUrl.menu,
                            width: 55,
                          ),
                        ),
                        Row(
                          children: [
                            // GestureDetector(
                            //   onTap: () {
                            //     CustomNavigation.push(
                            //         context: context,
                            //         screen: const NotificationsScreen());
                            //   },
                            //   child: Image.asset(
                            //     MyImagesUrl.notification,
                            //     width: 60,
                            //   ),
                            // ),
                            Consumer<FirebaseAuthProvider>(builder:
                                (context, firebaseAuthProvider, child) {
                              return GestureDetector(
                                onTap: () {},
                                child: CustomImage(
                                  height: 45,
                                  width: 45,
                                  imageUrl: userData?.profileImage ??
                                      MyImagesUrl.profileImage,
                                  borderRadius: 100,
                                  fileType: userData?.profileImage == null
                                      ? CustomFileType.asset
                                      : CustomFileType.network,
                                ),
                              );
                            }),
                          ],
                        )
                      ],
                    ),
                  ),
                  ValueListenableBuilder(
                    valueListenable: isShowPageViewNoti,
                    builder: (context, isShowPageViewValue, child) =>
                        Positioned(
                      top: isShowPageViewValue ? 10 : 24,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          if (!isShowPageViewValue)
                            Consumer<BookingHistoryProvider>(
                              builder: (context, bookingHistory, child) =>
                                  GestureDetector(
                                onTap: () {
                                  isShowPageViewNoti.value =
                                      !isShowPageViewValue;
                                },
                                child: Center(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 3),
                                    decoration: BoxDecoration(
                                        color: MyColors.blackColor,
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: CustomText.headingLarge(
                                      CustomNumberFormatters
                                          .formatNumberInCommasEnWithCurrencyWithoutDecimals(
                                              bookingHistory
                                                  .todayTotalEarningWithoutCommission),
                                      fontSize: 19,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          if (isShowPageViewValue)
                            Consumer<BookingHistoryProvider>(
                              builder: (context, bookingHistory, child) =>
                                  Column(
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    height: 210,
                                    child: PageView.builder(
                                      controller: pageController,
                                      itemCount: 2,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 5),
                                          decoration: BoxDecoration(
                                              color: MyColors.blackColor,
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  IconButton(
                                                    onPressed: () {
                                                      isShowPageViewNoti.value =
                                                          !isShowPageViewValue;
                                                    },
                                                    icon: const Icon(
                                                      Icons.visibility,
                                                      color:
                                                          MyColors.whiteColor,
                                                      size: 20,
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 13,
                                                        vertical: 3),
                                                    decoration: BoxDecoration(
                                                        color:
                                                            MyColors.whiteColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30)),
                                                    child:
                                                        CustomText.headingLarge(
                                                      CustomNumberFormatters
                                                          .formatNumberInCommasEnWithCurrencyWithoutDecimals(index
                                                                  .isOdd
                                                              ? bookingHistory
                                                                  .todayTotalEarningWithoutCommission
                                                              : bookingHistory
                                                                  .lastTripEarningWithOutCommission),
                                                      fontSize: 19,
                                                      color:
                                                          MyColors.blackColor,
                                                    ),
                                                  ),
                                                  IconButton(
                                                    onPressed: () {},
                                                    icon: const Icon(
                                                      Icons.visibility,
                                                      color:
                                                          MyColors.transparent,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              vSizedBox05,
                                              CustomText.headingSmall(
                                                index.isOdd
                                                    ? 'Today'
                                                    : 'Last Trip',
                                              ),
                                              Divider(
                                                color: MyColors.dividerColor,
                                                height: 30,
                                              ),
                                              CustomText.bodyText1(
                                                index.isOdd
                                                    ? translate(
                                                            'TOTAL_TRIP_NUMBER trips completed')
                                                        .replaceAll(
                                                            "TOTAL_TRIP_NUMBER",
                                                            bookingHistory
                                                                .totalTodaybookingCount
                                                                .toString())
                                                    : bookingHistory
                                                                .lastTripTime ==
                                                            null
                                                        ? ""
                                                        : CustomTimeFunctions
                                                            .formatDateInHHMM(
                                                                bookingHistory
                                                                    .lastTripTime!
                                                                    .toDate()),
                                              ),
                                              vSizedBox05,
                                              CustomText.bodyText1(
                                                '${CustomNumberFormatters.formatNumberInCommasEnWithCurrencyWithoutDecimals(index.isEven ? bookingHistory.lastTripEarningWithOutCommission : bookingHistory.todayTotalEarningWithoutCommission)} ${translate("earnings")}',
                                              ),
                                              vSizedBox,
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  SmoothPageIndicator(
                                    controller: pageController,
                                    count: 2,
                                    effect: const WormEffect(
                                      radius: 10,
                                      activeDotColor: Colors.white,
                                      dotHeight: 12,
                                      strokeWidth: 1.5,
                                      paintStyle: PaintingStyle.stroke,
                                      dotColor: Colors.white,
                                      dotWidth: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  if (isNetConnected)
                    Consumer<BottomSheetProvider>(
                        builder: (context, bottomSheetProviderValue, child) {
                      return Consumer<FirebaseAuthProvider>(
                          builder: (context, firebaseAuthProvider, _) {
                        if (!userData!.isOnline) {
                          return Positioned(
                            bottom: 0,
                            left: 18,
                            right: 18,
                            child: GestureDetector(
                              onTap: () async {
                                var locationProvider =
                                    Provider.of<LocationUpdateProvider>(context,
                                        listen: false);
                                locationProvider.firstTimeAtTheApp = true;

                                locationProvider.notifyListeners();
                                // bottomSheetProviderValue.isOfflineNoti.value =
                                //     !isOfflineValue;
                                userData!.isOnline = !userData!.isOnline;
                                Map<String, dynamic> request = {
                                  ApiKeys.isOnline: userData!.isOnline,
                                };
                                FirebaseAuthProvider.editProfile(request);
                                var liveBookingsProvider =
                                    Provider.of<LiveBookingProvider>(context,
                                        listen: false);
                                liveBookingsProvider.listenForCurrentBooking();

                                // bottomSheetProviderValue.bottomPageList = [];
                                bottomSheetProviderValue.pushAndPopUntil(
                                    const NewIncomingRideRequest(),
                                    screenName:
                                        ScreenNames.NewIncomingRideRequest);
                                bottomSheetProviderValue.measureChildSize();
                              },
                              child: AnimatedBuilder(
                                animation: CurvedAnimation(
                                    parent: _controller!,
                                    curve: Curves.fastOutSlowIn),
                                builder: (context, child) {
                                  return Stack(
                                    alignment: Alignment.center,
                                    children: <Widget>[
                                      _buildContainer(35 * _controller!.value),
                                      _buildContainer(70 * _controller!.value),
                                      _buildContainer(105 * _controller!.value),
                                      _buildContainer(140 * _controller!.value),
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundColor:
                                            const Color(0xFF2196F3),
                                        child: CustomText.headingLarge(
                                          'GO',
                                          fontSize: 24,
                                        ),
                                      )
                                    ],
                                  );
                                },
                              ),
                            ),
                          );
                        } else {
                          myCustomPrintStatement(
                              'fdasfasdf ${bottomSheetProviderValue.bottomPageList} ${userData!.isOnline}');
                          return DraggableScrollableSheet(
                            controller:
                                bottomSheetProviderValue.dragScrollController,
                            initialChildSize: 0.2,
                            minChildSize:
                                bottomSheetProviderValue.minimumHeight,
                            maxChildSize: 1,
                            builder: (context, scrollController) {
                              return Container(
                                padding:
                                    const EdgeInsets.fromLTRB(18, 20, 18, 10),
                                decoration: const BoxDecoration(
                                    color: MyColors.blackColor,
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(30))),
                                child: ListView(
                                  controller: scrollController,
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          decoration: const BoxDecoration(
                                              color: MyColors.transparent),
                                          child: Stack(
                                            children: [
                                              if (bottomSheetProviderValue
                                                      .bottomPageList.length !=
                                                  1)
                                                GestureDetector(
                                                  onTap: () {
                                                    bottomSheetProviderValue
                                                        .removePage();
                                                  },
                                                  child: const CircleAvatar(
                                                    radius: 14,
                                                    backgroundColor:
                                                        MyColors.whiteColor,
                                                    child: Icon(
                                                      Icons.arrow_back,
                                                      color:
                                                          MyColors.blackColor,
                                                      size: 16,
                                                    ),
                                                  ),
                                                ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 50,
                                                    height: 4,
                                                    decoration: BoxDecoration(
                                                        color:
                                                            MyColors.whiteColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                            key: bottomSheetProviderValue
                                                .contKey,
                                            padding:
                                                const EdgeInsets.only(top: 35),
                                            child: bottomSheetProviderValue
                                                    .bottomPageList.isEmpty
                                                ? null
                                                : bottomSheetProviderValue
                                                    .bottomPageList.last),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      });
                    })
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  onWillPopInvoked() async {
    // return false;
    var provider = Provider.of<BottomSheetProvider>(context, listen: false);
    if (provider.bottomPageList.length != 1) {
      provider.removePage();
      return false;
    }
    final now = DateTime.now();
    if (timeBackPressed == null ||
        now.difference(timeBackPressed!) > const Duration(seconds: 2)) {
      timeBackPressed = now;
      showSnackbar('Please double tap to exit app');
      return false;
    }
    print(
        "provider.bottomPageList ${provider.bottomPageList} ${now.difference(timeBackPressed!)}");
    return true;
  }

  Widget buildOfflineBar() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        vSizedBox2,
        CustomText.bodyText1(
          "You're offline",
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        vSizedBox2,
      ],
    );
  }

  Widget _buildContainer(double radius) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue.withOpacity(1 - _controller!.value),
      ),
    );
  }
}
