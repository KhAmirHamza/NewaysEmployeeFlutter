import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neways3/src/features/contacts/controllers/ContactController.dart';
import 'package:neways3/src/features/contacts/models/employee_response_model.dart';
import 'package:neways3/src/features/message/bloc/p_to_p_chat_page.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../models/Conversation.dart';
import '../models/Message.dart';
import '../utils/Constant.dart';
import 'SocketController.dart';

class ConversationController extends GetxController implements SocketListeners {
  EmployeeResponseModel? currentEmployee;

  var conversations = <Conversation>[].obs;
  final dio = Dio();
  SocketController socketController = SocketController();

  setCurrentEmployee(EmployeeResponseModel currentEmployee) {
    this.currentEmployee = currentEmployee;
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

      print("Owner: ${owner.employeeId!}");
      print("Current Employee: ${currentEmployee!.employeeId!}");
      //print("Selected Employee: ${selectedEmployee!.employeeId!}"); //selectedEmployee can be null
      print("Message Recipients: ${jsonEncode(message.recipients)}");

      socketController.sendFirstMessage(currentEmployee!, selectedEmployee,
          convsType, message, title, photo, groupEmployees, owner, admins, this);

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
   // print(conversations[conversations.indexWhere((element) => element.id==convsId)].messages![messageIndex].reacts!.length);

    //print("Current Employee ID: " +currentEmployee!.employeeId!);
    //print("Current Employee ID: " +currentEmployee!.employeeId!);

    conversations[conversations.indexWhere((element) => element.id==convsId)]
        .messages![messageIndex]
        .reacts!
        .removeWhere((element) => ((element.title == react.title) && (element.sender!.employeeId! == react.sender!.employeeId!)));
    //print(conversations[conversations.indexWhere((element) => element.id==convsId)].messages![messageIndex].reacts!.length);
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
      socketController.notifyMessageReceived(
          convsId, convsType, currentEmployee!.employeeId!);

      print("seenMessage requested to called");
      pToP_ChatPage.seenMessage(this, convsId, convsType, messageId, socket,
          currentEmployee!.employeeId!);
    }
  }

  seenMessage(String convsId, String convsType, String messageId,
      IO.Socket socket) async {
    print("seenMessage called");
    print(messageId);
    print(convsId);
    print(currentEmployee!.employeeId);
    var header = {
      'Content-type': 'application/json; charset=utf-8',
      'Accept': 'application/json'
    };

    var response = await dio.post(
      "$chatUrl/conversation/seenMessage?convsId=$convsId",
      // "http://172.28.240.1:3000/conversation/seenMessage?convsId=" + convsId,
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

  void getConversationByUserId() async {
    print("currentEmployeeId: " + currentEmployee!.employeeId!);

    var header = {
      'Content-type': 'application/json; charset=utf-8',
      'Accept': 'application/json'
    };
    var response = await dio.get(
      //"$chatUrl/conversation/get?employeeId=${currentEmployee!.employeeId}assign_group=${currentEmployee!.assign_gr
      // .oup}",
      chatUrl + "/conversation/get?employeeId=${currentEmployee!.employeeId}",
      options: Options(headers: header),
    );
    if (response.statusCode == 200) {
      var result = response.data;

      conversations.clear();
      for (int i = 0; i < result.length; i++) {
        Conversation conversation = Conversation.fromJson(result[i]);
        List<Message> messages = <Message>[];
        conversations.add(conversation);
      }
      print("Conversations: " + result.length.toString());
      int newaysGroupIndex = conversations.indexWhere((element) => element.id=="C1688466708729");
      conversations.insert(0, conversations.firstWhere((element) => element.id=="C1688466708729"));
      conversations.removeAt(newaysGroupIndex+1);
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
    print("Other User Has Received Message: " + jsonMap.toString());

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
    print("Other User Has Seen Message: " + jsonMap.toString());

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

    print("onMessageSend called");


    var jsonMap = data as Map<String, dynamic>;

    if ((conversations.length == 0 ||
        !conversations.any((item) => item.id == jsonMap['convsId']))) {
      getConversationByUserId();
      return;
    }

    EmployeeResponseModel employee =
        EmployeeResponseModel.fromJson(jsonMap['sender']);

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
    print("A User Has Reacted into the Message: $jsonMap");

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
    print("A User Has Remove React into the Message: $jsonMap");

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
    print(
        "now react data: ${conversations[convsIndex].messages![messageIndex].reacts!.length}");
    conversations.refresh();
  }

  @override
  void onLockMessage(IO.Socket socket, data) {
    // TODO: implement onLockMessage
    print("onLockMessage");
    print(data);
  }

  @override
  void onRecallMessage(IO.Socket socket, data) {
    // TODO: implement onRecallMessage
    print("onRecallMessage");
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
    print("convsRecalvalue");
    print(value);
    print(conversations[convsIndex].messages![messageIndex].recall);
    conversations.refresh();
  }
}
