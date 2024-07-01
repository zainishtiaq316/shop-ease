import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:get/get.dart';
import 'package:image_card/image_card.dart';
import 'package:shopease/controllers/get-customer-device-controller.dart';
import 'package:shopease/models/cart-model.dart';
import 'package:shopease/models/product-model.dart';
import 'package:shopease/utils/app-constant.dart';

import '../../controllers/cart-price-controller.dart';
import '../../services/place-order-services.dart';
import 'product-detail-screen.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;
  final ProductPriceController productPriceController =
      Get.put(ProductPriceController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColor,
        surfaceTintColor: appColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Check Out",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            //passing this to a route
            Navigator.of(context).pop();
          },
        ),
        actions: [
          GestureDetector(
            onTap: () => productPriceController.deleteAllCarts(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
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
                return Container(
                    child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.4,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey)),
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Awesome Text',
                              hintText: 'Enter something awesome',
                              prefixIcon: Icon(Icons.star),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.clear),
                                onPressed: () {},
                              ),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.0)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 2.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.0)),
                              ),
                              filled: true,
                              fillColor:
                                  Colors.lightBlueAccent.withOpacity(0.1),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              if (value.length < 3) {
                                return 'Must be at least 3 characters long';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.height,
                      height: MediaQuery.of(context).size.height * 0.07,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.green.shade500, width: 2),
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width * 0.1,
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                child: Image.asset("assets/images/cash.png")),
                            SizedBox(
                              width: 30,
                            ),
                            Text(
                              "Cash on Delivery",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ),
                    ),
                    ListView.builder(
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
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  "x${cartModel.productQuantity}",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ));
                        }),
                  ],
                ));
              }

              return Container();
            }),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(bottom: 5.0, left: 10, right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
                      showCustomBottomSheet();
                    },
                    child: Text(
                      "Confirm Order",
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
    );
  }

  void showCustomBottomSheet() {
    Get.bottomSheet(
        Container(
          height: Get.height * 0.8,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.0))),
          child: SingleChildScrollView(
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 20.0),
                child: Container(
                  height: 55.0,
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: nameController,
                    decoration: InputDecoration(
                        labelText: "Name",
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                        hintStyle: TextStyle(
                          fontSize: 12,
                        )),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 20.0),
                child: Container(
                  height: 55.0,
                  child: TextFormField(
                    controller: phoneController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                        labelText: "Phone",
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                        hintStyle: TextStyle(
                          fontSize: 12,
                        )),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 20.0),
                child: Container(
                  height: 55.0,
                  child: TextFormField(
                    controller: addressController,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                        labelText: "Address",
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                        hintStyle: TextStyle(
                          fontSize: 12,
                        )),
                  ),
                ),
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstant.appMainColor,
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10)),
                  onPressed: () async {
                    if (nameController.text != '' &&
                        phoneController.text != '' &&
                        addressController.text != '') {
                      String name = nameController.text.trim();
                      String phone = phoneController.text.trim();
                      String address = addressController.text.trim();
                      String customerToken =
                          await getCustomerDeviceController();
                      placeOrder(
                          context: context,
                          customerName: name,
                          customerPhone: phone,
                          customerAddress: address,
                          customerDeviceToken: customerToken);
                    } else {
                      print("please fill all details");
                    }
                  },
                  child: Text(
                    "Place Order",
                    style: TextStyle(color: Colors.white),
                  ))
            ]),
          ),
        ),
        backgroundColor: Colors.transparent,
        isDismissible: true,
        enableDrag: true,
        elevation: 6);
  }
}
