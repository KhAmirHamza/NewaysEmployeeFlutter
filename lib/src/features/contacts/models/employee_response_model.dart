// To parse this JSON data, do
//
//     final employeeResponseModel = employeeResponseModelFromJson(jsonString);

// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';

List<EmployeeResponseModel> employeeResponseModelFromJson(List data) =>
    List<EmployeeResponseModel>.from(
        data.map((x) => EmployeeResponseModel.fromJson(x)));

String employeeResponseModelToJson(List<EmployeeResponseModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EmployeeResponseModel {
  EmployeeResponseModel({
    this.employeeId,
    this.roleName,
    this.designationName,
    this.departmentName,
    this.fullName,
    this.personalPhone,
    this.email,
    this.photo,
    this.companyPhone,
    this.companyEmail,
    this.status,
    //this.assign_group,
  });

  String? employeeId;
  String? roleName;
  String? designationName;
  String? departmentName;
  String? fullName;
  String? personalPhone;
  String? email;
  String? photo;
  String? companyPhone;
  String? companyEmail;
  dynamic status;
  //String? assign_group;


  factory EmployeeResponseModel.fromJson(Map<String, dynamic> json) =>
      EmployeeResponseModel(
        employeeId: json["employee_id"],
        roleName: json["role_name"],
        designationName: json["designation_name"],
        departmentName: json["department_name"],
        fullName: json["full_name"],
        personalPhone: json["personal_Phone"],
        email: json["email"],
        photo: json["photo"].toString().contains("http://erp.superhomebd.com/super_home/") ? json["photo"]: "http://erp.superhomebd.com/super_home/" + json["photo"],
        companyPhone: json["Company_phone"],
        companyEmail: json["company_email"],
        status: json["status"],
        //assign_group: json["assign_group"],
      );

  Map<String, dynamic> toJson() => {
        "employee_id": employeeId.toString(),
        "role_name": roleName,
        "designation_name": designationName,
        "department_name": departmentName,
        "full_name": fullName,
        "personal_Phone": personalPhone,
        "email": email,
        "photo": photo,
        "Company_phone": companyPhone,
        "company_email": companyEmail,
        "status": status.toString(),
        //"assign_group": assign_group.toString(),
      };
}
