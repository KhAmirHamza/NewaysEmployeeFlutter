// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:neways3/src/features/wallet/models/wallet_response_model.dart';
import '../../../utils/httpClient.dart';
import '../models/current_salary_response_model.dart';

class WalletService {
  static Future wallet() async {
    final box = GetStorage();
    Map<String, String>? headers = {
      "accept": "application/json",
      "authorization": "Bearer ${box.read('token')}"
    };
    var url = Uri.http(baseUrl, '$unencodedPath/wallet');
    var response = await http.post(url, headers: headers, body: {
      'month': DateTime.now().month.toString(),
      'year': (DateTime.now().year - 2000).toString()
    });
    // print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      return WalletResponseModel.fromJson(jsonDecode(response.body));
    } else {
      return {"error": "Server Error"};
    }
  }

  static Future currentSalary() async {
    final box = GetStorage();
    Map<String, String>? headers = {
      "accept": "application/json",
      "authorization": "Bearer ${box.read('token')}"
    };
    var url = Uri.http(baseUrl, '$unencodedPath/current_salary');
    print(url);
    var response = await http.post(url, headers: headers, body: {
      'month': DateTime.now().month.toString(),
      'year': (DateTime.now().year - 2000).toString()
    });
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      return CurrentSalaryResponseModel.fromJson(jsonDecode(response.body));
    } else {
      return {"error": "Server Error"};
    }
  }
}
