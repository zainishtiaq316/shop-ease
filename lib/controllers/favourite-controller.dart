import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopease/models/product-model.dart';

import '../utils/app-constant.dart';

class FavoriteController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var favorites = <String>[].obs; // Example list of favorite item IDs

  var isLoading = false.obs;

  Stream<QuerySnapshot> getFavoritesStream() {
    final String userId = _auth.currentUser!.uid;
    return _firestore
        .collection('favorites')
        .doc(userId)
        .collection('items')
        .snapshots();
  }

  Stream<DocumentSnapshot> getFavoriteSnapshot(String itemName) {
    final String userId = _auth.currentUser!.uid;
    return _firestore
        .collection('favorites')
        .doc(userId)
        .collection('items')
        .doc(itemName)
        .snapshots();
  }

  Future<void> toggleFavorite(ProductModel model, bool isFavorite) async {
    isLoading.value = true;
    final String userId = _auth.currentUser!.uid;
    final DocumentReference docRef = _firestore
        .collection('favorites')
        .doc(userId)
        .collection('items')
        .doc(model.productName);

    try {
      if (isFavorite) {
        await docRef.delete();
      } else {
        await docRef.set(model.toMap());
      }
    } finally {
      isLoading.value = false;
    }
  }

void deleteAllFavorites() async {
  final String userId = _auth.currentUser!.uid;
  final CollectionReference itemsCollection = _firestore
      .collection('favorites')
      .doc(userId)
      .collection('items');

  try {
    EasyLoading.show(status: 'Deleting...');

    // Get all documents in the collection
    final QuerySnapshot snapshot = await itemsCollection.get();
    
    if (snapshot.size == 0) {
      Get.snackbar(
        'Favorite', 'No items found to delete',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.purple, // You can choose a color
        colorText: AppConstant.appTextColor
      );
      return; // Exit function if there are no items to delete
    }
    
    // Batch delete all documents
    WriteBatch batch = _firestore.batch();
    for (DocumentSnapshot doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    
    // Commit the batch
    await batch.commit();

    // Clear the local list if needed
    favorites.clear();

    Get.snackbar(
      'Favorite', 'All items deleted successfully',
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
