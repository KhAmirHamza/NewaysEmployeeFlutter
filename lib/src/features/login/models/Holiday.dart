class Holiday {
  String? day;
  String? reason;

  Holiday({this.day, this.reason});

  Holiday.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day'] = this.day;
    data['reason'] = this.reason;
    return data;
  }
}