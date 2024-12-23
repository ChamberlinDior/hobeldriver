import 'package:connect_app_driver/constants/sized_box.dart';
import 'package:connect_app_driver/extensions/pet_type_extenstion.dart';
import 'package:flutter/material.dart';
import '../constants/global_data.dart';
import '../constants/my_colors.dart';
import '../functions/showCustomBottomSheet.dart';

Future<void> customBottomSheet(context,
    {isHorizontalPadding = false, required child}) {

  return showModalBottomSheet(
    context: context,
    isScrollControlled: false,
    isDismissible: true,
    useSafeArea: true,
    backgroundColor: MyColors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
    clipBehavior: Clip.antiAliasWithSaveLayer,
    builder: (BuildContext context) {
      return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            padding: EdgeInsets.symmetric(
                horizontal: isHorizontalPadding ? 0 : globalHorizontalPadding,
                vertical: isHorizontalPadding ? 0 : 20),
            decoration: BoxDecoration(
                color: MyColors.blackColor,
                borderRadius: BorderRadius.circular(30)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Draggable(
                  feedback: Container(),
                  onDragUpdate: (va) {
                    var height = MediaQuery.of(context).size.height -
                        va.globalPosition.dy+40;
                    if (height >= 200) {
                      maxHeightNotifier.value =
                          height ;
                      print(
                          ' fskdfsfkj kl ${va.globalPosition}lklklklk${maxHeightNotifier.value}');
                    }
                  },
                  child: Container(
                    // padding: const EdgeInsets.all(12.0),
                    height: 70,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        color: MyColors.transparent
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: s,
                      children: [
                        Container(
                          width: 50,
                          height: 4,
                          decoration: BoxDecoration(
                              color: MyColors.whiteColor,
                              borderRadius: BorderRadius.circular(5)),
                        ),
                      ],
                    ),
                  ),
                ),
                ValueListenableBuilder(
                    valueListenable: maxHeightNotifier,
                    builder: (context, maxHeightNotifierValue, dsf) {
              return Container(
                constraints: BoxConstraints(
                  maxHeight: maxHeightNotifierValue,
                ),
                color: Colors.black,
              child: child,
              );
            }
          )
              ],
            )),
      );
    },
  );
}
 customDragBottomSheet(context,
    {isHorizontalPadding = false, required child}) {
  return DraggableScrollableSheet(
    builder: (context, scrollController) {
      return  Container(
          padding: EdgeInsets.symmetric(
              horizontal: isHorizontalPadding ? 0 : globalHorizontalPadding,
              vertical: isHorizontalPadding ? 0 : 20),
          decoration: const BoxDecoration(
              color: MyColors.blackColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 4,
              decoration: BoxDecoration(
                  color: MyColors.whiteColor,
                  borderRadius: BorderRadius.circular(5)),
            ),
            vSizedBox2,
            Expanded(
              child: SingleChildScrollView(
                child: child,
              ),
            )
          ],
        ),
      );
    },
    minChildSize: 0.2,
    maxChildSize: 0.75,
    initialChildSize: 0.3,

  );
}