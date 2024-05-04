
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intern_project/constants.dart';
import 'package:intern_project/controllers/authcontroller.dart';
import 'package:intern_project/controllers/manager_controller.dart';
import 'package:intern_project/views/screens/accounts/login_screen.dart';

class ManagerDashboard extends StatefulWidget {
  const ManagerDashboard({super.key});

  @override
  State<ManagerDashboard> createState() => _ManagerDashboardState();
}

class _ManagerDashboardState extends State<ManagerDashboard> {
  AuthController authController = Get.put(AuthController());
  ManagerController managerController = Get.put(ManagerController());

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
                    managerController.ticketInfo[0].subject.toString(),
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text("User Id: ${managerController.ticketInfo[0].createdBy}"),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                      "Branch Id: ${managerController.ticketInfo[0].branchId}"),
                  const SizedBox(
                    height: 5,
                  ),
                  Text("Status: ${managerController.ticketInfo[0].status}"),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Approved",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
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
    managerController.getUserList(authController.authToken.value);
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
                            (value) => Get.off(const LoginScreen(),transition: Transition.noTransition),
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
                                  managerController.ticketList.length
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
                                    managerController.userList.length
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
                    children: managerController.ticketList
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
                                // managerController
                                //     .getTicketInfo(e.id)
                                //     .then((value) {
                                //   _showTicketDialog(context);
                                // });
                                managerController.getTicketInfo(e).then(
                                    (value) => _showTicketDialog(context));
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
                      children: managerController.userList
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
}
