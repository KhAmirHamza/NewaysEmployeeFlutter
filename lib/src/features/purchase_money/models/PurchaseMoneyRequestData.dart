// To parse this JSON data, do
//
//     final purchaseMoneyRequestData = purchaseMoneyRequestDataFromJson(jsonString);

import 'dart:convert';

PurchaseMoneyRequestData purchaseMoneyRequestDataFromJson(String str) =>
    PurchaseMoneyRequestData.fromJson(json.decode(str));

String purchaseMoneyRequestDataToJson(PurchaseMoneyRequestData data) =>
    json.encode(data.toJson());

class PurchaseMoneyRequestData {
  PurchaseMoneyRequestData({
    required this.products,
    required this.employees,
  });

  List<RequestProduct> products;
  List<Employee> employees;

  factory PurchaseMoneyRequestData.fromJson(Map<String, dynamic> json) =>
      PurchaseMoneyRequestData(
        products: List<RequestProduct>.from(
            json["products"].map((x) => RequestProduct.fromJson(x))),
        employees: List<Employee>.from(
            json["employees"].map((x) => Employee.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
        "employees": List<dynamic>.from(employees.map((x) => x.toJson())),
      };
}

class Employee {
  Employee({
    required this.id,
    required this.fullName,
  });

  dynamic id;
  dynamic fullName;

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
        id: json["id"],
        fullName: json["full_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
      };
}

class RequestProduct {
  RequestProduct({
    required this.id,
    required this.name,
  });

  dynamic id;
  dynamic name;

  factory RequestProduct.fromJson(Map<String, dynamic> json) => RequestProduct(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
