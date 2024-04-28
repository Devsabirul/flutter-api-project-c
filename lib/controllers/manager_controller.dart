import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intern_project/data/apis/accounts_api.dart';
import 'package:intern_project/data/apis/managerdashboard_api.dart';
import 'package:intern_project/data/apis/userdashboard_api.dart';
import 'package:intern_project/models/ticket_model.dart';

class ManagerController extends GetxController {
  RxList ticketList = [].obs;
  RxList ticketInfo = [].obs;
  RxList userList = [].obs;

  Future getTicketList(branchId) async {
    try {
      final res = await http.get(Uri.parse("$getTicketByBranch=$branchId"));
      var data = jsonDecode(res.body);
      ticketList.clear();

      for (Map<String, dynamic> index in data) {
        ticketList.add(TicketsModel.fromJson(index));
      }
      return ticketList;
    } catch (e) {
      return [];
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

  Future updateTicket(context, id, status) async {
    try {
      var res = await http.patch(
        Uri.parse("$ticketApi/$id"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: {
          "subject": ticketInfo[0].subject.toString(),
          "details": ticketInfo[0].details.toString(),
          "status": status,
          "branch_id": ticketInfo[0].branchId.toString(),
          "categories_id": ticketInfo[0].categoriesId.toString(),
          "subcategories_id": ticketInfo[0].subcategoriesId.toString(),
          "users_id": ticketInfo[0].usersId.toString(),
        },
      );
      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ticket updated successfully.'),
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('something wrong, please try again.'),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('something wrong, please try again.'),
        ),
      );
      Navigator.pop(context);
    }
  }

  Future getUserList(id) async {
    try {
      final res = await http.get(Uri.parse("$getUserApi=$id&role_type=user"));
      var data = jsonDecode(res.body);
      for (Map<String, dynamic> index in data) {
        userList.add(index);
      }
      print(userList);
    } catch (e) {
      Get.snackbar("Error", "Something wrong!");
    }
  }
}
