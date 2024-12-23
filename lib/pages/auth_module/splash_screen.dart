import 'package:connect_app_driver/provider/new_firebase_auth_provider.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../constants/my_image_url.dart';
import '../../widget/custom_scaffold.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // late AuthProvider auth;
  late FirebaseAuthProvider firebaseAuthProvider;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // auth = Provider.of<AuthProvider>(context, listen: false);
      firebaseAuthProvider =
          Provider.of<FirebaseAuthProvider>(context, listen: false);
      Future.delayed(Duration(seconds: 0), () {
        firebaseAuthProvider.splashAuthentication(context);
        // auth.splashAuthentication(context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          MyImagesUrl.splash,
          width: MediaQuery.of(context).size.width / 4,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
