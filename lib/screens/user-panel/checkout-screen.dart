import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:get/get.dart';
import 'package:image_card/image_card.dart';
import 'package:shopease/controllers/get-customer-device-controller.dart';
import 'package:shopease/models/cart-model.dart';
import 'package:shopease/models/product-model.dart';
import 'package:shopease/screens/user-panel/add-shipping-details.dart';
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

 String selectedOption = '';

 void selectOption(String option) {
    setState(() {
      selectedOption = option;
    });

    // Print the selected option to the console
    print('Selected Payment Option: $option');

    
  }
  
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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
                  return Container(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5.0),
                          padding: EdgeInsets.all(10.0),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Colors.green.shade500,
                              border:
                                  Border.all(color: Colors.green, width: 0.2),
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            children: [
                              Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 35,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Add Shipping Address",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 13),
                              )
                            ],
                          )),
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          children: [
                            Text(
                              "Shipping Information ",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: (){
                                Get.to(()=>ShippingDetails());
                              },
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: 8, right: 8, top: 5, bottom: 5),
                                decoration: BoxDecoration(
                                    color: Colors.green.shade400,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text(
                                  "Edit",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 5.0),
                        padding: EdgeInsets.all(10.0),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            border: Border.all(color: Colors.grey, width: 0.2),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Name : ",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Zain Ishtiaq",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 13),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Text(
                                  "Phone : ",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "+923028163676",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 13),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Street : ",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Text(
                                    "Madinah Street Mangla Road",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "City : ",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Text(
                                    "Dina",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Country : ",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Text(
                                    "Pakistan",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Zip Code : ",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Text(
                                    "49400",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          children: [
                            Text(
                              "Order Summary ",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 5.0),
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 3,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ListView.separated(
                          itemCount: snapshot.data!.docs.length,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          separatorBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Divider(
                                color: Colors.grey.shade300,
                                thickness: 1.0,
                              ),
                            );
                          },
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
                                  productData['productTotalPrice'].toString()),
                            );

                            // CALCULATE PRICE
                            productPriceController.fetchProductPrice();

                            return Container(
                              padding: EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.25,
                                    height: MediaQuery.of(context).size.width *
                                        0.25,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
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
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                              fontSize: 18.0,
                                            ),
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                'PKR ${cartModel.productTotalPrice.toString()}',
                                                style: TextStyle(
                                                  color: Colors.green.shade700,
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              SizedBox(width: 10.0),
                                              Text(
                                                "x${cartModel.productQuantity}",
                                                style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.timer,
                                                color: Colors.orange,
                                                size: 16.0,
                                              ),
                                              SizedBox(width: 5.0),
                                              Text(
                                                'Delivery: ${cartModel.deliveryTime}',
                                                style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 14.0,
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
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          children: [
                            Text(
                              "Payment Method",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),


                      
                    PaymentOption(
            option: 'Cash On Delivery',
            imagePath: 'assets/images/cash.png',
            isSelected: selectedOption == 'Cash On Delivery',
            onSelect: () => selectOption('Cash On Delivery'),
            backgroundColor: Colors.green.shade100,
            textColor: Colors.green.shade900,
          ),
          PaymentOption(
            option: 'RazorPay',
            imagePath: 'assets/images/razorpay.png',
            isSelected: selectedOption == 'RazorPay',
            onSelect: () => selectOption('RazorPay'),
            backgroundColor: Colors.blue.shade100,
            textColor: Colors.blue.shade900,
          ),
                   
                    ],
                  ));
                }

                return Container();
              }),
        ),
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

class PaymentOption extends StatelessWidget {
  final String option;
  final String imagePath;
  final bool isSelected;
  final VoidCallback onSelect;
  final Color backgroundColor;
  final Color textColor;

  PaymentOption({
    required this.option,
    required this.imagePath,
    required this.isSelected,
    required this.onSelect,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
        padding: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(
            color: isSelected ? textColor : Colors.transparent,
            width: 2.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 25,
              height: 25,
              child: Image.asset(imagePath),
            ),
            SizedBox(width: 10),
            Text(
              option,
              style: TextStyle(
                color: textColor,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            isSelected ?
            Icon(
              Icons.check_circle,
              color: isSelected ? textColor : Colors.grey,
            ) : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}