import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:getx_user_app/Auth/login_screen.dart';

import 'Network Connectivity/connectivty_check.dart';
import 'Screen/user_details_screen.dart';
import 'Screen/user_list_screen.dart';

void main() {
  runApp(const MyApp());
  NetworkConnectivityService();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GetX User App',
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/userList', page: () => UserListScreen()),
        GetPage(name: '/userDetails', page: () => UserDetailsScreen()),
      ],
    );
  }
}