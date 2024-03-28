import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:shopease/utils/app-constant.dart';

class GetDeviceTokenController extends GetxController {
  String? deviceToken;
  @override
  void onInit() {
    super.onInit();
    getDeviceToken();
  }

  Future<void> getDeviceToken() async {
    try {
      await FirebaseMessaging.instance.requestPermission();

      await FirebaseMessaging.instance.getToken().then((t) {
        if (t != null) {
          deviceToken = t;
          print("token : $deviceToken");
          update();
        }
      });
    } catch (e) {
      Get.snackbar('Error', '$e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppConstant.appSecondaryColor,
          colorText: AppConstant.appTextColor);
    }
  }
}
