import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shopease/models/user-model.dart';
import 'package:shopease/utils/app-constant.dart';

import 'getting-token.dart';

class SignUpController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //for password visibilty
  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;
  DateTime currentTime = DateTime.now();
  
  Future<UserCredential?> signUpMethod(
      String userName,
       String secondName,
      String userEmail,
      String userPhone,
      String userCity,
      String userPassword,
      String userDeviceToken) async {
    final GetDeviceTokenController getDeviceTokenController =
        Get.put(GetDeviceTokenController());
        String formattedDateTime = DateFormat('dd/MM/yyyy - h:mma').format(currentTime);
    try {
      EasyLoading.show(status: "Please wait a moments");
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: userEmail, password: userPassword);

      await userCredential.user!.sendEmailVerification();

      UserModel userModel = UserModel(
          city: userCity,
          lastName: secondName,
          Gender: '',
          language: 'English',
          dateOfBirth: '',
          updatedOn: DateTime.now(),
          joinedTime: formattedDateTime,
          updatedTime: formattedDateTime,
          country: '',
          createdOn: DateTime.now(),
          email: userEmail,
          isAdmin: false,
          isActive: true,
          phone: userPhone,
          street: '',
          uid: userCredential.user!.uid,
          userAddress: '',
          userDeviceToken: getDeviceTokenController.deviceToken.toString(),
          userImg: '',
          firstName: userName);
      _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(userModel.toMap());

      EasyLoading.dismiss();
      return userCredential;
    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      Get.snackbar('Error', '$e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppConstant.appSecondaryColor,
          colorText: AppConstant.appTextColor);
    }
  }
  
}
