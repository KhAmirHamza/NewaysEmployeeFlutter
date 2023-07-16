// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:neways3/src/utils/constants.dart';

import '../models/TADAResponse.dart';

getStatus({required TadaResponse response}) {
  String status = "";
  Color color = Colors.black;
  if (response.status.toString() == '1') {
    if (response.departmentHeadAproval.toString() == '0') {
      status = "Pending";
      color = Colors.blue;
    } else if (response.departmentHeadAproval.toString() == '1') {
      status = "Processing";
      color = Colors.blue;
      if (response.bossAproval.toString() == '1') {
        status = "B:Approve";
        color = Colors.greenAccent;
        if (response.accountsAproval.toString() == '1') {
          status = "A:Approve";
          color = Colors.green;
          if (response.selfAproval.toString() == '1') {
            status = "RECEIVED";
            color = Colors.blueGrey;
          }
        } else if (response.accountsAproval.toString() == '2') {
          status = "A:Rejected";
          color = Colors.redAccent;
        }
      } else if (response.bossAproval.toString() == '2') {
        status = "B:Rejected";
        color = Colors.redAccent;
      }
    } else if (response.departmentHeadAproval.toString() == '2') {
      status = "DH:Rejected";
      color = Colors.redAccent;
    }
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
