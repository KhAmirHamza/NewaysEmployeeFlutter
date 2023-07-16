import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:neways3/src/utils/httpClient.dart';

import '../models/TADAResponse.dart';

class TADAAPIServices {
  static getAllData() async {
    try {
      var response = await httpAuthGet(path: '/ta_da_request_list');
      if (response.statusCode == 200) {
        return tadaResponseFromJson(response.body);
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        return {"error": "Server Error"};
      }
      print(e.response?.statusCode);
    }

    return null;
  }

  static submit({required data}) async {
    try {
      var response = await httpAuthPost(path: '/ta_da_request', data: data);
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['message'];
      } else if (response.statusCode == 401) {
        return jsonDecode(response.body)['error'];
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        return {"error": "Server Error"};
      }
      print(e.response?.statusCode);
    }

    return null;
  }

  static delete({required id}) async {
    try {
      var response = await httpAuthGet(path: '/ta_da_delete/$id');
      print(response.body);
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['message'];
      } else if (response.statusCode == 401) {
        return jsonDecode(response.body)['error'];
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        return {"error": "Server Error"};
      }
      print(e.response?.statusCode);
    }

    return null;
  }

  static moneyReceived({required id}) async {
    try {
      var response = await httpAuthGet(path: '/ta_da_accept/$id');
      print(response.body);
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['message'];
      } else if (response.statusCode == 401) {
        return jsonDecode(response.body)['error'];
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        return {"error": "Server Error"};
      }
      print(e.response?.statusCode);
    }

    return null;
  }

  static getPendingData() async {
    try {
      var response = await httpAuthGet(path: '/employee_ta_da_request_list');
      print(response.body);
      if (response.statusCode == 200) {
        return tadaResponseFromJson(response.body);
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        return {"error": "Server Error"};
      }
      print(e.response?.statusCode);
    }

    return null;
  }

  static approved({required id}) async {
    try {
      var response = await httpAuthGet(path: '/ta_da_dep_head_approve/$id');
      print(response.body);
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['message'];
      } else if (response.statusCode == 401) {
        return jsonDecode(response.body)['error'];
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        return {"error": "Server Error"};
      }
      print(e.response?.statusCode);
    }

    return null;
  }

  static reject({required id}) async {
    try {
      var response = await httpAuthGet(path: '/ta_da_dep_head_reject/$id');
      print(response.body);
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['message'];
      } else if (response.statusCode == 401) {
        return jsonDecode(response.body)['error'];
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        return {"error": "Server Error"};
      }
      print(e.response?.statusCode);
    }

    return null;
  }
}
