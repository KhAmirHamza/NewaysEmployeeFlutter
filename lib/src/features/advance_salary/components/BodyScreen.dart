// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/AdvanceSalaryController.dart';
import '../models/AdvanceSalaryResponse.dart';
import '../widgets/getStatus.dart';
import 'package:neways3/src/utils/constants.dart';
import 'package:neways3/src/utils/functions.dart';

class BodyScreen extends StatelessWidget {
  const BodyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdvanceSalaryController>(
      init: AdvanceSalaryController(),
      builder: ((controller) => ListView.builder(
            itemCount: controller.responses.length,
            itemBuilder: (context, index) {
              AdvanceSalaryResponse response = controller.responses[index];
              return Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: DPadding.half, vertical: DPadding.half),
                child: Card(
                  elevation: 0,
                  child: Padding(
                    padding: EdgeInsets.all(DPadding.half),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Amount',
                                    style: TextStyle(
                                        color: Colors.blueGrey.shade600,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                HeightSpace(height: DPadding.half / 2),
                                Text(
                                  "BDT ${response.amount}",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade800),
                                ),
                              ],
                            ),
                            getStatus(
                                aproval: response.aproval,
                                accountAproval: response.aprovalAccount),
                          ],
                        ),
                        const HeightSpace(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Reason',
                                style: TextStyle(
                                    color: Colors.blueGrey.shade600,
                                    fontWeight: FontWeight.bold)),
                            HeightSpace(height: DPadding.half / 2),
                            Text(
                              response.note,
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          )),
    );
  }
}
