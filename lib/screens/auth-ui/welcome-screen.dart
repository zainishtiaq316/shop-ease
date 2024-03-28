import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shopease/controllers/google-signin-controller.dart';
import 'package:shopease/screens/auth-ui/signin-screen.dart';

import '../../utils/app-constant.dart';


class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  final GoogleSignInController _googleSignInController = Get.put(GoogleSignInController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appSecondaryColor,
        title: Text("Welcome to my app", style: TextStyle(color: AppConstant.appTextColor),),
        elevation: 0,
        centerTitle: true,

      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
         Container(
          color: AppConstant.appSecondaryColor,
          child: Lottie.asset("assets/images/splash-icon.json"),
          ),
       Container(
         margin: EdgeInsets.only(top: 20.0),
          child: Text("Happy Shopping", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),)),

         SizedBox(
         height :Get.height/12
         ),
         Material(
          child: Container(
            width: Get.width/1.2,
            height: Get.height/12,
            decoration: BoxDecoration(
              color: AppConstant.appSecondaryColor,
              borderRadius: BorderRadius.circular(20.0)
            ),
            child: TextButton.icon(
              
              icon: Image.asset("assets/images/google-icon.png", width: Get.width/12,height: Get.height/12,),
              onPressed: (){
                _googleSignInController.signInWithGoogle();
              }, label: Text("Sign in with google", style: TextStyle(color: AppConstant.appTextColor,),),),
          ),
         )

         ,SizedBox(
         height :Get.height/50
         ),
         Material(
          child: Container(
            width: Get.width/1.2,
            height: Get.height/12,
            decoration: BoxDecoration(
              color: AppConstant.appSecondaryColor,
              borderRadius: BorderRadius.circular(20.0)
            ),
            child: TextButton.icon(
              
              icon: Icon(Icons.email, color: AppConstant.appTextColor,),
              onPressed: (){

                Get.to(()=> SignInScreen());
              }, label: Text("Sign in with email", style: TextStyle(color: AppConstant.appTextColor,),),),
          ),
         )


          ],
        ),
      ),
    );
  }
}