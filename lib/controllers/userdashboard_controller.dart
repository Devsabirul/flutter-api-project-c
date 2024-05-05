import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intern_project/controllers/authcontroller.dart';
import 'package:intern_project/data/apis/userdashboard_api.dart';
import 'package:intern_project/models/ticket_model.dart';

class UserDashboardController extends GetxController {
  AuthController authController = AuthController();

  TextEditingController subjectController = TextEditingController();
  TextEditingController detailsController = TextEditingController();

  List categoryList = [];
  List categories = [];
  List subCategoryList = [];
  List subCategories = [];
  RxList tickets = [].obs;
  RxList ticketInfo = [].obs;
  RxString currentUserId = "".obs;

  clearfield() {
    subjectController.clear();
    detailsController.clear();
  }

  Future getCategories(token) async {
    try {
      final res = await http.get(
        Uri.parse(categoryApi),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      var data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        // clear list
        categoryList.clear();
        subCategoryList.clear();

        // add category list
        for (Map<String, dynamic> index in data) {
          categoryList.add(index);
        }

        // add only active  category
        for (var e in categoryList) {
          if (e['status'] == 'active') {
            categories.add(e);
          }
        }

        // add subcategory list
        for (var e in categoryList) {
          if (e['subcategory'].isNotEmpty) {
            for (Map<String, dynamic> i in e['subcategory']) {
              subCategoryList.add(i);
            }
          }
        }
        return categories;
      }
    } catch (e) {
      return [];
    }
  }

  Future getTicketByUser(token) async {
    try {
      final res = await http.get(
        Uri.parse(getTicketApi),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      var data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        tickets.clear();
        for (Map<String, dynamic> index in data['tickets']) {
          tickets.add(TicketsModel.fromJson(index));
        }
        return tickets;
      }
    } catch (e) {
      return [];
    }
  }

  Future createTicket(
      context, branchId, categoryId, subCategoryId, token, userId) async {
    try {
      if (subjectController.text.isNotEmpty &&
          detailsController.text.isNotEmpty) {
        var res = await http.post(
          Uri.parse(createTicketApi),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
          body: jsonEncode({
            "subject": subjectController.text.toString(),
            "details": detailsController.text.toString(),
            "status": "in_progress",
            "branch_id": branchId.toString(),
            "category_id": categoryId.toString(),
            "sub_category_id": subCategoryId.toString(),
            "created_by": userId.toString(),
            "solved_by": "11", // Change it manually 
          }),
        );

        // Check for any successful status code
        if (res.statusCode >= 200 && res.statusCode < 300) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ticket created successfully.'),
            ),
          );
          clearfield();
          Navigator.pop(context);
        } else {
          // Handle other status codes (e.g., validation errors, server errors)
          // You can extract error messages from the response body if available
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to create ticket. ${res.reasonPhrase}'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill out all required fields'),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred. Please try again later.'),
        ),
      );
      Navigator.pop(context);
    }
  }

  Future updateTicket(
      context, branchId, categoryId, subCategoryId, id, status) async {
    try {
      if (subjectController.text.isNotEmpty &&
          detailsController.text.isNotEmpty) {
        var res = await http.patch(
          Uri.parse("$getTicketApi/$id"),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
          },
          body: {
            "subject": subjectController.text,
            "details": detailsController.text,
            "status": status,
            "branch_id": branchId.toString(),
            "categories_id": categoryId.toString(),
            "subcategories_id": subCategoryId.toString(),
            "users_id": currentUserId.toString(),
          },
        );
        if (res.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ticket create successfully.'),
            ),
          );
          clearfield();
          Navigator.pop(context);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill out all required fields'),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      Navigator.pop(context);
    }
  }
}
