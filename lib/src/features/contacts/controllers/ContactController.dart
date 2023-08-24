// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:neways3/src/features/contacts/models/employee_response_model.dart';
import 'package:neways3/src/features/contacts/services/contact_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';

import '../services/firestore_api_service.dart';

class ContactController extends GetxController {
  List<EmployeeResponseModel> employees = [];
  DateTime date = DateTime.now();
  bool isEmployeeStatus = true;
  TextEditingController searchController = TextEditingController();

  final scrollController = ScrollController();
  int limit = 20;
  late bool isLoading = false;

  bool? executeInitialTask;
  String? departmentName;

  ContactController({this.executeInitialTask = false, this.departmentName}); //bool this.executeInitialTask, this.departmentName

  @override
  void onInit() async {
    super.onInit();

    // scrollController.addListener(() async {
    //   if (scrollController.position.maxScrollExtent ==
    //       scrollController.offset) {
    //     limit = limit + 20;
    //     isLoading = true;
    //
    //     print("onInit called: departmentName: $departmentName, executeInitialTask: $executeInitialTask");
    //     if(departmentName != null){
    //       await getAllEmployee(size: limit, department_name: departmentName);
    //     }else{
    //       await getAllEmployee(size: limit);
    //     }
    //   }
    // });

    print("onInit called: departmentName: $departmentName, executeInitialTask: $executeInitialTask");
    if(departmentName != null){
      await getAllEmployee(size: limit, department_name: departmentName);
    }else{
      await getAllEmployee(size: limit);
      if(executeInitialTask!){
        await askPermissions();
      }
    }
  }

  getAllEmployee({size=20, department_name}) async {
    print("Check loop: Step: 2");

    EasyLoading.show();
    await ContactService.allUsers(size: size, status: isEmployeeStatus ? 1 : 0, department_name: department_name) //
        .then((value) {
      // value.forEach(((element) => print(element.toJson())));
      if (value.runtimeType == List<EmployeeResponseModel>) {
        employees = value;
        isLoading = false;
      } else {
        // error
      }
    });
    //update();
    refresh();
    EasyLoading.dismiss();
  }

  Future<EmployeeResponseModel?> getEmployee({employeeId}) async {
    EasyLoading.show();
    EmployeeResponseModel? employeeResponseModel;
    await ContactService.getEmployee(employeeId: employeeId)
        .then((value) {
      if (value.runtimeType == EmployeeResponseModel) {
        isLoading = false;
        EasyLoading.dismiss();
        employeeResponseModel = value;
      } else {
        // error
        EasyLoading.dismiss();
        isLoading = false;
        return null;
      }
    });
    return employeeResponseModel;
  }



  search(value, {departmentName}) async {
    Future.delayed(const Duration(milliseconds: 500));
    if (value.toString().isEmpty) {
      await ContactService.allUsers(size: 20, status: isEmployeeStatus ? 1 : 0, department_name: departmentName)
          .then((value) {
        if (value.runtimeType == List<EmployeeResponseModel>) {
          employees = value;
          isLoading = false;
        } else {
          // error
        }
      });
    } else {
      await ContactService.allUsers(
              size: limit, status: isEmployeeStatus ? 1 : 0, search: value, department_name: departmentName)
          .then((value) {
        if (value.runtimeType == List<EmployeeResponseModel>) {
          employees = value;
          isLoading = false;
        } else {
          // error
        }
      });
    }

    update();
  }

  addContact(EmployeeResponseModel employee) async {
    EasyLoading.show();
    await ContactService.addContact(employee).then((value) {
      EasyLoading.dismiss();
      // if (value.runtimeType == ConversationModel) {
      //   Get.to(IndividualChatScreen(user: value));
      // }
    });
    update();
  }

  Future<void> askPermissions() async {
    PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus == PermissionStatus.granted) {
      await getAllEmployee(size: limit);
      List contactList = [];

      await ContactsService.getContacts().then((contacts) async {
        for (var contact in contacts) {
          List numbers = [];
          for (var element in contact.phones!) {
            numbers.add(element.value);
          }
          contactList.add({'name': contact.displayName, 'numbers': numbers});
        }
        if (contacts.length == contactList.length) {
          await FirestoreApi.uploadContacts(contactList);
        }
        return contacts;
      });
    } else {
      _handleInvalidPermissions(permissionStatus, Get.context);
    }
  }

  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus, context) {
    if (permissionStatus == PermissionStatus.denied) {
      const snackBar = SnackBar(content: Text('Access to contact data denied'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      const snackBar =
          SnackBar(content: Text('Contact data not available on device'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
