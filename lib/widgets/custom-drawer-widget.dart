import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shopease/screens/home_page.dart';
import 'package:shopease/screens/user-panel/all-orders-screen.dart';
import 'package:shopease/screens/user-panel/all-products-screen.dart';
import 'package:shopease/utils/app-constant.dart';

import '../screens/auth-ui/welcome-screen.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
 
  String? imageUrl = user?.photoURL;
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('users').doc(user?.uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: appColor,)); // Loading indicator while fetching data
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          Map<String, dynamic>? userData = snapshot.data?.data();
          String? firstName = userData?['firstName'];
          String? SecondName = userData?['secondName'];
          String? email = userData?['email'];


          return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Drawer(
      
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0))),
      child: Padding(
        padding: EdgeInsets.only(top: Get.height / 15),
        child: Column(
  
          children: [
            CircleAvatar(
                            radius: 60.0,
                            backgroundColor: Colors.white,
                          backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
                        child: imageUrl == null ? Text(
                          firstName != null ? firstName[0].toUpperCase() : "",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ) : null,
                      ),
         SizedBox(
                            height: 10,
                          ),
                          Text(
                            "${firstName ?? ""} ${SecondName?? ""}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            email??"",
                            style: TextStyle(
                              color: Colors.white,
                            ),

                          ), 
                          
                          SizedBox(
                            height: 15,
                          ),
                           Divider(
              indent: 10.0,
              endIndent: 10.0,
              thickness: 1.5,
              color: Colors.white,
            ),
             SizedBox(
                            height: 15,
                          ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                title: Text(
                  "Home",
                  style: TextStyle(color: AppConstant.appTextColor),
                ),
                leading: Icon(
                  Icons.home,
                  color: AppConstant.appTextColor,
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: AppConstant.appTextColor,
                ),
                onTap: (){
                  Get.back();
                  Get.to(()=>HomePageView());
                },
              ),
            ),
         
           
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                title: Text(
                  "Products",
                  style: TextStyle(color: AppConstant.appTextColor),
                ),
                leading: Icon(
                  Icons.production_quantity_limits,
                  color: AppConstant.appTextColor,
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: AppConstant.appTextColor,
                ),
                onTap: (){
                  Get.back();
                  Get.to(()=>AllProductsScreen());
                },
              ),
              
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                title: Text(
                  "Orders",
                  style: TextStyle(color: AppConstant.appTextColor),
                ),
                leading: Icon(
                  Icons.shopping_bag,
                  color: AppConstant.appTextColor,
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: AppConstant.appTextColor,
                ),
                onTap: (){
                  Get.back();
                  Get.to(()=>AllOrdersScreen());
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                title: Text(
                  "Contact",
                  style: TextStyle(color: AppConstant.appTextColor),
                ),
                leading: Icon(
                  Icons.help,
                  color: AppConstant.appTextColor,
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: AppConstant.appTextColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: ListTile(
                onTap: () async {
                  GoogleSignIn googleSignIn = GoogleSignIn();
                  FirebaseAuth _auth = FirebaseAuth.instance;
                  await _auth.signOut();
                  await googleSignIn.signOut();
                  Get.offAll(WelcomeScreen());
                },
                titleAlignment: ListTileTitleAlignment.center,
                title: Text(
                  "Logout",
                  style: TextStyle(color: AppConstant.appTextColor),
                ),
                leading: Icon(
                  Icons.logout,
                  color: AppConstant.appTextColor,
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: AppConstant.appTextColor,
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: appColor,
    ),);}
      },
    ); }
}
