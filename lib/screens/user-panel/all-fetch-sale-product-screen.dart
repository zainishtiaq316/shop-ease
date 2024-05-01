import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_card/image_card.dart';
import 'package:shopease/models/categories-model.dart';
import 'package:shopease/models/product-model.dart';
import 'package:shopease/screens/user-panel/single-category-product-screen.dart';
import 'package:shopease/utils/app-constant.dart';

class AllFetchSaleProductScreen extends StatefulWidget {
  const AllFetchSaleProductScreen({super.key});

  @override
  State<AllFetchSaleProductScreen> createState() => _AllFetchSaleProductScreenState();
}

class _AllFetchSaleProductScreenState extends State<AllFetchSaleProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstant.appTextColor),
        backgroundColor: AppConstant.appMainColor,
        title: Text("All Flash Sale Products", style: TextStyle(color: AppConstant.appTextColor),),
      ),

      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('products').where('isSale', isEqualTo: true).get(),
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
              child: Text("No product found"),
            );
          }
          if (snapshot.data != null) {
            return GridView.builder(
              itemCount: snapshot.data!.docs.length,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 3, crossAxisSpacing: 3, childAspectRatio: 1.19), itemBuilder: (context, index) {
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
                          // onTap: ()=> Get.to(()=> AllSingleCategoryProductScreen(categoryId : categoriesModel.categoryId)),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Container(
                              child: FillImageCard(
                                borderRadius: 20.0,
                                width: Get.width/2.3,
                                heightImage: Get.height/10
                                ,
                                imageProvider: CachedNetworkImageProvider(productModel.productImages[0]),
                                title: Center(child: Text(productModel.productName, overflow: TextOverflow.ellipsis, maxLines: 1, style: TextStyle(fontSize: 12.0),)),
                              
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  } );
            
            
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