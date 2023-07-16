// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:neways3/src/features/attendence/models/attendence_response_model.dart';
import 'package:neways3/src/features/attendence/services/attendence_service.dart';

class AttendenceController extends GetxController {
  List<AttendenceResponseModel> attendences = [];
  DateTime date = DateTime.now();
  @override
  void onInit() {
    super.onInit();
    getAllAttendence();
  }

  getAllAttendence() async {
    EasyLoading.show();
    print(date.month.toString());
    await AttendenceService.attendences(
            month: date.month.toString(),
            year: (DateTime.now().year - 2000).toString())
        .then((value) {
      if (value.runtimeType == List<AttendenceResponseModel>) {
        attendences = value;
      } else {
        // error
      }
    });
    update();
    EasyLoading.dismiss();
    return true;
  }

  Future pickDate(BuildContext context, {DateTime? initialDate}) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      // firstDate: DateTime.now().subtract(const Duration(days: 0)),
      firstDate: DateTime(DateTime.now().year - (DateTime.now().year - 2000)),
      lastDate: DateTime(DateTime.now().year + 10),
    );

    if (newDate == null) return;
    // return '${date.day}/${date.month}/${date.year}';
    date = newDate;
    await getAllAttendence();
    update();
    return newDate;
  }

  pickMonth(BuildContext context, {DateTime? initialDate}) async {
    final selected = await showMonthYearPicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 1, 5),
      lastDate: DateTime(DateTime.now().year + 1, 9),
    );
    date = selected!;
    await getAllAttendence();
    update();
    return selected;
    // showMonthPicker(
    //   context: context,
    //   firstDate: DateTime(DateTime.now().year - 1, 5),
    //   lastDate: DateTime(DateTime.now().year + 1, 9),
    //   initialDate: date,
    // ).then((newDate) async {
    //   if (newDate != null) {
    //     date = newDate;
    //     await getAllAttendence();
    //     update();
    //   }
    // });
  }

  String workHours(AttendenceResponseModel attendenceResponseModel) {
    String workHour = 'Undefined';
    if (attendenceResponseModel.checkin != '' &&
        attendenceResponseModel.checkout != '') {
      var fmt = DateFormat('HH:mm');
      var checkInTime = fmt.parse(attendenceResponseModel.checkin);
      var checkOutTime = fmt.parse(attendenceResponseModel.checkout);
      var now = DateTime.now();
      var inHour = DateTime(now.year, now.month, now.day, checkInTime.hour,
              checkInTime.minute)
          .difference(DateTime(now.year, now.month, now.day, checkOutTime.hour,
              checkOutTime.minute))
          .inHours
          .abs();
      var minutes = (DateTime(now.year, now.month, now.day, checkInTime.hour,
                      checkInTime.minute)
                  .difference(DateTime(now.year, now.month, now.day,
                      checkOutTime.hour, checkOutTime.minute))
                  .inMinutes)
              .abs() -
          (inHour * 60);

      workHour = '$inHour hour $minutes min';
    }
    return workHour;
  }
}
