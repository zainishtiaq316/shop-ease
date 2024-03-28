import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shopease/screens/auth-ui/splash-screen.dart';

import 'firebase_options.dart';
import 'screens/auth-ui/welcome-screen.dart';
import 'screens/auth-ui/signin-screen.dart';
import 'screens/user-panel/main-screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
     
      home: WelcomeScreen(),
      builder: EasyLoading.init(),
    );
  }
}

