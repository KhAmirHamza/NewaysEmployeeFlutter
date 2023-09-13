import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
//import 'package:mentionable_text_field/mentionable_text_field.dart';
import 'package:neways3/src/features/message/models/Message.dart';
import 'package:neways3/src/utils/constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../contacts/models/employee_response_model.dart';
import 'models/MessageTextItem.dart';

getParticipantsNameFromList(List<EmployeeResponseModel> participants){
  List<String> names = ["@Announcement", "@Complaint"];
  for(int i= 0; i< participants.length; i++){
    names.add("@${participants[i].fullName!}");
  }
  //print("Mentionable length: ${names}");
  return names;
}
matchText(List<String> mentionableStrings, String text, bool continuity){
  bool result = false;
  if(mentionableStrings.contains(text)) {
    result = true;
  }else if(continuity == true){
    for(int i=0; i<mentionableStrings.length; i++){
      if( mentionableStrings[i].contains(text)) {
        result = true;
        break;
      }
    }
  }
  return result;
}

bool showSeenBadge(List<EmployeeResponseModel> participants,EmployeeResponseModel currentEmployee, Message message, String mentionedEmployeeName){

  print("message: ${message.toJson().toString()}");

  print("Mentioned employee: //${currentEmployee.toJson().toString()}//");

  print("Mentioned employee name s2: //$mentionedEmployeeName//");

  if(mentionedEmployeeName.length>1){
    //print("Mentioned employee id s2");
    int participantIndex= participants.indexWhere((element) => element.fullName==mentionedEmployeeName);
    //print("Mentioned employee id s2: $participantIndex");

    if(currentEmployee.fullName!.trim() == mentionedEmployeeName){
     //print("showSeenBadge: ${message.seenBy!.contains(participants[participantIndex].employeeId)}");
      return true;
    }else if(participantIndex > -1){
      return message.seenBy!.contains(participants[participantIndex].employeeId);
    }else{
      return false;
    }
  }else{
    return false;
  }
  //String employeeId = participants.firstWhere((element) => element.fullName==employeeName).employeeId!;
  //return employeeId== ? false : message.seenBy!.contains(employeeId);
//  return true;

}

// getMessageWidget(Message message, List<EmployeeResponseModel> participants){
//   List<String> mentionableStrings = generateMentionsIncludingConst(participants: participants)[0];
//   int startMention = 0;
//   bool containingMention = false;
//   int containMentionEndIndex = 0;
//   List<TextSpan> messageTextSpans = [];
//   for(int i=0; i<message.text!.length; i++){
//     if(message.text![i]=="@"){
//      // print("startMention:$startMention, containMentionEndIndex: $containMentionEndIndex, '${message.text![i]}' found at: $i, containMention: $containingMention");
//       //if(i>containMentionEndIndex && message.text!.substring(containMentionEndIndex, i).trim().isNotEmpty){
//         if(containMentionEndIndex ==0 && i>0){
//           //print("Step 1.1, Add: ${message.text!.substring(containMentionEndIndex, i)}");
//           messageTextSpans.add(TextSpan(text: message.text!.substring(containMentionEndIndex, i), style: const TextStyle( fontWeight: FontWeight.normal, color: Colors.black),));
//         }else if(containingMention && matchText(mentionableStrings, message.text!.substring(startMention, i).trim(), false)){
//           //print("Step 1.2, Add: ${message.text!.substring(containMentionEndIndex, i)}");
//         }else if(i>0 && !containingMention && !matchText(mentionableStrings, message.text!.substring(containMentionEndIndex, i-1).trim(), false)){
//           messageTextSpans.add(TextSpan(text: message.text!.substring(containMentionEndIndex, i-1).trim(), style: const TextStyle( fontWeight: FontWeight.normal, color: Colors.black),));
//
//         }
//
//
//      // }
//
//       startMention = i;
//       containingMention = true;
//       containMentionEndIndex = i;
//       //print("@ found at index: $i");
//
//     }
//     else if(containingMention && (message.text![i]==" " || (i == (message.text!.length-1)))){
//       //print("startMention:$startMention, containMentionEndIndex: $containMentionEndIndex, '${message.text![i]}' found at: $i, continuity: ${matchText(mentionableStrings, message.text!.substring(startMention, i), true)}");
//       //print("<Space> found at index: $i, Checking Text: ${message.text!.substring(startMention, i)}");
//
//       if(containingMention && matchText(mentionableStrings, message.text!.substring(startMention, i+1), true)){ //i+1 means including current space
//         //print("Contain Mention Text: ${message.text!.substring(startMention, i)}");
//         containingMention = true;
//         containMentionEndIndex = i;
//         if(i== (message.text!.length-1)){
//           //print("Step 2, Add: ${message.text!.substring(startMention, containMentionEndIndex)}");
//           messageTextSpans.add(
//               TextSpan(
//                   children: [
//                     TextSpan(text: " ${message.text!.substring(startMention, containMentionEndIndex)}", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.blue.shade800),),
//                     if(
//                     showSeenBadge(participants, message, message.text!.substring(startMention, containMentionEndIndex))
//                     ) WidgetSpan(child: Transform.translate(offset:  const Offset(0, -5), child: Icon(Icons.check_circle_rounded, color: Colors.green.shade600, size: 11),))
//                   ]
//               )
//           );
//         }
//       }
//       else if(containingMention && matchText(mentionableStrings, message.text!.substring(startMention, i), false)){
//        // print("Not Contain Mention, Previous Mention Text: ${message.text!.substring(startMention, containMentionEndIndex)}");
//         containingMention = false;
//         containMentionEndIndex = i-1;
//         List<List<String>> mentionConst =  generateMentionsIncludingConst();
//         //print("Step 3, Add: ${message.text!.substring(startMention, i)}");
//         messageTextSpans.add(
//             TextSpan(
//               children: [
//                 TextSpan(text: " ${message.text!.substring(startMention, i)}", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.blue.shade800, ),),
//                 if(!mentionConst[0].contains(message.text!.substring(startMention, i)))
//                   WidgetSpan(child: Transform.translate(offset:  const Offset(0, -5), child: Icon(
//                     showSeenBadge(participants, message, message.text!.substring(startMention, i))?
//                     Icons.check_circle_rounded:Icons.radio_button_unchecked_outlined
//                     , color:
//                   showSeenBadge(participants, message, message.text!.substring(startMention, i))?
//                   Colors.green.shade600:
//                       Colors.red.shade600
//                       , size: 11),))
//               ]
//             )
//         );
//         // if(i == (message.text!.length-1)){
//         //   print("Step 4, Add: ${message.text!.substring(containMentionEndIndex, i+1)}");
//         //   messageTextSpans.add(TextSpan(text: " ${message.text!.substring(containMentionEndIndex, i+1).trim()}", style: const TextStyle( fontWeight: FontWeight.normal, color: Colors.black),));
//         // }
//       }
//      // else if(!containingMention && !matchText(mentionableStrings, text.substring(startMention, i), false)){
//
//     }
//     else{
//       //print("else startMention:$startMention, containMentionEndIndex: $containMentionEndIndex, '${message.text![i]}' found at: $i, continuity: ${matchText(mentionableStrings, message.text!.substring(startMention, i), true)}");
//
//       // print("else: index: $i");
//       if(i == (message.text!.length-1)){
//         print("Step 5, Add: ${message.text!.substring((containMentionEndIndex), i+1).trim()}"); //start index is after last containMentionEndIndex ,So=> (containMentionEndIndex+1)
//         //  print("else last: index: $i , char: ${message.text![i]}, last Normal Text: ${message.text!.substring(containMentionEndIndex, i+1).trim()}");
//         messageTextSpans.add(TextSpan(text: " ${message.text!.substring((containMentionEndIndex+1), i+1).trim()}", style: const TextStyle( fontWeight: FontWeight.normal, color: Colors.black),));
//       }
//       // print("Not Contain Mention, Not Contain Previous Mention Text: ${text.substring(containMentionEndIndex, i)}");
//       // containingMention = false;
//       // messageTextSpans.add(TextSpan(text: text.substring(containMentionEndIndex, i), style: const TextStyle( fontWeight: FontWeight.normal, color: Colors.black),));
//     }
//   }
//   return RichText(text: TextSpan(
//     children: messageTextSpans
//   ));
// }


getMessageWidget(Message message, List<EmployeeResponseModel> participants, EmployeeResponseModel currentEmployee){
  List<TextSpan> messageTextSpans = [];
  List<String> constMentionableStrings = generateMentionsIncludingConst()[0];


  if(message.texts!=null){
    for(int i=0; i<message.texts!.length; i++){
      if(message.texts![i].type=="mention"){

        //print("Message Text Type: ${message.texts![i].type}");
        String messageValue = message.texts![i].value!.trim();
        messageTextSpans.add(
            TextSpan(
                children: [
                  TextSpan(text: messageValue.trim(), style: TextStyle( fontWeight: FontWeight.bold, color: Colors.blue.shade800, ),),
                  if(!constMentionableStrings.contains(messageValue))
                    WidgetSpan(child: Transform.translate(offset:  const Offset(0, -5), child: Icon(
                        showSeenBadge(participants, currentEmployee, message, messageValue.substring(1)) ||
                            messageValue == currentEmployee.employeeId?
                        Icons.check_circle_rounded : Icons.radio_button_unchecked_outlined
                        , color:
                    showSeenBadge(participants,currentEmployee, message, messageValue.substring(1)) || messageValue== currentEmployee.employeeId?
                    Colors.green.shade600:
                    Colors.red.shade600
                        , size: 11),))
                ]
            )
        );
      }else{
        //print("Message Text Type: ${message.texts![i].type}");
        messageTextSpans.add(TextSpan(text: message.texts![i].value, style: const TextStyle( fontWeight: FontWeight.normal, color: Colors.black),));
      }
    }
  }

    return RichText(text: TextSpan(
    children: messageTextSpans
  ));
}



buildStringFromTextItems(List<MessageTextItem> texts){
  var concatenate = StringBuffer();
  texts.forEach((element) {concatenate.write(element.value);});
  return concatenate.toString();
}


sendNotification(List<String> employeeIds, String title, String message ) async {
  final dio = Dio();
  var header = {
    'Content-type': 'application/json; charset=utf-8',
    'Accept': 'application/json'
  };
  for(int i =0; i<employeeIds.length; i++){
    var response = await dio.post(
      "http://erp.superhomebd.com/neways_employee_mobile_application/v1/api/push-notification",
      data: jsonEncode(<String, dynamic>{
        "employee_id": employeeIds[i],
        "title": title,
        "message": message
      }),
      options: Options(headers: header),
    );
  }


}


