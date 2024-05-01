import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_card/image_card.dart';
import 'package:shopease/models/categories-model.dart';
import 'package:shopease/models/product-model.dart';
import 'package:shopease/utils/app-constant.dart';

import '../screens/user-panel/product-detail-screen.dart';

class AllProductsWidget extends StatefulWidget {
  const AllProductsWidget({super.key});

  @override
  State<AllProductsWidget> createState() => _AllProductsWidgetState();
}

class _AllProductsWidgetState extends State<AllProductsWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('products')
            .where('isSale', isEqualTo: false)
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
            return GridView.builder(
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                    childAspectRatio:0.80),
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
                      GestureDetector(
                        onTap: ()=> Get.to(()=> ProductDetailsScreen(productModel: productModel))
                        
                        , child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Container(
                            child: FillImageCard(
                              borderRadius: 20.0,
                              width: Get.width / 2.3,
                              heightImage: Get.height / 6,
                              imageProvider: CachedNetworkImageProvider(
                                  productModel.productImages[0]),
                              title: Center(
                                  child: Text(
                                productModel.productName,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(fontSize: 12.0),
                              )),
                              footer: Center(child: Text("PKR" + productModel.fullPrice)),
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                });
          }

          return Container();
        });
  }
}
