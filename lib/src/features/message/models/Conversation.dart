
import 'package:neways3/src/features/contacts/models/employee_response_model.dart';

import 'Message.dart';

class Conversation {
  String? id;
  String? title;
  String? photo;
  String? type;
  List<EmployeeResponseModel>? participants;
  List<Message>? messages;
  EmployeeResponseModel? owner;
  List<EmployeeResponseModel>? admins;
  List<String>? lockedMsgs;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Conversation(
      {this.id,
      this.title,
      this.photo,
      this.type,
      this.participants,
      this.messages,
      this.owner,
      this.admins,
      this.lockedMsgs,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Conversation.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    title = json['title'];
    photo = json['photo'];
    type = json['type'];
    if (json['participants'] != null) {
      participants = <EmployeeResponseModel>[];
      json['participants'].forEach((v) {
        participants!.add(new EmployeeResponseModel.fromJson(v));
      });
    }

    if (json['messages'] != null) {
      messages = <Message>[];
      json['messages'].forEach((v) {
        messages!.add(new Message.fromJson(v));
      });
    }

    owner = json['owner'] != null ? EmployeeResponseModel.fromJson(json['owner']) : null;
    if (json['admins'] != null) {
      admins = <EmployeeResponseModel>[];
      json['admins'].forEach((v) {
        admins!.add(EmployeeResponseModel.fromJson(v));
      });
    }
    lockedMsgs = json['lockedMsgs'].cast<String>();
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['title'] = this.title;
    data['photo'] = this.photo;
    data['type'] = this.type;
    if (this.participants != null) {
      data['participants'] = this.participants!.map((v) => v.toJson()).toList();
    }

    if (this.messages != null) {
      data['messages'] = this.messages!.map((v) => v.toJson()).toList();
    }
    if (this.owner != null) {
      data['owner'] = this.owner!.toJson();
    }

    if (this.admins != null) {
      data['admins'] = this.admins!.map((v) => v.toJson()).toList();
    }
    data['lockedMsgs'] = this.lockedMsgs;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}


