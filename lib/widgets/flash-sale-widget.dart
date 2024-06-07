import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_card/image_card.dart';
import 'package:shopease/controllers/favourite-controller.dart';
import 'package:shopease/models/categories-model.dart';
import 'package:shopease/models/product-model.dart';
import 'package:shopease/screens/user-panel/product-detail-screen.dart';
import 'package:shopease/utils/app-constant.dart';
import 'package:shopease/widgets/favourite-button.dart';

import '../screens/user-panel/all-fetch-sale-product-screen.dart';
import 'heading-widget.dart';

class FlashSaleWidget extends StatefulWidget {
  const FlashSaleWidget({super.key});

  @override
  State<FlashSaleWidget> createState() => _FlashSaleWidgetState();
}

class _FlashSaleWidgetState extends State<FlashSaleWidget> {
   final FavoriteController  favoriteController=  Get.put(FavoriteController());
  @override
  
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('products')
            .where('isSale', isEqualTo: true)
            .get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeadingWidget(
                  headingTitle: "Flash Sale",
                  headSubTitle: "According to your budget",
                  onTap: () => Get.to(() => AllFetchSaleProductScreen()),
                  buttonText: "See all",
                ),
                Container(
                  height: Get.height / 3.5,
                  child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final productData = snapshot.data!.docs[index];
                        ProductModel productModel = ProductModel(
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
                            updatedAt: productData['updatedAt']);
                        // CategoriesModel categoriesModel = CategoriesModel(
                        //     updatedAt: snapshot.data!.docs[index]['updatedAt'],
                        //     createdAt: snapshot.data!.docs[index]['createdAt'],
                        //     categoryId: snapshot.data!.docs[index]['categoryId'],
                        //     categoryImg: snapshot.data!.docs[index]['categoryImg'],
                        //     categoryName: snapshot.data!.docs[index]['categoryName']);
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                             
                                GestureDetector(
                                  onTap: () => Get.to(() => ProductDetailsScreen(
                                      productModel: productModel)),
                                  child: Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Container(
                                      width: Get.width / 2.5,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.3),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(20.0)),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  productModel.productImages[0],
                                              width: Get.width / 2.5,
                                              height: Get.height /
                                                  6, // Adjusted height for better proportions
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              productModel.productName,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  'Rs ${productModel.salePrice}',
                                                  style: TextStyle(
                                                      fontSize: 12.0,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.green,
                                                      overflow:
                                                          TextOverflow.ellipsis),
                                                ),
                                                SizedBox(width: 5.0),
                                                Text(
                                                  '${productModel.fullPrice}',
                                                  style: TextStyle(
                                                      fontSize: 12.0,
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                      color: AppConstant
                                                          .appSecondaryColor,
                                                      overflow:
                                                          TextOverflow.ellipsis),
                                                ),
                                              ],
                                            ),
                                          ),
                                          
                                          SizedBox(height: 8.0),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              
                              Positioned(
                                top: 12,
                                right: 15,
                                child: Container(
                                child: ItemFavoriteButton(model: productModel)
                              ))
                              ],
                            )
                          ],
                        );
                      }),
                ),
              ],
            );
          }

          return Container();
        });
  }
}
