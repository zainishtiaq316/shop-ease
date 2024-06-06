import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopease/screens/Profile/Admin-contact.dart';
import 'package:shopease/screens/Profile/developer-contact.dart';
import 'package:shopease/utils/app-constant.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({Key? key}) : super(key: key);

  @override
  _HelpCenterScreenState createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: appColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Help Center",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            //passing this to a route
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ListView(
        children: [
          ExpansionTile(
            title: Text('How do I create an account?'),
            iconColor: appColor,
            collapsedIconColor: appColor,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Text(
                    'To create an account, go to the registration page and fill in the required details. Once you have submitted the form, you will receive a verification email. Click on the verification link in the email to activate your account.'),
              ),
            ],
          ),
          ExpansionTile(
            title: Text('How do I place an order?'),
            iconColor: appColor,
            collapsedIconColor: appColor,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Text(
                    'To place an order, browse the products, add your desired items to the cart, and proceed to checkout. Fill in the required shipping and payment details, then confirm your order.'),
              ),
            ],
          ),
          ExpansionTile(
            title: Text('How can I track my order?'),
            iconColor: appColor,
            collapsedIconColor: appColor,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Text(
                    'To track your order, go to the "My Orders" section in your account. Select the order you want to track to see the current status and estimated delivery time.'),
              ),
            ],
          ),
          ExpansionTile(
            title: Text('What is the return policy?'),
            iconColor: appColor,
            collapsedIconColor: appColor,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Text(
                    'Our return policy allows you to return items within 30 days of receipt. The items must be unused and in their original packaging. Visit the "Returns" section for more details and to initiate a return.'),
              ),
            ],
          ),
        ExpansionTile(
            title: Text('What payment methods are accepted?'),
            iconColor: appColor,
            collapsedIconColor: appColor,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Text(
                    'We accept various payment methods including Easypaisa/Jazzcash and Cash on Delivery . Select your preferred method during checkout.'),
              ),
            ],
          ),
          ExpansionTile(
            title: Text('How can I contact customer support?'),
            iconColor: appColor,
            collapsedIconColor: appColor,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Text(
                    'You can contact customer support via the "Contact Us Admin" section in the app. You can also reach us through email or our customer service hotline.'),
              ),
            ],
          ),
          ExpansionTile(
            iconColor: appColor,
            collapsedIconColor: appColor,
            title: Text(
              'Developer Contacts',
              style: TextStyle(color: Colors.black),
            ),
            children: [
              ListTile(
                title: Text(
                  'Contact with Developer',
                  style: TextStyle(color: appColor),
                ),
                onTap: () {
                  Get.to(() => DeveloperContactPage());
                },
              ),
                            ListTile(
                title: Text(
                  'Contact Us Admin',
                  style: TextStyle(color: appColor),
                ),
                onTap: () {
                  Get.to(() => AdminContactPage());
                },
              ),
            
            
            ],
          )
        ],
      ),
    );
  }
}
