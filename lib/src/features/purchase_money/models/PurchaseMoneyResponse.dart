// To parse this JSON data, do
//
//     final purchaseMoneyResponse = purchaseMoneyResponseFromJson(jsonString);

import 'dart:convert';

List<PurchaseMoneyResponse> purchaseMoneyResponseFromJson(String str) =>
    List<PurchaseMoneyResponse>.from(
        json.decode(str)['data'].map((x) => PurchaseMoneyResponse.fromJson(x)));

String purchaseMoneyResponseToJson(List<PurchaseMoneyResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PurchaseMoneyResponse {
  PurchaseMoneyResponse({
    required this.id,
    required this.employeeId,
    this.fullName,
    this.photo,
    this.projectName,
    required this.amount,
    required this.requestAmount,
    required this.note,
    required this.status,
    required this.uploaderInfo,
    required this.data,
    required this.dHeadEmployeeId,
    required this.dHeadApproval,
    required this.products,
  });

  dynamic id;
  dynamic employeeId;
  String? fullName;
  String? photo;
  String? projectName;
  dynamic amount;
  dynamic requestAmount;
  dynamic note;
  dynamic status;
  dynamic uploaderInfo;
  dynamic data;
  dynamic dHeadEmployeeId;
  dynamic dHeadApproval;
  List<Product> products;

  factory PurchaseMoneyResponse.fromJson(Map<String, dynamic> json) =>
      PurchaseMoneyResponse(
        id: json["id"],
        employeeId: json["employee_id"],
        fullName: json["full_name"],
        photo: "http://erp.superhomebd.com/super_home/${json["photo"]}",
        projectName: json["project_name"],
        amount: json["amount"],
        requestAmount: json["request_amount"],
        note: json["note"],
        status: json["status"],
        uploaderInfo: json["uploader_info"],
        data: json["data"],
        dHeadEmployeeId: json["d_head_employee_id"],
        dHeadApproval: json["d_head_approval"],
        products: List<Product>.from(
            json["products"].map((x) => Product.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "employee_id": employeeId,
        "full_name": fullName,
        "photo": photo,
        "project_name": projectName,
        "amount": amount,
        "request_amount": requestAmount,
        "note": note,
        "status": status,
        "uploader_info": uploaderInfo,
        "data": data,
        "d_head_employee_id": dHeadEmployeeId,
        "d_head_approval": dHeadApproval,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
      };
}

class Product {
  Product({
    required this.id,
    required this.name,
    required this.requestedQty,
  });

  dynamic id;
  dynamic name;
  dynamic requestedQty;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        requestedQty: json["requested_qty"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "requested_qty": requestedQty,
      };
}
