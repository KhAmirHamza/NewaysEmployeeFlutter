// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../utils/httpClient.dart';
import '../models/IncreamentResponse.dart';

class IncreamentService {
  static Future getData() async {
    final box = GetStorage();
    Map<String, String>? headers = {
      "accept": "application/json",
      "authorization": "Bearer ${box.read('token')}"
    };
    var url = Uri.http(baseUrl, '$unencodedPath/increaments');
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      return IncreamentResponse.fromJson(jsonDecode(response.body));
    } else {
      return {"error": "Server Error"};
    }
  }
}
