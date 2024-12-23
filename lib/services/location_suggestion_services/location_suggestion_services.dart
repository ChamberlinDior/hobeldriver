// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'dart:async';

import 'package:connect_app_driver/constants/global_data.dart';
import 'package:connect_app_driver/constants/global_keys.dart';
import 'package:connect_app_driver/widget/custom_button.dart';
import 'package:connect_app_driver/widget/custom_text.dart';
import 'package:connect_app_driver/widget/custom_text_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../constants/my_colors.dart';
import '../../constants/my_image_url.dart';
import '../../constants/sized_box.dart';
import '../../functions/print_function.dart';
import '../../functions/showCustomDialog.dart';
import '../../provider/location_provider.dart';
import '../../widget/location_permission.dart';
import '../custom_navigation_services.dart';
import '../google_map_services.dart';

class LocationSuggestionServices {
  GoogleMapController? googleMapController;
  TextEditingController searchController = TextEditingController();
  String previousLocation = "";
  FocusNode searchByLocationFocusNode = FocusNode();
  ValueNotifier<List> predictions = ValueNotifier([]);
  ValueNotifier<LatLng> latLngValueNotifier =
      ValueNotifier(const LatLng(22.70040, 75.875));
  ValueNotifier<bool> showAll = ValueNotifier(false);
  bool start = false;
  String hintText;
  Timer? searchTimer;
  String prefixImage;
  String pinLocationImage;
  double horizontalPadding = 0;
  Function()? onSelectLocation;

  LocationSuggestionServices({
    this.hintText = 'Search here',
    this.prefixImage = MyImagesUrl.location,
    this.pinLocationImage = MyImagesUrl.pin_location_green,
    this.onSelectLocation,
  });

  navigateToMyLocation() async {
    predictions.value = [];
    searchByLocationFocusNode.unfocus();

    var locationProvider = Provider.of<MyLocationProvider>(
        MyGlobalKeys.navigatorKey.currentContext!,
        listen: false);
    latLngValueNotifier.value =
        LatLng(locationProvider.latitude, locationProvider.longitude);

    print('the lat long is ${latLngValueNotifier.value}');

    searchController.text = await GoogleMapServices.getAddressFromLatLng(
        latLngValueNotifier.value.latitude,
        latLngValueNotifier.value.longitude);
    previousLocation = searchController.text;

    // if (getPetSittersListValue) {
    //   await getPetSitterList();
    // }

    googleMapController!.animateCamera(
      CameraUpdate.newLatLng(latLngValueNotifier.value),
    );
    if (onSelectLocation != null) {
      onSelectLocation!();
    }
  }

  showCustomLocationPicker({double? lat, double? lng}) async {
    TextEditingController searchController = TextEditingController();
    FocusNode searchByLocationFocusNode = FocusNode();
    CameraPosition? previousCameraPosition;
    var locationProvider = Provider.of<MyLocationProvider>(
        MyGlobalKeys.navigatorKey.currentContext!,
        listen: false);
    ValueNotifier<LatLng> latLngValueNotifier = ValueNotifier(LatLng(
        lat ?? locationProvider.latitude, lng ?? locationProvider.longitude));

    ValueNotifier<bool> isClear = ValueNotifier(false);
    ValueNotifier<List> predictions = ValueNotifier([]);
    return showCustomDialog(
      height: 600,
      horizontalInsetPadding: 20,
      horizontalPadding: 16,
      child: Stack(children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    CustomNavigation.pop(
                        MyGlobalKeys.navigatorKey.currentContext!);
                    searchByLocationFocusNode.unfocus();
                    unFocusKeyBoard();
                  },
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            ValueListenableBuilder(
                valueListenable: predictions,
                builder: (context, predictionsValue, child) {
                  return ValueListenableBuilder(
                      valueListenable: isClear,
                      builder: (context, isClearValue, child) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding),
                          child: CustomTextField(
                            controller: searchController,
                            readOnly: true,
                            focusNode: searchByLocationFocusNode,
                            headingText: null,
                            hintText: isClearValue
                                ? "Enter location..."
                                : 'Detecting location...',
                            onTap: () async {
                              predictions.notifyListeners();
                            },
                            onChanged: (val) async {
                              if (val.isEmpty) {
                                isClear.value = true;
                              }
                              print('sfadsfsdfsd');
                              // Image image = Image(image: AssetImage(MyImagesUrl.homeLocationPinRed));
                              // ByteData data = await rootBundle.load(MyImagesUrl.homeLocationPinRed);
                              // myCustomLogStatements('sdfksjflk ${ data.buffer.asUint8List()}');
                              // return;
                              predictions.value =
                                  await GoogleMapServices.getPlacePridiction(
                                      val);
                              print('the results are ${predictions.value}');
                            },
                            prefix: Image.asset(
                              pinLocationImage,
                              scale: 12,
                              height: 12,
                            ),
                            suffix: predictionsValue.isEmpty &&
                                    searchByLocationFocusNode.hasFocus == false
                                ? null
                                : GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    child: const Icon(Icons.close),
                                    onTap: () {
                                      FocusScope.of(context).requestFocus(
                                          searchByLocationFocusNode);
                                      predictions.value.clear();
                                      isClear.value = true;
                                      predictions.notifyListeners();
                                      searchController.clear();
                                    },
                                  ),
                          ),
                        );
                      });
                }),
            vSizedBox,
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: latLngValueNotifier,
                builder: (_, latLngValue, __) => Stack(
                  children: [
                    GoogleMap(
                      onCameraMove: (CameraPosition position) async {
                        if (previousCameraPosition != position) {
                          if (searchController.text.isEmpty) {
                            isClear.value = false;
                          }
                          //     myCustomPrintStatement(
                          //         "current move value $position");
                          latLngValueNotifier.value = position.target;
                          // latLngValueNotifier.value.latitude=argument.latitude;
                          // onMapScrolled(
                          //         context: context, argument: position.target);
                          //     previousCameraPosition = position;
                        }
                      },
                      onCameraIdle: () async {
                        myCustomPrintStatement("current not move value ");
                        searchController.text =
                            await GoogleMapServices.getAddressFromLatLng(
                                latLngValueNotifier.value.latitude,
                                latLngValueNotifier.value.longitude);
                        print('sdfklsflk ${searchController.text}....');
                      },
                      gestureRecognizers: {
                        Factory<OneSequenceGestureRecognizer>(
                            () => EagerGestureRecognizer())
                      },
                      onMapCreated: (GoogleMapController controller) {
                        googleMapController = controller;
                      },
                      initialCameraPosition: CameraPosition(
                        target: latLngValueNotifier.value,
                        zoom: 12,
                      ),
                      rotateGesturesEnabled: true,
                      indoorViewEnabled: true,
                      compassEnabled: true,
                      zoomControlsEnabled: false,
                      // markers: markers.toSet(),
                    ),
                    Center(
                      child: Image.asset(
                        pinLocationImage,
                        scale: 10,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: IconButton(
                        onPressed: () {
                          getGPS(
                                  context:
                                      MyGlobalKeys.navigatorKey.currentContext!)
                              .then((value) {
                            // createSitterProvider.latLngValueNotifier.value =
                            //     LatLng(
                            //   double.parse(value!['lat']),
                            //   double.parse(
                            //     value['lng'],
                            //   ),
                            // );
                            myCustomPrintStatement(
                                "Current location lat lang ${double.parse(value!['lat'])} -----${double.parse(
                              value['lng'],
                            )}");
                            googleMapController!
                                .animateCamera(CameraUpdate.newLatLng(LatLng(
                              double.parse(value['lat']),
                              double.parse(
                                value['lng'],
                              ),
                            )));
                            // onMapScrolled(
                            //     context: context,
                            //     argument: LatLng(
                            //       double.parse(value!['lat']),
                            //       double.parse(
                            //         value['lng'],
                            //       ),
                            //     ));
                          });
                        },
                        icon: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: MyColors.whiteColor,
                          ),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(
                            Icons.my_location_sharp,
                            color: MyColors.blueColor,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            CustomButton(
              text: 'Confirm',
              horizontalMargin: horizontalPadding,
              onTap: () {
                CustomNavigation.pop(MyGlobalKeys.navigatorKey.currentContext!,
                    latLngValueNotifier.value);
                unFocusKeyBoard();
                FocusScope.of(
                  MyGlobalKeys.navigatorKey.currentContext!,
                ).requestFocus(FocusNode());
              },
            ),
          ],
        ),
      ]),
    );
  }

  Widget getPredictionsDropdown({
    bool getPetSittersListValue = false,
  }) {
    return ValueListenableBuilder(
        valueListenable: showAll,
        builder: (context, value, child) {
          return ValueListenableBuilder(
              valueListenable: predictions,
              builder: (c, p, w) {
                print("datadtadta::::::::${value}");
                if (!value) {
                  return Container();
                }
                return Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: MyColors.primaryColor),
                      borderRadius: BorderRadius.circular(8)),
                  // height: 300,
                  constraints: const BoxConstraints(
                    // minHeight: 100,
                    maxHeight: 220,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          predictions.value = [];
                          FocusScope.of(
                                  MyGlobalKeys.navigatorKey.currentContext!)
                              .requestFocus(FocusNode());

                          LatLng? val = await showCustomLocationPicker(
                              lat: latLngValueNotifier.value.latitude,
                              lng: latLngValueNotifier.value.longitude);
                          if (val != null) {
                            latLngValueNotifier.value = val;
                          }

                          print('the lat long is ${latLngValueNotifier.value}');

                          searchController.text =
                              await GoogleMapServices.getAddressFromLatLng(
                                  latLngValueNotifier.value.latitude,
                                  latLngValueNotifier.value.longitude);

                          previousLocation = searchController.text;

                          // if (getPetSittersListValue) {
                          //   await getPetSitterList();
                          // }

                          googleMapController?.animateCamera(
                            CameraUpdate.newLatLng(latLngValueNotifier.value),
                          );
                          if (onSelectLocation != null) {
                            onSelectLocation!();
                          }
                          // pickupLocation['lng'] =address['result']['geometry']['location']['lng'] ;
                          // _focusDrop.requestFocus();
                        },
                        child: Container(
                          width: MediaQuery.of(
                                  MyGlobalKeys.navigatorKey.currentContext!)
                              .size
                              .width,
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(),
                          child: CustomText.bodyText1(
                            'Pin Location On Map',
                            color: Colors.black,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          navigateToMyLocation();
                        },
                        child: Container(
                          width: MediaQuery.of(
                                  MyGlobalKeys.navigatorKey.currentContext!)
                              .size
                              .width,
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            border: Border(
                                bottom:
                                    // i == p.length - 1
                                    //     ?
                                    BorderSide.none
                                //     :
                                // const BorderSide(
                                //   color: MyColors.greenColor,
                                // ),
                                ),
                          ),
                          child: CustomText.bodyText1(
                            'My Current Location',
                            color: Colors.black,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Flexible(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              vSizedBox05,
                              for (int i = 0; i < p.length; i++)
                                GestureDetector(
                                  onTap: () async {
                                    searchController.text = p[i]['description'];

                                    previousLocation = searchController.text;

                                    String placeId = p[i]['place_id'];
                                    predictions.value = [];
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    var address = await GoogleMapServices
                                        .getLatLngByPlaceId(placeId);
                                    latLngValueNotifier.value = LatLng(
                                        address['result']['geometry']
                                            ['location']['lat'],
                                        address['result']['geometry']
                                            ['location']['lng']);

                                    try {
                                      googleMapController!.animateCamera(
                                        CameraUpdate.newLatLng(
                                          LatLng(
                                              address['result']['geometry']
                                                  ['location']['lat'],
                                              address['result']['geometry']
                                                  ['location']['lng']),
                                        ),
                                      );
                                    } catch (e) {
                                      myCustomPrintStatement(
                                          'Error in catch block 345');
                                    }
                                    if (onSelectLocation != null) {
                                      onSelectLocation!();
                                    }
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.all(10),
                                    decoration: const BoxDecoration(
                                        // border: Border(
                                        //   bottom:
                                        //
                                        //       const BorderSide(
                                        //     color: MyColors.primaryColor,
                                        //   ),
                                        // ),
                                        ),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          MyImagesUrl.location,
                                          height: 18,
                                        ),
                                        hSizedBox05,
                                        Expanded(
                                          child: CustomText.bodyText1(
                                            p[i]['description'],
                                            color: Colors.black,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              });
        });
  }

  Widget showTextField({
    bool showOtherOptions = false,
    final Function(String)? onChanged,

    // required FocusNode searchByLocationFocusNode,
  }) {
    // if(searchController.text.isEmpty){
    //   var provider = Provider.of(context, listen: false)
    // }
    return ValueListenableBuilder(
        valueListenable: predictions,
        builder: (context, predictionsValue, child) {
          return CustomTextField(
              controller: searchController,
              focusNode: searchByLocationFocusNode,
              headingText: null,
              hintText: hintText,

              ///'Detecting location...',
              // textFieldBorderColor: MyColors.whiteColor,
              contentPaddingVertical: 8,
              // onSubmit: (value) async {
              //   if(getPetSittersList)
              //     {
              //       if(value!.trim().isNotEmpty)
              //       {
              //         if (predictions.value.isNotEmpty) {
              //           //searchController.text = predictions.value.first['description'];
              //           String placeId = predictions.value.first['place_id'];
              //           predictions.value = [];
              //           FocusScope.of(context).requestFocus(FocusNode());
              //           var address =
              //           await GoogleMapServices.getLatLngByPlaceId(placeId);

              //           latLngValueNotifier.value = LatLng(
              //               address['result']['geometry']['location']['lat'],
              //               address['result']['geometry']['location']['lng']);
              //           await getPetSitterList();
              //           googleMapController!.animateCamera(
              //             CameraUpdate.newLatLng(
              //               LatLng(
              //                   address['result']['geometry']['location']['lat'],
              //                   address['result']['geometry']['location']['lng']),
              //             ),
              //           );
              //         } else {
              //           showSnackbar("No results found. Select a suggestion or check input.");
              //         }
              //       }
              //       else
              //       {
              //         showSnackbar("Please enter something. For get result.");
              //       }
              //     }

              // },
              onTap: () async {
                searchByLocationFocusNode.addListener(() async {
                  showAll.value = searchByLocationFocusNode.hasFocus;
                  if (!start) {
                    start = true;
                    if (!showAll.value &&
                        searchController.text.trim().isEmpty) {
                      searchController.text = previousLocation;
                      start = false;
                    } else if (!showAll.value) {
                      if (predictions.value.isNotEmpty) {
                        String placeId = predictions.value.first['place_id'];
                        FocusScope.of(context).requestFocus(FocusNode());
                        var address =
                            await GoogleMapServices.getLatLngByPlaceId(placeId);
                        searchController.text =
                            predictions.value.first['description'];
                        previousLocation = searchController.text;
                        latLngValueNotifier.value = LatLng(
                            address['result']['geometry']['location']['lat'],
                            address['result']['geometry']['location']['lng']);
                        start = false;
                        googleMapController!.animateCamera(
                          CameraUpdate.newLatLng(
                            LatLng(
                                address['result']['geometry']['location']
                                    ['lat'],
                                address['result']['geometry']['location']
                                    ['lng']),
                          ),
                        );
                      } else {
                        searchController.text = previousLocation;
                        start = false;
                      }
                    }
                    start = false;
                  }
                });
                FocusScope.of(context).requestFocus(searchByLocationFocusNode);
                predictions.notifyListeners();
              },
              onChanged: onChanged ??
                  (val) async {
                    if (val.isNotEmpty) {
                      const duration = Duration(milliseconds: 300);
                      if (searchTimer != null) {
                        searchTimer?.cancel(); // clear timer
                      }
                      searchTimer = Timer(duration, () async {
                        predictions.value =
                            await GoogleMapServices.getPlacePridiction(val);
                      });
                    } else {
                      hintText = "Enter location...";
                      predictions.value.clear();
                      if (searchTimer != null) {
                        searchTimer?.cancel();
                      }
                    }
                    print('the results are ${predictions.value}');
                  },
              prefix: Image.asset(
                prefixImage,
                color: MyColors.whiteColor,
                scale: 4,
              ),
              suffix: predictionsValue.isEmpty &&
                      searchByLocationFocusNode.hasFocus == false
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () async {
                        // FocusScope.of(context).requestFocus(FocusNode());
                        myCustomPrintStatement('The close icon is pressed');

                        predictions.value.clear();
                        //  predictions.notifyListeners();
                        searchController.clear();
                        predictions.notifyListeners();

                        FocusScope.of(context)
                            .requestFocus(searchByLocationFocusNode);
                        // Future.delayed(Duration(milliseconds: 200)).then((val){
                        //   FocusScope.of(context).requestFocus(FocusNode());
                        // });
                        // FocusScope.of(context).requestFocus(FocusNode());
                      },
                    ));
        });
  }
}
