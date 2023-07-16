// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:neways3/src/utils/constants.dart';
//status == 0 - pending
///status == 1 - dep head approve
///status == 2 - myself - final money received
///status == 3 - boss reject
///status == 4 - boss approve (Send Notification)
// d_head approval == 0 - pendind
// d_head approval == 1 - approve
// d_head approval == 2 - reject

getStatus({aproval, hAproval}) {
  aproval = int.parse(aproval.toString());
  hAproval = int.parse(hAproval.toString());
  String status = "";
  Color color = Colors.black;
  if (aproval == 0) {
    status = "Applied";
    color = Colors.black;
  } else if (aproval == 1) {
    if (hAproval == 0) {
      status = "Pending";
      color = Colors.blueGrey;
    } else if (hAproval == 1) {
      status = "Dep. Head Approve";
      color = Colors.blue;
    } else if (hAproval == 2) {
      status = "Dep. Head Rejected";
      color = Colors.redAccent;
    }
  } else if (aproval == 2) {
    status = "Money Received";
    color = Colors.blue;
  } else if (aproval == 3) {
    status = "Boss Rejected";
    color = Colors.red;
  } else if (aproval == 4) {
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
