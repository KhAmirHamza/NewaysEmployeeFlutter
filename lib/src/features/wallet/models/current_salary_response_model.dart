// To parse this JSON data, do
//
//     final walletResponseModel = walletResponseModelFromJson(jsonString);

import 'dart:convert';

CurrentSalaryResponseModel walletResponseModelFromJson(String str) =>
    CurrentSalaryResponseModel.fromJson(json.decode(str));

String walletResponseModelToJson(CurrentSalaryResponseModel data) =>
    json.encode(data.toJson());

class CurrentSalaryResponseModel {
  CurrentSalaryResponseModel({
    required this.attend,
    required this.basicSalary,
    this.increament,
    this.wallet = 00,
    this.decreament,
  });

  dynamic attend;
  dynamic basicSalary, wallet;
  dynamic increament;
  dynamic decreament;

  factory CurrentSalaryResponseModel.fromJson(Map<String, dynamic> json) =>
      CurrentSalaryResponseModel(
        attend: json["attend"],
        basicSalary: json["basic_salary"],
        wallet: json["wallet"],
        increament: json["increament"],
        decreament: json["decreament"],
      );

  Map<String, dynamic> toJson() => {
        "attend": attend,
        "basic_salary": basicSalary,
        "wallet": wallet,
        "increament": increament,
        "decreament": decreament,
      };
}
