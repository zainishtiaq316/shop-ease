import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shopease/screens/Profile/edit-profile.dart';
import 'package:shopease/screens/auth-ui/splash-screen.dart';
import 'package:shopease/utils/app-constant.dart';

class AccountInfo extends StatefulWidget {
  @override
  State<AccountInfo> createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {
  // final auth = FirebaseAuth.instance;
  // UserModel loggedInUser = UserModel();

  // @override
  // void initState() {
  //   super.initState();

  //   FirebaseFirestore.instance
  //       .collection("users")
  //       .doc(auth.currentUser!.uid)
  //       .get()
  //       .then((value) {
  //     setState(() {
  //       this.loggedInUser = UserModel.fromMap(value.data());
  //     });
  //   });
  // }
// void _deactivateAccount() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Container(
//           child: ,
//         );

  // AlertDialog(
  //   title: Text("Deactivate Account"),
  //   content: Text("Are you sure you want to deactivate your account?"),
  //   actions: <Widget>[
  //     TextButton(
  //       onPressed: () {
  //         Navigator.of(context).pop();
  //       },
  //       child: Text("Cancel"),
  //     ),
  //     TextButton(
  //       onPressed: () async {
  //         await CircularProgressIndicator();
  //         await FirebaseAuth.instance.currentUser!.delete();
  //         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SplashScreen()));
  //         // You can perform additional actions after deactivation here
  //       },
  //       child: Text(
  //         "Deactivate",
  //         style: TextStyle(color: Colors.red),
  //       ),
  //     ),
  //   ],
  // );

//       },
//     );
//   }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String? name = user?.displayName;
    String? imageUrl = user?.photoURL;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: appColor,
          surfaceTintColor: appColor,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "Account Info",
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
        body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
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
                String? SecondName = userData?['secondName'];
                String? email = userData?['email'];
                String? phone = userData?['phoneNumber'];
                print("${user!.uid}");

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                        
                          decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(30)),
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 30),
                                      child: CircleAvatar(
                                        radius: 70.0,
                                        backgroundColor: Colors.white,
                                        backgroundImage: imageUrl != null
                                            ? NetworkImage(imageUrl)
                                            : null,
                                        child: imageUrl == null
                                            ? Text(
                                                name != null
                                                    ? name[0].toUpperCase()
                                                    : "",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              )
                                            : null,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Divider(
                                  color: Colors.white,
                                  thickness: 2,
                                ),
                                info("UserName", "$firstName $SecondName"),
                                info("Email", "$email"),
                                info("Phone", "$phone"),
                                  info("Address", "$firstName $SecondName"),
                                info("Street", "$email"),
                                info("Gender", "$phone"),
                                  info("Language", "$firstName $SecondName"),
                                info("Date of Birth", "$phone"),
                                info("Joined Date", "$phone"),
                                info("Updated Date", "$phone"),
                                SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      
                      
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20,),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>EditProfileScreen()));
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height * 0.07,
                                  decoration: BoxDecoration(
                                      color: Colors.green.shade900,
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Center(
                                      child: Text(
                                    "Edit Profile",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  )),
                                ),
                              ),
                            ),
                            SizedBox(width: 20,),
                          
                          Expanded(child: GestureDetector(
                                onTap: () {
                                  AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.noHeader,
                                      animType: AnimType.bottomSlide,
                                      title: 'Deactivate Account',
                                      desc:
                                          'Are you sure you want to deactivate your account?',
                                      btnCancelOnPress: () {
                                        Navigator.of(context).pop();
                                      },
                                      btnOkOnPress: () async {
                                        CircularProgressIndicator();
                                        await FirebaseAuth.instance.currentUser!
                                            .delete();
                                        await FirebaseFirestore.instance
                                            .collection("users")
                                            .doc(user.uid)
                                            .delete();
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => SplashScreen()));
                                      }).show();
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height * 0.07,
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Center(
                                      child: Text(
                                    "Delete Account",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  )),
                                ),
                              ),
                           )
                          ],
                        ),
                      ),
                      
                      
                      SizedBox(height: 30,)
                   
                   
                    ],
                  ),
                );
              }
            }));
  }

  Widget info(String name, String value) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      child: Row(
        children: [
          Text(
            "${name ?? ""} : ",
            style: TextStyle(
                color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
          ),
          Spacer(),
          Text(
            "${value ?? ""}",
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
            ),
          )
        ],
      ),
    );
  }
}
