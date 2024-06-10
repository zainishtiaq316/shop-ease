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
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Column(
        children: [
          Expanded(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('cart')
                    .doc(user!.uid)
                    .collection('cartOrders')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
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
                              productTotalPrice: double.parse(
                                  productData['productTotalPrice'].toString()));

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
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 5.0),
                                padding: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  color: AppConstant.appTextColor,
                                  borderRadius: BorderRadius.circular(10.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 3,
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.25,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.25,
                                      decoration: BoxDecoration(
                                        color: appColor,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              cartModel.productImages[0]),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10.0),
                                    Expanded(
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.25,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              cartModel.productName,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black,
                                                fontSize: 17.0,
                                              ),
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: Text(
                                                    'PKR ${cartModel.productTotalPrice.toString()}',
                                                    style: TextStyle(
                                                        color: Colors.green,
                                                        fontSize: 13.0,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                                Spacer(),
                                                GestureDetector(
                                                  onTap: () async {
                                                    if (cartModel
                                                            .productQuantity >
                                                        1) {
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection('cart')
                                                          .doc(user!.uid)
                                                          .collection(
                                                              'cartOrders')
                                                          .doc(cartModel
                                                              .productId)
                                                          .update({
                                                        'productQuantity': cartModel
                                                                .productQuantity -
                                                            1,
                                                        'productTotalPrice': (double
                                                                .parse(cartModel
                                                                    .fullPrice) *
                                                            (cartModel
                                                                    .productQuantity -
                                                                1))
                                                      });
                                                    }
                                                  },
                                                  child: CircleAvatar(
                                                    backgroundColor: appColor,
                                                    radius: 14.0,
                                                    child: Text(
                                                      "-",
                                                      style: TextStyle(
                                                        fontSize: 17,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 10.0),
                                                Container(
                                                  child: Text(
                                                    cartModel.productQuantity
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 18.0,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 10.0),
                                                GestureDetector(
                                                  onTap: () async {
                                                    if (cartModel
                                                            .productQuantity >
                                                        0) {
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection('cart')
                                                          .doc(user!.uid)
                                                          .collection(
                                                              'cartOrders')
                                                          .doc(cartModel
                                                              .productId)
                                                          .update({
                                                        'productQuantity': cartModel
                                                                .productQuantity +
                                                            1,
                                                        'productTotalPrice': (double
                                                                .parse(cartModel
                                                                    .fullPrice) *
                                                            (cartModel
                                                                    .productQuantity +
                                                                1))
                                                      });
                                                    }
                                                  },
                                                  child: CircleAvatar(
                                                    backgroundColor: appColor,
                                                    radius: 14.0,
                                                    child: Text(
                                                      "+",
                                                      style: TextStyle(
                                                        fontSize: 17,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ));
                        });
                  }

                  return Container();
                }),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 5.0),
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(
                  () => Text(
                    "PKR : ${productPriceController.totalPrice.value.toStringAsFixed(1)}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: GestureDetector(
                    onTap: () {
                      Get.to(() => CheckOutScreen());
                    },
                    child: Container(
                      width: Get.width / 2.5,
                      height: Get.height / 14,
                      decoration: BoxDecoration(
                        color: appColor,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "CHECKOUT",
                            style: TextStyle(
                              color: AppConstant.appTextColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8.0), // Space between text and icon
                          Icon(
                            Icons.arrow_forward,
                            color: AppConstant.appTextColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        
        ],
      ),
    );
  }
}
