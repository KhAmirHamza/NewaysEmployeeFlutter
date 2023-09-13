// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:neways3/src/utils/constants.dart';

// if ($d=='0') {
//     return '<span class="badge badge-info">D-head Pending</span>';
// }elseif ($d=='1') {
//     return '<span class="badge badge-warning">Boss Approved</span>';
// }elseif ($d=='2') {
//     return '<span class="badge badge-danger">Boss Reject</span>';
// }elseif ($d=='3') {
//     return '<span class="badge badge-warning">Boss Pending</span>';
// }elseif ($d=='4') {
//     return '<span class="badge badge-danger">D-head Reject</span>';
// }
getStatus({status}) {
  String message = "";
  Color color = Colors.black;
  if (status == 0) {
    message = "D-head Pending";
    color = Colors.blueGrey;
  } else if (status == 1) {
    message = "Boss Approved";
    color = Colors.green;
  } else if (status == 2) {
    message = "Boss Rejected";
    color = Colors.redAccent;
  } else if (status == 3) {
    message = "HR Pending";
    color = Colors.blue;
  } else if (status == 4) {
    message = "D-head Rejected";
    color = Colors.red;
  } else if (status == 5) {
    message = "Boss Pending";
    color = Colors.blue;
  } else if (status == 6) {
    message = "HR Rejected";
    color = Colors.red;
  } else {
    message = "Rejected";
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
        message.toUpperCase(),
        style:
            TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 10),
      ),
    ),
  );
}
