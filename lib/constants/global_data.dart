import 'package:connect_app_driver/modal/general_setting_modal.dart';
import 'package:connect_app_driver/modal/user_modal.dart';
import 'package:connect_app_driver/modal/vehicle_type_modal.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_keys.dart';

UserModal? userData;

// ValueNotifier<UserModal?> userDataNotifier = ValueNotifier(null);
String? userToken;

enum ChatMessageType { text, image }

late SharedPreferences sharedPreference;
void unFocusKeyBoard() {
  FocusManager.instance.primaryFocus?.unfocus();
}

GeneralSettingModal generalSettings = GeneralSettingModal(
  adminCommissionInPer: 10,
  serviceFeeInPercent: 5,
);
String fontFamily = "Poppins-Regular";
String cur = "\$";
const String defaultCountryCode = "241";

Map<String, String> globalHeaders = {
  'Accept': 'application/json',
  'Content-Type': 'application/json'
};

List languagesList = [
  {'key': 'en', 'value': 'English'},
  {'key': 'fr', 'value': 'French'},
];

List globalCategoriesList = [];
List globalSubCategoriesList = [];
List globalPackageTypeList = [];
bool runOnLiveLocation = true;
const double globalHorizontalPadding = 18;
const double globalBorderRadius = 15;

List getSubCatetoriesList(categoryId) {
  print('the select cat value  $categoryId');
  List temp = [];
  for (int i = 0; i < globalSubCategoriesList.length; i++) {
    print(
        'the select cat value ${categoryId == globalSubCategoriesList[i][ApiKeys.type_id]} id is ${globalSubCategoriesList[i][ApiKeys.type_id]} comparing to $categoryId');
    if (categoryId == globalSubCategoriesList[i][ApiKeys.type_id]) {
      Map dd = globalSubCategoriesList[i];
      print('sdflks $dd');
      dd['isSelect'] = ValueNotifier(false);
      temp.add(dd);
    }
  }
  return temp;
}

List<VehicleTypeModal> vehicleTypesList = [];
Map<String, VehicleTypeModal> vehicleTypesMap = {};

// List<Map<dynamic,dynamic>> vehicleTypesList = [];
// Map vehicleTypesMap = {};

//
// String getVehicleName(String? id){
//   if(id==null){
//     return 'null';
//   }
//   return vehicleTypesMap[id][ApiKeys.title];
// }
// String getVehicleImage(String? id){
//   if(id==null){
//     return MyImagesUrl.car;
//   }
//   return MyImagesUrl.baseImageUrl+ vehicleTypesMap[id][ApiKeys.image];
// }
