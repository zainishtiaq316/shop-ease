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
import 'package:shopease/models/order-model.dart';
import 'package:shopease/models/product-model.dart';
import 'package:shopease/screens/user-panel/checkout-screen.dart';
import 'package:shopease/utils/app-constant.dart';

import '../../controllers/cart-price-controller.dart';
import 'product-detail-screen.dart';

class AllOrdersScreen extends StatefulWidget {
  const AllOrdersScreen({super.key});

  @override
  State<AllOrdersScreen> createState() => _AllOrdersScreenState();
}

class _AllOrdersScreenState extends State<AllOrdersScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  final ProductPriceController productPriceController =
      Get.put(ProductPriceController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: appColor,
          surfaceTintColor: appColor,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "My Orders",
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              //passing this to a route
              Navigator.of(context).pop();
            },
          ),
        ),
       
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('orders')
              .doc(user!.uid)
              .collection('confirmOrders')
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
                  child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final productData = snapshot.data!.docs[index];
                        OrderModel orderModel = OrderModel(
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
                              productData['productTotalPrice'].toString(),
                            ),
                            customerId: productData['customerId'],
                            customerStreet: productData['customerStreet'],
                            customerCity : productData ['customerCity'],
                            customerCountry : productData ['customerCountry'],
                            customerZipCode : productData['customerZipCode'],
                            customerDeviceToken:
                                productData['customerDeviceToken'],
                            customerName: productData['customerName'],
                            customerPhone: productData['customerPhone'],
                            status: productData['status']);

                        //CALCULATE PRICE

                        productPriceController.fetchProductPrice();
                        return Card(
                          elevation: 5,
                          color: AppConstant.appTextColor,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: AppConstant.appMainColor,
                              backgroundImage:
                                  NetworkImage(orderModel.productImages[0]),
                            ),
                            title: Text(orderModel.productName),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(orderModel.productTotalPrice.toString()),
                                SizedBox(
                                  width: 10.0,
                                ),
                                orderModel.status != true
                                    ? Text(
                                        "Pending",
                                        style: TextStyle(color: Colors.green),
                                      )
                                    : Text("Delivered",
                                        style: TextStyle(color: Colors.red))
                              ],
                            ),
                          ),
                        );
                      }));
            }

            return Container();
          }),
    );
  }
}
