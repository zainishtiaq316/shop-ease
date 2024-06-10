import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:shopease/controllers/signup-controller.dart';
import 'package:shopease/screens/auth-ui/signin-screen.dart';
import 'package:shopease/utils/app-constant.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    final SignUpController signUpController = Get.put(SignUpController());
    TextEditingController firstNameController = TextEditingController();
     TextEditingController secondNameController = TextEditingController();
    TextEditingController userEmailController = TextEditingController();
    TextEditingController userPhoneController = TextEditingController();
    TextEditingController userCityController = TextEditingController();
    TextEditingController userPasswordController = TextEditingController();
    TextEditingController userConfirmPasswordController =
        TextEditingController();
    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppConstant.appSecondaryColor,
          title: Text(
            "Sign Up",
            style: TextStyle(color: AppConstant.appTextColor),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            child: Column(
              children: [
                SizedBox(
                  height: Get.height / 20,
                ),
                Container(
                    alignment: Alignment.center,
                    child: Text(
                      "Welcome to my app",
                      style: TextStyle(
                          color: AppConstant.appSecondaryColor,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
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
                        controller: userEmailController,
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
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    width: Get.width,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: firstNameController,
                        cursorColor: AppConstant.appSecondaryColor,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          hintText: "First Name",
                          contentPadding: EdgeInsets.only(top: 2.0, left: 8.0),
                          prefixIcon: Icon(
                            Icons.person,
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
                      child: TextFormField(
                        controller: secondNameController,
                        cursorColor: AppConstant.appSecondaryColor,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          hintText: "Second Name",
                          contentPadding: EdgeInsets.only(top: 2.0, left: 8.0),
                          prefixIcon: Icon(
                            Icons.person,
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
                      child: TextFormField(
                        controller: userPhoneController,
                        cursorColor: AppConstant.appSecondaryColor,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Phone",
                          contentPadding: EdgeInsets.only(top: 2.0, left: 8.0),
                          prefixIcon: Icon(
                            Icons.phone,
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
                      child: TextFormField(
                        controller: userCityController,
                        cursorColor: AppConstant.appSecondaryColor,
                        keyboardType: TextInputType.streetAddress,
                        decoration: InputDecoration(
                          hintText: "City",
                          contentPadding: EdgeInsets.only(top: 2.0, left: 8.0),
                          prefixIcon: Icon(
                            Icons.location_pin,
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
                            controller: userPasswordController,
                            cursorColor: AppConstant.appSecondaryColor,
                            obscureText:
                                signUpController.isPasswordVisible.value,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                              hintText: "Password",
                              suffixIcon: IconButton(
                                icon: Icon(
                                  signUpController.isPasswordVisible.value
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: AppConstant.appSecondaryColor,
                                ),
                                onPressed: () {
                                  signUpController.isPasswordVisible.toggle();
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
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    width: Get.width,
                    child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Obx(
                          () => TextFormField(
                            controller: userConfirmPasswordController,
                            obscureText:
                                signUpController.isConfirmPasswordVisible.value,
                            cursorColor: AppConstant.appSecondaryColor,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                              hintText: "Confirm Password",
                              suffixIcon: IconButton(
                                icon: Icon(
                                  signUpController
                                          .isConfirmPasswordVisible.value
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: AppConstant.appSecondaryColor,
                                ),
                                onPressed: () {
                                  signUpController.isConfirmPasswordVisible
                                      .toggle();
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
                        String fname = firstNameController.text.trim();
                         String sname = firstNameController.text.trim();
                        String email = userEmailController.text.trim();
                        String phone = userPhoneController.text.trim();
                        String city = userCityController.text.trim();
                        String password = userPasswordController.text.trim();
                        String confirmPassword =
                            userConfirmPasswordController.text.trim();
                        String userDeviceToken = '';
                        RegExp emailRegex = RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

                        if (fname.isEmpty ||
                        sname.isEmpty ||
                            email.isEmpty ||
                            phone.isEmpty ||
                            city.isEmpty ||
                            password.isEmpty ||
                            confirmPassword.isEmpty) {
                          Get.snackbar("Error", "Please Enter All details",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: AppConstant.appSecondaryColor,
                              colorText: AppConstant.appTextColor);
                        } else if (fname.length < 4) {
                          Get.snackbar(
                            "Error",
                            "First Name must be at least 4 characters long",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: AppConstant.appSecondaryColor,
                            colorText: AppConstant.appTextColor,
                          );
                        }
                        else if (sname.length < 4) {
                          Get.snackbar(
                            "Error",
                            "Second Name must be at least 4 characters long",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: AppConstant.appSecondaryColor,
                            colorText: AppConstant.appTextColor,
                          );
                        } else if (!emailRegex.hasMatch(email)) {
                          Get.snackbar(
                            "Error",
                            "Invalid email format",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: AppConstant.appSecondaryColor,
                            colorText: AppConstant.appTextColor,
                          );
                        } else if (password != confirmPassword) {
                          Get.snackbar(
                            "Error",
                            "Passwords do not match",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: AppConstant.appSecondaryColor,
                            colorText: AppConstant.appTextColor,
                          );
                        } else {
                          UserCredential? userCredential =
                              await signUpController.signUpMethod(fname, sname, email,
                                  phone, city, password, userDeviceToken);

                          if (userCredential != null) {
                            Get.snackbar("Verification email sent",
                                "Please check your email.",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: AppConstant.appSecondaryColor,
                                colorText: AppConstant.appTextColor);

                            FirebaseAuth.instance.signOut();
                            Get.off(() => SignInScreen());
                          }
                        }
                      },
                      child: Text(
                        "SIGN UP",
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
                      "Already have an account? ",
                      style: TextStyle(
                        color: AppConstant.appSecondaryColor,
                      ),
                    ),
                    GestureDetector(
                        onTap: () => Get.offAll(SignInScreen()),
                        child: Text(
                          "Sign In?",
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
