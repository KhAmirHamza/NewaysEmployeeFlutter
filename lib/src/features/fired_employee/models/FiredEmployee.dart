// To parse this JSON data, do
//
//     final purchaseMoneyRequestData = purchaseMoneyRequestDataFromJson(jsonString);

import 'dart:convert';

List<Employee> firedEmployeeDataFromJson(String str) => List<Employee>.from(
    jsonDecode(str)['employees'].map((x) => Employee.fromJson(x)));

class Employee {
  Employee({
    required this.id,
    required this.fullName,
  });

  String id;
  String fullName;

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
        id: json["id"],
        fullName: json["full_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
      };
}

class Product {
  Product({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
