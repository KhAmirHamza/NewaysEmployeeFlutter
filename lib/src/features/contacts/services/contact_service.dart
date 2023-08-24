// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:neways3/src/features/contacts/models/employee_response_model.dart';
import 'package:neways3/src/utils/constants.dart';
import 'package:neways3/src/utils/httpClient.dart';

class ContactService {
  static Future allUsers({size, status, search, department_name}) async {
    print("departmentName: $department_name");
    final box = GetStorage();
    Map<String, String>? headers = {
      "accept": "application/json",
      "Content-Type": "application/json",
      "authorization": "Bearer ${box.read('token')}"
    };
    String path = '/employees/$size/$status/$search';
    if(department_name!=null){
      path+='/$department_name';
    }
    print("path: $path");

    var response = await httpAuthGet(path: path);
    print("Department Name: ____________${response.body}__________");
    if (response.statusCode == 200) {
      return employeeResponseModelFromJson(jsonDecode(response.body)['data']);
    } else {
      return {"error": "Server Error"};
    }
  }



  static Future getEmployee({employeeId}) async {
    var response = await httpAuthGet(path: '/employees/$employeeId');
    //print(response.body);
    if (response.statusCode == 200) {
      return EmployeeResponseModel.fromJson(jsonDecode(response.body)[0]);
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
    //print(data);
    var response = await http.post(url, headers: headers, body: data);
    //print(response);
    if (response.statusCode == 200) {
      // return ConversationModel.fromJson(jsonDecode(response.body));
    } else {
      return {"error": "Server Error"};
    }
  }
}
