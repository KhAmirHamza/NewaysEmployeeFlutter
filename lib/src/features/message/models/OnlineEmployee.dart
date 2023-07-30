import 'dart:ffi';

import 'package:neways3/src/features/message/ChatScreen.dart';

class OnlineEmployee {
  String? employeeId;
  String? socketId;
  int? lastCheckIn;
  String? status;

  OnlineEmployee({this.employeeId, this.socketId});

  OnlineEmployee.fromJson(Map<String, dynamic> json) {
    employeeId = json['employee_id'];
    socketId = json['socket_id'];
    lastCheckIn = json['lastCheckIn'];
    status = json['status']==null?"0": json['status'].toString();

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employee_id'] = this.employeeId;
    data['socket_id'] = this.socketId;
    data['lastCheckIn'] = this.lastCheckIn;
    data['status'] = this.status;
    return data;
  }
}
