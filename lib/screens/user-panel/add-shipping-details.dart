import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shopease/screens/user-panel/checkout-screen.dart';
import 'package:shopease/utils/app-constant.dart';

class ShippingDetails extends StatefulWidget {
  const ShippingDetails({super.key});

  @override
  State<ShippingDetails> createState() => _ShippingDetailsState();
}

class _ShippingDetailsState extends State<ShippingDetails> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _zipcodeController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
       EasyLoading.show(status: "Please Wait .");
      if(user !=null){
        try {
        await FirebaseFirestore.instance
            .collection('orders')
            .doc(user!.uid)
            .set({
          'uId': user!.uid,
          'customerName': _nameController.text.trim(),
          'customerPhone': '+92 ${_phoneController.text.trim()}',
          'customerAddress':
              "${_streetController.text.trim()}, ${_cityController.text.trim()}, Pakistan, ${_zipcodeController.text.trim()}",
          'createdAt': DateTime.now(),
        });
        print("Address Added");
      Get.snackbar("Address Added","Please Select Payment then CheckOut",
          backgroundColor: Colors.grey.shade300,
          colorText: Colors.black,
          duration: Duration(seconds: 2));

          EasyLoading.dismiss();
          Navigator.pop(context);
      } catch (e) {
        // Handle errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
        print('Error adding document: $e');
      }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColor,
        surfaceTintColor: appColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Add Shipping Detail",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    } else if (value.length < 4) {
                      return 'Name must be at least 4 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: "Phone",
                    prefixText: '+92 ',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a phone number';
                    } else if (!RegExp(r'^\d{10}$')
                        .hasMatch(value.replaceFirst('+92 ', ''))) {
                      return 'Phone number must be exactly 10 digits';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _streetController,
                  decoration: InputDecoration(
                    labelText: "Street",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a street';
                    } else if (value.length < 5) {
                      return 'Street must be at least 5 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _cityController,
                  decoration: InputDecoration(
                    labelText: "City",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a city';
                    } else if (value.length < 2) {
                      return 'City must be at least 2 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  initialValue: 'Pakistan',
                  decoration: InputDecoration(
                    labelText: "Country",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    enabled: false,
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _zipcodeController,
                  decoration: InputDecoration(
                    labelText: "Zipcode",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a zipcode';
                    } else if (!RegExp(r'^\d+$').hasMatch(value)) {
                      return 'Zipcode must be a number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32.0),
                GestureDetector(
                  onTap: _submitForm,
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    decoration: BoxDecoration(
                      color: appColor,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(
                      'Add',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
