// To parse this JSON data, do
//
//     final increamentResponse = increamentResponseFromJson(jsonString);

import 'dart:convert';

IncreamentResponse increamentResponseFromJson(String str) =>
    IncreamentResponse.fromJson(json.decode(str));

String increamentResponseToJson(IncreamentResponse data) =>
    json.encode(data.toJson());

class IncreamentResponse {
  List<Increament> increaments;
  List<Increament> decreaments;

  IncreamentResponse({
    required this.increaments,
    required this.decreaments,
  });

  factory IncreamentResponse.fromJson(Map<String, dynamic> json) =>
      IncreamentResponse(
        increaments: List<Increament>.from(
            json["increaments"].map((x) => Increament.fromJson(x))),
        decreaments: List<Increament>.from(
            json["decreaments"].map((x) => Increament.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "increaments": List<dynamic>.from(increaments.map((x) => x.toJson())),
        "decreaments": List<dynamic>.from(decreaments.map((x) => x.toJson())),
      };
}

class Increament {
  String amount;
  String data;
  dynamic status;

  Increament({required this.amount, required this.data, this.status});

  factory Increament.fromJson(Map<String, dynamic> json) =>
      Increament(amount: json["amount"], data: json["data"], status: true);

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "data": data,
        "status": status,
      };
}
