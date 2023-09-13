import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:neways3/src/features/contacts/controllers/ContactController.dart';
import 'package:neways3/src/features/contacts/models/employee_response_model.dart';
import 'package:neways3/src/features/message/bloc/group_chat_widget.dart';
import 'package:neways3/src/features/message/bloc/single_chat_page.dart';
import 'package:neways3/src/features/message/services/ConversationService.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../../utils/functions.dart';
import '../models/Conversation.dart';
import '../models/Mentionable.dart';
import '../models/Message.dart';
import '../utils/Constant.dart';
import 'CustomTextEditingController.dart';
import 'SocketController.dart';

class ConversationController extends GetxController implements SocketListeners {
  late bool isLoadding = false;
  EmployeeResponseModel? currentEmployee;

  var conversations = <Conversation>[].obs;
  final dio = Dio();
  SocketController socketController = SocketController();
  List<Mentionable> matchMentionableBySearch = [];
  List<int> selectedMentionsIndexList = [];


  setCurrentEmployee(EmployeeResponseModel currentEmployee) {
    this.currentEmployee = currentEmployee;
  }

  addParticipant(String convsId, EmployeeResponseModel newParticipant) async {
    var header = {
      'Content-type': 'application/json; charset=utf-8',
      'Accept': 'application/json'
    };
    var response = await dio.post(
      "$chatUrl/v1/conversation/addParticipant?convsId=$convsId",
      data: newParticipant.toJson(),
      options: Options(headers: header),
    );
    if (response.statusCode == 200) {
     // print("Added Participant: ConvsId: $convsId , EmployeeId: ${newParticipant.employeeId}");
      conversations[conversations.indexWhere((element) => element.id==convsId)].participants!.add(newParticipant);
      conversations.refresh();
    }
  }

  removeParticipant(String convsId, String participantEmployeeId) async {
    var header = {
      'Content-type': 'application/json; charset=utf-8',
      'Accept': 'application/json'
    };
    var response = await dio.delete(
      "$chatUrl/v1/conversation/deleteParticipant?convsId=$convsId&employee_id=$participantEmployeeId",
      options: Options(headers: header),
    );
    if (response.statusCode == 200) {
      //print("Removed Participant: ConvsId: $convsId, EmployeeId: $participantEmployeeId");
      conversations[conversations.indexWhere((element) => element.id==convsId)].participants!.removeWhere((element) => element.employeeId == participantEmployeeId);
      conversations.refresh();
    }
  }

  sendFirstMessage(
      BuildContext context,
      IO.Socket socket,
      ContactController contactController,
      ConversationController convsController,
      EmployeeResponseModel? selectedEmployee,
      List<EmployeeResponseModel>? groupEmployees,
      String title,
      Message message,
      String convsType,
      String photo,
      EmployeeResponseModel owner,
      List<EmployeeResponseModel> admins) async {
      EasyLoading.show();
      isLoadding = true;
      socketController.sendFirstMessage(currentEmployee!, selectedEmployee,
          convsType, message, title, photo, groupEmployees, owner, admins, this);
      EasyLoading.dismiss();
      isLoadding = true;

  }

  sendMessage(String convsId, String convsType, Message message) {
    socketController.notifyMessageSend(
        convsId, convsType, message, this);
  }

  addReactUpdateConvs(
      int messageIndex,
      String convsId,
      String convsType,
      String messageId,
      String reactTitle,
      IO.Socket socket) async {
    var header = {
      'Content-type': 'application/json; charset=utf-8',
      'Accept': 'application/json'
    };
    var response = await dio.post(
      "$chatUrl/conversation/reactMessage?convsId=$convsId",
      data: jsonEncode(<String, dynamic>{
        'messageId': messageId,
        "reactTitle": reactTitle,
        "sender": currentEmployee,
      }),
      options: Options(headers: header),
    );
    if (response.statusCode == 200) {
      React react = React(title: reactTitle, sender: currentEmployee!);

      socketController.notifyNewReactAdded(
          convsId, messageId, convsType, reactTitle, currentEmployee!);
      conversations[conversations.indexWhere((element) => element.id==convsId)].messages![messageIndex].reacts!.add(react);
      conversations.refresh();
    }
  }

  removeReactUpdateConvs(
      int messageIndex,
      String convsId,
      String convsType,
      String messageId,
      String reactTitle,
      IO.Socket socket) async {
    var header = {
      'Content-type': 'application/json; charset=utf-8',
      'Accept': 'application/json'
    };
    await dio.delete(
      "$chatUrl/conversation/reactMessage?convsId=$convsId",
      data: jsonEncode(<String, dynamic>{
        'messageId': messageId,
        "reactTitle": reactTitle,
        "sender": currentEmployee,
      }),
      options: Options(headers: header),
    );

    React react = React(title: reactTitle, sender: currentEmployee!);
    socketController.notifyReactRemoved(
        convsId, messageId, convsType, reactTitle, currentEmployee!);
    conversations[conversations.indexWhere((element) => element.id==convsId)]
        .messages![messageIndex]
        .reacts!
        .removeWhere((element) => ((element.title == react.title) && (element.sender!.employeeId! == react.sender!.employeeId!)));
    conversations.refresh();
  }

  receivedMessage(String convsId, String convsType, String messageId,
      IO.Socket socket) async {
    var header = {
      'Content-type': 'application/json; charset=utf-8',
      'Accept': 'application/json'
    };

    var response = await dio.post(
      "$chatUrl/conversation/receivedMessage?convsId=$convsId",
      data: jsonEncode(<String, dynamic>{
        'messageId': messageId,
        "currentEmployeeId": currentEmployee!.employeeId,
      }),
      options: Options(headers: header),
    );

    if (response.statusCode == 200) {
      socketController.notifyMessageReceived( convsId, convsType, currentEmployee!.employeeId!);

      if(convsType=="Single"){
        SingleChatPage.seenMessage(this, convsId, convsType, messageId, socket, currentEmployee!.employeeId!);
      }else{
        GroupChatWidget.seenMessage(this, convsId, convsType, messageId, socket, currentEmployee!.employeeId!);
      }
    }
  }

  seenMessage(String convsId, String convsType, String messageId,
      IO.Socket socket) async {
    var header = {
      'Content-type': 'application/json; charset=utf-8',
      'Accept': 'application/json'
    };

    var response = await dio.post(
      "$chatUrl/conversation/seenMessage?convsId=$convsId",
      data: jsonEncode(<String, dynamic>{
        'messageId': messageId,
        "currentEmployeeId": currentEmployee!.employeeId,
      }),
      options: Options(headers: header),
    );
    if (response.statusCode == 200) {
      print("MessageSeenUpdated");
      socketController.notifyMessageSeen(
          convsId, convsType, currentEmployee!.employeeId!);
    } else {
      print("Something went wrong");
    }
  }
  Future<bool> getMessages(String convsId, int skip, int limit, minutes) async{

    EasyLoading.show();
    isLoadding = true;
    var url = "$chatUrl/v1/conversation/getConvsData?skip=$skip&messages=1&limit=$limit&convsId=$convsId&minutes=$minutes";
    var headers = {
      'Content-type': 'application/json; charset=utf-8',
      'Accept': 'application/json'
    };
    var response = await dio.get(url, options: Options(headers: headers));
    if(response.statusCode == 200){
      int convsIndex = conversations.indexWhere((element) => element.id == convsId);
      if(convsIndex== -1) return false;
      Conversation conversation = Conversation.fromJson(response.data[0]);
      if(skip==0) { //If only calling for first time and not calling for pagination
        conversations[convsIndex].messages!.clear();
        conversations[convsIndex].messages!.addAll(conversation.messages!.reversed.toList());
      }else{
        conversations[convsIndex].messages = [...conversation.messages!.reversed.toList(), ...conversations[convsIndex].messages!.toList()];
      }
      conversations.refresh();
      EasyLoading.dismiss();
      isLoadding = false;
      return true;
    }
    EasyLoading.dismiss();
    isLoadding = false;
    return false;

  }

  void getConversationByUserId() async {
    var header = {
      'Content-type': 'application/json; charset=utf-8',
      'Accept': 'application/json'
    };
    var response = await dio.get(
      "$chatUrl/v1/conversation/getConvsData?title=1&photo=1&skip=0&type=1&messages=1&participants=1&owner=1&limit=1&minutes=10&employeeId=${currentEmployee!.employeeId}",
      options: Options(headers: header),
    );
    if (response.statusCode == 200) {
      var result = response.data;

      conversations.clear();
      for (int i = 0; i < result.length; i++) {
        Conversation conversation = Conversation.fromJson(result[i]);
        conversations.add(conversation);
      }
      int newaysGroupIndex = conversations.indexWhere((element) => element.id==NEWAYS_GROUP_ID);
      if(newaysGroupIndex>-1){
        conversations.insert(0, conversations.firstWhere((element) => element.id==NEWAYS_GROUP_ID));
        conversations.removeAt(newaysGroupIndex+1);
      }
      bool isCurrentEmployeeAdded = conversations[newaysGroupIndex].participants!.indexWhere((element) => element.employeeId==currentEmployee!.employeeId)>-1;
      print("isCurrentEmployeeAdded: $isCurrentEmployeeAdded, currentEmployee!.assign_group: ${GetStorage().read('assign_group')!}");
      if(!isCurrentEmployeeAdded && "${GetStorage().read('assign_group')}" =="1"){
        //todo... add Current employee to neways group...
        print("Current Employee Should Add!");
        addParticipant(conversations[newaysGroupIndex].id!, currentEmployee!); //Selected Employee
      }else if(!isCurrentEmployeeAdded && "${GetStorage().read('assign_group')}" =="0"){
        conversations.removeWhere((element) => element.id==NEWAYS_GROUP_ID);
      }
      conversations.refresh();
    }
  }

  recallMessageUpdateConvs(int messageIndex, String convsId,
      String convsType, String messageId, int value, IO.Socket socket) async {
    var header = {
      'Content-type': 'application/json; charset=utf-8',
      'Accept': 'application/json'
    };
    var response = await dio.post(
      "$chatUrl/conversation/recallMessage?convsId=$convsId",
      data: jsonEncode(<String, dynamic>{
        'messageId': messageId,
        "value": value,
      }),
      options: Options(headers: header),
    );
    if (response.statusCode == 200) {
      socketController.notifyRecallMessage(
          convsId, messageId, convsType, value);
      conversations[conversations.indexWhere((element) => element.id==convsId)].messages![messageIndex].recall = value;
      conversations.refresh();
    }
  }

  lockMessageUpdateConvs(int messageIndex, String convsId,
      String convsType, String messageId, IO.Socket socket) async {
    var header = {
      'Content-type': 'application/json; charset=utf-8',
      'Accept': 'application/json'
    };
    var response = await dio.post(
      "$chatUrl/conversation/lockMessage?convsId=$convsId",
      data: jsonEncode(<String, dynamic>{
        'messageId': messageId,
      }),
      options: Options(headers: header),
    );
    if (response.statusCode == 200) {
      socketController.notifyLockMessage(convsId, messageId, convsType);
      conversations[conversations.indexWhere((element) => element.id == convsId)].lockedMsgs!.add(messageId);
      conversations.refresh();
    }
  }

  @override
  void onMessageReceived(IO.Socket socket, data) {
    // TODO: implement onMessageReceived

    var jsonMap = data as Map<String, dynamic>;
    print("Other User Has Received Message: $jsonMap");

    int convsIndex = 0;
    for (int i = 0; i < conversations.length; i++) {
      if (conversations[i].id == jsonMap['convsId']) {
        convsIndex = i;
        break;
      }
    }

    if (!conversations[convsIndex]
        .messages![conversations[convsIndex].messages!.length - 1]
        .receivedBy!
        .contains(jsonMap['newEmployeeId'])) {
      conversations[convsIndex]
          .messages![conversations[convsIndex].messages!.length - 1]
          .receivedBy!
          .add(jsonMap['newEmployeeId']);
      conversations.refresh();
    }
  }

  @override
  void onMessageSeen(IO.Socket socket, data) {
    var jsonMap = data as Map<String, dynamic>;
   print("Other User Has Seen Message: $jsonMap");

    int convsIndex = 0;
    for (int i = 0; i < conversations.length; i++) {
      if (conversations[i].id == jsonMap['convsId']) {
        convsIndex = i;
        break;
      }
    }
    if (!conversations[convsIndex]
        .messages![conversations[convsIndex].messages!.length - 1]
        .seenBy!
        .contains(jsonMap['newEmployeeId'])) {
      conversations[convsIndex]
          .messages![conversations[convsIndex].messages!.length - 1]
          .seenBy!
          .add(jsonMap['newEmployeeId']);
      conversations.refresh();
    }
  }

  @override
  void onMessageSend(IO.Socket socket, data) {
    // TODO: implement onMessageSend
    print("onMessageSend called-->data->");
    print(data);

    var jsonMap = data as Map<String, dynamic>;

    if ((conversations.isEmpty ||
        !conversations.any((item) => item.id == jsonMap['convsId']))) {
      getConversationByUserId();
      return;
    }

    EmployeeResponseModel employee = EmployeeResponseModel.fromJson(jsonMap['sender']);

    if (employee.employeeId != currentEmployee!.employeeId!) {
      var receivedByList = jsonMap['receivedBy'].toList();
      List<String> receivedBy = <String>[];
      for (var i = 0; i < receivedByList.length; i++) {
        //Convert And Reassign Existing SeenBy Data...
        receivedBy.add(receivedByList[i]);
      }

      var reactList = jsonMap['reacts'].toList();
      List<React> reacts = <React>[];
      for (var i = 0; i < reactList.length; i++) {
        //Convert And Reassign Existing SeenBy Data...
        reacts.add(reactList[i]);
      }

      var seenByList = jsonMap['seenBy'].toList();
      List<String> seenBy = <String>[];
      for (var i = 0; i < seenByList.length; i++) {
        //Convert And Reassign Existing SeenBy Data...
        seenBy.add(seenByList[i]);
      }

      int convsIndex = 0;
      for (int i = 0; i < conversations.length; i++) {
        if (conversations[i].id == jsonMap['convsId']) {
          convsIndex = i;
          break;
        }
      }

      // Message message = Message(
      //     id: jsonMap['_id'],
      //     sender: EmployeeResponseModel.fromJson(jsonMap['sender']),
      //     recipients: jsonMap['to'],
      //     text: jsonMap['text'],
      //     seenBy: seenBy,
      //     receivedBy: receivedBy,
      //     imageUrl: jsonMap['imageUrl'],
      //     reacts: reacts,
      //     replyOf: jsonMap['replyOf']!=null?ReplyOf.fromJson(jsonMap['replyOf']):null,
      //     createdAt: jsonMap['createdAt'],
      //     updatedAt: jsonMap['updatedAt']
      // );

      Message message = Message.fromJson(jsonMap);

       // print("message.toJson()");
       // print(data);
       // print(message.toJson());

      if (!(message.receivedBy!.contains(currentEmployee!.employeeId!))) {
        message.receivedBy!.add(currentEmployee!.employeeId!);
        conversations[convsIndex].messages!.add(message);
        receivedMessage(
            jsonMap['convsId'], jsonMap['convsType'], jsonMap['_id'], socket);

        // int newaysGroupIndex = conversations.indexWhere((element) => element.id=="C1688466708729");
        // conversations.insert(0, conversations.firstWhere((element) => element.id=="C1688466708729"));
        // conversations.removeAt(newaysGroupIndex+1);


        conversations.insert(1, conversations[convsIndex]);
        conversations.removeAt(convsIndex + 1);
        conversations.refresh();

      }
    }
  }

  @override
  void onNewReactAdded(IO.Socket socket, data) {
    // TODO: implement onNewReactAdded
    var jsonMap = data as Map<String, dynamic>;
    //print("A User Has Reacted into the Message: $jsonMap");

    int convsIndex = 0;
    for (int i = 0; i < conversations.length; i++) {
      if (conversations[i].id == jsonMap['convsId']) {
        convsIndex = i;
        break;
      }
    }
    React react = React(
        title: jsonMap['reactTitle'],
        sender: EmployeeResponseModel.fromJson(jsonMap['sender']));
    int messageIndex = 0;
    for (int i = 0; i < conversations[convsIndex].messages!.length; i++) {
      if (conversations[convsIndex].messages![i].id == jsonMap['messageId']) {
        messageIndex = i;
        break;
      }
    }

    if (!conversations[convsIndex]
        .messages![messageIndex]
        .reacts!
        .contains(react)) {
      conversations[convsIndex].messages![messageIndex].reacts!.add(react);
      print(
          "now react data: ${conversations[convsIndex].messages![messageIndex].reacts!.length}");

      conversations.refresh();
    }
  }

  @override
  void onReactRemoved(IO.Socket socket, data) {
    // TODO: implement onNewReactAdded
    var jsonMap = data as Map<String, dynamic>;
   // print("A User Has Remove React into the Message: $jsonMap");

    int convsIndex = 0;
    for (int i = 0; i < conversations.length; i++) {
      if (conversations[i].id == jsonMap['convsId']) {
        convsIndex = i;
        break;
      }
    }

    React react = React(
        title: jsonMap['reactTitle'],
        sender: EmployeeResponseModel.fromJson(jsonMap['sender']));
    int messageIndex = 0;
    for (int i = 0; i < conversations[convsIndex].messages!.length; i++) {
      if (conversations[convsIndex].messages![i].id == jsonMap['messageId']) {
        messageIndex = i;
        break;
      }
    }
    conversations[convsIndex]
        .messages![messageIndex]
        .reacts!
        //.removeWhere((element) => element.title == react.title);
        .removeWhere((element) => ((element.title == react.title) && (element.sender!.employeeId! == react.sender!.employeeId!)));
   // print("now react data: ${conversations[convsIndex].messages![messageIndex].reacts!.length}");
    conversations.refresh();
  }

  @override
  void onLockMessage(IO.Socket socket, data) {
    // TODO: implement onLockMessage
    //print("onLockMessage");
    print(data);
  }

  @override
  void onRecallMessage(IO.Socket socket, data) {
    // TODO: implement onRecallMessage
   // print("onRecallMessage");
    print(data);

    var jsonMap = data as Map<String, dynamic>;

    String convsId = jsonMap['convsId'];
    String messageId = jsonMap['messageId'];
    dynamic value = jsonMap['value'];

    //  conversations.firstWhere((element) => element.id==convsId).messages!.firstWhere((element) => element.id==messageId).recall = value;

    int convsIndex = 0;
    for (int i = 0; i < conversations.length; i++) {
      if (conversations[i].id == convsId) {
        convsIndex = i;
        break;
      }
    }

    int messageIndex = 0;
    for (int i = 0; i < conversations[convsIndex].messages!.length; i++) {
      if (conversations[convsIndex].messages![i].id == messageId) {
        messageIndex = i;
        break;
      }
    }
    conversations[convsIndex].messages![messageIndex].recall = value;
  //  print("convsRecalvalue");
  //  print(value);
   // print(conversations[convsIndex].messages![messageIndex].recall);
    conversations.refresh();
  }

  updateConversation(String convsId, String? title, String? photo) async{

    await ConversationService.updateConversation(convsId, title, photo, (data)
      {
        int convsIndex = conversations.indexWhere((element) => element.id==convsId);
        if(title!=null){
        conversations[convsIndex].title = title;
        }else if(photo!=null){
        conversations[convsIndex].photo = photo;
        }
        conversations.refresh();
      }
    );
  }


  openGalleryUploadImageAsBase64(Function(String url, String filename) onSuccess) async {
    var file = await ImagePicker().pickImage(source: ImageSource.gallery); //pick an image
    //convert file...
    List<int> imageBytes = await file!.readAsBytes();
    String base64Image = base64Encode(imageBytes);
    //String base64Image = base64Encode(file.readAsBytesSync());
    String filename = file.path.split('/').last;
    ConversationService.uploadImageAsBase64(base64Image, filename, (data) => onSuccess(data['url'], filename));
  }

  uploadImageAsMultipartLaravel(Function(String imageUrl, String filename) onSuccess) async {
    chooseImageFileFromGallery((File galleryFile) async {
      ConversationService.uploadImageAsMultipartLaravel(galleryFile, (imageUrl) => {
        onSuccess("http://erp.superhomebd.com/super_home/$imageUrl", imageUrl.substring(imageUrl.indexOf("assets")))
      });
    });
  }
}
