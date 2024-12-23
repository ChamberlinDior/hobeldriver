import 'package:connect_app_driver/constants/global_keys.dart';
import 'package:flutter/material.dart';

import '../functions/compareList.dart';
import '../functions/print_function.dart';

class BottomSheetProvider extends ChangeNotifier {
  // ValueNotifier<bool> isOfflineNoti = ValueNotifier(true);
  ValueNotifier<double> initialChildSizeNotifier = ValueNotifier(0.3);

  DraggableScrollableController dragScrollController =
      DraggableScrollableController();
  List<Widget> bottomPageList = [];
  List<String> bottomPageListScreenNames = [];

  ValueNotifier<bool> hide = ValueNotifier(false);

  List<String> screensAfterBooking = [];

  removeAllBookingPagesIfAny() async {
    if (compareLists(bottomPageListScreenNames, screensAfterBooking)) {
      // pushAndPopUntil(SelectDestination(), screenName: ScreenNames.SelectDestination);
      removePageUntil();
    }
  }

  pushAndPopUntil(Widget page,
      {bool fullHeight = false,
      double? height,
      required,
      required String screenName}) {
    bottomPageList.clear();
    bottomPageListScreenNames.clear();
    addPage(page,
        height: height, screenName: screenName, fullHeight: fullHeight);
    notifyListeners();
    measureChildSize();
  }
  // addPage(Widget page){
  //   initialChildSizeNotifier.value=0.8;
  //    bottomPageList.add(page);
  //    notifyListeners();
  //    measureChildSize();
  // }

  void addPage(
    Widget page, {
    bool fullHeight = false,
    double? height,
    required String screenName,
  }) {
    myCustomPrintStatement(
        'Adding page ... ${screenName}.... ${bottomPageListScreenNames}');
    if (bottomPageListScreenNames.contains(screenName)) {
      myCustomPrintStatement(
          'The screen name is same $screenName...this is present in the index');
    } else {
      bottomPageList.add(page);
      bottomPageListScreenNames.add(screenName);
    }
    notifyListeners();
    try {
      measureChildSize(fullHeight: fullHeight, height: height);
    } catch (e) {
      myCustomPrintStatement('Error in catch block $e');
    }
  }

  void addPageAndRemovePrevious(
    Widget page, {
    bool fullHeight = false,
    double? height,
    required String screenName,
  }) {
    myCustomPrintStatement(
        'Adding page ... ${screenName}.... ${bottomPageListScreenNames}');
    if (bottomPageListScreenNames.contains(screenName)) {
      myCustomPrintStatement(
          'The screen name is same $screenName...this is present in the index');
    } else {
      if (bottomPageList.isNotEmpty) {
        bottomPageList.removeLast();
      }
      if (bottomPageList.isNotEmpty) {
        bottomPageListScreenNames.removeLast();
      }
      bottomPageList.add(page);
      bottomPageListScreenNames.add(screenName);
    }
    notifyListeners();
    try {
      measureChildSize(fullHeight: fullHeight, height: height);
    } catch (e) {
      myCustomPrintStatement('Error in catch block $e');
    }
  }

  removePage() {
    initialChildSizeNotifier.value = 0.8;
    bottomPageList.removeLast();
    bottomPageListScreenNames.removeLast();
    // if (bottomPageList.isEmpty)
    // isOfflineNoti.value=true;
    notifyListeners();
    measureChildSize();
  }

  removeSpecificPage({required String screenName}) {
    initialChildSizeNotifier.value = 0.8;
    int index = bottomPageListScreenNames
        .indexWhere((element) => element == screenName);
    if (index != -1) {
      bottomPageList.removeAt(index);
      bottomPageListScreenNames.removeAt(index);
    }
    // if (bottomPageList.isEmpty)
    // isOfflineNoti.value=true;
    notifyListeners();
    measureChildSize();
  }

  removePageUntil() {
    initialChildSizeNotifier.value = 0.8;
    bottomPageList.clear();
    bottomPageListScreenNames.clear();

    if (bottomPageList.isEmpty) {}
    // isOfflineNoti.value=true;
    notifyListeners();
    measureChildSize();
  }

  double minimumHeight = 0.2;
  final contKey = GlobalKey();

  double getHeight() {
    // final RenderBox renderBox =
    //     contKey.currentContext?.findRenderObject() as RenderBox;
    var totalh =
        MediaQuery.of(MyGlobalKeys.navigatorKey.currentContext!).size.height;
    // final size = renderBox.size;
    // var h = size.height;
    // var val =  h/totalh;
    return dragScrollController.size * totalh;
  }

  void measureChildSize({bool fullHeight = false, double? height}) {
    ///height should be 0.1 to 1;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (height != null) {
        dragScrollController.animateTo(height,
            duration: Duration(milliseconds: 250), curve: Curves.linear);
        return;
      }
      final RenderBox? renderBox =
          contKey.currentContext?.findRenderObject() as RenderBox?;

      if (renderBox != null) {
        final size = renderBox.size;
        var h = size.height;
        var totalh = MediaQuery.of(MyGlobalKeys.navigatorKey.currentContext!)
            .size
            .height;

        if (h >= totalh || fullHeight) {
          dragScrollController.animateTo(1,
              duration: Duration(milliseconds: 250), curve: Curves.linear);
        } else {
          var val = h / totalh;
          // val = val>0.9?val:val+0.07;
          myCustomPrintStatement('the data is initial $val');
          // val = (val>0.7?val*1.1:val*1.2)+0.05;
          val = (val > 0.7
              ? val * 1.1
              : val > 0.4
                  ? val * 1.15
                  : val * 1.2);
          if (val > 1) {
            val = 1;
          }

          /// val
          myCustomPrintStatement('the data is ${val}....${h}..... ${totalh}');
          // initialChildSizeNotifier.value =val>minimumHeight?val:minimumHeight;

          dragScrollController.animateTo(val,
              duration: Duration(milliseconds: 250), curve: Curves.linear);
        }
      }

      // hide.value = true;
      // Future.delayed(Duration(milliseconds: 50)).then((val){
      //   hide.value = false;
      // });
    });
  }
  // void measureChildSize() {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     final RenderBox renderBox= contKey.currentContext?.findRenderObject() as RenderBox;
  //
  //     if (renderBox != null) {
  //
  //
  //
  //       final size = renderBox.size;
  //       var h = size.height;
  //       var totalh = MediaQuery.of(MyGlobalKeys.navigatorKey.currentContext!).size.height;
  //
  //       if(h>=totalh){
  //         dragScrollController.animateTo(1, duration: Duration(milliseconds: 250), curve: Curves.linear);
  //       }else{
  //         var val =  h/totalh;
  //         // val = val>0.9?val:val+0.07;
  //         myCustomPrintStatement('the data is initial $val');
  //         val = (val>0.7?val*1.1:val*1.2);
  //         if(val>1){
  //           val = 1;
  //         }
  //         /// val
  //         myCustomPrintStatement('the data is ${val}....${h}..... ${totalh}');
  //         // initialChildSizeNotifier.value =val>minimumHeight?val:minimumHeight;
  //         dragScrollController.animateTo(val, duration: Duration(milliseconds: 250), curve: Curves.linear);
  //       }
  //     }
  //
  //     // hide.value = true;
  //     // Future.delayed(Duration(milliseconds: 50)).then((val){
  //     //   hide.value = false;
  //     // });
  //   });
  //
  // }
  ///

  // final contKey = GlobalKey();
  // void measureChildSize() {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     // var bottomSheetProvider=Provider.of<BottomSheetProvider>(context,listen: false);
  //     final RenderBox renderBox= contKey.currentContext?.findRenderObject() as RenderBox;
  //     if (renderBox != null) {
  //
  //       final size = renderBox.size;
  //       var h = size.height;
  //       var totalh = MediaQuery.of(MyGlobalKeys.navigatorKey.currentContext!).size.height;
  //
  //       if(h>=totalh){
  //         initialChildSizeNotifier.value = 1;
  //       }else{
  //         var val =  h/totalh;
  //         val = val>0.9?val:val+0.07;
  //         myCustomPrintStatement('the data is ${val}....${h}..... ${totalh}');
  //         initialChildSizeNotifier.value =val>minimumHeight?val:minimumHeight;
  //       }
  //     }
  //
  //     hide.value = true;
  //     Future.delayed(Duration(milliseconds: 50)).then((val){
  //       hide.value = false;
  //     });
  //   });
  // }
}
