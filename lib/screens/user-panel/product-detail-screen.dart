import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shopease/models/cart-model.dart';
import 'package:shopease/models/product-model.dart';
import 'package:shopease/utils/app-constant.dart';

class ProductDetailsScreen extends StatefulWidget {
  ProductModel productModel;
  ProductDetailsScreen({super.key, required this.productModel});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: Text("Product Details"),
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: Get.height / 60,
            ),
            CarouselSlider(
              items: widget.productModel.productImages
                  .map(
                    (imageUrls) => ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: CachedNetworkImage(
                          imageUrl: imageUrls,
                          fit: BoxFit.cover,
                          width: Get.width - 10,
                          placeholder: (context, url) => ColoredBox(
                            color: Colors.white,
                            child: Center(
                              child: CupertinoActivityIndicator(),
                            ),
                          ),
                          errorWidget: ((context, url, error) =>
                              Icon(Icons.error)),
                        )),
                  )
                  .toList(),
              options: CarouselOptions(
                  scrollDirection: Axis.horizontal,
                  autoPlay: true,
                  aspectRatio: 2.5,
                  viewportFraction: 1),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Card(
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          alignment: Alignment.topLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(widget.productModel.productName),
                              Icon(Icons.favorite_outline)
                            ],
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          alignment: Alignment.topLeft,
                          child: Row(
                            children: [
                              widget.productModel.isSale == true &&
                                      widget.productModel.salePrice != ''
                                  ? Text(
                                      "PKR: " + widget.productModel.salePrice)
                                  : Text(
                                      "PKR: " + widget.productModel.fullPrice),
                            ],
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                              "Category: " + widget.productModel.categoryName)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          alignment: Alignment.topLeft,
                          child: Text(widget.productModel.productDescription)),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Material(
                              child: Container(
                                width: Get.width / 3.0,
                                height: Get.height / 16,
                                decoration: BoxDecoration(
                                    color: AppConstant.appSecondaryColor,
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: TextButton(
                                  onPressed: () {
                                    // Get.to(()=> SignInScreen());
                                  },
                                  child: Text(
                                    "WhatsApp",
                                    style: TextStyle(
                                      color: AppConstant.appTextColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Material(
                              child: Container(
                                width: Get.width / 3.0,
                                height: Get.height / 16,
                                decoration: BoxDecoration(
                                    color: AppConstant.appSecondaryColor,
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: TextButton(
                                  onPressed: () async {
                                    // Get.to(()=> SignInScreen());
                                    await checkProductExistence(uId: user!.uid);
                                  },
                                  child: Text(
                                    "Add to cart",
                                    style: TextStyle(
                                      color: AppConstant.appTextColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  //checkl product exist or not

  Future<void> checkProductExistence(
      {required String uId, int quantityIncreament = 1}) async {
    final DocumentReference documentReference = FirebaseFirestore.instance
        .collection('cart')
        .doc(uId)
        .collection('cartOrders')
        .doc(widget.productModel.productId.toString());

    DocumentSnapshot snapshot = await documentReference.get();

    if (snapshot.exists) {
      int currentQuantity = snapshot['productQuantity'];

      int updatedQuantity = currentQuantity + quantityIncreament;
      double totalPrice =
          double.parse(widget.productModel.isSale ? widget.productModel.salePrice : widget.productModel.fullPrice) * updatedQuantity;
      await documentReference.update({
        'productQuantity': updatedQuantity,
        'productTotalPrice': totalPrice
      });
         print("product exists");
    } else {
      await FirebaseFirestore.instance.collection('cart').doc(uId).set({
        'uId': uId,
        'createdAt': DateTime.now(),
      });

      CartModel cartModel = CartModel(
          categoryId: widget.productModel.categoryId,
          categoryName: widget.productModel.categoryName,
          createdAt: DateTime.now(),
          deliveryTime: widget.productModel.deliveryTime,
          fullPrice: widget.productModel.fullPrice,
          isSale: widget.productModel.isSale,
          productDescription: widget.productModel.productDescription,
          productId: widget.productModel.productId,
          productImages: widget.productModel.productImages,
          productName: widget.productModel.productName,
          productQuantity: 1,
          productTotalPrice: double.parse(widget.productModel.isSale ? widget.productModel.salePrice : widget.productModel.fullPrice),
          salePrice: widget.productModel.salePrice,
          updatedAt: DateTime.now());


      await documentReference.set(cartModel.toMap()
      
      );

      print("product added");
    }
  }
}
