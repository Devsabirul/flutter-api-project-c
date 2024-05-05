import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intern_project/constants.dart';
import 'package:intern_project/controllers/authcontroller.dart';
import 'package:intern_project/controllers/userdashboard_controller.dart';
import 'package:intern_project/views/screens/accounts/login_screen.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  AuthController authController = Get.put(AuthController());
  UserDashboardController userController = Get.put(UserDashboardController());
  String selectedBranch = '1';
  String selectedCategory = '1';
  String selectedSubCategory = '1';
  late int userId;

  _showDialogItemsForm(BuildContext context) {
    return showDialog(
        barrierColor: const Color.fromARGB(176, 0, 0, 0),
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.only(left: 20, right: 20),
            title: const Text(
              "Create Ticket",
              style: TextStyle(
                fontSize: 23,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: userController.subjectController,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      hintText: "subject",
                      contentPadding: EdgeInsets.all(2),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    controller: userController.detailsController,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      hintText: "details",
                      contentPadding: EdgeInsets.all(2),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  DropdownButtonFormField(
                    value: selectedCategory,
                    items: userController.categoryList.map((e) {
                      return DropdownMenuItem(
                        value: e['id'].toString(),
                        child: Text(e['title'].toString()),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        selectedCategory == value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  DropdownButtonFormField<String>(
                    value: selectedSubCategory,
                    items: userController.subCategoryList.map((e) {
                      return DropdownMenuItem(
                        value: e['id'].toString(),
                        child: Text(e['title'] ?? ''),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedSubCategory == value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      userController
                          .createTicket(
                              context,
                              authController.currentUser[0]['branch_id'],
                              selectedCategory,
                              selectedSubCategory,
                              authController.authToken.value,
                              userId)
                          .then((value) => userController
                              .getTicketByUser(authController.authToken.value));
                    },
                    child: const Text(
                      "Create",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Cancel",
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
    userController.getCategories(authController.authToken.value).then((value) {
      if (userController.categories.isNotEmpty) {
        selectedCategory = value[0]['id'].toString();
      }
      if (userController.subCategoryList.isNotEmpty) {
        selectedSubCategory =
            userController.subCategoryList[0]['id'].toString();
      }
    });
    print(userController.subCategoryList);
    userController.getTicketByUser(authController.authToken.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                      authController
                          .logout(context, authController.authToken.value)
                          .then(
                            (value) => Get.off(const LoginScreen(),
                                transition: Transition.noTransition),
                          );
                    },
                    child: const Icon(
                      Icons.logout,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  width: Get.width,
                  height: 150,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total Tickets",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                _showDialogItemsForm(context);
                              },
                              child: const Icon(
                                Icons.add_circle_outline_sharp,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Obx(
                          () => Text(
                            userController.tickets.length.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Text(
                          "see details",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "List of Tickets: ",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        userController.getTicketByUser(userId);
                      },
                      child: const Icon(Icons.refresh),
                    ),
                  ],
                ),
                Obx(
                  () => Column(
                    children: userController.tickets
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
                            subtitle: Text(e.status.toString()),
                            trailing: InkWell(
                              onTap: () {},
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
        ),
      ),
    );
  }
}
