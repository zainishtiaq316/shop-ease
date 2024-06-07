import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shopease/controllers/favourite-controller.dart';
import 'package:shopease/screens/auth-ui/splash-screen.dart';
import 'package:shopease/screens/favourite/favourite-screen.dart';
import 'package:shopease/screens/user-panel/home-page-cart.dart';
import 'package:shopease/screens/user-panel/main-screen.dart';
import 'package:shopease/utils/app-constant.dart';
import 'package:shopease/widgets/custom-drawer-widget.dart';

import '../controllers/cart-price-controller.dart';
import 'Profile/profile-screen.dart';
import 'user-panel/cart-screen.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
   final ProductPriceController productPriceController =
      Get.put(ProductPriceController());
  late FocusNode myFocusNode;

  DateTime? currentBackPressTime;
  int _selectedIndex = 0;

  Future<bool> onWillPop() async {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: 'Press back again to exit');
      setState(() {
        myFocusNode.unfocus();
      });
      return Future.value(false);
    }
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => SplashScreen()));

    return Future.value(true);
  }

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    myFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle optionStyle =
        TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
    const List<Widget> _widgetOptions = <Widget>[
      MainScreen(),
      HomeCartScreen(),
      Text(
        'Search',
        style: optionStyle,
      ),
      ProfileScreen(),
    ];

    return WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
          backgroundColor: Colors.grey.shade100,
          drawer: DrawerWidget(),
          appBar: AppBar(
            surfaceTintColor: appColor,
            iconTheme: IconThemeData(color: AppConstant.appTextColor),
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: appColor,
                statusBarIconBrightness: Brightness.light),
            backgroundColor: appColor,
            centerTitle: true,
            title: Text(
              _selectedIndex == 0
                  ? '${AppConstant.appMainName}'
                  : _selectedIndex == 1
                      ? 'Cart'
                      : _selectedIndex == 2
                          ? 'Search'
                          : 'Profile',
              style: TextStyle(color: AppConstant.appTextColor),
            ),
            actions: _selectedIndex == 0
                ? [
                    GestureDetector(
                      onTap: () => Get.to(() => CartScreen()),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.shopping_cart),
                      ),
                    )
                  ]
                :  _selectedIndex == 1
                ? [
                    GestureDetector(
                      onTap: () => productPriceController.deleteAllCarts(),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.delete),
                      ),
                    )
                  ] : [],
          ),
          body: Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [appColor, appColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            margin:
                const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: GNav(
                backgroundColor: Colors.transparent,
                rippleColor: Colors.grey[300]!,
                hoverColor: Colors.grey[100]!,
                gap: 8,
                activeColor: Colors.white,
                iconSize: 24,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                duration: Duration(milliseconds: 400),
                tabBackgroundColor: Colors.white24,
                color: Colors.white,
                tabs: [
                  GButton(
                    icon: Icons.home,
                    text: 'Home',
                    iconColor: Colors.white,
                  ),
                  GButton(
                    icon: Icons.shopping_cart,
                    text: 'Cart',
                    iconColor: Colors.white,
                  ),
                  GButton(
                    icon: Icons.search,
                    text: 'Search',
                    iconColor: Colors.white,
                  ),
                  GButton(
                    icon: Icons.person,
                    text: 'Profile',
                    iconColor: Colors.white,
                  ),
                ],
                selectedIndex: _selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
              ),
            ),
          ),
        ));
  }
}
