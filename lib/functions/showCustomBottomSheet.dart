import 'package:connect_app_driver/functions/print_function.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

const double pageBreakpoint = 750.0;
ValueNotifier<double> maxHeightNotifier = ValueNotifier(1000);
Future showCustomBottomSheet({
  required BuildContext context,
  required dynamic child,
  bool enableDrag = true,
  required List<SliverWoltModalSheetPage> list,
  double paddingHorizontal = 18,
}) async {
  maxHeightNotifier.value = 1000;

  // SliverWoltModalSheetPage page1(
  //     BuildContext modalSheetContext, TextTheme textTheme) {
  //   return WoltModalSheetPage(
  //     hasSabGradient: false,
  //     backgroundColor: Colors.black,
  //     enableDrag: enableDrag,
  //     hasTopBarLayer: false,
  //
  //     child:Container(
  //       color: Colors.black,
  //       padding:  EdgeInsets.only(left: paddingHorizontal,right: paddingHorizontal,bottom: 20,top: 30),
  //       child: child,
  //     ),
  //   );
  // }

  return await WoltModalSheet.show(
    context: context,
    pageListBuilder: (modalSheetContext) {
      return list;
    },
    modalTypeBuilder: (context) {
      final size = MediaQuery.of(context).size.width;
      if (size < pageBreakpoint) {
        return WoltModalType.bottomSheet;
      } else {
        return WoltModalType.dialog;
      }
    },
    onModalDismissedWithBarrierTap: () {
      myCustomPrintStatement('Closed modal sheet with barrier tap');
      Navigator.of(context).pop();
    },
    maxDialogWidth: 560,
    minDialogWidth: 400,
    minPageHeight: 0.0,
    maxPageHeight: 0.9,
  );
}
