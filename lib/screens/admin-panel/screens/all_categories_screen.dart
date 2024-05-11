import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shopease/models/categories-model.dart';
import 'package:shopease/utils/app-constant.dart';

import 'add_category_screen.dart';

class AllCategoriesScreenAdmin extends StatefulWidget {
  AllCategoriesScreenAdmin({super.key});

  @override
  State<AllCategoriesScreenAdmin> createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreenAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: Text("All Categories"),
        actions: [InkWell(

          onTap: ()=> Get.to(()=>AddCategoriesScreen()),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.add),
          ),
        )],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('categories')
            // .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Container(
              child: Center(
                child: Text('Error occurred while fetching category!'),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              child: Center(
                child: CupertinoActivityIndicator(),
              ),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return Container(
              child: Center(
                child: Text('No categories found!'),
              ),
            );
          }

          if (snapshot.data != null) {
            return ListView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final data = snapshot.data!.docs[index];

                CategoriesModel categoriesModel = CategoriesModel(
                    categoryId: data['categoryId'],
                    categoryName: data['categoryName'],
                    categoryImg: data['categoryImg'],
                    createdAt: data['createdAt'],
                    updatedAt: data['updatedAt']);
                return SwipeActionCell(
                  key: ObjectKey(categoriesModel.categoryId),

                  /// this key is necessary
                  trailingActions: <SwipeAction>[
                    SwipeAction(
                        title: "Delete",
                        onTap: (CompletionHandler handler) async {
                          await Get.defaultDialog(
                            title: "Delete Categories",
                            content: Text(
                                "Are you sure you want to delete this categroies?"),
                            textCancel: "Cancel",
                            textConfirm: "Delete",
                            contentPadding: EdgeInsets.all(10.0),
                            confirmTextColor: Colors.white,
                            onCancel: () {},
                            onConfirm: () async {
                              Get.back(); // Close the dialog
                              EasyLoading.show(status: 'Please wait..');

                              // await deleteImagesFromFirebase(
                              //   productModel.productImages,
                              // );

                              // await FirebaseFirestore.instance
                              //     .collection('products')
                              //     .doc(productModel.productId)
                              //     .delete();

                              // EasyLoading.dismiss();
                            },
                            buttonColor: Colors.red,
                            cancelTextColor: Colors.black,
                          );
                        },
                        color: Colors.red),
                  ],
                  child: Card(
                    elevation: 5,
                    child: ListTile(
                      onTap: () {},
                      leading: CircleAvatar(
                        backgroundColor: AppConstant.appSecondaryColor,
                        backgroundImage: CachedNetworkImageProvider(
                          categoriesModel.categoryImg.toString(),
                          errorListener: (err) {
                            // Handle the error here
                            print('Error loading image');
                            Icon(Icons.error);
                          },
                        ),
                      ),
                      title: Text(categoriesModel.categoryName),
                      subtitle: Text(categoriesModel.categoryId),
                      trailing: GestureDetector(
                          onTap: () {}, child: Icon(Icons.edit)),
                    ),
                  ),
                );
              },
            );
          }

          return Container();
        },
      ),
    );
  }
}
