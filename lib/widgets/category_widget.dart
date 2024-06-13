import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_card/image_card.dart';
import 'package:shopease/models/categories-model.dart';
import 'package:shopease/screens/user-panel/all-categories-screen.dart';
import 'package:shopease/screens/user-panel/single-category-product-screen.dart';
import 'package:shopease/utils/app-constant.dart';
import 'package:shopease/widgets/heading-widget.dart';

class CategoriesWidget extends StatefulWidget {
  const CategoriesWidget({super.key});

  @override
  State<CategoriesWidget> createState() => _CategoriesWidgetState();
}

class _CategoriesWidgetState extends State<CategoriesWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance.collection('categories').get(),
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
                child: CupertinoActivityIndicator(
                  color: appColor,
                ),
              ),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return SizedBox.shrink();
          }
          if (snapshot.data != null) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeadingWidget(
                  headingTitle: "Categories",
                  headSubTitle: "Explore our diverse range",
                  onTap: () => Get.to(() => AllCategoriesScreen()),
                  buttonText: "View More",
                ),
                Container(
                  height: Get.height / 7,
                  child: ListView.builder(
                      itemCount: snapshot.data!.docs.length > 7
                          ? 7
                          : snapshot.data!.docs.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        CategoriesModel categoriesModel = CategoriesModel(
                            updatedAt: snapshot.data!.docs[index]['updatedAt'],
                            createdAt: snapshot.data!.docs[index]['createdAt'],
                            categoryId: snapshot.data!.docs[index]
                                ['categoryId'],
                            categoryImg: snapshot.data!.docs[index]
                                ['categoryImg'],
                            categoryName: snapshot.data!.docs[index]
                                ['categoryName']);
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () =>
                                  Get.to(() => AllSingleCategoryProductScreen(
                                        categoryId: categoriesModel.categoryId,
                                        name: categoriesModel.categoryName,
                                      )),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 10, right: 8, top: 8, bottom: 8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Circular Image
                                    Container(
                                      width: Get.width / 5.5,
                                      height: Get.width /
                                          5.5, // Use width to ensure it's a circle
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: CachedNetworkImageProvider(
                                              categoriesModel.categoryImg),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    // Category Name
                                    SizedBox(
                                        height:
                                            8.0), // Space between image and text
                                    Text(
                                      categoriesModel.categoryName,
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
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
