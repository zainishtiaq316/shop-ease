import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:intl/intl.dart';
import 'package:shopease/screens/home_page.dart';
import 'package:shopease/utils/app-constant.dart';

import '../screens/Profile/uploader.dart';

class UpdateProfileController extends GetxController {
  DateTime currentTime = DateTime.now();
  final UploaderService uploaderService = UploaderService();

  Future<void> updateProfileMethod(
      File? pickImage,
      String firstName,
      String lastName,
      String userEmail,
      String phoneNumber,
      String dateOfBirth,
      String country,
      String city,
      String street,
      String gender) async {
    try {
      String formattedDateTime =
          DateFormat('dd/MM/yyyy - h:mma').format(currentTime);
      EasyLoading.show(status: "Please wait a moments");

      if (pickImage != null) {
        final image = await uploaderService.uploadFile(
            pickImage, "Profile_Images", FileType.Image);

        await FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          "photoURL": image.downloadLink,
        }).catchError((e) {
          Fluttertoast.showToast(msg: e!.message);
        });

        await FirebaseAuth.instance.currentUser!
            .updatePhotoURL(image.downloadLink);
         
            pickImage = null;
         
      }

      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        // "photoURL": image.downloadLink,

        "firstName": firstName,
        "lastName": lastName,
        "phone": phoneNumber,
        'email': userEmail,
        'dateOfBirth': dateOfBirth,
        'gender': gender,
        'country': country,
        'street': street,
        'city': city,
        'updatedOn': DateTime.now(),
        'updatedTime': formattedDateTime,
        'userAddress': "${street},${city},${country}"
      });

      Get.snackbar('Profile', 'Updated Successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: AppConstant.appTextColor);
      EasyLoading.dismiss();
      Get.off(() => HomePageView());
    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      Get.snackbar('Error', '$e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppConstant.appSecondaryColor,
          colorText: AppConstant.appTextColor);
    }
  }
}
