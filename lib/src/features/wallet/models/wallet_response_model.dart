// To parse this JSON data, do
//
//     final walletResponseModel = walletResponseModelFromJson(jsonString);

import 'dart:convert';

WalletResponseModel walletResponseModelFromJson(String str) =>
    WalletResponseModel.fromJson(json.decode(str));

String walletResponseModelToJson(WalletResponseModel data) =>
    json.encode(data.toJson());

class WalletResponseModel {
  WalletResponseModel({
    required this.attend,
    required this.basicSalary,
  });

  dynamic attend;
  dynamic basicSalary;

  factory WalletResponseModel.fromJson(Map<String, dynamic> json) =>
      WalletResponseModel(
        attend: json["attend"],
        basicSalary: json["basic_salary"],
      );

  Map<String, dynamic> toJson() => {
        "attend": attend,
        "basic_salary": basicSalary,
      };
}
