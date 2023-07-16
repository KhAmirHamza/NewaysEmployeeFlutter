// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:neways3/src/utils/constants.dart';

getStatus({state, aproval}) {
  String status = "";
  Color color = Colors.black;
  if (aproval == 0 && state == 0) {
    status = "Applied";
    color = Colors.black;
  } else if (aproval == 0 && state == 1) {
    status = "Processing";
    color = Colors.blue;
  } else if (aproval == 1 && state == 2) {
    status = "Approved";
    color = Colors.green;
  } else if (aproval == 2 && state == 2) {
    status = "Rejected";
    color = Colors.red;
  }
  return Container(
    padding: EdgeInsets.symmetric(
        horizontal: DPadding.full, vertical: DPadding.half),
    decoration: BoxDecoration(
      color: color.withOpacity(.2),
      borderRadius: BorderRadius.circular(DPadding.full),
    ),
    child: Text(
      status.toUpperCase(),
      style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 10),
    ),
  );
}
