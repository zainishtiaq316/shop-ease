import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_card/image_card.dart';
import 'package:shopease/models/categories-model.dart';
import 'package:shopease/models/product-model.dart';
import 'package:shopease/screens/user-panel/product-detail-screen.dart';
import 'package:shopease/screens/user-panel/single-category-product-screen.dart';
import 'package:shopease/utils/app-constant.dart';
import 'package:shopease/widgets/favourite-button.dart';

class AllFetchSaleProductScreen extends StatefulWidget {
  const AllFetchSaleProductScreen({super.key});

  @override
  State<AllFetchSaleProductScreen> createState() =>
      _AllFetchSaleProductScreenState();
}

class _AllFetchSaleProductScreenState extends State<AllFetchSaleProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: appColor,
        surfaceTintColor: appColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "All Flash Sale Products",
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
      body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('products')
              .where('isSale', isEqualTo: true)
              .get(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Error"),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                child: Center(
                  child: CupertinoActivityIndicator(
                    color: appColor,
                  ),
                ),
              );
            }

            if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text("No product found"),
              );
            }
            if (snapshot.data != null) {
              return Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: GridView.builder(
                  itemCount: snapshot.data!.docs.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 0,
                    crossAxisSpacing: 0,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (context, index) {
                    final productData = snapshot.data!.docs[index];
                    ProductModel productModel = ProductModel(
                      categoryId: productData['categoryId'],
                      categoryName: productData['categoryName'],
                      createdAt: productData['createdAt'],
                      deliveryTime: productData['deliveryTime'],
                      fullPrice: productData['fullPrice'],
                      isSale: productData['isSale'],
                      productDescription: productData['productDescription'],
                      productId: productData['productId'],
                      productImages:
                          List<String>.from(productData['productImages']),
                      productName: productData['productName'],
                      salePrice: productData['salePrice'],
                      updatedAt: productData['updatedAt'],
                    );
                
                    return Stack(
                      children: [
                        GestureDetector(
                          onTap: () => Get.to(() =>
                              ProductDetailsScreen(productModel: productModel)),
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 10, right: 8, top: 8, bottom: 8),
                            child: Container(
                              width: Get.width / 2.2,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                  color: Colors.white),
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(10.0),
                                            bottom: Radius.circular(10)),
                                        child: CachedNetworkImage(
                                          imageUrl: productModel.productImages[0],
                                          width: Get.width / 2,
                                          height: Get.height /
                                              5.8, // Adjusted height for better proportions
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(0.0),
                                      child: Text(
                                        productModel.productName,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(0.0),
                                      child: Text(
                                        productModel.categoryName,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.grey),
                                      ),
                                    ),
                                    Spacer(),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            'Rs ${productModel.salePrice}',
                                            style: TextStyle(
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green,
                                                overflow: TextOverflow.ellipsis),
                                          ),
                                          SizedBox(width: 5.0),
                                          Text(
                                            '${productModel.fullPrice}',
                                            style: TextStyle(
                                                fontSize: 12.0,
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                color:
                                                    AppConstant.appSecondaryColor,
                                                overflow: TextOverflow.ellipsis),
                                          ),
                                          Spacer(),
                                          Icon(
                                            Icons.shopping_bag,
                                            size: 20,
                                            color: Colors.grey,
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                            top: 20,
                            right: 20,
                            child: Container(
                                child: ItemFavoriteButton(model: productModel)))
                      ],
                    );
                  },
                ),
              );
              // Container(
              //   height: Get.height / 5.5,
              //   child: ListView.builder(
              //       itemCount: snapshot.data!.docs.length,
              //       shrinkWrap: true,
              //       scrollDirection: Axis.horizontal,
              //       ),
              // );
            }

            return Container();
          }),
    );
  }
}
