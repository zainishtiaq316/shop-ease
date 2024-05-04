import 'package:flutter/material.dart';

import '../../utils/app-constant.dart';
import 'widget/admin-custom-drawer-widget.dart';

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      
      appBar: AppBar(
        
        
        backgroundColor: AppConstant.appMainColor,
        title: Text("Admin Panel")),
        
        drawer: AdminDrawerWidget(),
        );

        
  }



}