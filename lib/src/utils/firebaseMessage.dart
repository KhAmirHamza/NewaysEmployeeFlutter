import 'dart:convert';

import 'package:http/http.dart' as http;

const firebaseAppKey =
    "AAAAKcZRFiE:APA91bEXenv9Nfc0QBVhsKsit-u_XTcZ4GUylVsmUz8zHIhSfYLXuhD3OT4Q7rQG9eJ5PGc4Amo1UFQ-2q5XjV22-dCthMxCxEGyTQcj7GP7XP_uF3Cr7X-EWuPeLChR-EK6vfBCXepr";
Future<void> firebasePushMsg(
    {required String topic,
    required String title,
    required String body}) async {
  await http
      .post(
        Uri.https('fcm.googleapis.com', '/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $firebaseAppKey',
        },
        body: jsonEncode(<String, dynamic>{
          "to": "/topics/$topic",
          //"condition": "'dogs' in topics || 'cats' in topics",up to 5 using &&,||,!
          "priority": "high",
          "notification": {"title": title, "body": body, "sound": "default"},
          "android": {
            "direct_boot_ok": true,
          },
          "apns": {
            "headers": {"apns-priority": "5"},
          }
        }),
      )
      .timeout(const Duration(seconds: 10));
}
