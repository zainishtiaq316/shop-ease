import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shopease/controllers/forgot-password-controller-.dart';
import 'package:shopease/screens/auth-ui/signin-screen.dart';
import 'package:shopease/screens/auth-ui/signup-screen.dart';
import 'package:shopease/utils/app-constant.dart';

class forgotPassword extends StatefulWidget {
  const forgotPassword({super.key});

  @override
  State<forgotPassword> createState() => _forgotPasswordState();
}

class _forgotPasswordState extends State<forgotPassword> {
  @override
  Widget build(BuildContext context) {
    TextEditingController userEmail = TextEditingController();
    ForgotPasswordController forgotPasswordController =
        Get.put(ForgotPasswordController());
    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppConstant.appSecondaryColor,
          title: Text(
            "Forgot Password",
            style: TextStyle(color: AppConstant.appTextColor),
          ),
          centerTitle: true,
          elevation: 0,
        ),
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
                            "Please enter email for forgot password",
                            style: TextStyle(
                                color: AppConstant.appSecondaryColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    :

                    // SizedBox.shrink():
                    Column(
                        children: [
                          Container(
                              width: Get.width,
                              height: Get.height / 3,
                              color: AppConstant.appSecondaryColor,
                              child: Lottie.asset(
                                  "assets/images/splash-icon.json"))
                        ],
                      ),
                SizedBox(
                  height: Get.height / 20,
                ),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    width: Get.width,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: userEmail,
                        cursorColor: AppConstant.appSecondaryColor,
                        keyboardType: TextInputType.emailAddress,
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
                SizedBox(
                  height: Get.height / 30,
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

                        RegExp emailRegex = RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

                        if (email.isEmpty) {
                          Get.snackbar("Error", "Please enter email",
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
                          String email = userEmail.text.trim();
                          forgotPasswordController.forgotPasswordMethod(email);
                        }
                      },
                      child: Text(
                        "FORGOT",
                        style: TextStyle(
                          color: AppConstant.appTextColor,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: Get.height / 20,
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
