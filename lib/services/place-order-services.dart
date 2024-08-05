import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shopease/models/order-model.dart';
import 'package:shopease/screens/home_page.dart';
import 'package:shopease/screens/user-panel/main-screen.dart';
import 'package:shopease/utils/app-constant.dart';

import 'generate-order-id-service.dart';

void placeOrder(
    {
      
    required BuildContext context,
    required String customerName,
    required String customerPhone,
    required String customerStreet,
    required String customerCity,
    required String customerZipCode,
    required String customerCountry,

    required String customerAddress,

    required String price,
    required String paymentMethod,
    required bool paymentStatus,
    required String customerDeviceToken,
    }) async {
  final user = FirebaseAuth.instance.currentUser;
  EasyLoading.show(status: "Please Wait .");
  if (user != null) {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('cart')
          .doc(user.uid)
          .collection('cartOrders')
          .get();

      List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      for (var doc in documents) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>;

        String orderId = generateOrderId();

        OrderModel cartModel = OrderModel(
            categoryId: data['categoryId'],
            categoryName: data['categoryName'],
            createdAt: DateTime.now(),
            deliveryTime: data['deliveryTime'],
            fullPrice: data['fullPrice'],
            isSale: data['isSale'],
            productDescription: data['productDescription'],
            productId: data['productId'],
            productImages: data['productImages'],
            productName: data['productName'],
            salePrice: data['salePrice'],
            updatedAt: data['updatedAt'],
            productQuantity: data['productQuantity'],
            productTotalPrice: double.parse(
              data['productTotalPrice'].toString(),
            ),
            customerId: user.uid,
            status: false,
            customerName: customerName,
            customerPhone: customerPhone,
            customerStreet: customerStreet,
            customerCity : customerCity,
            customerCountry : customerCountry,
            customerZipCode:  customerZipCode,
            customerAddress: customerAddress,
            paymentMethod: paymentMethod,
            paymentStatus: paymentStatus,
            customerDeviceToken: customerDeviceToken);

        for (var x = 0; x < documents.length; x++) {
          await FirebaseFirestore.instance
              .collection('orders')
              .doc(user.uid)
              .update({
            'uId': user.uid,
            'customerDeviceToken': customerDeviceToken,
            'orderStatus': false,
            'createdAt': DateTime.now()
          });

          //uplaod orders

          await FirebaseFirestore.instance
              .collection('orders')
              .doc(user.uid)
              .collection('confirmOrders')
              .doc(orderId)
              .set(cartModel.toMap());

          //delete cart product

          await FirebaseFirestore.instance
              .collection('cart')
              .doc(user.uid)
              .collection('cartOrders')
              .doc(cartModel.productId.toString())
              .delete()
              .then((value) {
            print("Delete cart Product ${cartModel.productId.toString()}");
          });
        }
      }
      print("Order Confirmed");
      Get.snackbar("Order Confirmed", "Thank you for your order!",
          backgroundColor: Colors.green.shade400,
          colorText: Colors.white,
          duration: Duration(seconds: 2));

          EasyLoading.dismiss();
          Get.offAll(()=> HomePageView());
    } catch (e) {
      print("Error $e");
    }
  }
}
