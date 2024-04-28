import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intern_project/constants.dart';
import 'package:intern_project/controllers/authcontroller.dart';
import 'package:intern_project/controllers/itdesk_controller.dart';
import 'package:intern_project/controllers/userdashboard_controller.dart';
import 'package:restart_app/restart_app.dart';

class ItDeskDashboardScreen extends StatefulWidget {
  const ItDeskDashboardScreen({super.key});

  @override
  State<ItDeskDashboardScreen> createState() => _ItDeskDashboardScreenState();
}

class _ItDeskDashboardScreenState extends State<ItDeskDashboardScreen> {
  AuthController authController = Get.put(AuthController());
  UserDashboardController userController = Get.put(UserDashboardController());
  ItDeskController itDeskController = Get.put(ItDeskController());
  late int userId;
  int branchId = 0;

  _showTicketDialog(BuildContext context) {
    return showDialog(
        barrierColor: const Color.fromARGB(176, 0, 0, 0),
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.only(left: 20, right: 20),
            title: const Text(
              "Ticket Info",
              style: TextStyle(
                fontSize: 23,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Subject: ${itDeskController.ticketInfo[0].subject.toString()}",
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text("User Id: ${itDeskController.ticketInfo[0].usersId}"),
                  const SizedBox(
                    height: 5,
                  ),
                  Text("Branch Id: ${itDeskController.ticketInfo[0].branchId}"),
                  const SizedBox(
                    height: 5,
                  ),
                  Text("Status: ${itDeskController.ticketInfo[0].status}"),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text(
                      "Send Message",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    var data = Get.arguments;
    userId = data[0];
    authController.getCurrentUser(data[0]).then((value) {
      branchId = authController.currentUser[0]['branch_id'];
      Timer(const Duration(seconds: 1), () {
        itDeskController.getApprovedTicketList(value[0]['branch_id']);
        itDeskController
            .getUserList(authController.currentUser[0]['branch_id']);
        itDeskController.getCategoryList();
        itDeskController.getSubCategoryList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                title: Obx(
                  () => authController.currentUser.isNotEmpty
                      ? Text(
                          "Hi, ${authController.currentUser[0]['name']}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      : const Text(
                          "loading...",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
                subtitle: Obx(
                  () => authController.currentUser.isNotEmpty
                      ? Text(
                          authController.currentUser[0]['role'],
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        )
                      : const Text(
                          "loading...",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                ),
                trailing: InkWell(
                  onTap: () {
                    Restart.restartApp();
                  },
                  child: const Icon(
                    Icons.logout,
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Total Tickets",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Obx(
                              () => Text(
                                itDeskController.approvedticket.length
                                    .toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _showButtomSheet(context);
                      },
                      child: Container(
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Total users",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Obx(
                                () => Text(
                                  itDeskController.userList.length.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _showCategoryButtomSheet(context);
                      },
                      child: Container(
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Total Category",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Obx(
                                () => Text(
                                  itDeskController.catergoryList.length
                                      .toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _showSubCategoryButtomSheet(context);
                      },
                      child: Container(
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.purple,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Total sub-category",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Obx(
                                () => Text(
                                  itDeskController.subCatergoryList.length
                                      .toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Recent Tickets: ",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: const Icon(Icons.refresh),
                  ),
                ],
              ),
              Obx(
                () => Column(
                  children: itDeskController.approvedticket
                      .map(
                        (e) => ListTile(
                          contentPadding: const EdgeInsets.all(5),
                          title: Text(
                            e.subject.toString(),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            e.status.toString(),
                          ),
                          trailing: InkWell(
                            onTap: () {
                              itDeskController
                                  .getTicketInfo(e.id)
                                  .then((value) {
                                _showTicketDialog(context);
                              });
                            },
                            child: const Icon(
                              Icons.info_outline,
                              size: 30,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }

  _showButtomSheet(context) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return SizedBox(
            width: Get.width,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 50.0, horizontal: 15),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "User List:",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Divider(),
                    Column(
                      children: itDeskController.userList
                          .map(
                            (e) => ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                e['name'].toString(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(e['email']),
                              trailing: Text(
                                e['role'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  _showCategoryButtomSheet(context) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return SizedBox(
            width: Get.width,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 50.0, horizontal: 15),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "Category List:",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Divider(),
                    Column(
                      children: itDeskController.catergoryList
                          .map(
                            (e) => ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                e['title'].toString(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle:
                                  Text("Category id : ${e['id'].toString()}"),
                              trailing: Text(
                                e['status'].toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  _showSubCategoryButtomSheet(context) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return SizedBox(
            width: Get.width,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 50.0, horizontal: 15),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "Sub Category List:",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Divider(),
                    Column(
                      children: itDeskController.subCatergoryList
                          .map(
                            (e) => ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                e['title'].toString(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                  "Category id : ${e['categories_id'].toString()}"),
                              trailing: Text(
                                e['status'].toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
