// To parse this JSON data, do
//
//     final loginResponseModel = loginResponseModelFromJson(jsonString);

import 'dart:convert';

LoginResponseModel loginResponseModelFromJson(String str) =>
    LoginResponseModel.fromJson(json.decode(str));

String loginResponseModelToJson(LoginResponseModel data) =>
    json.encode(data.toJson());

class LoginResponseModel {
  LoginResponseModel({
    required this.accessToken,
    required this.tokenType,
    required this.employeeId,
    this.fName,
    required this.fullName,
    required this.designationName,
    required this.departmentName,
    required this.roleName,
    required this.avater,
    required this.phone,
    required this.otp,
    required this.isDepHead,
  });

  String accessToken;
  String tokenType;
  String employeeId;
  String? fName;
  String fullName;
  String designationName;
  String departmentName;
  String roleName;
  String avater;
  dynamic phone;
  dynamic otp;
  bool isDepHead;

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      LoginResponseModel(
        accessToken: json["access_token"],
        tokenType: json["token_type"],
        employeeId: json["employee_id"],
        fName: json["f_name"],
        fullName: json["full_name"],
        designationName: json["designation_name"],
        departmentName: json["department_name"],
        roleName: json["role_name"],
        isDepHead: json["d_head"] == 1 ? true : false,
        avater: json["avater"],
        phone: json["phone"],
        otp: json["otp"],
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "token_type": tokenType,
        "employee_id": employeeId,
        "f_name": fName,
        "full_name": fullName,
        "designation_name": designationName,
        "department_name": departmentName,
        "role_name": roleName,
        "d_head": isDepHead == true ? 1 : 0,
        "avater": avater,
        "phon": phone,
        "otp": otp,
      };
}
