import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:client_information/client_information.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:neways3/src/utils/constants.dart';
import 'package:path_provider/path_provider.dart';

String numToMonth(String date) {
  var strList = date.split('/');
  return "${strList[0]} ${getMonth(strList[1])} ${strList[2]}";
}

String numToMonth2(String date, {bool isReverse = false}) {
  var strList = date.split('-');
  return isReverse == true
      ? "${strList[2]} ${getMonth(strList[1])} ${strList[0]}"
      : "${strList[0]} ${getMonth(strList[1])} ${strList[2]}";
}

String getDate(DateTime date) {
  return "${date.day} ${getMonth(date.month)} ${date.year}";
}

String getDateTime(DateTime date) {
  return "${date.day} ${getMonth(date.month)} ${date.year}, ${DateFormat.jm().format(date)}";
}

String getMonth(dynamic num, {bool isFullName = false}) {
  if (num == '01' || num == '1' || num == 1) {
    return isFullName ? "January" : "Jan";
  } else if (num == '02' || num == '2' || num == 2) {
    return isFullName ? "February" : "Feb";
  } else if (num == '03' || num == '3' || num == 3) {
    return isFullName ? "March" : "March";
  } else if (num == '04' || num == '4' || num == 4) {
    return isFullName ? "April" : "April";
  } else if (num == '05' || num == '5' || num == 5) {
    return isFullName ? "May" : "May";
  } else if (num == '06' || num == '6' || num == 6) {
    return isFullName ? "June" : "Jun";
  } else if (num == '07' || num == '7' || num == 7) {
    return isFullName ? "July" : "July";
  } else if (num == '08' || num == '8' || num == 8) {
    return isFullName ? "August" : "Aug";
  } else if (num == '09' || num == '9' || num == 9) {
    return isFullName ? "September" : "Sep";
  } else if (num == '10' || num == 10) {
    return isFullName ? "October" : "Oct";
  } else if (num == '11' || num == 11) {
    return isFullName ? "November" : "Nav";
  } else if (num == '12' || num == 12) {
    return isFullName ? "December" : "Dec";
  } else {
    return "NoN";
  }
}

Map<String, dynamic> stringToMap(strValue) {
  List<String> str =
      strValue.replaceAll("{", "").replaceAll("}", "").split(",");
  Map<String, dynamic> result = {};
  for (int i = 0; i < str.length; i++) {
    List<String> s = str[i].split(": ");
    result.putIfAbsent(s[0].trim(), () => s[1].trim());
  }
  return result;
}

defaultDialog(
    {required String title,
    required VoidCallback okPress,
    required Widget widget,
    isAction = true}) {
  return Get.defaultDialog(
    titlePadding: EdgeInsets.all(DPadding.full),
    title: title,
    radius: 5,
    content: SizedBox(
      width: 300,
      child: Column(
        children: [
          widget,
          if (isAction)
            Wrap(
              spacing: 8,
              children: [
                TextButton(
                    onPressed: okPress,
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.green,
                        padding:
                            EdgeInsets.symmetric(horizontal: DPadding.full),
                        backgroundColor: Colors.green.withOpacity(0.2)),
                    child: const Text('YES')),
                TextButton(
                    onPressed: () => Get.back(),
                    style: TextButton.styleFrom(
                        foregroundColor: DColors.highLight,
                        padding:
                            EdgeInsets.symmetric(horizontal: DPadding.full),
                        backgroundColor: DColors.highLight.withOpacity(0.2)),
                    child: const Text('NO')),
              ],
            ),
        ],
      ),
    ),
  );
}

Future pickDate(BuildContext context,
    {DateTime? initialDate, DateTime? firstDate, DateTime? lastDate}) async {
  final newDate = await showDatePicker(
    context: context,
      initialDate: initialDate ?? DateTime.now(),
  // firstDate: DateTime.now().subtract(const Duration(days: 0)),
    firstDate: firstDate ?? DateTime.now(),
    lastDate: lastDate ??
        DateTime(DateTime.now().year, DateTime.now().month,
            DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day),
  );

  if (newDate == null) return;
  // return '${date.day}/${date.month}/${date.year}';
  // startDate = newDate;
  return newDate;
}

void onTextFieldTap(context,
    {required String title, required List<SelectedListItem> list, callback}) {
  DropDownState(
    DropDown(
      bottomSheetTitle: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
        ),
      ),
      submitButtonChild: const Text(
        'Done',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      data: list ?? [],
      selectedItems: (List<dynamic> selectedList) {
        String value = "";
        for (var item in selectedList) {
          if (item is SelectedListItem) {
            value =
                item.value == null ? item.name : "${item.value} - ${item.name}";
          }
        }
        callback(value);
        // showSnackBar(value.toString());
      },
      enableMultipleSelection: false,
    ),
  ).showModal(context);
}

Future<ClientInformation> getClientInformation() async {
  late ClientInformation info;
  try {
    info = await ClientInformation.fetch();
  } on PlatformException {
    print('Failed to get client information');
  }

  return info;
}

Future openBox({required String name}) async {
  var dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  return await Hive.openBox(name);
}


void showInSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text)
  ));
}

Future<void> playScanSound() async {

  FlutterRingtonePlayer.play(
    fromAsset: "assets/audio/scan_sound.mp3",
    //android: AndroidSounds.notification,
    //ios: IosSounds.glass,
    looping: false, // Android only - API >= 28
    volume: 0.8, // Android only - API >= 28
    asAlarm: false, // Android only - all APIs
  );
}


File? galleryFile;
String? imagePath;
final picker = ImagePicker();
Future chooseImageFileFromGallery(Function(File gallaryFile) onSuccess) async {
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  XFile? xfilePick = pickedFile;
  if (xfilePick != null) {
    galleryFile = File(pickedFile!.path);
    onSuccess(galleryFile!);
  } else {
    print("Nothing is selected");
  }
}

buildMessageTextArray(){

}


