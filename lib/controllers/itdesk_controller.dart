import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intern_project/data/apis/accounts_api.dart';
import 'package:intern_project/data/apis/branch_api.dart';
import 'package:intern_project/data/apis/userdashboard_api.dart';
import 'package:intern_project/models/ticket_model.dart';

class ItDeskController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController routingController = TextEditingController();

  TextEditingController categoryTitleController = TextEditingController();

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

  Future getApprovedTicketList() async {
    try {
      final res = await http.get(Uri.parse(
          'https://x8ki-letl-twmt.n7.xano.io/api:D_eRidPY/approvedticketlist?status=approved'));

      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        approvedticket.clear();

        for (Map<String, dynamic> index in data) {
          approvedticket.add(TicketsModel.fromJson(index));
        }
        return approvedticket;
      } else {
        Get.snackbar("Error", "Something wrong.");
      }
    } catch (e) {
      print(e);
    }
  }

  Future getUserList() async {
    try {
      final res = await http.get(Uri.parse(userListApi));
      var data = jsonDecode(res.body);
      for (Map<String, dynamic> index in data) {
        userList.add(index);
      }
    } catch (e) {
      Get.snackbar("Error", "Something wrong!");
    }
  }

  Future getCategoryList() async {
    try {
      final res = await http.get(Uri.parse(categoryApi));
      var data = jsonDecode(res.body);
      catergoryList.clear();
      for (Map<String, dynamic> index in data) {
        catergoryList.add(index);
      }
      print(catergoryList);
    } catch (e) {
      Get.snackbar("Error", "Something wrong!");
    }
  }

  Future getSubCategoryList() async {
    try {
      final res = await http.get(Uri.parse(subCategoryApi));
      var data = jsonDecode(res.body);
      subCatergoryList.clear();
      for (Map<String, dynamic> index in data) {
        subCatergoryList.add(index);
      }
    } catch (e) {
      Get.snackbar("Error", "Something wrong!");
    }
  }

  Future getBranchList() async {
    try {
      final res = await http.get(Uri.parse(branchListApi));
      var data = jsonDecode(res.body);
      branchList.clear();
      for (Map<String, dynamic> index in data) {
        branchList.add(index);
      }
    } catch (e) {
      Get.snackbar("Error", "Something wrong!");
    }
  }

  Future getTicketInfo(ticketId) async {
    try {
      final res = await http.get(Uri.parse("$ticketApi/$ticketId"));
      var data = jsonDecode(res.body);
      ticketInfo.clear();
      ticketInfo.add(TicketsModel.fromJson(data));
      return ticketInfo;
    } catch (e) {
      return [];
    }
  }

  Future createBranchList(context) async {
    try {
      if (nameController.text.isNotEmpty &&
          addressController.text.isNotEmpty &&
          routingController.text.isNotEmpty) {
        final res = await http.post(
          Uri.parse(branchListApi),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
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
          getBranchList();
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
      print(e);
      Navigator.pop(context);
    }
  }

  Future createCategoyList(context) async {
    try {
      if (categoryTitleController.text.isNotEmpty) {
        final res = await http.post(
          Uri.parse(categoryApi),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
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
          getSubCategoryList();
          catergoryList.clear();
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
      print(e);
      Navigator.pop(context);
    }
  }
  Future createSubCategoyList(context,selectedCategory) async {
    try {
      if (categoryTitleController.text.isNotEmpty) {
        final res = await http.post(
          Uri.parse(categoryApi),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
          },
          body: {
            "title": categoryTitleController.text,
            "status": "active",
            "categories_id":selectedCategory.toString(),
          },
        );
        if (res.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Category create successfully.'),
            ),
          );
          getSubCategoryList();
          catergoryList.clear();
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
      print(e);
      Navigator.pop(context);
    }
  }
}
