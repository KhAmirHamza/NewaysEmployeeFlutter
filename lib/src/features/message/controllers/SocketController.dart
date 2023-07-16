import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:neways3/src/features/contacts/models/employee_response_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';
import '../ChatScreen.dart';
import '../models/Conversation.dart';
import '../models/Message.dart';
import '../utils/Constant.dart';
import 'ConvsCntlr.dart';

IO.Socket? socket;

final dio = Dio();

class SocketController {
  SocketController() {
    connectToSocket();
  }

  IO.Socket getInstance() {
    return connectToSocket()!;
  }

  notifyMessageSend(String convsId, String convsType, Message message, ConversationController convsController) {
    sendMessage(convsId, convsType, message, socket!,
        convsController);
  }

  notifyMessageReceived(
      String convsId, String convsType, String currentUserId) {
    //Notify Sender, Receiver has received the Message... Step: 3 //Receiver Page
    print("notify other client that MessageReceived called");

    var json = {
      "convsId": convsId,
      "convsType": convsType,
      "newEmployeeId": currentUserId
    };
    socket!.emit('notifyMessageReceived', json);
  }

  notifyMessageSeen(String convsId, String convsType, String currentUserId) {
    //Notify Sender, Receiver has seen the Message... Step: 5 //Receiver Page
    print("notify other client that MessageSeen called");

    var json = {
      "convsId": convsId,
      "convsType": convsType,
      "newEmployeeId": currentUserId
    };
    socket!.emit('notifyMessageSeen', json);
  }

  notifyNewReactAdded(String convsId, String messageId, String convsType,
      String reactTitle, EmployeeResponseModel currentemployee) {
    //Notify Sender, Receiver has seen the Message... Step: 5 //Receiver Page
    var json = {
      "convsId": convsId,
      "messageId": messageId,
      "convsType": convsType,
      "reactTitle": reactTitle,
      "sender": currentemployee
    };
    print("notify other client that NewReactAdded called: json: " +
        json.toString());
    socket!.emit('notifyNewReactAdded', json);
  }

  notifyReactRemoved(String convsId, String messageId, String convsType,
      String reactTitle, EmployeeResponseModel currentEmployee) {
    //Notify Sender, Receiver has seen the Message... Step: 5 //Receiver Page
    var json = {
      "convsId": convsId,
      "messageId": messageId,
      "convsType": convsType,
      "reactTitle": reactTitle,
      "sender": currentEmployee
    };
    print("notify other client that NewReactAdded called: json: $json");
    socket!.emit('notifyReactRemoved', json);
  }

  notifyRecallMessage(
      String convsId, String messageId, String convsType, int value) {
    //Notify other, Sender has recall the Message... Step: ... //Receiver Page
    var json = {
      "convsId": convsId,
      "messageId": messageId,
      "convsType": convsType,
      "value": value
    };
    print("notify other client that notifyRecallMessage called: json: $json");
    socket!.emit('notifyRecallMessage', json);
  }

  notifyLockMessage(
    String convsId,
    String messageId,
    String convsType,
  ) {
    //Notify other, A member has lock the Message... Step: ... //Receiver Page
    var json = {
      "convsId": convsId,
      "messageId": messageId,
      "convsType": convsType,
    };
    print("notify other client that notifyLockMessage called: json: $json");
    socket!.emit('notifyLockMessage', json);
  }

  Future<void> sendFirstMessage(
      EmployeeResponseModel currentEmployee,
      EmployeeResponseModel? selectedEmployee,
      String convsType,
      Message message,
      String convsTitle,
      String photo,
      List<EmployeeResponseModel>? groupEmployees,
      EmployeeResponseModel owner,
      List<EmployeeResponseModel> admins,
      ConversationController convsController) async {
    var header = {
      'Content-type': 'application/json; charset=utf-8',
      'Accept': 'application/json'
    };

    List<EmployeeResponseModel> employees = <EmployeeResponseModel>[];
    employees.add(currentEmployee);

    selectedEmployee != null ? employees.add(selectedEmployee) : {};
    print("photo url: " + photo);

    var response = await dio.post(
      //'https://nodejsrealtimechat.onrender.com/conversation/firstMessage',
      chatUrl + "/conversation/firstMessage",
      // 'http://172.28.240.1:3000/conversation/add',
      data: jsonEncode(<String, dynamic>{
        "title": convsTitle,
        "photo": photo,
        "type": convsType,
        "participants": convsType == "Single" ? employees : groupEmployees,
        "message": message,
        "owner": owner,
        "admins": admins,
        "lockedMsgs": [],
      }),
      options: Options(headers: header),
    );
    Conversation conversation = Conversation.fromJson(response.data);
    Message messageData =
        conversation.messages![conversation.messages!.length - 1];

    if (response.statusCode == 200) {
      print("First Message Successfully Sent!");

      var result = response.data;
      Conversation conversation = Conversation.fromJson(result);
      var messageJson = {
        "_id": messageData.id,
        "sender": messageData.sender,
        "recipients": messageData.recipients,
        "convsId": conversation.id,
        "convsType": convsType,
        "text": messageData.text,
        "seenBy": messageData.seenBy,
        "receivedBy": messageData.receivedBy,
        'attachments': messageData.attachments,
        'reacts': messageData.reacts,
        'replyOf': messageData.replyOf,
        'recall': message.recall,
        'createdAt': messageData.createdAt,
        'updatedAt': messageData.updatedAt,
      };
      if (convsController.conversations
          .any((element) => element.id == conversation.id)) {
        convsController.conversations
            .firstWhere((element) => element.id == conversation.id)
            .messages!
            .add(messageData);
        print("Conversations: ${result.length}");
        convsController.conversations.refresh();

        socket!.emit('sendMessage', messageJson);
        print("Message Send Successfully2!");
      } else {
        convsController.conversations.add(conversation);
        print("Conversations: ${result.length}");
        convsController.conversations.refresh();

        socket!.emit('sendMessage', messageJson);
        print("Message Send Successfully3!");
      }
    }
  }
}

abstract class SocketListeners {
  void onMessageSend(IO.Socket socket,
      dynamic data); //Sender Send Message...  Step:2 //Receiver Page

  void onMessageReceived(
      IO.Socket socket,
      dynamic
          data); //Receiver has received the Message...  Step:4 //Sender Page

  void onMessageSeen(IO.Socket socket,
      dynamic data); //Receiver has seen the Message...  Step:6 //Sender Page

  void onNewReactAdded(
      IO.Socket socket,
      dynamic
          data); //A User has reacted into the Message...  Step:6 //A User Page

  void onReactRemoved(
      IO.Socket socket,
      dynamic
          data); //A User has reacted into the Message...  Step:6.1 //A User Page

  void onRecallMessage(
      IO.Socket socket,
      dynamic
          data); //Sender has recall a Message...  Step:... //Rest of Recipient Page

  void onLockMessage(
      IO.Socket socket,
      dynamic
          data); //An Employee has lock Message...  Step:... //Rest of Recipient Page
}

connectToSocket() {
  if (socket != null) {
    return socket;
  } else {
    socket = io(
        //'https://nodejsrealtimechat.onrender.com/',
        chatUrl,
        OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .disableAutoConnect() // disable auto-connection
            //.setExtraHeaders({'foo': 'bar'}) // optional
            .build());
    socket!.connect();
    socket!.on("connect", (data) {
      print("Connected: " + socket!.id.toString());
    });
    return socket!;
  }
}

sendMessage(
    String convsId,
    String convsType,
    Message message,
    IO.Socket socket,
    ConversationController convsController) async {
  print("message.replyOf");
  //print(message.replyOf!.toJson().toString());

  var header = {
    'Content-type': 'application/json; charset=utf-8',
    'Accept': 'application/json'
  };

  var response = await dio.post(
    // "http://172.28.240.1:3000/conversation/sendMessage?convsId=" + convsId,
    //"https://nodejsrealtimechat.onrender.com/conversation/sendMessage?convsId=" + convsId,
    "$chatUrl/conversation/sendMessage?convsId=$convsId",
    data: jsonEncode(<String, dynamic>{
      '_id': message.id,
      "sender": message.sender,
      "recipients": message.recipients,
      'text': message.text,
      'seenBy': message.seenBy,
      'receivedBy': message.receivedBy,
      'attachments': message.attachments,
      'reacts': message.reacts,
      'replyOf': message.replyOf,
      'recall': message.recall,
    }),
    options: Options(headers: header),
  );

  Message messageData = Message.fromJson(response.data);

  if (response.statusCode == 200) {
    var json = {
      "_id": messageData.id,
      "sender": messageData.sender,
      "recipients": messageData.recipients,
      "convsId": convsId,
      "convsType": convsType,
      "text": messageData.text,
      "seenBy": messageData.seenBy,
      "receivedBy": messageData.receivedBy,
      'attachments': messageData.attachments,
      'reacts': messageData.reacts,
      'replyOf': messageData.replyOf,
      'recall': messageData.recall,
      'createdAt': messageData.createdAt,
      'updatedAt': messageData.updatedAt,
    };

    print("messageData.id");
    print(json);

    convsController.conversations.firstWhere((element) => element.id==convsId).messages!.add(messageData);
    convsController.conversations.refresh();

    socket.emit('sendMessage', json);
    print("Message Send Successfully1!: ${convsController.conversations.firstWhere((element) => element.id==convsId).type!}");

    var otherUserActiveStatus = "Offline";

    print("Online Employee: ${onlineEmployees.length}");

    if (convsController.conversations.firstWhere((element) => element.id==convsId).type == "Single" &&
        onlineEmployees.length > 0) {
      if (convsController.conversations.firstWhere((element) => element.id==convsId).participants![0].employeeId ==
          message.sender!.employeeId) {
        var otherEmployee = convsController.conversations.firstWhere((element) => element.id==convsId).participants![1];
        otherUserActiveStatus = onlineEmployees.any(
                (element) => element.employeeId == otherEmployee.employeeId)
            ? "Online"
            : "Offline";
      } else {
        var otherEmployee = convsController.conversations.firstWhere((element) => element.id == convsId).participants![0];
        otherUserActiveStatus = onlineEmployees.any(
                (element) => element.employeeId == otherEmployee.employeeId)
            ? "Online"
            : "Offline";
      }

      if (otherUserActiveStatus == "Offline") {
        print("otherUserActiveStatus: $otherUserActiveStatus");
        var response = await dio.post(
          "http://erp.superhomebd.com/neways_employee_mobile_application/v1/api/push-notification",
          data: jsonEncode(<String, dynamic>{
            "employee_id": message.recipients![0].employeeId,
            "title": "${message.sender!.fullName!} has sent a message",
            "message": message.text
          }),
          options: Options(headers: header),
        );
      } else {
        print("otherUserActiveStatus: " + otherUserActiveStatus);
      }
    }
    else {
      print("Online employees: ${onlineEmployees.length}");
    }
  } else {
    print(response.data);
  }
}
