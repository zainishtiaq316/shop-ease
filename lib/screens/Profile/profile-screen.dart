import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shopease/screens/Profile/edit-profile.dart';
import 'package:shopease/screens/Profile/my-account.dart';
import 'package:shopease/utils/app-constant.dart';

import 'change-password.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    
    User? user = FirebaseAuth.instance.currentUser;
     String? imageUrl = user?.photoURL;
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: appColor,
            )); // Loading indicator while fetching data
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            Map<String, dynamic>? userData = snapshot.data?.data();
            String? firstName = userData?['firstName'];
            String? SecondName = userData?['lastName'];
            String? email = userData?['email'];
            String? dateOfBirth = userData?['dateOfBirth'];
            String? gender = userData?['gender'];
            String? phone = userData?['phone'];

            return SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height * 1.21,
                width: MediaQuery.of(context).size.width,
                color: appColor,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 70,
                          backgroundImage: imageUrl != null
                                              ? NetworkImage(imageUrl)
                                              : null,
                                          child: imageUrl == null
                                              ? Text(
                                                  firstName != null
                                                      ? firstName[0].toUpperCase()
                                                      : "",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                )
                                              : null,),
                        Positioned(
                            right: 0,
                            top: 90,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            EditProfileScreen()));
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle),
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.green.shade900,
                                ),
                              ),
                            ))
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "${firstName} ${SecondName}",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "${email}",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                          fontSize: 14),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 2,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30))),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 20, left: 20, right: 20, bottom: 20),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.256,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 15, bottom: 15),
                                  child: Column(
                                    children: [
                                      personalDetail("Email",
                                          "${email??""}"),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Divider(
                                        thickness: 2,
                                        color: Colors.grey.shade300,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      // 24-06-2001
                                      personalDetail(
                                          "Date of Birth", "${dateOfBirth??""}"),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Divider(
                                        thickness: 2,
                                        color: Colors.grey.shade300,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      personalDetail("Gender", "${gender??""}"),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Divider(
                                        thickness: 2,
                                        color: Colors.grey.shade300,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      personalDetail("Phone", "${phone??""}"),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, bottom: 20),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AccountInfo()));
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 0.09,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                          top: 15,
                                          bottom: 15),
                                      child: buttons(
                                          "assets/images/account.png",
                                          "My Account",
                                          Colors.blue,
                                          Colors.blue.shade100)),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, bottom: 20),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ChangePasswordScreen()));
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 0.09,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                          top: 15,
                                          bottom: 15),
                                      child: buttons(
                                          "assets/images/lock.png",
                                          "Change Password",
                                          Colors.pink,
                                          Colors.grey.shade200)),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, bottom: 20),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.175,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 15, bottom: 15),
                                  child: Column(
                                    children: [
                                      buttons(
                                          "assets/images/myOrders.png",
                                          "My Orders",
                                          Colors.green,
                                          Colors.green.shade100),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Divider(
                                        thickness: 2,
                                        color: Colors.grey.shade300,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      buttons("assets/images/help.png", "Help",
                                          Colors.purple, Colors.purple.shade100)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, bottom: 20),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.09,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                        top: 15,
                                        bottom: 15),
                                    child: buttons(
                                        "assets/images/logout.png",
                                        "Log Out",
                                        Colors.red,
                                        Colors.red.shade100)),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        });
  }

  Widget personalDetail(
    String name,
    String value,
  ) {
    return Row(
      children: [
        Text(
          "$name",
          style: TextStyle(
              color: Colors.black, fontSize: 15, fontWeight: FontWeight.w600),
        ),
        Spacer(),
        Text(
          "$value",
          style: TextStyle(
              fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w400),
        )
      ],
    );
  }

  Widget buttons(String imageLink, String name, Color color, Color background) {
    return Row(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.1,
          height: MediaQuery.of(context).size.height * 0.05,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: background,
          ),
          child: Padding(
            padding: const EdgeInsets.all(7.0),
            child: Image.asset(
              "$imageLink",
              color: color,
            ),
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Text(
          "$name",
          style: TextStyle(
              color: Colors.black, fontSize: 15, fontWeight: FontWeight.w600),
        )
      ],
    );
  }
}
