import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shopease/utils/app-constant.dart';

class ProductPriceController extends GetxController {
  RxDouble totalPrice = 0.0.obs;
  User? user = FirebaseAuth.instance.currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;
   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var favorites = <String>[].obs; // Example list of favorite item IDs
  @override
  void onInit() {
    fetchProductPrice();
    super.onInit();
  }

  void fetchProductPrice() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('cart')
        .doc(user!.uid)
        .collection('cartOrders')
        .get();

    double sum = 0.0;
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

    // Get all user documents in the 'cart' collection
    final QuerySnapshot userSnapshot = await cartCollection.get();
    
    if (userSnapshot.size == 0) {
      Get.snackbar(
        'Cart', 'No user carts found to delete',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.purple, // You can choose a color
        colorText: AppConstant.appTextColor
      );
      return; // Exit function if there are no user carts to delete
    }

    // Iterate through each user document
    for (DocumentSnapshot userDoc in userSnapshot.docs) {
      // Get the collection of cart orders for the current user
      final CollectionReference itemsCollection = userDoc.reference.collection('cartOrders');

      // Get all documents in the user's cartOrders collection
      final QuerySnapshot itemSnapshot = await itemsCollection.get();

      // Batch delete all documents in the user's cartOrders collection
      WriteBatch batch = _firestore.batch();
      for (DocumentSnapshot doc in itemSnapshot.docs) {
        batch.delete(doc.reference);
      }

      // Delete the user document itself
      batch.delete(userDoc.reference);

      // Commit the batch
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
