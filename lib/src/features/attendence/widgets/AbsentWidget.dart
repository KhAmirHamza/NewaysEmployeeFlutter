// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:neways3/src/utils/constants.dart';

class AbsentWidget extends StatelessWidget {
  bool isAbsent;
  bool isFuture;
  AbsentWidget({Key? key, required this.isAbsent, this.isFuture = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
            backgroundColor: isAbsent
                ? (!isFuture ? Colors.red.shade100 : Colors.white)
                : Colors.white,
            side: BorderSide(
                color: isAbsent
                    ? (!isFuture ? Colors.red : DColors.secondary)
                    : DColors.secondary)),
        child: Text(
          "Absent",
          style: TextStyle(
            color: isAbsent
                ? (!isFuture ? Colors.red : DColors.primary)
                : DColors.primary,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
