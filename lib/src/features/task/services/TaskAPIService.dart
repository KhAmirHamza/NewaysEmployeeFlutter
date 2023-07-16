import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:neways3/src/utils/httpClient.dart';

import '../../fired_employee/models/FiredEmployee.dart';
import '../models/TaskCommentResponse.dart';
import '../models/TaskResponse.dart';

class TaskAPIServices {
  static getAllDepartment() async {
    try {
      var response = await httpAuthGet(path: '/task_departments');
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['data'];
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        return {"error": "Server Error"};
      }
      print(e.response?.statusCode);
    }

    return null;
  }

  static getAllData(department) async {
    try {
      var response = await httpAuthGet(path: '/task_list/$department');
      if (response.statusCode == 200) {
        return taskResponseFromJson(response.body);
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        return {"error": "Server Error"};
      }
      print(e.response?.statusCode);
    }

    return null;
  }

  static getAllReviewData(department) async {
    try {
      var response = await httpAuthGet(path: '/task_review_list/$department');
      if (response.statusCode == 200) {
        return taskResponseFromJson(response.body);
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        return {"error": "Server Error"};
      }
      print(e.response?.statusCode);
    }

    return null;
  }

  static getAllTaskComments({required taskId}) async {
    try {
      var response = await httpAuthGet(path: '/task_comments/$taskId');
      if (response.statusCode == 200) {
        return taskCommentResponseFromJson(response.body);
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        return {"error": "Server Error"};
      }
      print(e.response?.statusCode);
    }

    return null;
  }

  static getAllTaskFeedback({required taskId}) async {
    try {
      var response = await httpAuthGet(path: '/task_feedbacks/$taskId');
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['data'];
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        return {"error": "Server Error"};
      }
      print(e.response?.statusCode);
    }

    return null;
  }

  static getAllEmployee() async {
    try {
      var response = await httpAuthGet(path: '/dep_employees');
      if (response.statusCode == 200) {
        return firedEmployeeDataFromJson(response.body);
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
      var response = await httpAuthPost(path: '/task_create', data: data);
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

  static accept({required data}) async {
    try {
      var response = await httpAuthPost(path: '/task_accept', data: data);
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

  static sendReview({required data}) async {
    try {
      var response = await httpAuthPost(path: '/task_review', data: data);
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

  static completeTask({required data}) async {
    try {
      var response = await httpAuthPost(path: '/task_complete', data: data);
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

  static sendComment({required data}) async {
    try {
      var response = await httpAuthPost(path: '/send_comment', data: data);
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
        // return tadaResponseFromJson(response.body);
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
