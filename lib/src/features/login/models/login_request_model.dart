// To parse this JSON data, do
//
//     final loginRequestModel = loginRequestModelFromJson(jsonString);

import 'dart:convert';

LoginRequestModel loginRequestModelFromJson(String str) =>
    LoginRequestModel.fromJson(json.decode(str));

String loginRequestModelToJson(LoginRequestModel data) =>
    json.encode(data.toJson());

class LoginRequestModel {
  LoginRequestModel({
    this.employeeId,
    this.password,
  });

  dynamic employeeId;
  dynamic password;

  factory LoginRequestModel.fromJson(Map<String, dynamic> json) =>
      LoginRequestModel(
        employeeId: json["employee_id"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "employee_id": employeeId,
        "password": password,
      };
}
