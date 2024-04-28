import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intern_project/constants.dart';
import 'package:intern_project/controllers/authcontroller.dart';
import 'package:intern_project/controllers/userdashboard_controller.dart';
import 'package:restart_app/restart_app.dart';


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
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    items: userController.categories.map((e) {
                      return DropdownMenuItem(
                        value: e.id.toString(),
                        child: Text(e.title ?? ''),
                      );
                    }).toList(),
                    onChanged: (value) {
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
                    items: userController.subCategories.map((e) {
                      return DropdownMenuItem(
                        value: e.id.toString(),
                        child: Text(e.title ?? ''),
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
                              selectedSubCategory)
                          .then((value) =>
                              userController.getTicketByUser(userId));
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
    authController.getCurrentUser(data[0]).then((value) =>
        userController.currentUserId.value = value[0]['id'].toString());
    selectedCategory = userController.categories[0].id.toString();
    selectedSubCategory = userController.subCategories[0].id.toString();
    userController.getTicketByUser(data[0]);
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
                      Restart.restartApp();
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
                              onTap: () {
                                userController
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
        ),
      ),
    );
  }

  _showTicketDialog(BuildContext context) {
    return showDialog(
        barrierColor: const Color.fromARGB(176, 0, 0, 0),
        barrierDismissible: false,
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
                    height: 10,
                  ),
                  Text(
                    "Current subject : ${userController.ticketInfo[0].subject}",
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: userController.subjectController,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      hintText: "subject",
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Current subject : ${userController.ticketInfo[0].details}",
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: userController.detailsController,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      hintText: "details",
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Current category: ${userController.ticketInfo[0].categoriesId}",
                  ),
                  const SizedBox(height: 5),
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    items: userController.categories.map((e) {
                      return DropdownMenuItem(
                        value: e.id.toString(),
                        child: Text(e.title ?? ''),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory == value;
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: "Category",
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Current subcategory: ${userController.ticketInfo[0].subcategoriesId}",
                  ),
                  const SizedBox(height: 5),
                  DropdownButtonFormField<String>(
                    value: selectedSubCategory,
                    items: userController.subCategories.map((e) {
                      return DropdownMenuItem(
                        value: e.id.toString(),
                        child: Text(e.title ?? ''),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedSubCategory == value;
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: "Sub Category",
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                    ),
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
                      var ticketId = userController.ticketInfo[0].id.toString();
                      var status =
                          userController.ticketInfo[0].status.toString();
                      userController
                          .updateTicket(
                              context,
                              authController.currentUser[0]['branch_id'],
                              selectedCategory,
                              selectedSubCategory,
                              ticketId,
                              status)
                          .then((value) =>
                              userController.getTicketByUser(userId));
                    },
                    child: const Text(
                      "Update",
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
}
