import 'dart:ffi';

import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../utils/constants.dart';
import '../../fired_employee/models/FiredEmployee.dart';
import '../models/TaskCommentResponse.dart';
import '../models/TaskResponse.dart';
import '../services/TaskAPIService.dart';

class TaskController extends GetxController {
  final scrollController = ScrollController();

  String? departmentName = '';
  String selectStatus = 'Backlog';

  List<TaskResponse>? backLogs;
  List<TaskResponse>? processing;
  List<TaskResponse>? complete;
  List<TaskResponse> displayData = [TaskResponse()];

  TaskResponse? task;
  List<TaskCommentResponse> comments = [TaskCommentResponse()];
  List<dynamic> feedbacks = [];

  // create task
  List<SelectedListItem> employees = [];
  TextEditingController employeeController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController benefitController = TextEditingController();
  TextEditingController pointController = TextEditingController();
  String taskType = "regular";
  bool isCheckBoxChecked = false;

  bool isCommets = false;
  TextEditingController commentController = TextEditingController();
  TextEditingController feedbackController = TextEditingController();
  DateTime deadline = DateTime.now();
  bool isOneStar = true;
  bool isTwoStar = false;
  bool isThreeStar = false;
  bool isFourStar = false;
  bool isFiveStar = false;
  List departments = [];

  TaskController({this.departmentName});

  @override
  onInit() {
    super.onInit();
    print("getData: departmentName: $departmentName");

    getDepartment();
  }

  getDepartment() async {

    EasyLoading.show();
    await TaskAPIServices.getAllDepartment().then((value) {
      departments = value;
    });
    EasyLoading.dismiss();
    update();
  }

  getData() async {

    EasyLoading.show();
    displayData = [];
    backLogs = [];
    processing = [];
    complete = [];
    await TaskAPIServices.getAllData(departmentName).then((data) {
      if (data is List<TaskResponse>) {
        for (var element in data) {
          if (element.status == 0) {
            backLogs!.add(element);
          } else if (element.status == 1) {
            processing!.add(element);
          } else if (element.status == 2) {
            complete!.add(element);
          }
        }
        displayData = backLogs!;
        selectStatus = 'Backlog';
      }
    });
    EasyLoading.dismiss();
    update();
  }

  getReviewData() async {
    EasyLoading.show();
    displayData = [];
    await TaskAPIServices.getAllReviewData(departmentName).then((data) {
      if (data is List<TaskResponse>) {
        for (var element in data) {
          displayData.add(element);
        }
        selectStatus = 'Review';
      }
    });
    EasyLoading.dismiss();
    update();
  }

  getComments({id}) async {
    EasyLoading.show();
    await TaskAPIServices.getAllTaskComments(taskId: id).then((data) {
      if (data is List<TaskCommentResponse>) {
        comments = data;
      }
    });
    EasyLoading.dismiss();
    update();
  }

  getFeedback({id}) async {
    EasyLoading.show();
    await TaskAPIServices.getAllTaskFeedback(taskId: id).then((data) {
      feedbacks = data;
    });
    EasyLoading.dismiss();
    update();
  }

  getEmployee() async {
    EasyLoading.show();
    await TaskAPIServices.getAllEmployee().then((data) {
      if (data.runtimeType == List<Employee>) {
        for (Employee element in data) {
          employees.add(SelectedListItem(
              name: element.fullName, value: element.id.toString()));
        }
      }
    });
    EasyLoading.dismiss();

    update();
  }

  create() async {
    if (employeeController.text.isEmpty && isDepHead) {
      Get.snackbar('Warning', "Employee must be required",
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(DPadding.full));
      return false;
    } else if (titleController.text.isEmpty) {
      Get.snackbar('Warning', "Title must be required",
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(DPadding.full));
      return false;
    }

    else if (isCheckBoxChecked && pointController.text.isEmpty) {
      Get.snackbar('Warning', "Performance bonus point must be required",
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(DPadding.full));
      return false;
    }

    else if (isCheckBoxChecked && pointController.text.isNotEmpty && !(int.parse(pointController.text)>=5 && int.parse(pointController.text)<=100)) {
      Get.snackbar('Warning', "Performance bonus points must be between 5 and 100%",
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(DPadding.full));
      return false;
    }
    print({
      "employee_id": employeeController.text.isNotEmpty
          ? employeeController.text.split(' - ')[0]
          : GetStorage().read('employeeId'),
      "title": titleController.text,
      "description": descriptionController.text,
      "task_benefit": benefitController.text,
      "deadline": deadline.toString(),
      "task_type": taskType,
      "point": pointController.text.isEmpty? "0": pointController.text,
      "rate": rate,
    });

    //return;

    EasyLoading.show();
    await TaskAPIServices.submit(
      data: {
        "employee_id": employeeController.text.isNotEmpty
            ? employeeController.text.split(' - ')[0]
            : GetStorage().read('employeeId'),
        "title": titleController.text,
        "description": descriptionController.text,
        "task_benefit": benefitController.text,
        "deadline": deadline.toString(),
        "task_type": taskType,
        "point": pointController.text.isEmpty? "0": pointController.text,
        "rate": rate,
      },
    ).then((data) async {
      Get.back();
      Get.snackbar('Message', data,
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(DPadding.full));
      await getDepartment();
    });
    EasyLoading.dismiss();
    clear();
    update();
    return true;
  }

  accept(id) async {
    EasyLoading.show();
    await TaskAPIServices.accept(
      data: {
        "task_id": id.toString(),
        "target_at": deadline.toString(),
      },
    ).then((data) async {
      Get.back();
      Get.snackbar('Message', data,
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(DPadding.full)
      );
      await getData();
    });
    EasyLoading.dismiss();
    update();
    return true;
  }

  sendReview(id) async {
    EasyLoading.show();
    if (feedbackController.text.isEmpty) {
      Get.snackbar('Warning', "Feedback must be required",
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(DPadding.full));
      return false;
    }
    await TaskAPIServices.sendReview(
      data: {
        "task_id": id.toString(),
        "feedback": feedbackController.text,
      },
    ).then((data) async {
      Get.snackbar('Message', data,
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(DPadding.full));
      await getFeedback(id: id.toString());
    });
    EasyLoading.dismiss();
    feedbackController.clear();
    update();
    return true;
  }

  completeTask(id) async {
    EasyLoading.show();
    await TaskAPIServices.completeTask(
      data: {
        "task_id": id.toString(),
        "employee_id": task!.assignedBy.toString(),
      },
    ).then((data) async {
      Get.back();
      Get.snackbar('Message', data,
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(DPadding.full));
      await getData();
    });
    EasyLoading.dismiss();
    update();
    return true;
  }

  sendComment(comment) async {
    EasyLoading.show();
    await TaskAPIServices.sendComment(
      data: {
        "task_id": task!.id.toString(),
        "comment": comment.toString(),
      },
    ).then((data) async {
      // Get.back();
      // Get.snackbar('Message', data,
      //     snackPosition: SnackPosition.BOTTOM,
      //     margin: EdgeInsets.all(DPadding.full));
      commentController.clear();
      await getComments(id: task!.id.toString());
    });
    EasyLoading.dismiss();
    update();
    return true;
  }

  get rate {
    if (isFiveStar) {
      return "5";
    } else if (isFourStar) {
      return "4";
    } else if (isThreeStar) {
      return "3";
    } else if (isTwoStar) {
      return "2";
    } else {
      return "1";
    }
  }

  makeRating(int star) {
    switch (star) {
      case 1:
        isOneStar = true;
        isTwoStar = false;
        isThreeStar = false;
        isFourStar = false;
        isFiveStar = false;
        break;
      case 2:
        isOneStar = true;
        isTwoStar = true;
        isThreeStar = false;
        isFourStar = false;
        isFiveStar = false;
        break;
      case 3:
        isOneStar = true;
        isTwoStar = true;
        isThreeStar = true;
        isFourStar = false;
        isFiveStar = false;
        break;
      case 4:
        isOneStar = true;
        isTwoStar = true;
        isThreeStar = true;
        isFourStar = true;
        isFiveStar = false;
        break;
      case 5:
        isOneStar = true;
        isTwoStar = true;
        isThreeStar = true;
        isFourStar = true;
        isFiveStar = true;
        break;
      default:
    }
    update();
  }

  clear() {
    employeeController.clear();
    titleController.clear();
    descriptionController.clear();
    benefitController.clear();
    taskType = "regular";
    pointController.clear();
    makeRating(1);
  }





}
