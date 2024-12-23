import 'package:connect_app_driver/constants/sized_box.dart';
import 'package:flutter/material.dart';
import '../../constants/my_colors.dart';
import '../../constants/my_image_url.dart';
import '../custom_text.dart';

class CustomStepper extends StatelessWidget {
  final List<StepData> steps;

  const CustomStepper({Key? key, required this.steps}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: steps.map((step) {
        int index = steps.indexOf(step);
        return StepItem(
          step: step,
          isLast: index == steps.length - 1,
        );
      }).toList(),
    );
  }
}

class StepItem extends StatefulWidget {
  final StepData step;
  final bool isLast;

  const StepItem({
    Key? key,
    required this.step,
    required this.isLast,
  }) : super(key: key);

  @override
  State<StepItem> createState() => _StepItemState();
}

class _StepItemState extends State<StepItem> {
  ValueNotifier<double> height = ValueNotifier(10);
  final contKey = GlobalKey();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((j) {
      height.value = contKey.currentContext?.size?.height ?? 5;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            if (!widget.isLast)
              CircleAvatar(
                  radius: 9,
                  backgroundColor: MyColors.whiteColor.withOpacity(0.5),
                  child: const Icon(
                    Icons.circle,
                    size: 13,
                    color: MyColors.whiteColor,
                  )),
            if (!widget.isLast)
              ValueListenableBuilder(
                valueListenable: height,
                builder: (context, value, child) => Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  width: 3,
                  height: value,
                  // color: widget.step.isCurrent ? Colors.blue : Colors.black,
                  color: MyColors.whiteColor,
                ),
              ),
            if (widget.isLast)
              Image.asset(
                MyImagesUrl.location01,
                width: 20,
                color: MyColors.whiteColor,
              )
          ],
        ),
        hSizedBox,
        Flexible(
          child: Container(
            key: contKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText.bodyText2(
                  widget.step.title,
                  height: 1,
                  fontSize: 15,
                ),
                CustomText.smallText(
                  widget.step.subtitle,
                  color: MyColors.whiteColor.withOpacity(0.7),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class StepData {
  final String title;
  final String subtitle;
  final bool isCurrent;

  StepData({
    required this.title,
    required this.subtitle,
    this.isCurrent = false,
  });
}
