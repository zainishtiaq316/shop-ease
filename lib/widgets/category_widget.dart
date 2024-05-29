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
                child: CupertinoActivityIndicator(),
              ),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text("No category found"),
            );
          }
          if (snapshot.data != null) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeadingWidget(
                          headingTitle: "Categories",
                          headSubTitle: "According to your budget",
                          onTap: () => Get.to(() => AllCategoriesScreen()),
                          buttonText: "See all",
                        ),
                Container(
                  height: Get.height / 5.5,
                  child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        CategoriesModel categoriesModel = CategoriesModel(
                            updatedAt: snapshot.data!.docs[index]['updatedAt'],
                            createdAt: snapshot.data!.docs[index]['createdAt'],
                            categoryId: snapshot.data!.docs[index]['categoryId'],
                            categoryImg: snapshot.data!.docs[index]['categoryImg'],
                            categoryName: snapshot.data!.docs[index]['categoryName']);
                        return Row(
                         mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
  onTap: () => Get.to(() => AllSingleCategoryProductScreen(categoryId: categoriesModel.categoryId)),
  child: Padding(
    padding: EdgeInsets.all(5.0),
    child: Padding(
      padding: const EdgeInsets.only(left: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Circular Image
          Container(
            width: Get.width / 4.5,
            height: Get.width / 4.5, // Use width to ensure it's a circle
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: CachedNetworkImageProvider(categoriesModel.categoryImg),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Category Name
          SizedBox(height: 8.0), // Space between image and text
          Text(
            categoriesModel.categoryName,
            style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
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
