import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intern_project/data/apis/accounts_api.dart';
import 'package:intern_project/data/apis/userdashboard_api.dart';
import 'package:intern_project/models/ticket_model.dart';

class ItDeskController extends GetxController {
  RxList approvedticket = [].obs;
  RxList userList = [].obs;
  RxList catergoryList = [].obs;
  RxList subCatergoryList = [].obs;
  RxList ticketInfo = [].obs;

  Future getApprovedTicketList(branchId) async {
    try {
      final res = await http.get(Uri.parse(
          "https://x8ki-letl-twmt.n7.xano.io/api:D_eRidPY/ticketsgetwhichapproved?branch_id=$branchId&status=approved"));

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

  Future getUserList(id) async {
    try {
      final res = await http.get(Uri.parse("$getUserWithBranchApi=$id"));
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
      for (Map<String, dynamic> index in data) {
        subCatergoryList.add(index);
      }
      print(subCatergoryList);
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
}
