import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intern_project/constants.dart';
import 'package:intern_project/controllers/authcontroller.dart';
import 'package:intern_project/controllers/userdashboard_controller.dart';
import 'package:intern_project/views/screens/accounts/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AuthController authController = Get.put(AuthController());
  UserDashboardController userDashboardController =
      Get.put(UserDashboardController());

  @override
  void initState() {
    userDashboardController.getCategories();
    userDashboardController.getSubCategories();
    authController.getBranchList().then((value) {
      Get.off(const LoginScreen(), transition: Transition.noTransition);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          "assets/images/logo.jpg",
          height: 150,
        ),
      ),
    );
  }
}
