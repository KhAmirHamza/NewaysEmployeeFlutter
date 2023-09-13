class PendingApprovals {
  int? leave;
  int? purchase;
  int? taDa;
  int? advance;
  int? emergencyWork;
  int? resign;
  int? fired;

  PendingApprovals(
      {this.leave,
        this.purchase,
        this.taDa,
        this.advance,
        this.emergencyWork,
        this.resign,
        this.fired});

  PendingApprovals.fromJson(Map<String, dynamic> json) {
    leave = json['leave'];
    purchase = json['purchase'];
    taDa = json['ta_da'];
    advance = json['advance'];
    emergencyWork = json['emergency_work'];
    resign = json['resign'];
    fired = json['fired'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['leave'] = this.leave;
    data['purchase'] = this.purchase;
    data['ta_da'] = this.taDa;
    data['advance'] = this.advance;
    data['emergency_work'] = this.emergencyWork;
    data['resign'] = this.resign;
    data['fired'] = this.fired;
    return data;
  }
}