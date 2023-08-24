import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:neways3/src/features/contacts/models/employee_response_model.dart';

import '../features/message/widgets/MentionItem.dart';

String socketURL = "116.68.198.178:5005";
String chatImageURL = "http://116.68.198.178:5005/images/";

//const appVersion = '1.0.5'; // App Version

get isDepHead {
  bool result =  (GetStorage().read('isDepHead') ?? GetStorage().read('inDepHead')) || (GetStorage().read('employeeId') == '72505');
  return result;
}

get isBoss {
  return GetStorage().read('departmentName') == "Top Management ";
}

class DColors {
  DColors._();

  static const Color primary = Color(0xFF676FA3);
  static Color secondary = const Color(0xFF676FA3).withOpacity(0.2);
  static const Color background = Color(0xFFEEF2FF);
  static const Color background_light = Color(0xFFF6F7FD);
  static const Color card = Color(0xFFCDDEFF);
  static const Color cardLight = Color(0xFFDAE5FF);
  static const Color highLight = Color(0xFFFF5959);
  static const Color black = Color(0xFF191919);
  static const Color white = Color(0xFFFFFFFF);
}

class DPadding {
  DPadding._();

  static double full = 16.0;
  static double half = 8.0;
}

class DRadius {
  DRadius._();

  static double full = 16.0;
  static double half = 8.0;
}

class DTextStyle {
  DTextStyle._();

  static TextStyle textTitleStyle = TextStyle(
      color: Colors.grey.shade800, fontSize: 18, fontWeight: FontWeight.bold);
  static TextStyle textTitleStyle2 = TextStyle(
      color: Colors.grey.shade800, fontSize: 21, fontWeight: FontWeight.bold);
  static TextStyle textTitleStyle3 = TextStyle(
      color: Colors.grey.shade900, fontSize: 16, fontWeight: FontWeight.bold);

  static TextStyle textSubTitleStyle = TextStyle(
      color: Colors.grey.shade600, fontSize: 14, fontWeight: FontWeight.normal);
  static TextStyle textSubTitleBoldStyle = TextStyle(
      color: Colors.grey.shade600, fontSize: 14, fontWeight: FontWeight.bold);
  static TextStyle textSubTitleBoldStyle2 = const TextStyle(
      color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold);
  static TextStyle textSubTitleStyle2 = TextStyle(
      color: Colors.grey.shade600, fontSize: 10, fontWeight: FontWeight.w500);
}

class HeightSpace extends StatelessWidget {
  final double height;
  const HeightSpace({Key? key, this.height = 8.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}

class WidthSpace extends StatelessWidget {
  final double width;
  const WidthSpace({Key? key, this.width = 8.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width);
  }
}

generateMentionsIncludingConst(
    {List<EmployeeResponseModel>? participants, bool asMentionable = false}) {
  if (!asMentionable) {
    List<String> mentionsTitle = [
      "@Everyone",
      "@Announcement",
      "@Complaint",
      "@Congratulations",
      "@Well Done",
      "@Welcome"
    ];
    List<String> mentionsPhoto = [
      "https://cdn-icons-png.flaticon.com/512/3160/3160069.png",
      "https://cdn-icons-png.flaticon.com/512/2417/2417848.png",
      "https://cdn-icons-png.flaticon.com/512/1972/1972388.png"
      "https://cdn-icons-png.flaticon.com/512/9281/9281502.png"
      "https://cdn-icons-png.flaticon.com/512/1533/1533908.png"
      "https://cdn-icons-png.flaticon.com/512/10071/10071089.png"
    ];

    List<String> gMentionsTitle = mentionsTitle;
    List<String> gMentionsPhoto = mentionsPhoto;
    if (participants != null) {
      for (int i = 0; i < participants.length; i++) {
        gMentionsTitle.add("@${participants[i].fullName!}");
        gMentionsPhoto.add(participants[i].photo!);
      }
    }
    return [gMentionsTitle, gMentionsPhoto];
  } else {
    List<MentionItem> mentionItems = [
      const MentionItem(
          title: "Everyone",
          photo: "https://cdn-icons-png.flaticon.com/512/3160/3160069.png"),

      const MentionItem(
          title: "Announcement",
          photo: "https://cdn-icons-png.flaticon.com/512/2417/2417848.png"),
      const MentionItem(
          title: "Complaint",
          photo: "https://cdn-icons-png.flaticon.com/512/1972/1972388.png"),
      const MentionItem(
          title: "Congratulations",
          photo: "https://cdn-icons-png.flaticon.com/512/9281/9281502.png"),
      const MentionItem(
          title: "Well Done",
          photo: "https://cdn-icons-png.flaticon.com/512/1533/1533908.png"),
      const MentionItem(
          title: "Welcome",
          photo: "https://cdn-icons-png.flaticon.com/512/10071/10071089.png"),

    ];

    for (int i = 0; i < participants!.length; i++) {
      mentionItems.add(MentionItem(
          title: participants![i].fullName!, photo: participants[i].photo!));
    }
    return mentionItems;
  }
}
