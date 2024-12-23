import 'package:connect_app_driver/constants/global_keys.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../constants/global_data.dart';
import 'location_provider.dart';

class AddShipmentProvider extends ChangeNotifier{


  final formKey = GlobalKey<FormState>();
  final pickupController = TextEditingController();
  ValueNotifier<LatLng> pickuplatLngNotifier = ValueNotifier(LatLng(0, 0));
  ValueNotifier<LatLng> droplatLngNotifier = ValueNotifier(LatLng(0, 0));
  final dropController = TextEditingController();
  final nameController = TextEditingController();
  final weightController = TextEditingController();
  final budgetController = TextEditingController();
  final quantityController = TextEditingController();
  final pickUpDateController = TextEditingController();
  DateTime? pickUpDate;
  final numberController = TextEditingController();
  ValueNotifier<String> selectedCountryCode = ValueNotifier(defaultCountryCode);
  ValueNotifier selectedPackageType = ValueNotifier(null);

  ValueNotifier<List<XFile>> imageList = ValueNotifier([]);





  initializePickAndDropLocations(){

      var locationProvider =
      Provider.of<MyLocationProvider>(MyGlobalKeys.navigatorKey.currentContext!, listen: false);
      pickuplatLngNotifier.value =
          LatLng(locationProvider.latitude, locationProvider.longitude);
      droplatLngNotifier.value =
          LatLng(locationProvider.latitude, locationProvider.longitude);

  }


  resetAllValues()async{
    pickupController.clear();
    dropController.clear();
    nameController.clear();
    weightController.clear();
    budgetController.clear();
    quantityController.clear();
    pickUpDateController.clear();
    numberController.clear();
    pickuplatLngNotifier.value = LatLng(0, 0);
    droplatLngNotifier.value = LatLng(0, 0);
    pickUpDate = null;
    selectedCountryCode.value = defaultCountryCode;
    selectedPackageType.value = null;
    imageList.value = [];
  }
}