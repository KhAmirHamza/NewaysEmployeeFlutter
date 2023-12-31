// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:neways3/src/features/salary/models/salary_response_model.dart';
import 'package:neways3/src/utils/httpClient.dart';

class SalaryService {
  static Future salaries() async {
    final box = GetStorage();
    var response = await httpAuthPost(path: '/salaries');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      return salaryResponseModelFromJson(jsonDecode(response.body));
    } else {
      return {"error": "Server Error"};
    }
  }
}
