// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import '../models/attendence_response_model.dart';
import 'package:neways3/src/utils/httpClient.dart';

class AttendenceService {
  static Future attendences(
      {required String month, required String year}) async {
    var response = await httpAuthPost(
        path: '/attendences', data: {"month": month, "year": year});
    if (response.statusCode == 200) {
      print(response.body);
      return attendenceResponseModelFromJson(jsonDecode(response.body));
    } else {
      return {"error": "Server Error"};
    }
  }
}
