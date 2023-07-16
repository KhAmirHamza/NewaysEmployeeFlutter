class Prebook {
  String? id;
  String? employeeId;
  String? fName;
  String? lName;
  String? fullName;
  String? fatherName;
  String? motherName;
  String? gender;
  String? maritalStatus;
  String? dateOfBirth;
  String? dateOfJoining;
  String? bloodGroup;
  String? personalPhone;
  String? email;
  String? photo;
  String? nidNumber;
  String? emergencyContactName;
  String? emergencyContactRelation;
  String? emergencyNo1;
  String? emergencyContactName2;
  String? emergencyContactRelation2;
  String? emergencyNo2;
  String? emergencyAttachment1;
  String? emergencyAttachment2;
  String? currentAddress;
  String? permanentAddress;
  String? qualification;
  String? workExp;
  String? previusCompany;
  String? previusDesignation;
  String? reasonLeave;
  String? note;
  String? facebook;
  String? twitter;
  String? linkedin;
  String? instagram;
  String? status;
  String? date;

  Prebook(
      {this.id,
        this.employeeId,
        this.fName,
        this.lName,
        this.fullName,
        this.fatherName,
        this.motherName,
        this.gender,
        this.maritalStatus,
        this.dateOfBirth,
        this.dateOfJoining,
        this.bloodGroup,
        this.personalPhone,
        this.email,
        this.photo,
        this.nidNumber,
        this.emergencyContactName,
        this.emergencyContactRelation,
        this.emergencyNo1,
        this.emergencyContactName2,
        this.emergencyContactRelation2,
        this.emergencyNo2,
        this.emergencyAttachment1,
        this.emergencyAttachment2,
        this.currentAddress,
        this.permanentAddress,
        this.qualification,
        this.workExp,
        this.previusCompany,
        this.previusDesignation,
        this.reasonLeave,
        this.note,
        this.facebook,
        this.twitter,
        this.linkedin,
        this.instagram,
        this.status,
        this.date});

  Prebook.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeId = json['employee_id'];
    fName = json['f_name'];
    lName = json['l_name'];
    fullName = json['full_name'];
    fatherName = json['father_name'];
    motherName = json['mother_name'];
    gender = json['gender'];
    maritalStatus = json['marital_status'];
    dateOfBirth = json['date_of_birth'];
    dateOfJoining = json['date_of_joining'];
    bloodGroup = json['blood_group'];
    personalPhone = json['personal_Phone'];
    email = json['email'];
    photo = json['photo'];
    nidNumber = json['nid_number'];
    emergencyContactName = json['emergency_contact_name'];
    emergencyContactRelation = json['emergency_contact_relation'];
    emergencyNo1 = json['emergency_no1'];
    emergencyContactName2 = json['emergency_contact_name2'];
    emergencyContactRelation2 = json['emergency_contact_relation2'];
    emergencyNo2 = json['emergency_no2'];
    emergencyAttachment1 = json['emergency_attachment_1'];
    emergencyAttachment2 = json['emergency_attachment_2'];
    currentAddress = json['current_address'];
    permanentAddress = json['permanent_address'];
    qualification = json['qualification'];
    workExp = json['work_exp'];
    previusCompany = json['previus_company'];
    previusDesignation = json['previus_designation'];
    reasonLeave = json['reason_leave'];
    note = json['note'];
    facebook = json['facebook'];
    twitter = json['twitter'];
    linkedin = json['linkedin'];
    instagram = json['instagram'];
    status = json['status'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if(this.id!=null){
      data['id'] = this.id;
    }
    data['employee_id'] = this.employeeId;
    data['f_name'] = this.fName;
    data['l_name'] = this.lName;
    data['full_name'] = this.fullName;
    data['father_name'] = this.fatherName;
    data['mother_name'] = this.motherName;
    data['gender'] = this.gender;
    data['marital_status'] = this.maritalStatus;
    data['date_of_birth'] = this.dateOfBirth;
    data['date_of_joining'] = this.dateOfJoining;
    data['blood_group'] = this.bloodGroup;
    data['personal_Phone'] = this.personalPhone;
    data['email'] = this.email;
    data['photo'] = this.photo;
    data['nid_number'] = this.nidNumber;
    data['emergency_contact_name'] = this.emergencyContactName;
    data['emergency_contact_relation'] = this.emergencyContactRelation;
    data['emergency_no1'] = this.emergencyNo1;
    data['emergency_contact_name2'] = this.emergencyContactName2;
    data['emergency_contact_relation2'] = this.emergencyContactRelation2;
    data['emergency_no2'] = this.emergencyNo2;
    data['emergency_attachment_1'] = this.emergencyAttachment1;
    data['emergency_attachment_2'] = this.emergencyAttachment2;
    data['current_address'] = this.currentAddress;
    data['permanent_address'] = this.permanentAddress;
    data['qualification'] = this.qualification;
    data['work_exp'] = this.workExp;
    data['previus_company'] = this.previusCompany;
    data['previus_designation'] = this.previusDesignation;
    data['reason_leave'] = this.reasonLeave;
    data['note'] = this.note;
    data['facebook'] = this.facebook;
    data['twitter'] = this.twitter;
    data['linkedin'] = this.linkedin;
    data['instagram'] = this.instagram;
    data['status'] = this.status;
    data['date'] = this.date;
    return data;
  }
}