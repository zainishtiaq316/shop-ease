import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shopease/screens/home_page.dart';
import 'package:shopease/screens/user-panel/main-screen.dart';

import '../models/user-model.dart';
import 'getting-token.dart';

class GoogleSignInController extends GetxController {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signInWithGoogle() async {
    final GetDeviceTokenController getDeviceTokenController =
        Get.put(GetDeviceTokenController());
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        EasyLoading.show(status: "Please wait a moment...");
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        final User? user = userCredential.user;

        if (user != null) {
          final userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

          if (userDoc.exists) {
            // User exists, check isAdmin status
            final userData = userDoc.data() as Map<String, dynamic>;
            final isAdmin = userData['isAdmin'] ?? false;
            EasyLoading.dismiss();
            if (isAdmin) {
             // User is not admin, show error message
              EasyLoading.showError("Error: Only users are allowed.");
              await _auth.signOut();
              await googleSignIn.signOut();
            } else {
              // User is not admin, navigate to main screen
              Get.offAll(() => HomePageView());
            }
          } else {
            UserModel userModel = UserModel(
                city: '',
                country: '',
                createdOn: DateTime.now(),
                email: user.email.toString(),
                isAdmin: false,
                isActive: true,
                phone: user.phoneNumber.toString(),
                street: '',
                uid: user.uid,
                userAddress: '',
                userDeviceToken:
                    getDeviceTokenController.deviceToken.toString(),
                userImg: user.photoURL.toString(),
                username: user.displayName.toString());

            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .set(userModel.toMap());
            EasyLoading.dismiss();
            Get.offAll(() => MainScreen());
          }
        }
      }
    } catch (e) {
      EasyLoading.dismiss();
      print("error $e");
    }
  }
}
