import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shopease/controllers/favourite-controller.dart';
import 'package:shopease/models/product-model.dart';
import 'package:shopease/utils/app-constant.dart';

class ItemFavoriteButton extends StatelessWidget {
  final ProductModel model;

  const ItemFavoriteButton({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FavoriteController favoriteController = Get.find();

    return StreamBuilder<DocumentSnapshot>(
      stream: favoriteController.getFavoriteSnapshot(model.productName),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final bool isFavorite = snapshot.data!.exists;
          return GestureDetector(
             onTap: () => favoriteController.toggleFavorite(model, isFavorite),
            child: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: appColor,),
           
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return GestureDetector(onTap: null, child: Icon(Icons.favorite_border, color: appColor,));
        }
      },
    );
  }
}