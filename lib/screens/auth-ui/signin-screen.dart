import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shopease/controllers/get-user-data-controller.dart';
import 'package:shopease/controllers/signin-controller.dart';
import 'package:shopease/screens/auth-ui/signup-screen.dart';
import 'package:shopease/screens/home_page.dart';
import 'package:shopease/screens/user-panel/main-screen.dart';
import 'package:shopease/utils/app-constant.dart';

import 'forgotPassword-screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final SigninController signinController = Get.put(SigninController());
  final GetUserDataController getUserDataController =
      Get.put(GetUserDataController());
  TextEditingController userEmail = TextEditingController();

  TextEditingController userPassword = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      return Scaffold(
               backgroundColor: Colors.white,
       
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                isKeyboardVisible
                    ? Column(
                        children: [
                        
                          SizedBox(
                            height: Get.height / 20,
                          ),
                          Text(
                            "Welcome to Shop Ease",
                            style: TextStyle(
                                color: appColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          Container(
                               height: Get.height /4,
                              
                              child: Lottie.asset(
                                  "assets/images/splash-icon.json", ),
                            ),
                        ],
                      )
                    :

                    // SizedBox.shrink():
                    Container(
                        width: Get.width,
                        height: Get.height /2.5,
                        decoration: BoxDecoration(
                          color: appColor,
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(100))
                        ),
                        child: Column(
                          children: [
                            Container(
                               height: Get.height /3,
                              child: Lottie.asset(
                                  "assets/images/splash-icon.json"),
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(right: 15, bottom: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text("Login Account", style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold,),)
                                ],
                              ),
                            )
                          ],
                        )),
                SizedBox(
                  height: Get.height / 20,
                ),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    width: Get.width,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        cursorColor: AppConstant.appSecondaryColor,
                        keyboardType: TextInputType.emailAddress,
                        controller: userEmail,
                        decoration: InputDecoration(
                          hintText: "Email",
                          contentPadding: EdgeInsets.only(top: 2.0, left: 8.0),
                          prefixIcon: Icon(
                            Icons.email,
                            color: AppConstant.appSecondaryColor,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.grey.shade500),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                                color: AppConstant
                                    .appSecondaryColor), // Border color when focused
                          ),
                        ),
                      ),
                    )),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    width: Get.width,
                    child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Obx(
                          () => TextFormField(
                            controller: userPassword,
                            obscureText:
                                signinController.isPasswordVisible.value,
                            cursorColor: AppConstant.appSecondaryColor,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                              hintText: "Password",
                              suffixIcon: IconButton(
                                icon: Icon(
                                  signinController.isPasswordVisible.value
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: AppConstant.appSecondaryColor,
                                ),
                                onPressed: () {
                                  signinController.isPasswordVisible.toggle();
                                },
                              ),
                              contentPadding:
                                  EdgeInsets.only(top: 2.0, left: 8.0),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: AppConstant.appSecondaryColor,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade500),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                    color: AppConstant
                                        .appSecondaryColor), // Border color when focused
                              ),
                            ),
                          ),
                        ))),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                      onTap: () => Get.to(forgotPassword()),
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                            color: AppConstant.appSecondaryColor,
                            fontWeight: FontWeight.bold),
                      )),
                ),
                SizedBox(
                  height: Get.height / 20,
                ),
                Material(
                  child: Container(
                    width: Get.width / 2,
                    height: Get.height / 18,
                    decoration: BoxDecoration(
                        color: AppConstant.appSecondaryColor,
                        borderRadius: BorderRadius.circular(20.0)),
                    child: TextButton(
                      onPressed: () async {
                        String email = userEmail.text.trim();
                        String password = userPassword.text.trim();

                        RegExp emailRegex = RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

                        if (email.isEmpty || password.isEmpty) {
                          Get.snackbar("Error", "Please Enter All details",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: AppConstant.appSecondaryColor,
                              colorText: AppConstant.appTextColor);
                        } else if (!emailRegex.hasMatch(email)) {
                          Get.snackbar(
                            "Error",
                            "Invalid email format",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: AppConstant.appSecondaryColor,
                            colorText: AppConstant.appTextColor,
                          );
                        } else {
                          UserCredential? userCredential =
                              await signinController.signInMethod(
                                  email, password);
                          var userData = await getUserDataController
                              .getUserData(userCredential!.user!.uid);

                          // ignore: unnecessary_null_comparison
                          if (userCredential != null) {
                            //
                            if (userCredential.user!.emailVerified) {
                              if (userData[0]['isAdmin'] == true) {
                               Get.snackbar(
                                    "Error", "Only users are allowed.",
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor:
                                        AppConstant.appSecondaryColor,
                                    colorText: AppConstant.appTextColor);
                              } else {
                                Get.offAll(() => HomePageView());
                                Get.snackbar("Success User Login",
                                    "Login Scuccessfully!",
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor:
                                        AppConstant.appSecondaryColor,
                                    colorText: AppConstant.appTextColor);
                              }

                              // Get.off(() => MainScreen());
                            } else {
                              Get.snackbar("Error",
                                  "Please verify your email before login",
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor:
                                      AppConstant.appSecondaryColor,
                                  colorText: AppConstant.appTextColor);
                            }
                          } else {
                            Get.snackbar("Error", "Please try again",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: AppConstant.appSecondaryColor,
                                colorText: AppConstant.appTextColor);
                          }
                        }
                      },
                      child: Text(
                        "SIGN IN",
                        style: TextStyle(
                          color: AppConstant.appTextColor,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: Get.height / 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Dont't have an account? ",
                      style: TextStyle(
                        color: AppConstant.appSecondaryColor,
                      ),
                    ),
                    GestureDetector(
                        onTap: () => Get.offAll(SignUpScreen()),
                        child: Text(
                          "Sign Up?",
                          style: TextStyle(
                              color: AppConstant.appSecondaryColor,
                              fontWeight: FontWeight.bold),
                        )),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
