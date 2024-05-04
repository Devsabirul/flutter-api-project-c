import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intern_project/data/apis/managerdashboard_api.dart';
import 'package:intern_project/data/apis/userdashboard_api.dart';
import 'package:intern_project/models/ticket_model.dart';

class ManagerController extends GetxController {
  RxList ticketList = [].obs;
  RxList ticketInfo = [].obs;
  RxList userList = [].obs;

  Future getUserList(token) async {
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
        ticketList.clear();

        for (Map<String, dynamic> index in data['user']) {
          // add user list
          if (index['role'] == "user") {
            userList.add(index);
          }

          // add ticket in ticketlist
          if (index['tickets'].isNotEmpty) {
            for (Map<String, dynamic> json in index['tickets']) {
              ticketList.add(TicketsModel.fromJson(json));
            }
          }
        }
      }
    } catch (e) {
      return [];
    }
  }

  Future getTicketInfo(ticketInstance) async {
    ticketInfo.clear();
    ticketInfo.add(ticketInstance);
    return ticketInfo;
  }

  Future updateTicket(context, id, status) async {
    try {
      var res = await http.patch(
        Uri.parse("$getTicketApi/$id"),
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
}
