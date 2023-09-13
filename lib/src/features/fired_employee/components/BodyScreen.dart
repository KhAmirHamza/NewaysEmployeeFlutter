// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/EmployeeFiredController.dart';
import '../models/EmployeeFiredResponse.dart';
import '../widgets/getStatus.dart';
import 'package:neways3/src/utils/constants.dart';
import 'package:neways3/src/utils/functions.dart';

class BodyScreen extends StatelessWidget {
  const BodyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EmployeeFiredController>(
      init: EmployeeFiredController(),
      builder: ((controller) => controller.isDataEmpty
          ? const Center(
              child: Text("Data Not Fount"),
            )
          : ListView.builder(
              itemCount: controller.responses.length,
              itemBuilder: (context, index) {
                EmployeeFiredResponse response = controller.responses[index];
                return Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: DPadding.half, vertical: DPadding.half),
                  child: Card(
                    elevation: 0,
                    child: Padding(
                      padding: EdgeInsets.all(DPadding.full),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.network(response.photo,
                                    width: 80, height: 80, fit: BoxFit.fill),
                              ),
                              WidthSpace(width: DPadding.full),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      response.fullName,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    HeightSpace(height: DPadding.half),
                                    getStatus(
                                        state: response.status,
                                        aproval: response.approval),
                                  ],
                                ),
                              ),
                             // if(getStatus(state: response.status,aproval: response.approval) == "APP")
                              if(response.approval == 0 && response.status == 0)
                              IconButton(
                                color: Colors.red,
                                onPressed: () => defaultDialog(
                                    title: "Are you sure delete this request?",
                                    okPress: () async {
                                      await controller.delete(response.id);
                                    },
                                    widget: const SizedBox()),
                                icon: const Icon(
                                  Icons.delete_outline,
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Fired Reason',
                                  style: TextStyle(
                                      color: Colors.blueGrey.shade600,
                                      fontWeight: FontWeight.bold)),
                              HeightSpace(height: DPadding.half / 2),
                              Text(
                                response.reason.toString(),
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
