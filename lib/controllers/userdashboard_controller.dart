import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intern_project/controllers/authcontroller.dart';
import 'package:intern_project/data/apis/userdashboard_api.dart';
import 'package:intern_project/models/category_model.dart';
import 'package:intern_project/models/sub_category_model.dart';
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

  Future getCategories() async {
    try {
      final res = await http.get(Uri.parse(categoryApi));
      var data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        categoryList.clear();
        for (Map<String, dynamic> index in data) {
          categoryList.add(CategoryModel.fromJson(index));
        }
        for (var e in categoryList) {
          if (e.status == 'active') {
            categories.add(e);
          }
        }
        return categories;
      }
    } catch (e) {
      return [];
    }
  }

  Future getSubCategories() async {
    try {
      final res = await http.get(Uri.parse(subCategoryApi));
      var data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        subCategoryList.clear();
        for (Map<String, dynamic> index in data) {
          subCategoryList.add(SubCategoryModel.fromJson(index));
        }
        for (var e in subCategoryList) {
          if (e.status == 'active') {
            subCategories.add(e);
          }
        }
        return subCategories;
      }
    } catch (e) {
      return [];
    }
  }

  Future getTicketByUser(userId) async {
    try {
      final res = await http.get(Uri.parse("$getTiketByUserIdApi=$userId"));
      var data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        tickets.clear();
        for (Map<String, dynamic> index in data) {
          tickets.add(TicketsModel.fromJson(index));
        }
        return tickets;
      }
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

  Future createTicket(context, branchId, categoryId, subCategoryId) async {
    try {
      if (subjectController.text.isNotEmpty &&
          detailsController.text.isNotEmpty) {
        var res = await http.post(
          Uri.parse(ticketApi),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
          },
          body: {
            "subject": subjectController.text,
            "details": detailsController.text,
            "status": "in_progress",
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

  Future updateTicket(context, branchId, categoryId, subCategoryId, id,status) async {
    try {
      if (subjectController.text.isNotEmpty &&
          detailsController.text.isNotEmpty) {
        var res = await http.patch(
          Uri.parse("$ticketApi/$id"),
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
