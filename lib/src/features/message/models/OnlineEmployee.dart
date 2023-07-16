class OnlineEmployee {
  String? employeeId;
  String? socketId;

  OnlineEmployee({this.employeeId, this.socketId});

  OnlineEmployee.fromJson(Map<String, dynamic> json) {
    employeeId = json['employee_id'];
    socketId = json['socket_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employee_id'] = this.employeeId;
    data['socket_id'] = this.socketId;
    return data;
  }
}
