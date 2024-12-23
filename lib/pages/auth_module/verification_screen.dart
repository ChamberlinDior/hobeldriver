import 'package:connect_app_driver/constants/global_data.dart';
import 'package:connect_app_driver/constants/types/approval_status.dart';
import 'package:connect_app_driver/provider/new_firebase_auth_provider.dart';
import 'package:connect_app_driver/widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/my_image_url.dart';
import '../../constants/sized_box.dart';
import '../../services/custom_navigation_services.dart';
import '../../widget/custom_scaffold.dart';
import '../../widget/custom_button.dart';
import 'login_screen.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({Key? key}) : super(key: key);

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {

  bool isVerified = false;
  @override
  Widget build(BuildContext context) {
    return Consumer<FirebaseAuthProvider>(
      builder: (context, firebaseAuthProvider, child) {
        if(userData!.approvalStatus==ApprovalStatus.approved || userData!.approvalStatus==ApprovalStatus.rejected){
          print('verify userNavigationAfterLogin my user is ');
          if(!isVerified){
            isVerified = true;
            firebaseAuthProvider.userNavigationAfterLogin();
          }
        }
        return CustomScaffold(
          body:Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(MyImagesUrl.successIcon,
                  width: MediaQuery.of(context).size.width*0.25,
                ),
                vSizedBox4,
                CustomText.heading('Registration Success',),
                vSizedBox,
                CustomText.bodyText2('Thank you for registration admin will\ncheck your details and back to you within 5 business day',
                  textAlign: TextAlign.center,),

                CustomButton(
                  height: 50,
                  onTap: (){
                    var firebaseAuthProvider = Provider.of<FirebaseAuthProvider>(context, listen: false);
                    firebaseAuthProvider.signOutUser();
                    CustomNavigation.pushAndRemoveUntil(context: context, screen: const LoginPage());
                  },
                  verticalMargin: 30,
                  text: "Ok",

                ),

              ],
            ),
          ),

        );
      }
    );
  }
}
