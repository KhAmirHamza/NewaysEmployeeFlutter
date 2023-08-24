import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import '../../../utils/functions.dart';
import '../utils/Constant.dart';

class ConversationService {
  static final dio = Dio();
  static var header = {
    'Content-type': 'application/json; charset=utf-8',
    'Accept': 'application/json'
  };

  static updateConversation(String convsId, String? title, String? photo,
      Function(dynamic data) onSuccessful) async {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (title != null) {
      data['title'] = title;
    }if (photo != null) {
      data['photo'] = photo;
    }
    print("data:$data");
    var response = await dio.post(
      "$chatUrl/v1/conversation/update?convsId=$convsId",
      data: data,
      options: Options(headers: header),
    );
    if (response.statusCode == 200) {
      onSuccessful(response.data);
    }
  }

  static uploadImageAsBase64(String base64Image, String filename,
      Function(dynamic data) onSuccessful) async {
    try {
      var response = await dio.post("$chatUrl/upload",
          data: {"image": base64Image, "name": filename});
      if (response.statusCode == 200) {
        onSuccessful(response.data);
      }
    } catch (e) {
      print("Error => uploadImageAsBase64 => $e");
      return;
    }
  }

  static uploadImageAsMultipartLaravel(File galleryFile, Function(String imageUrl) onSuccessful) async {
    try {
      var uri = "http://116.68.198.178/neways_employee_mobile_application/v1/api/send";
      var request = http.MultipartRequest('POST', Uri.parse(uri));
      var pic = await http.MultipartFile.fromPath("image",
          galleryFile.path); // Uploading Image using Multipart System
      request.files.add(pic);

      await request.send().then((result) {
        http.Response.fromStream(result).then((response) {
          var message = jsonDecode(response.body);
          imagePath = message['file_path'];
          onSuccessful(imagePath!);
        });
      });
    } catch (e) {
      print("Error => uploadImageAsMultipartLaravel => $e");
      return;
    }
  }
}
