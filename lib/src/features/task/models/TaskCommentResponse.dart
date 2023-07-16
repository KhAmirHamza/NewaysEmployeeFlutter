import 'dart:convert';

List<TaskCommentResponse> taskCommentResponseFromJson(String str) =>
    List<TaskCommentResponse>.from(
        json.decode(str)['data'].map((x) => TaskCommentResponse.fromJson(x)));

String taskCommentResponseToJson(List<TaskCommentResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TaskCommentResponse {
  TaskCommentResponse({
    this.id,
    this.taskId,
    this.comment,
    this.createdAt,
    this.employeeId,
    this.fullName,
    this.photo,
  });

  dynamic id;
  dynamic taskId;
  dynamic comment;
  dynamic createdAt;
  dynamic employeeId;
  dynamic fullName;
  dynamic photo;

  factory TaskCommentResponse.fromJson(Map<String, dynamic> json) =>
      TaskCommentResponse(
        id: json["id"],
        taskId: json["task_id"],
        comment: json["comment"],
        createdAt: DateTime.parse(json["created_at"]),
        employeeId: json["employee_id"],
        fullName: json["full_name"],
        photo: "http://erp.superhomebd.com/super_home/${json["photo"]}",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "task_id": taskId,
        "comment": comment,
        "created_at": createdAt.toIso8601String(),
        "employee_id": employeeId,
        "full_name": fullName,
        "photo": photo,
      };
}
