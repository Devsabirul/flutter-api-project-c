import 'dart:convert';
import 'package:intern_project/views/screens/dashboard/itdesk_dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intern_project/data/apis/branch_api.dart';
import 'package:intern_project/data/apis/accounts_api.dart';
import 'package:intern_project/models/branch_model.dart';
import 'package:intern_project/views/screens/accounts/login_screen.dart';
import 'package:intern_project/views/screens/dashboard/manager_dashboard.dart';
import 'package:intern_project/views/screens/dashboard/user_dashboard.dart';
import 'package:http/http.dart' as http;

class AuthController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  GlobalKey<FormState> signupkey = GlobalKey<FormState>();

  RxBool isLoading = false.obs;
  RxBool isLoggedIn = false.obs;
  RxString userId = ''.obs;
  RxString authToken = ''.obs;
  RxList branchList = [].obs;
  List branchListDropdown = [];
  RxList currentUser = [].obs;

  RxString role = ''.obs;

  clearfield() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    phoneNumberController.clear();
  }

  Future getBranchList() async {
    try {
      final res = await http.get(Uri.parse(branchListApi));
      var data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        branchList.clear();
        for (Map<String, dynamic> index in data) {
          branchList.add(BranchModel.fromJson(index));
        }
        for (var e in branchList) {
          if (e.status == 'active') {
            branchListDropdown.add(e);
          }
        }
        return branchList;
      }
    } catch (e) {
      return [];
    }
  }

  Future login(context) async {
    isLoading.value = true;
    try {
      if (emailController.text.isNotEmpty &&
          passwordController.text.isNotEmpty) {
        final res = await http.post(
          Uri.parse(loginApi),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
          },
          body: {
            "email": emailController.text,
            "password": passwordController.text,
          },
        );
        if (res.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Loging successfully.'),
            ),
          );
          isLoading.value = false;

          var data = jsonDecode(res.body);
          role.value = data['users']['role'];
          if (role.value == 'user') {
            Get.off(const UserDashboard(),
                transition: Transition.noTransition,
                arguments: [data['users']['id']]);
          } else if (role.value == 'manager') {
            Get.off(const ManagerDashboard(),
                transition: Transition.noTransition,
                arguments: [data['users']['id']]);
          } else if (role.value == 'itdesk') {
            Get.off(const ItDeskDashboardScreen(),
                transition: Transition.noTransition,
                arguments: [data['users']['id']]);
          }
          clearfield();
        } else {
          isLoading.value = false;
          return ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('something wrong, please try again.'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill out all required fields'),
          ),
        );
      }
    } catch (e) {
      isLoading.value = false;
      return ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('something wrong, please try again.'),
        ),
      );
    }
    isLoading.value = false;
  }

  Future registration(branchId, accoutRole, context) async {
    isLoading.value = true;
    try {
      var userRole = "";
      if (accoutRole == "1") {
        userRole = "user";
      } else if (accoutRole == "2") {
        userRole = "manager";
      } else if (accoutRole == "3") {
        userRole = "itdesk";
      }
      final res = await http.post(
        Uri.parse(registrationApi),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: {
          "name": nameController.text,
          "email": emailController.text,
          "role": userRole,
          "password": passwordController.text,
          "branch_id": branchId,
        },
      );
      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Accout created successfully.'),
          ),
        );
        clearfield();
        Get.to(const LoginScreen(), transition: Transition.noTransition);
      }
    } catch (e) {
      return ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('something wrong, please try again.'),
        ),
      );
    }
    isLoading.value = false;
  }

  // logout info
  Future logout() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.remove("isLoggedIn");
    prefs.remove("userId");
    prefs.remove("authToken");
    prefs.remove("role");
    clearfield();
  }

  // save login info
  saveLoginInfo(role) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString("role", role);
    prefs.setBool("isLoggedIn", true);
  }

  // get login info
  getIsLoggedIn() async {
    var prefs = await SharedPreferences.getInstance();
    var userRole = prefs.getString("role");
    var loginValue = prefs.getBool("isLoggedIn");
    isLoggedIn.value = loginValue ?? false;
    role.value = userRole.toString();
  }

  Future getCurrentUser(id) async {
    try {
      final res = await http.get(Uri.parse("$currentUserApi/$id"));
      var data = jsonDecode(res.body);
      currentUser.add(data);
      return currentUser;
    } catch (e) {}
  }
}
