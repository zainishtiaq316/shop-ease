import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:intl/intl.dart';
import 'package:shopease/screens/home_page.dart';
import 'package:shopease/utils/app-constant.dart';

class UpdatePasswordController extends GetxController {
  DateTime currentTime = DateTime.now();
  final _auth = FirebaseAuth.instance;

  Future<void> updatePasswordMethod(String password) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        EasyLoading.show(status: "Please wait a moments");

        await user.updatePassword(password);
        Get.snackbar('Password', 'Updated Successfully',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: AppConstant.appTextColor);
        EasyLoading.dismiss();
        Get.off(() => HomePageView());
      }
    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      Get.snackbar('Error', '$e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppConstant.appSecondaryColor,
          colorText: AppConstant.appTextColor);
    }
  }
}
