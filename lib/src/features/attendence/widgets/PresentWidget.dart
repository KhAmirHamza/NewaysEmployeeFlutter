// ignore_for_file: must_be_immutable, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neways3/src/features/attendence/controller/AttendenceController.dart';
import 'package:neways3/src/features/attendence/models/attendence_response_model.dart';
import 'package:neways3/src/utils/constants.dart';

class PresentWidget extends StatelessWidget {
  AttendenceResponseModel attendenceResponseModel;
  PresentWidget({Key? key, required this.attendenceResponseModel})
      : super(key: key);
  final controller = Get.put(AttendenceController());
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
        onPressed: () {
          if (attendenceResponseModel.days != null) {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text(
                  "Details",
                  style: TextStyle(color: DColors.primary),
                ),
                content: SizedBox(
                  height: 75,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Check In".toUpperCase(),
                            style: TextStyle(
                              color: Colors.grey.shade600,
                            ),
                          ),
                          Text(
                            "${attendenceResponseModel.checkin} am",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      const HeightSpace(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Check out".toUpperCase(),
                            style: TextStyle(
                              color: Colors.grey.shade600,
                            ),
                          ),
                          Text(
                            "${attendenceResponseModel.checkout} pm",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      const HeightSpace(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "Working Hours".toUpperCase(),
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                          const WidthSpace(),
                          Expanded(
                            child: Text(
                              controller.workHours(attendenceResponseModel),
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Colors.grey,
                    ),
                    child: const Text("OK"),
                  ),
                ],
              ),
            );
          }
        },
        style: TextButton.styleFrom(
            elevation: 1,
            backgroundColor: attendenceResponseModel.days != null
                ? Colors.green.shade100
                : Colors.white,
            side: BorderSide(
                color: attendenceResponseModel.days != null
                    ? Colors.green
                    : DColors.secondary)),
        child: Text(
          "Present",
          style: TextStyle(
              color: attendenceResponseModel.days != null
                  ? Colors.green.shade800
                  : DColors.primary,
              fontSize: 13),
        ),
      ),
    );
  }
}
