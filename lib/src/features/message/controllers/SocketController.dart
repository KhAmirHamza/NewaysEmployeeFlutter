import 'dart:convert';
import 'package:dio/dio.dart';
//import 'package:mentionable_text_field/mentionable_text_field.dart';
import 'package:neways3/src/features/contacts/models/employee_response_model.dart';
import 'package:neways3/src/utils/constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';
import '../ChatScreen.dart';
import '../functions.dart';
import '../models/Conversation.dart';
import '../models/Message.dart';
import '../models/MessageTextItem.dart';
import '../models/OnlineEmployee.dart';
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
    //print("notify other client that MessageReceived called");

    var json = {
      "convsId": convsId,
      "convsType": convsType,
      "newEmployeeId": currentUserId
    };
    socket!.emit('notifyMessageReceived', json);
  }

  notifyMessageSeen(String convsId, String convsType, String currentUserId) {
    //Notify Sender, Receiver has seen the Message... Step: 5 //Receiver Page
    //print("notify other client that MessageSeen called");

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
    //print("notify other client that NewReactAdded called: json: " +json.toString());
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
    //print("notify other client that NewReactAdded called: json: $json");
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
    //print("notify other client that notifyRecallMessage called: json: $json");
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
    //print("notify other client that notifyLockMessage called: json: $json");
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
    //print("photo url: " + photo);


    var data = jsonEncode(<String, dynamic>{
      "title": convsTitle,
      "photo": photo,
      "type": convsType,
      "participants": convsType == "Single" ? employees : groupEmployees,
      "message": message,
      "owner": owner,
      "admins": admins,
      "lockedMsgs": [],
    });


    var response = await dio.post(
      //'https://nodejsrealtimechat.onrender.com/conversation/firstMessage',
      "$chatUrl/conversation/firstMessage",
      // 'http://172.28.240.1:3000/conversation/add',
      data: data,
      options: Options(headers: header),
    );
    Conversation conversation = Conversation.fromJson(response.data);
    Message messageData =
        conversation.messages![conversation.messages!.length - 1];

    if (response.statusCode == 200) {
      //print("First Message Successfully Sent!");

      var result = response.data;
      Conversation conversation = Conversation.fromJson(result);
      var messageJson = {
        "_id": messageData.id,
        "sender": messageData.sender,
        "recipients": messageData.recipients,
        "convsId": conversation.id,
        "convsType": convsType,
        "texts": messageData.texts,
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
       // print("Conversations: ${result.length}");
        convsController.conversations.refresh();

        socket!.emit('sendMessage', messageJson);
       // print("Message Send Successfully2!");
      } else {
        convsController.conversations.add(conversation);
       // print("Conversations: ${result.length}");
        convsController.conversations.refresh();

        socket!.emit('sendMessage', messageJson);
       // print("Message Send Successfully3!");
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
      //print("Connected: " + socket!.id.toString());
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
  //print("message:01");
  //print(message.texts![0].toJson().toString());

  var header = {
    'Content-type': 'application/json; charset=utf-8',
    'Accept': 'application/json'
  };
  message.sender!.photo = message.sender!.photo!.substring(message.sender!.photo!.indexOf("assets"));

  var response = await dio.post(
    // "http://172.28.240.1:3000/conversation/sendMessage?convsId=" + convsId,
    //"https://nodejsrealtimechat.onrender.com/conversation/sendMessage?convsId=" + convsId,
    "$chatUrl/conversation/sendMessage?convsId=$convsId",
    data: jsonEncode(<String, dynamic>{
      '_id': message.id,
      "sender": message.sender,
      "recipients": message.recipients,
      'texts': message.texts,
      'seenBy': message.seenBy,
      'receivedBy': message.receivedBy,
      'attachments': message.attachments,
      'reacts': message.reacts,
      'replyOf': message.replyOf,
      'recall': message.recall,
    }),
    options: Options(headers: header),
  );

  if(response.statusCode!=200){
    print("Message uploaded: error: ${response}");
    return;
  }

  Message messageData = Message.fromJson(response.data);

  if (response.statusCode == 200) {
    var json = {
      "_id": messageData.id,
      "sender": messageData.sender,
      "recipients": messageData.recipients,
      "convsId": convsId,
      "convsType": convsType,
      "texts": messageData.texts,
      "seenBy": messageData.seenBy,
      "receivedBy": messageData.receivedBy,
      'attachments': messageData.attachments,
      'reacts': messageData.reacts,
      'replyOf': messageData.replyOf,
      'recall': messageData.recall,
      'createdAt': messageData.createdAt,
      'updatedAt': messageData.updatedAt,
    };

    //print("messageData.id");
   // print(json);

    convsController.conversations.firstWhere((element) => element.id==convsId).messages!.add(messageData);
    convsController.conversations.refresh();

    socket.emit('sendMessage', json);
   // print("Message Send Successfully1!: ${convsController.conversations.firstWhere((element) => element.id==convsId).type!}");





    sendNotificationToOfflineParticipants(convsController.conversations.firstWhere((element) => element.id==convsId).participants!, message.texts!, onlineEmployees, message.sender!.fullName!);

    return;

    var otherUserActiveStatus = "Offline";
    print("Online Employee: ${onlineEmployees.length}");
    if (convsController.conversations.firstWhere((element) => element.id==convsId).type == "Single" &&
        onlineEmployees.isNotEmpty) {
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
            "message": message.texts
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


sendNotificationToOfflineParticipants(List<EmployeeResponseModel> participants, List<MessageTextItem> texts, List<OnlineEmployee> onlineEmployees, String senderName){

  List<String> onlineEmployeeIds = [];
  for(int i=0; i<onlineEmployees.length; i++){
    if(onlineEmployees[i].status!.toLowerCase() == "online") {
      onlineEmployeeIds.add(onlineEmployees[i].employeeId!);
    }
  }
  List<String> offlineParticipantsIds = [];
  for(int i=0; i<participants.length; i++){
    if(!onlineEmployeeIds.contains(participants[i].employeeId)) {
      offlineParticipantsIds.add(participants[i].employeeId!);
     // print("Offline: Participant: ${participants[i].employeeId}");
    }
  }

  String message = "";
  for(int i=0; i<texts.length; i++){
    message+=texts[i].value!;
  }

  String notificationTitle = "";
  List<String> constMentionTitles = generateMentionsIncludingConst()[0];
  for(int t=0; t<texts.length; t++){
    if(texts[t].type=="mention" && !constMentionTitles.contains(texts[t].value)){
    //  print("notificationTitle: ${texts[t].toJson().toString()}");
      int mentionedParticipantIndex = participants.indexWhere((element) => element.fullName==texts[t].value!.substring(1));
      if(mentionedParticipantIndex>-1){
        String mentionedParticipantId = participants[mentionedParticipantIndex].employeeId!;
        offlineParticipantsIds.remove(mentionedParticipantId);
        sendNotification([mentionedParticipantId],
            "$senderName has mentioned you", message);
      }
    }else if(texts[t].type=="mention" && texts[t].value=="@Everyone"){
      notificationTitle = "$senderName has mentioned you";
    }else if(texts[t].type=="mention" && texts[t].value=="@Announcement"){
      notificationTitle = "$senderName Announced!";
    }
  }

  if(notificationTitle.isNotEmpty){
    List<String> allParticipants = [];
    for(int i=0; i<participants.length; i++){
      allParticipants.add(participants[i].employeeId!);
    }
    sendNotification(allParticipants, notificationTitle, message);
  }else{
    sendNotification(offlineParticipantsIds, "$senderName has sent a message", message);
  }

}