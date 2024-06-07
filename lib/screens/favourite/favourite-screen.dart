import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopease/models/product-model.dart';
import 'package:shopease/screens/user-panel/product-detail-screen.dart';
import 'package:shopease/utils/app-constant.dart';
import 'package:shopease/widgets/favourite-button.dart';
import '../../controllers/favourite-controller.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({Key? key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  final FavoriteController _favoriteController = Get.put(FavoriteController());

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
            "Favourites",
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              //passing this to a route
              Navigator.of(context).pop();
            },
          ),
        
        actions: [
                    GestureDetector(
                       onTap: () => _favoriteController.deleteAllFavorites(),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.delete, color: Colors.white,),
                      ),
                    )
                  ],
        ),
       
      body:  StreamBuilder<QuerySnapshot>(
      stream: _favoriteController.getFavoritesStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final favorites =
              snapshot.data!.docs.map((doc) => doc.data() as dynamic).toList();

          if (favorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'No favorites found',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              childAspectRatio: 0.9,
            ),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final item = favorites[index];
              final productModel = ProductModel(
                productId: item['productId'],
                categoryId: item['categoryId'],
                productName: item['productName'],
                categoryName: item['categoryName'],
                salePrice: item['salePrice'],
                fullPrice: item['fullPrice'],
                productImages: item['productImages'],
                deliveryTime: item['deliveryTime'],
                isSale: item['isSale'],
                productDescription: item['productDescription'],
                createdAt: item['createdAt'],
                updatedAt: item['updatedAt'],
              );
              return TripCard(
                detailsPage: ProductDetailsScreen(productModel: productModel),
                productModel: productModel,
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    ),
    ); }
}

class TripCard extends StatelessWidget {
  final ProductModel productModel;
  final Widget detailsPage;

  TripCard({
    required this.productModel,
    required this.detailsPage,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Color(0XFFF3E5F5),
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(
              color: Colors.purple.shade100,
              width: 2.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: InkWell(
            onTap: () {
              Get.to(() => detailsPage);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(13.0),
                      topRight: Radius.circular(13.0),
                    ),
                    image: DecorationImage(
                      image: productModel.productImages.isNotEmpty
                          ? NetworkImage(productModel.productImages[0])
                          : AssetImage('assets/placeholder_image.png')
                              as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                  width: double.infinity,
                  height: Get.height / 7,
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    productModel.productName,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      productModel.isSale == true &&
                              productModel.salePrice != ''
                          ? Text(
                              "PKR: " + productModel.salePrice,
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.green,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          : Text(
                              "PKR: " + productModel.fullPrice,
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.green,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.1,
            height: MediaQuery.of(context).size.height * 0.05,
            decoration: BoxDecoration(
              color: Colors.purple.shade100,
              shape: BoxShape.circle,
            ),
            child: Center(child: ItemFavoriteButton(model: productModel)),
          ),
        ),
      ],
    );
  }
}
