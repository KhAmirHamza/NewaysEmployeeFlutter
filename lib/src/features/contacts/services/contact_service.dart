// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:neways3/src/features/contacts/models/employee_response_model.dart';
import 'package:neways3/src/utils/constants.dart';
import 'package:neways3/src/utils/httpClient.dart';

class ContactService {
  static Future allUsers({size, status, search}) async {
    final box = GetStorage();
    Map<String, String>? headers = {
      "accept": "application/json",
      "Content-Type": "application/json",
      "authorization": "Bearer ${box.read('token')}"
    };
    var response = await httpAuthGet(path: '/employees/$size/$status/$search');
    print(response.body);
    if (response.statusCode == 200) {
      return employeeResponseModelFromJson(jsonDecode(response.body)['data']);
    } else {
      return {"error": "Server Error"};
    }
  }

  static Future addContact(EmployeeResponseModel employee) async {
    final box = GetStorage();
    Map<String, String>? headers = {
      "accept": "application/json",
      "authorization": "Bearer ${box.read('token')}"
    };
    var url = Uri.http(socketURL, 'api/create-conversation');
    Map<String, dynamic> data = {
      "creator": {
        "employeeId": box.read('employeeId').toString(),
        "name": box.read('name').toString(),
        "avatar": box.read('avater').toString(),
        "designation": box.read('designationName').toString()
      }.toString(),
      "participant": {
        "employeeId": employee.employeeId!.toString(),
        "name": employee.fullName!.toString(),
        "avatar": employee.photo!.toString(),
        "designation": employee.designationName!.toString()
      }.toString()
    };
    print(data);
    var response = await http.post(url, headers: headers, body: data);
    print(response);
    if (response.statusCode == 200) {
      // return ConversationModel.fromJson(jsonDecode(response.body));
    } else {
      return {"error": "Server Error"};
    }
  }
}
