import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:get/get.dart';
import 'package:image_card/image_card.dart';
import 'package:shopease/models/cart-model.dart';
import 'package:shopease/models/product-model.dart';
import 'package:shopease/screens/user-panel/checkout-screen.dart';
import 'package:shopease/utils/app-constant.dart';

import '../../controllers/cart-price-controller.dart';
import 'product-detail-screen.dart';

class HomeCartScreen extends StatefulWidget {
  const HomeCartScreen({super.key});

  @override
  State<HomeCartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<HomeCartScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  final ProductPriceController productPriceController =
      Get.put(ProductPriceController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('cart')
                  .doc(user!.uid)
                  .collection('cartOrders')
                  .snapshots(),
              builder:
                  (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Error"),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    height: Get.height / 5,
                    child: Center(
                      child: CupertinoActivityIndicator(),
                    ),
                  );
                }

                if (snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text("No products found"),
                  );
                }
                if (snapshot.data != null) {
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final productData = snapshot.data!.docs[index];
                        CartModel cartModel = CartModel(
                            categoryId: productData['categoryId'],
                            categoryName: productData['categoryName'],
                            createdAt: productData['createdAt'],
                            deliveryTime: productData['deliveryTime'],
                            fullPrice: productData['fullPrice'],
                            isSale: productData['isSale'],
                            productDescription:
                                productData['productDescription'],
                            productId: productData['productId'],
                            productImages: productData['productImages'],
                            productName: productData['productName'],
                            salePrice: productData['salePrice'],
                            updatedAt: productData['updatedAt'],
                            productQuantity: productData['productQuantity'],
                            productTotalPrice:
                                double.parse(productData['productTotalPrice'].toString()));

                        //CALCULATE PRICE

                        productPriceController.fetchProductPrice();
                        return SwipeActionCell(
                            key: ObjectKey(cartModel.productId),
                            trailingActions: [
                              SwipeAction(
                                  title: "Delete",
                                  forceAlignmentToBoundary: true,
                                  performsFirstActionWithFullSwipe: true,
                                  onTap: (CompletionHandler handler) async {
                                    await FirebaseFirestore.instance
                                        .collection('cart')
                                        .doc(user!.uid)
                                        .collection('cartOrders')
                                        .doc(cartModel.productId)
                                        .delete();
                                    print("deleted");
                                  })
                            ],
                            child: Card(
                              elevation: 5,
                              color: AppConstant.appTextColor,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: AppConstant.appMainColor,
                                  backgroundImage:
                                      NetworkImage(cartModel.productImages[0]),
                                ),
                                title: Text(cartModel.productName),
                                subtitle: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                        cartModel.productTotalPrice.toString()),
                                    SizedBox(
                                      width: Get.width / 20.0,
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        if (cartModel.productQuantity > 1) {
                                          await FirebaseFirestore.instance
                                              .collection('cart')
                                              .doc(user!.uid)
                                              .collection('cartOrders')
                                              .doc(cartModel.productId)
                                              .update({
                                            'productQuantity':
                                                cartModel.productQuantity - 1,
                                            'productTotalPrice': (double.parse(
                                                    cartModel.fullPrice) *
                                                (cartModel.productQuantity - 1))
                                          });
                                        }
                                      },
                                      child: CircleAvatar(
                                        backgroundColor:
                                            AppConstant.appMainColor,
                                        radius: 14.0,
                                        child: Text("-"),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Get.width / 20.0,
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        if (cartModel.productQuantity > 0) {
                                          await FirebaseFirestore.instance
                                              .collection('cart')
                                              .doc(user!.uid)
                                              .collection('cartOrders')
                                              .doc(cartModel.productId)
                                              .update({
                                            'productQuantity':
                                                cartModel.productQuantity + 1,
                                            'productTotalPrice': (double.parse(
                                                    cartModel.fullPrice) +
                                                double.parse(
                                                        cartModel.fullPrice) *
                                                    (cartModel.productQuantity))
                                          });
                                        }
                                      },
                                      child: CircleAvatar(
                                        backgroundColor:
                                            AppConstant.appMainColor,
                                        radius: 14.0,
                                        child: Text("+"),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ));
                      });
                }

                return Container();
              }),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              GestureDetector(
                onTap: (){
                  print("Total ${productPriceController.totalPrice.value.toStringAsFixed(1)} : PKR");
                },
                child: Text("data"),
              ),
              Obx(
                () => Text(
                    "Total ${productPriceController.totalPrice.value.toStringAsFixed(1)} : PKR",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                  child: Container(
                    width: Get.width / 2.0,
                    height: Get.height / 18,
                    decoration: BoxDecoration(
                        color: AppConstant.appSecondaryColor,
                        borderRadius: BorderRadius.circular(20.0)),
                    child: TextButton(
                      onPressed: () {
                        Get.to(() => CheckOutScreen());
                      },
                      child: Text(
                        "Checkout",
                        style: TextStyle(
                          color: AppConstant.appTextColor,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
