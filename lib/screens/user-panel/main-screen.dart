import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shopease/screens/auth-ui/welcome-screen.dart';
import 'package:shopease/screens/user-panel/all-categories-screen.dart';
import 'package:shopease/screens/user-panel/all-fetch-sale-product-screen.dart';
import 'package:shopease/screens/user-panel/all-products-screen.dart';
import 'package:shopease/utils/app-constant.dart';
import 'package:shopease/widgets/all-products-widget.dart';
import 'package:shopease/widgets/banner-widget.dart';
import 'package:shopease/widgets/category_widget.dart';
import 'package:shopease/widgets/custom-drawer-widget.dart';
import 'package:shopease/widgets/flash-sale-widget.dart';
import 'package:shopease/widgets/heading-widget.dart';

import 'cart-screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: Get.height / 90.0,
            ),
            BannerWidet(),
           
            CategoriesWidget(),
           
            FlashSaleWidget(),
            HeadingWidget(
              headingTitle: "All Products",
              headSubTitle: "According to your budget",
              onTap: () => Get.to(() => AllProductsScreen()),
              buttonText: "See all",
            ),
            AllProductsWidget()
          ],
        )),
      );
    
    
    
    
    // Scaffold(
    //   appBar: AppBar(
    //     iconTheme: IconThemeData(color: AppConstant.appTextColor),
    //     systemOverlayStyle: SystemUiOverlayStyle(
    //         statusBarColor: AppConstant.appSecondaryColor,
    //         statusBarIconBrightness: Brightness.light),
    //     backgroundColor: AppConstant.appMainColor,
    //     title: Text(
    //       AppConstant.appMainName,
    //       style: TextStyle(color: AppConstant.appTextColor),
    //     ),
    //     centerTitle: true,
    //     actions: [
    //       GestureDetector(
    //         onTap: () => Get.to(() => CartScreen()),
    //         child: Padding(
    //           padding: const EdgeInsets.all(8.0),
    //           child: Icon(Icons.shopping_cart),
    //         ),
    //       )
    //     ],
    //   ),
    //   drawer: DrawerWidget(),
      
      
    //   body: SingleChildScrollView(
    //     physics: BouncingScrollPhysics(),
    //     child: Container(
    //         child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         SizedBox(
    //           height: Get.height / 90.0,
    //         ),
    //         BannerWidet(),
    //         HeadingWidget(
    //           headingTitle: "Categories",
    //           headSubTitle: "According to your budget",
    //           onTap: () => Get.to(() => AllCategoriesScreen()),
    //           buttonText: "See More >",
    //         ),
    //         CategoriesWidget(),
    //         HeadingWidget(
    //           headingTitle: "Flash Sale",
    //           headSubTitle: "According to your budget",
    //           onTap: () => Get.to(() => AllFetchSaleProductScreen()),
    //           buttonText: "See More >",
    //         ),
    //         FlashSaleWidget(),
    //         HeadingWidget(
    //           headingTitle: "All Products",
    //           headSubTitle: "According to your budget",
    //           onTap: () => Get.to(() => AllProductsScreen()),
    //           buttonText: "See More >",
    //         ),
    //         AllProductsWidget()
    //       ],
    //     )),
    //   ),
    // );
  }
}
