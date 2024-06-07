import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shopease/utils/app-constant.dart';

class ProductPriceController extends GetxController {
  RxDouble totalPrice = 0.0.obs;
  User? user = FirebaseAuth.instance.currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var favorites = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    _firestore
      .collection('cart')
      .doc(user!.uid)
      .collection('cartOrders')
      .snapshots()
      .listen((snapshot) {
        fetchProductPrice();
      });
    fetchProductPrice();
  }

  void fetchProductPrice() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection('cart')
        .doc(user!.uid)
        .collection('cartOrders')
        .get();

    double sum = 0;
    for (final doc in snapshot.docs) {
      final data = doc.data();
      if (data != null && data.containsKey('productTotalPrice')) {
        sum += (data['productTotalPrice'] as num).toDouble();
      }
    }
    totalPrice.value = sum;
  }

  void deleteAllCarts() async {
    final CollectionReference cartCollection = _firestore.collection('cart');

    try {
      EasyLoading.show(status: 'Deleting all carts...');

      final QuerySnapshot userSnapshot = await cartCollection.get();

      if (userSnapshot.size == 0) {
        Get.snackbar(
          'Cart', 'No user carts found to delete',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.purple,
          colorText: AppConstant.appTextColor
        );
        return;
      }

      for (DocumentSnapshot userDoc in userSnapshot.docs) {
        final CollectionReference itemsCollection = userDoc.reference.collection('cartOrders');
        final QuerySnapshot itemSnapshot = await itemsCollection.get();

        WriteBatch batch = _firestore.batch();
        for (DocumentSnapshot doc in itemSnapshot.docs) {
          batch.delete(doc.reference);
        }

        batch.delete(userDoc.reference);
        await batch.commit();
      }

      Get.snackbar(
        'Cart', 'All user carts deleted successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: AppConstant.appTextColor
      );
    } catch (e) {
      Get.snackbar('Error', '$e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppConstant.appSecondaryColor,
        colorText: AppConstant.appTextColor
      );
    } finally {
      EasyLoading.dismiss();
    }
  }
}
