import 'package:neways3/src/features/contacts/models/employee_response_model.dart';
import 'package:html_unescape/html_unescape.dart';

import 'MessageTextItem.dart';
var unescape = HtmlUnescape();
class Message {
  String? id;
  EmployeeResponseModel? sender;
  List<EmployeeResponseModel>? recipients;
 // String? text;
  List<MessageTextItem>? texts;
  List<String>? seenBy;
  List<String>? receivedBy;
  List<Attachment>? attachments;
  List<React>? reacts;
  ReplyOf? replyOf;
  dynamic recall;
  String? createdAt;
  String? updatedAt;

  Message({this.id, this.sender, this.recipients, this.texts, this.seenBy, this.receivedBy,this.attachments, this.reacts, this.replyOf, this.recall, this.createdAt, this.updatedAt});

  Message.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    sender = json['sender'] != null ? EmployeeResponseModel.fromJson(json['sender']) : null;

    if (json['recipients'] != null) {
      recipients = <EmployeeResponseModel>[];
      json['recipients'].forEach((v) {
        recipients!.add(EmployeeResponseModel.fromJson(v));
      });
    }
    //text =unescape.convert(json['text']);
    if (json['texts'] != null) {
      texts = <MessageTextItem>[];
      print("json['texts']");
      print(json['texts']);
      json['texts'].forEach((v) {
        texts!.add(MessageTextItem.fromJson(v));
      });
    }


    //else if(json['text']!=null){
      //print(object)
      //texts = [MessageTextItem(value: json['text'], type: "text")];
   // }

   // print("json['seenBy']");
   // print(json['seenBy']);
    seenBy = json['seenBy'].cast<String>();
    receivedBy = json['receivedBy'].cast<String>();
    if (json['attachments'] != null) {
      attachments = <Attachment>[];
      json['attachments'].forEach((v) {
        attachments!.add(Attachment.fromJson(v));
      });
    }
    if (json['reacts'] != null) {
      reacts = <React>[];
      json['reacts'].forEach((v) {
        reacts!.add(new React.fromJson(v));
      });
    }
    replyOf = json['replyOf'] != null ? new ReplyOf.fromJson(json['replyOf']) : null;
    recall = json['recall'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    if (this.sender != null) {
      data['sender'] = this.sender!.toJson();
    }
    if (this.recipients != null) {
      data['recipients'] = this.recipients!.map((v) => v.toJson()).toList();
    }

    //data['text'] = this.text;
    if (this.texts != null) {
      data['texts'] = this.texts!.map((v) => v.toJson()).toList();
    }
    data['seenBy'] = this.seenBy;
    data['receivedBy'] = this.receivedBy;
    if (this.attachments != null) {
      data['attachments'] = this.attachments!.map((v) => v.toJson()).toList();
    }if (this.reacts != null) {
      data['reacts'] = this.reacts!.map((v) => v.toJson()).toList();
    }
    if (this.replyOf != null) {
      data['replyOf'] = this.replyOf!.toJson();
    }
    data['recall'] = this.recall;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}



class React {
  String? title;
  EmployeeResponseModel? sender;

  React({this.title, this.sender});

  React.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    sender = json['sender'] != null ? new EmployeeResponseModel.fromJson(json['sender']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    if (this.sender != null) {
      data['sender'] = this.sender!.toJson();
    }
    return data;
  }
}

class ReplyOf {
  String? id;
  EmployeeResponseModel? sender;
  List<EmployeeResponseModel>? recipients;
  List<MessageTextItem>? texts;
  List<Attachment>? attachments;
  ReplyOf({this.id, this.sender, this.recipients,  this.texts, this.attachments});

  ReplyOf.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    sender = json['sender'] != null ? EmployeeResponseModel.fromJson(json['sender']) : null;
    if (json['recipients'] != null) {
      recipients = <EmployeeResponseModel>[];
      json['recipients'].forEach((v) {
        recipients!.add(EmployeeResponseModel.fromJson(v));
      });
    }

   // text = json['text'];
    if (json['texts'] != null) {

      texts = <MessageTextItem>[];
      json['texts'].forEach((v) {
        texts!.add(MessageTextItem.fromJson(v));
      });
    }else if(json['text']!=null){
      texts = [MessageTextItem(value: json['text'], type: "text")];
    }
    if (json['attachments'] != null) {
    attachments = <Attachment>[];
    json['attachments'].forEach((v) {
    attachments!.add(Attachment.fromJson(v));
    });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    if (this.sender != null) {
      data['sender'] = this.sender!.toJson();
    }

    if (this.recipients != null) {
      data['recipients'] = this.recipients!.map((v) => v.toJson()).toList();
    }

    //data['text'] = this.text;
    if (this.texts != null) {
      data['texts'] = this.texts!.map((v) => v.toJson()).toList();
    }
    if (this.attachments != null) {
      data['attachments'] = this.attachments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Attachment {
  final String? name;
  final String type;
  final String url;

  Attachment({
    this.name,
    required this.type,
    required this.url,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) {
    
    String imageUrl = json['url'];
    return Attachment(
      name: json['name'] ?? imageUrl,
      type: json['type'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name??url,
      'type': type,
      'url': url,
    };
  }
}
