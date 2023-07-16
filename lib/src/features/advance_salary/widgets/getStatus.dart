// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:neways3/src/utils/constants.dart';

getStatus({aproval, accountAproval}) {
  String status = "";
  Color color = Colors.black;
  if (aproval == 0) {
    status = "Dep. Head Approved";
    color = Colors.greenAccent;
  } else if (aproval == 1) {
    status = "Boss Approved";
    color = Colors.lightGreen;
    if (accountAproval == 1) {
      status = "Boss & Account Approved";
      color = Colors.green;
    }
  } else if (aproval == 2) {
    status = "Boss Rejected";
    color = Colors.red;
  } else if (aproval == 3) {
    status = "Pending";
    color = Colors.blue;
  } else if (aproval == 4) {
    status = "Dep. Head Rejected";
    color = Colors.red;
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
