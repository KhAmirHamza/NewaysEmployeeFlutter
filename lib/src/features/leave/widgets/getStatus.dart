// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:neways3/src/utils/constants.dart';

getStatus({aproval, hAproval}) {
  print("aproval: $aproval, hAproval: $hAproval");
  String status = "";
  Color color = Colors.black;
  if (int.parse("$aproval") == 0) {
    if (int.parse(hAproval) == 1) {
      status = "D-head Approved - Boss pending";
      color = Colors.blue;
    } else if (int.parse(hAproval) == 2) {
      status = "D-head Rejected";
      color = Colors.redAccent;
    } else {
      status = "D-head Pending";
      color = Colors.blueGrey;
    }
  } else if (int.parse("$aproval") == 1) {
    status = "Boss Approved";
    color = Colors.green;
  } else {
    status = "Boss Rejected";
    color = Colors.red;
  }
  print("status: $status");
  return Align(
    alignment: Alignment.centerRight,
    child: Container(
      padding: EdgeInsets.symmetric(
          horizontal: DPadding.full, vertical: DPadding.half),
      decoration: BoxDecoration(
        color: color.withOpacity(.2),
        borderRadius: BorderRadius.circular(DPadding.full),
      ),

      child: Text(
        status.toUpperCase(),
        style:
            TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 10),
      ),
    ),
  );
}
