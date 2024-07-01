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
import 'package:shopease/controllers/favourite-controller.dart';
import 'package:shopease/models/cart-model.dart';
import 'package:shopease/models/product-model.dart';
import 'package:shopease/models/user-model.dart';
import 'package:shopease/screens/chat-panel/chat-screen.dart';
import 'package:shopease/screens/user-panel/cart-screen.dart';
import 'package:shopease/utils/app-constant.dart';
import 'package:shopease/widgets/favourite-button.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetailsScreen extends StatefulWidget {
  ProductModel productModel;
  ProductDetailsScreen({super.key, required this.productModel});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  final FavoriteController _favoriteController = Get.put(FavoriteController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: Text("Product Details"),
        actions: [
          GestureDetector(
            onTap: () => Get.to(() => CartScreen()),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.shopping_cart),
            ),
          )
        ],
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
                            ItemFavoriteButton(model: widget.productModel),
                          ],
                        ),
                      ),
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
                                    sendMessageOnWhatsApp(
                                        productModel: widget.productModel);
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
                        )),
                    StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(user?.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                                child: CircularProgressIndicator(
                              color: appColor,
                            )); // Loading indicator while fetching data
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            Map<String, dynamic>? userData =
                                snapshot.data?.data();
                            String? firstName = userData?['firstName'];
                            String? SecondName = userData?['lastName'];
                            String? email = userData?['email'];
                            String? dateOfBirth = userData?['dateOfBirth'];
                            String? gender = userData?['gender'];
                            String? phone = userData?['phone'];
                            bool ? isOnline = userData?['is_online'];
                            String ? last_active = userData?['last_active'];
                            String? language = userData?['language'];
                            String uid = userData?['uid'];
                            String userImg = userData?['userImg'];
                            String userDeviceToken = userData?['userDeviceToken'];
                            String userAddress = userData?['userAddress'];
                            dynamic updatedTime = userData?['updatedTime'];
                            dynamic updatedOn = userData?['updatedOn'];
                            String street = userData?['street'];
                            bool isActive = userData?['isActive'];
                            bool isAdmin = userData?['isAdmin'];
                            String city = userData?['city'];
                            dynamic createdOn = userData?['createdOn'];
                            String country = userData?['country'];
                            dynamic joinedTime = userData?['joinedTime'];

                            return Material(
                              child: Container(
                                width: Get.width / 3.0,
                                height: Get.height / 16,
                                decoration: BoxDecoration(
                                    color: AppConstant.appSecondaryColor,
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: TextButton(
                                  onPressed: () async {
                                    Get.to(() => ChatScreen(
                                          user: UserModel(
                                              Gender: gender!,
                                              isOnline: isOnline!,
                                              lastActive: last_active!,
                                              dateOfBirth: dateOfBirth!,
                                              language: language!,
                                              updatedOn: updatedOn,
                                              updatedTime: updatedTime,
                                              joinedTime: joinedTime,
                                              country: country,
                                              createdOn: createdOn,
                                              email: email!,
                                              city: city,
                                              isAdmin: isAdmin,
                                              isActive: isActive,
                                              phone: phone!,
                                              lastName: SecondName!,
                                              street: street,
                                              uid: uid,
                                              userAddress: userAddress,
                                              userDeviceToken: userDeviceToken,
                                              userImg: userImg,
                                              firstName: firstName!),
                                        ));
                                  },
                                  child: Text(
                                    "Chat",
                                    style: TextStyle(
                                      color: AppConstant.appTextColor,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                        }),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  static Future<void> sendMessageOnWhatsApp(
      {required ProductModel productModel}) async {
    final number = "+923028163676";
    final message =
        "Hello Shop-ease \n i want to know about this product \n ${productModel.productName} \n${productModel.productId}";

    final url = 'https://wa.me/$number?text=${Uri.encodeComponent(message)}';

    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      // ignore: deprecated_member_use
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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
      double totalPrice = double.parse(widget.productModel.isSale
              ? widget.productModel.salePrice
              : widget.productModel.fullPrice) *
          updatedQuantity;
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
          productTotalPrice: double.parse(widget.productModel.isSale
              ? widget.productModel.salePrice
              : widget.productModel.fullPrice),
          salePrice: widget.productModel.salePrice,
          updatedAt: DateTime.now());

      await documentReference.set(cartModel.toMap());

      print("product added");
    }
  }
}
