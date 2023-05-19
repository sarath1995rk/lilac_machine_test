import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lilac_machine_test/app_config/routes.dart' as route;
import 'package:lilac_machine_test/widgets/custom_progress_bar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    initRoute();
    super.initState();
  }

  initRoute() async {
    final user = auth.currentUser;
    if (user == null) {
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).pushReplacementNamed(route.kPhoneAuthScreen);
      });
    } else {
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context)
            .pushReplacementNamed(route.kHomeScreen, arguments: 0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body:CustomProgressBar(),
    );
  }
}
