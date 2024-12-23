import 'dart:developer';

import 'package:connect_app_driver/constants/api_keys.dart';
import 'package:connect_app_driver/services/firebase_services/firebase_service.dart';
import 'package:flutter/foundation.dart';
import '../constants/global_data.dart';
import '../constants/types/log_level.dart';

bool showPrintStatements = true;
bool showLogStatements = true;
void myCustomPrintStatement(Object? data,
    {bool showPrint = false, bool overrideDebugCondition = true}) {
  if (showPrintStatements || showPrint) {
    if (kDebugMode || overrideDebugCondition) {
      print('${DateTime.now()} : ${data}');
      return;
    }
  }
}

void myCustomLogStatements(Object? data,
    {bool showLog = false, bool overrideDebugCondition = false}) {
  if (showLogStatements || showLog) {
    if (kDebugMode || overrideDebugCondition) {
      log(data.toString());
      return;
    }
  }
}

void myCustomLogStatementsWithLogs(Object? data,
    {bool showLog = false,
    bool overrideDebugCondition = false,
    bool sendLogToServer = false,
    int logLevel = LogLevel.info}) {
  print('saving losdfg ${sendLogToServer}');
  if (sendLogToServer) {
    print('saving losdfg ${sendLogToServer}');
    try {
      var request = {
        ApiKeys.log_data: data.toString(),
        ApiKeys.userId: userData?.userId,
        ApiKeys.fullName: userData?.fullName,
        ApiKeys.log_datetime: DateTime.now().toString(),
        ApiKeys.log_level: logLevel,
      };
      FirebaseService.saveLogs(request);
    } catch (e) {
      print('as lsa fjslaj ${e}');
    }
  }
  if (showLogStatements || showLog) {
    // if(kDebugMode || overrideDebugCondition){
    log(data.toString());
    return;
    // }
  }
}
