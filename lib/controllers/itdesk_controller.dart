import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intern_project/controllers/authcontroller.dart';
import 'package:intern_project/data/apis/branch_api.dart';
import 'package:intern_project/data/apis/iddesk_api.dart';
import 'package:intern_project/models/ticket_model.dart';

class ItDeskController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController routingController = TextEditingController();

  TextEditingController categoryTitleController = TextEditingController();

  AuthController controller = Get.put(AuthController());

  RxList approvedticket = [].obs;
  RxList userList = [].obs;
  RxList catergoryList = [].obs;
  RxList subCatergoryList = [].obs;
  RxList ticketInfo = [].obs;
  RxList branchList = [].obs;

  clearField() {
    nameController.clear();
    addressController.clear();
    routingController.clear();
  }

  Future getUserListAndTickets(token) async {
    try {
      final res = await http.get(
        Uri.parse(getUserListAndTikets),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      var data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        userList.clear();
        approvedticket.clear();

        for (Map<String, dynamic> index in data['user']) {
          // add user list
          userList.add(index);

          // add ticket list
          for (Map<String, dynamic> json in index['tickets']) {
            approvedticket.add(TicketsModel.fromJson(json));
          }
        }
      }
    } catch (e) {
      return [];
    }
  }

  Future getCategoryList(token) async {
    try {
      final res = await http.get(
        Uri.parse(getCategoryLists),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      var data = jsonDecode(res.body);
      catergoryList.clear();
      subCatergoryList.clear();

      // add category list
      for (Map<String, dynamic> index in data) {
        catergoryList.add(index);
      }

      // add subcategory list
      for (var e in catergoryList) {
        if (e['subcategory'].isNotEmpty) {
          for (Map<String, dynamic> i in e['subcategory']) {
            subCatergoryList.add(i);
          }
        }
      }

      return catergoryList;
    } catch (e) {
      Get.snackbar("Error", "Something wrong!");
    }
  }

  Future getBranchList(token) async {
    try {
      final res = await http.get(
        Uri.parse(branchListApi),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      var data = jsonDecode(res.body);
      branchList.clear();
      for (Map<String, dynamic> index in data) {
        branchList.add(index);
      }
    } catch (e) {
      Get.snackbar("Error", "Something wrong!");
    }
  }

  Future getTicketInfo(ticketInstance) async {
    ticketInfo.clear();
    ticketInfo.add(ticketInstance);
    return ticketInfo;
  }

  Future createBranchList(context,token) async {
    try {
      if (nameController.text.isNotEmpty &&
          addressController.text.isNotEmpty &&
          routingController.text.isNotEmpty) {
        final res = await http.post(
          Uri.parse(createBranchApi),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded",
            "Authorization": 'Bearer $token',
          },
          body: {
            "name": nameController.text,
            "address": addressController.text,
            "routing": routingController.text,
            "status": "active",
          },
        );
        if (res.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Branch create successfully.'),
            ),
          );
          getBranchList(controller.authToken.value);
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Branch create unSuccessfully.'),
            ),
          );
          Navigator.pop(context);
        }
      }
    } catch (e) {
      Navigator.pop(context);
    }
  }

  Future createCategoyList(context, token) async {
    try {
      if (categoryTitleController.text.isNotEmpty) {
        final res = await http.post(
          Uri.parse(createCategoryApi),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded",
            "Authorization": 'Bearer $token',
          },
          body: {
            "title": categoryTitleController.text,
            "status": "active",
          },
        );
        if (res.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Category create successfully.'),
            ),
          );
          getCategoryList(controller.authToken.value);
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Category create unSuccessfully.'),
            ),
          );
          Navigator.pop(context);
        }
      }
    } catch (e) {
      Navigator.pop(context);
    }
  }

  Future createSubCategoyList(context, selectedCategory, token) async {
    try {
      if (categoryTitleController.text.isNotEmpty) {
        final res = await http.post(
          Uri.parse(createSubCategoryApi),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded",
            "Authorization": "Bearer $token",
          },
          body: {
            "title": categoryTitleController.text,
            "status": "active",
            "category_id": selectedCategory.toString(),
          },
        );
        if (res.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Sub Category create successfully.'),
            ),
          );
          getCategoryList(controller.authToken.value);
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Sub Category create unSuccessfully.'),
            ),
          );
          Navigator.pop(context);
        }
      }
    } catch (e) {
      Navigator.pop(context);
    }
  }
}
