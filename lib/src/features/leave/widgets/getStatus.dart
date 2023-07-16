// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:neways3/src/utils/constants.dart';

getStatus({aproval, hAproval}) {
  String status = "";
  Color color = Colors.black;
  if (aproval == 0) {
    if (hAproval == 1) {
      status = "Processing";
      color = Colors.blue;
    } else if (hAproval == 2) {
      status = "Rejected";
      color = Colors.redAccent;
    } else {
      status = "Pending";
      color = Colors.blueGrey;
    }
  } else if (aproval == 1) {
    status = "Approved";
    color = Colors.green;
  } else {
    status = "Rejected";
    color = Colors.red;
  }
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
