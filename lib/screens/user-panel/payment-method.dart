import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shopease/controllers/get-customer-device-controller.dart';
import 'package:shopease/services/place-order-services.dart';
import 'package:shopease/utils/app-constant.dart';

class AddPayment extends StatefulWidget {
  final String name;
  final String phone;
  final String street;
  final String city;
  final String zipCode;
  final String country;
  final String address;
  final String price;
  const AddPayment(
      {super.key,
      required this.address,
      required this.city,
      required this.country,
      required this.name,
      required this.phone,
      required this.price,
      required this.street,
      required this.zipCode});

  @override
  State<AddPayment> createState() => _AddPaymentState();
}

class _AddPaymentState extends State<AddPayment> {
  String selectedOption = '';
  void selectOption(String option) {
    setState(() {
      selectedOption = option;
    });

    // Print the selected option to the console
    print('Selected Payment Option: $option');
  }
@override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }
  Razorpay _razorpay = Razorpay();
  @override
  Widget build(BuildContext context) {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColor,
        surfaceTintColor: appColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Add Payment",
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Text(
                "Total Price : ${widget.price}",
                style: TextStyle(
                    color: Colors.green.shade900,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Divider(
                color: Colors.grey.shade300,
                thickness: 1,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Row(
                children: [
                  Text(
                    "Payment Method",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            PaymentOption(
              option: 'Cash On Delivery',
              imagePath: 'assets/images/cash.png',
              isSelected: selectedOption == 'Cash On Delivery',
              onSelect: () => selectOption('Cash On Delivery'),
              backgroundColor: Colors.green.shade100,
              textColor: Colors.green.shade900,
            ),
            PaymentOption(
              option: 'RazorPay',
              imagePath: 'assets/images/razorpay.png',
              isSelected: selectedOption == 'RazorPay',
              onSelect: () => selectOption('RazorPay'),
              backgroundColor: Colors.blue.shade100,
              textColor: Colors.blue.shade900,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        surfaceTintColor: Colors.white,
        child: ElevatedButton(
          onPressed: () async {
            // Check if payment option is selected
            if (selectedOption.isEmpty) {
              Get.snackbar(
                "Payment Method Required",
                "Please select a payment method before connfirm order.",
                backgroundColor: Colors.grey.shade300,
                colorText: Colors.black,
                duration: Duration(seconds: 1),
              );
              return;
            }

            print("name : ${widget.name}");
            print("name : ${widget.phone}");
            print("name : ${widget.street}");
            print("name : ${widget.city}");
            print("name : ${widget.zipCode}");
            print("name : ${widget.country}");
            print("name : ${widget.address}");
            print("name : ${widget.price}");
            print(FirebaseAuth.instance.currentUser!.phoneNumber);
            print(FirebaseAuth.instance.currentUser!.email);
            // If all checks pass, proceed with placing the order
            try {
              String customerToken = await getCustomerDeviceController();
              var options = {
                'key': 'rzp_test_YghCO1so2pwPnx',
                'amount':1000,
                'name': "${widget.name}",
                'description': 'Products',
                'currency' : 'PKR',
                'prefill': {
                  'contact': "03028163676",
                  'email': FirebaseAuth.instance.currentUser!.email,
                }
              };

              if(selectedOption == "Cash On Delivery")
                  placeOrder(
                context: context,
                customerName: widget.name,
                customerPhone: widget.phone,
                customerStreet: widget.street,
                customerCity: widget.city,
                customerZipCode: widget.zipCode,
                customerCountry: widget.country,
                customerAddress: widget.address,
                price: widget.price,
                paymentMethod: selectedOption,
                paymentStatus: false,
                customerDeviceToken: customerToken,
              );
            
             if(selectedOption == "RazorPay")
               _razorpay.open(options);
            
            } catch (e) {
              // Handle any exceptions or errors during the order placement
              Get.snackbar(
                "Order Failed",
                "There was an issue placing your order. Please try again.",
                backgroundColor: Colors.grey.shade300,
                colorText: Colors.black,
                duration: Duration(seconds: 2),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: appColor,
            padding: EdgeInsets.symmetric(vertical: 15.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          child: Center(
            child: Text(
              'Confirm Order',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async{
     String customerToken = await getCustomerDeviceController();
     placeOrder(
                context: context,
                customerName: widget.name,
                customerPhone: widget.phone,
                customerStreet: widget.street,
                customerCity: widget.city,
                customerZipCode: widget.zipCode,
                customerCountry: widget.country,
                customerAddress: widget.address,
                price: widget.price,
                paymentMethod: selectedOption,
                paymentStatus: true,
                customerDeviceToken: customerToken,
              );
            
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
  }


}

class PaymentOption extends StatelessWidget {
  final String option;
  final String imagePath;
  final bool isSelected;
  final VoidCallback onSelect;
  final Color backgroundColor;
  final Color textColor;

  PaymentOption({
    required this.option,
    required this.imagePath,
    required this.isSelected,
    required this.onSelect,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: GestureDetector(
        onTap: onSelect,
        child: Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
          padding: EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(
              color: isSelected ? textColor : Colors.transparent,
              width: 2.0,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 25,
                height: 25,
                child: Image.asset(imagePath),
              ),
              SizedBox(width: 10),
              Text(
                option,
                style: TextStyle(
                  color: textColor,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              isSelected
                  ? Icon(
                      Icons.check_circle,
                      color: isSelected ? textColor : Colors.grey,
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
