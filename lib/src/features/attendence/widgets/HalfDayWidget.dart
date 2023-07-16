// ignore_for_file: must_be_immutable, file_names

import 'package:flutter/material.dart';
import 'package:neways3/src/features/attendence/models/attendence_response_model.dart';
import 'package:neways3/src/utils/constants.dart';

class HalfDayWidget extends StatelessWidget {
  AttendenceResponseModel attendenceResponseModel;
  HalfDayWidget({Key? key, required this.attendenceResponseModel})
      : super(key: key);

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
                            "8.00 AM",
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
                            "19.00 PM",
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
                            "Working Hours".toUpperCase(),
                            style: TextStyle(
                              color: Colors.grey.shade600,
                            ),
                          ),
                          Text(
                            "11.00 H",
                            style: TextStyle(
                              color: Colors.grey.shade600,
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
            backgroundColor: Colors.white,
            side: BorderSide(color: DColors.secondary)),
        child: const Text(
          "Half",
          style: TextStyle(color: DColors.primary, fontSize: 13),
        ),
      ),
    );
  }
}
