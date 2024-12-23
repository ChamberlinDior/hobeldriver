import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../constants/my_colors.dart';

void easyLoadingConfigSetup() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 4000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.white
    ..backgroundColor = Colors.black
    ..indicatorColor = MyColors.primaryColor
    ..textColor = Colors.yellow
    ..maskColor = Colors.white.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false
    ..customAnimation = CustomAnimation();
}

class CustomAnimation extends EasyLoadingAnimation {
  CustomAnimation();

  @override
  Widget buildWidget(
    Widget child,
    AnimationController controller,
    AlignmentGeometry alignment,
  ) {
    return Opacity(
      opacity: controller.value,
      child: RotationTransition(
        turns: controller,
        child: child,
      ),
    );
  }
}

Future showLoading() async {
  if (!EasyLoading.isShow) {
    await EasyLoading.show(status: null, maskType: EasyLoadingMaskType.black);
  }
}

Future hideLoading() async {
  if (EasyLoading.isShow) {
    await EasyLoading.dismiss();
  }
}
