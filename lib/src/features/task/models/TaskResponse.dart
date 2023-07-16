// To parse this JSON data, do
//
//     final taskResponse = taskResponseFromJson(jsonString);

import 'dart:convert';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;

List<TaskResponse> taskResponseFromJson(String str) => List<TaskResponse>.from(
    json.decode(str)['data'].map((x) => TaskResponse.fromJson(x)));

String taskResponseToJson(List<TaskResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TaskResponse {
  TaskResponse({
    this.id,
    this.title,
    this.description,
    this.priorityRate,
    this.taskImage,
    this.departmentId,
    this.assignedTo,
    this.assignedBy,
    this.status,
    this.processingBy,
    this.completeBy,
    this.handedOver,
    this.empConfirm,
    this.deadlineAt,
    this.createdAt,
    this.acceptedAt,
    this.targetAt,
    this.completedAt,
    this.havePoint,
    this.assignedToName,
    this.assignedByName,
    this.sendReview,
  });

  dynamic id;
  dynamic title;
  dynamic description;
  dynamic priorityRate;
  dynamic taskImage;
  dynamic departmentId;
  dynamic assignedTo;
  dynamic assignedBy;
  dynamic status;
  dynamic processingBy;
  dynamic completeBy;
  dynamic handedOver;
  dynamic empConfirm;
  dynamic deadlineAt;
  dynamic createdAt;
  dynamic acceptedAt;
  dynamic targetAt;
  dynamic completedAt;
  dynamic havePoint;
  dynamic assignedToName;
  dynamic assignedByName;
  dynamic sendReview;

  factory TaskResponse.fromJson(Map<String, dynamic> json) => TaskResponse(
        id: json["id"],
        title: toBeginningOfSentenceCase(json["title"]),
        description: json["description"],
        priorityRate: json["priority_rate"],
        taskImage: json["task_image"],
        departmentId: json["department_id"],
        assignedTo: json["assigned_to"],
        assignedBy: json["assigned_by"],
        status: json["status"],
        processingBy: json["processing_by"],
        completeBy: json["complete_by"],
        handedOver: json["handed_over"],
        empConfirm: json["emp_confirm"],
        deadlineAt: json["deadline_at"],
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : null,
        acceptedAt: json["accepted_at"] != null
            ? DateTime.parse(json["accepted_at"])
            : null,
        targetAt: json["target_at"] != null
            ? DateTime.parse(json["target_at"])
            : null,
        completedAt: json["completed_at"] != null
            ? DateTime.parse(json["completed_at"])
            : null,
        havePoint: json["have_point"],
        assignedToName: json["assigned_to_name"],
        assignedByName: json["assigned_by_name"],
        sendReview: json["send_review"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "priority_rate": priorityRate,
        "task_image": taskImage,
        "department_id": departmentId,
        "assigned_to": assignedTo,
        "assigned_by": assignedBy,
        "status": status,
        "processing_by": processingBy,
        "complete_by": completeBy,
        "handed_over": handedOver,
        "emp_confirm": empConfirm,
        "deadline_at": deadlineAt,
        "created_at": createdAt.toIso8601String(),
        "accepted_at": acceptedAt.toIso8601String(),
        "target_at": targetAt.toIso8601String(),
        "completed_at": completedAt.toIso8601String(),
        "have_point": havePoint,
      };
}
