import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shopease/models/user-model.dart';
import 'package:shopease/screens/chat-panel/chat-screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shopease/utils/app-constant.dart';

class AdminContactPage extends StatelessWidget {
  const AdminContactPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: appColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Contact Us Admin",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where('isAdmin', isEqualTo: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData ||
                snapshot.data == null ||
                snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No admin found'));
            }

            var adminData =
                snapshot.data!.docs.first.data() as Map<String, dynamic>;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Admin Contact Information',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Text('Name: ${adminData['name'] ?? 'N/A'}'),
                SizedBox(height: 10),
                Text('Email: ${adminData['email'] ?? 'N/A'}'),
                SizedBox(height: 10),
                Text('Phone: ${adminData['phone'] ?? 'N/A'}'),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Get.to(() => ChatScreen(
                        user: UserModel(
                            Gender: adminData['gender']??"",
                            isOnline: adminData['is_online']??"",
                            lastActive: adminData['last_active']??"",
                            dateOfBirth: adminData['dateOfBirth']??"",
                            language: adminData['language']??"",
                            updatedOn:  adminData['updatedOn']??"",
                            updatedTime: adminData['updatedTime']??"",
                            joinedTime: adminData['joinedTime']??"",
                            country: adminData['country']??"",
                            createdOn: adminData['createdOn']??"",
                            email: adminData['email']??"",
                            city: adminData['city']??"",
                            isAdmin:adminData['isAdmin']??"",
                            isActive: adminData['isActive']??"",
                            phone: adminData['phone']??"",
                            lastName: adminData['lastName']??"",
                            street: adminData['street']??"",
                            uid: adminData['uid']??"",
                            userAddress: adminData['userAddress']??"",
                            userDeviceToken: adminData['userDeviceToken']??"",
                            userImg: adminData['userImg']??"",
                            firstName: adminData['firstName']??"",)));
                  },
                  child: Text('Email Admin'),
                ),
                ElevatedButton(
                  onPressed: () {
                    launchUrl(Uri(
                      scheme: 'tel',
                      path: adminData['phone'],
                    ));
                  },
                  child: Text('Call Admin'),
                ),
                Divider(),
              ],
            );
          },
        ),
      ),
    );
  }
}
