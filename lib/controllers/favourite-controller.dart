import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopease/models/product-model.dart';

class FavoriteController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
}
