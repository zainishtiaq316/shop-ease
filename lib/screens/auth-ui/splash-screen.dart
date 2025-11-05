import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shopease/screens/home_page.dart';
import 'package:shopease/utils/app-constant.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Get.offAll(() => HomePageView()); // Direct navigation to HomePageView
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: appColor,
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: size.width,
              alignment: Alignment.center,
              child: Lottie.asset(
                'assets/images/splash-icon.json',
                repeat: false,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 20.0),
            width: size.width,
            alignment: Alignment.center,
            child: Text(
              AppConstant.appPoweredBy,
              style: TextStyle(
                color: AppConstant.appTextColor,
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}
