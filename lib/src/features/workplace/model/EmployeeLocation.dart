class EmployeeLocation {
  int? id;
  String? userType;
  String? userId;
  String? fullName;
  String? photo;
  String? longitude;
  String? latitude;
  String? address;
  String? date;

  EmployeeLocation(
      {this.id,
        this.userId,
        this.fullName,
        this.photo,
        this.userType,
        this.longitude,
        this.latitude,
        this.address,
        this.date});

  EmployeeLocation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    fullName = json['full_name'];
    photo =  json["photo"].toString().contains("http://erp.superhomebd.com/super_home/") ? json["photo"]: "http://erp.superhomebd.com/super_home/" + json["photo"];
    userType = json['user_type'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    address = json['address'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['full_name'] = this.fullName;
    data['photo'] = this.photo;
    data['user_type'] = this.userType;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['address'] = this.address;
    data['date'] = this.date;
    return data;
  }
}