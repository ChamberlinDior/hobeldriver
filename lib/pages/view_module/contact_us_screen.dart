import 'package:connect_app_driver/provider/new_firebase_auth_provider.dart';
import 'package:connect_app_driver/widget/custom_appbar.dart';
import 'package:connect_app_driver/widget/custom_scaffold.dart';
import 'package:connect_app_driver/widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/global_data.dart';
import '../../constants/my_colors.dart';
import '../../constants/sized_box.dart';
import '../../services/custom_navigation_services.dart';
import '../../widget/app_specific/dotted_border_container.dart';
import '../../widget/custom_text_field.dart';
import '../../widget/custom_button.dart';
import '../../widget/show_snackbar.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  TextEditingController contactUsController = TextEditingController();
  ValueNotifier<bool> loader = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        isBackIcon: true,
        titleText: 'Contact us',
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: globalHorizontalPadding, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText.heading(
              'How we can help you?',
              fontSize: 22,
            ),
            vSizedBox,
            CustomText.bodyText2(
              'Please enter your questions or comments here.',
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            vSizedBox,
            CustomPaint(
              painter: DottedBorderPainter(
                color: MyColors.whiteColor,
                strokeWidth: 2,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 1),
                child: CustomTextField(
                  maxLines: 6,
                  fillColor: MyColors.blackColor,
                  borderColor: Colors.transparent,
                  controller: contactUsController,
                  hintText: "Type here...",
                ),
              ),
            ),
            vSizedBox,
            ValueListenableBuilder(
              valueListenable: loader,
              builder: (context, load, child) => CustomButton(
                height: 50,
                load: load,
                onTap: () async {
                  if (contactUsController.text.isEmpty) {
                    showSnackbar('Required**');
                  } else if (contactUsController.text.length < 20) {
                    showSnackbar(
                        "Please provide at least 20 characters in your questions.");
                  } else if (contactUsController.text.length >= 20) {
                    loader.value = true;
                    var provider = Provider.of<FirebaseAuthProvider>(context,
                        listen: false);
                    await provider.contactUsFunction(
                        comment: contactUsController.text);

                    loader.value = false;
                    CustomNavigation.pop(context);
                  }
                },
                verticalMargin: 20,
                text: "Submit",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
