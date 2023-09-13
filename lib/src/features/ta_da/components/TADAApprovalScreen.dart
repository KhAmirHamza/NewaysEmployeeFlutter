import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/appbar.dart';
import '../../../utils/constants.dart';
import '../../../utils/functions.dart';
import '../bloc/TADAApproveController.dart';
import '../bloc/TADAController.dart';
import '../models/TADAResponse.dart';
import '../widgets/getStatus.dart';

class TADAApprovalScreen extends StatefulWidget {

  const TADAApprovalScreen({super.key});

  @override
  State<TADAApprovalScreen> createState() => _TADAApprovalScreenState();
}

class _TADAApprovalScreenState extends State<TADAApprovalScreen> {
  bool multipleSelectionEnable = false;
  List<int> selectedTaDaIds = [];

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: buildAppBar(
        title: "TA/DA Approve",
        actions: [
          IconButton(
              onPressed: () async {
                await Get.put(TADAApproveController()).getAllData();
              },
              icon: const Icon(Icons.replay_outlined)),
        ],
      ),
      body: GetBuilder<TADAApproveController>(
        init: TADAApproveController(),
        builder: ((controller) =>

        Column(children: [
          if(multipleSelectionEnable)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [

              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.amber.shade100
                ),
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                child: Text("(${selectedTaDaIds.length})  Selected", style: TextStyle(color: Colors.blue.shade900, fontWeight: FontWeight.w700),),
              ),


              TextButton.icon(
                  onPressed: () => defaultDialog(
                    title: "Are you sure approved this TA/DA?",
                    okPress: () async {
                      //await controller.approved(response.id);
                      await controller.dHeadAndBossApproval("Accept", selectedTaDaIds);
                      if(!context.mounted) return;
                      Navigator.pop(context);
                    },
                    widget: const SizedBox(),
                  ),
                  style: TextButton.styleFrom(

                      foregroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(
                          horizontal: DPadding.full),
                      backgroundColor:
                      Colors.green.withOpacity(0.2)),
                  icon: const Icon(Icons.check, size: 18),
                  label: const Text('Approve')),
              TextButton.icon(
                  onPressed: () => defaultDialog(
                    title: "Are you sure Reject this request?",
                    okPress: () async {
                      //await controller.rejected(response.id);
                      await controller.dHeadAndBossApproval("Reject", selectedTaDaIds);
                      if(!context.mounted) return;
                      Navigator.pop(context);
                    },
                    widget: const SizedBox(),
                  ),
                  style: TextButton.styleFrom(
                      foregroundColor: DColors.highLight,
                      padding: EdgeInsets.symmetric(
                          horizontal: DPadding.full),
                      backgroundColor:
                      DColors.highLight.withOpacity(0.2)),
                  icon: const Icon(Icons.close, size: 18),
                  label: const Text('Reject')),
            ],
          ),

          Flexible(
            child: ListView.builder(
              itemCount: controller.responses.length,
              itemBuilder: (context, index) {
                TadaResponse taDa = controller.responses[index];
                return InkWell(
                  onLongPress: (){
                    selectedTaDaIds.clear();
                    multipleSelectionEnable = !multipleSelectionEnable;
                    if(multipleSelectionEnable) selectedTaDaIds.add(taDa.id);
                    setState(() {
                    });
                  },
                  onTap: (){
                    if(multipleSelectionEnable){
                      selectedTaDaIds.contains(taDa.id)? selectedTaDaIds.remove(taDa.id):selectedTaDaIds.add(taDa.id);
                      if(selectedTaDaIds.isEmpty){multipleSelectionEnable = false; }
                      setState(() { });
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: DPadding.half-2, left: DPadding.half-2, right: DPadding.half-2),
                    child: Card(
                      shadowColor: Colors.grey,
                      elevation: 5,
                      color: multipleSelectionEnable && selectedTaDaIds.contains(taDa.id)? Colors.blue.shade50 : Colors.grey.shade200,
                      child: Container(
                        padding: EdgeInsets.all(DPadding.half),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Image.network(
                                          taDa.photo!.toString(),
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.fill),
                                    ),
                                    const WidthSpace(),
                                    Text(
                                      taDa.fullName!.toString(),
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Text(taDa.transportDate,
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.blueGrey.shade600,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const HeightSpace(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('From',
                                        style: TextStyle(
                                            color: Colors.blueGrey.shade600,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 12)),
                                    HeightSpace(height: DPadding.half / 2),
                                    Text(taDa.destinationFrom,
                                        style: TextStyle(
                                            color: Colors.blueGrey.shade600,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text('To',
                                        style: TextStyle(
                                            color: Colors.blueGrey.shade600,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 12)),
                                    HeightSpace(height: DPadding.half / 2),
                                    Text(taDa.destinationTo,
                                        style: TextStyle(
                                            color: Colors.blueGrey.shade600,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                            ),
                            HeightSpace(height: DPadding.half+2),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Transport Type',
                                        style: TextStyle(
                                            color: Colors.blueGrey.shade600,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 12)),
                                    HeightSpace(height: DPadding.half / 2),
                                    Text(
                                        "${taDa.vehicleType} (${taDa.transportType})",
                                        style: TextStyle(
                                            color: Colors.blueGrey.shade600,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text('Transport Amount',
                                        style: TextStyle(
                                            color: Colors.blueGrey.shade600,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 12)),
                                    HeightSpace(height: DPadding.half / 2),
                                    Text("BDT ${taDa.transportAmount}",
                                        style: TextStyle(
                                            color: Colors.blueGrey.shade600,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                            ),
                            HeightSpace(height: DPadding.full),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Note',
                                    style: TextStyle(
                                        color: Colors.blueGrey.shade600,
                                        fontWeight: FontWeight.bold)),
                                HeightSpace(height: DPadding.half / 2),
                                Text(
                                  taDa.note,
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                            if(!multipleSelectionEnable)
                            const Divider(),

                            if(!multipleSelectionEnable)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [

                                TextButton.icon(
                                    onPressed: () => defaultDialog(
                                      title: "Are you sure approved this TA/DA?",
                                      okPress: () async {
                                        //await controller.approved(response.id);
                                        await controller.dHeadAndBossApproval("Accept", [taDa.id]);
                                        if(!context.mounted) return;
                                        Navigator.pop(context);
                                      },
                                      widget: const SizedBox(),
                                    ),
                                    style: TextButton.styleFrom(

                                        foregroundColor: Colors.green,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: DPadding.full),
                                        backgroundColor:
                                        Colors.green.withOpacity(0.2)),
                                    icon: const Icon(Icons.check, size: 18),
                                    label: const Text('Approve')),
                                TextButton.icon(
                                    onPressed: () => defaultDialog(
                                      title: "Are you sure Reject this request?",
                                      okPress: () async {
                                        //await controller.rejected(response.id);
                                        await controller.dHeadAndBossApproval("Reject", [taDa.id]);
                                        if(!context.mounted) return;
                                        Navigator.pop(context);
                                      },
                                      widget: const SizedBox(),
                                    ),
                                    style: TextButton.styleFrom(
                                        foregroundColor: DColors.highLight,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: DPadding.full),
                                        backgroundColor:
                                        DColors.highLight.withOpacity(0.2)),
                                    icon: const Icon(Icons.close, size: 18),
                                    label: const Text('Reject')),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],)

            /*ListView.builder(
              itemCount: controller.responses.length,
              itemBuilder: (context, index) {
                TadaResponse response = controller.responses[index];
                return Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: DPadding.half, vertical: DPadding.half),
                  child: Card(
                    elevation: 0,
                    color: Colors.grey.shade200,
                    child: Padding(
                      padding: EdgeInsets.all(DPadding.half),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.network(
                                        response.photo!.toString(),
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.fill),
                                  ),
                                  const WidthSpace(),
                                  Text(
                                    response.fullName!.toString(),
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Text(response.transportDate,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.blueGrey.shade600,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const HeightSpace(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('From',
                                      style: TextStyle(
                                          color: Colors.blueGrey.shade600,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 12)),
                                  HeightSpace(height: DPadding.half / 2),
                                  Text(response.destinationFrom,
                                      style: TextStyle(
                                          color: Colors.blueGrey.shade600,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('To',
                                      style: TextStyle(
                                          color: Colors.blueGrey.shade600,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 12)),
                                  HeightSpace(height: DPadding.half / 2),
                                  Text(response.destinationTo,
                                      style: TextStyle(
                                          color: Colors.blueGrey.shade600,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ],
                          ),
                          HeightSpace(height: DPadding.half+2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Transport Type',
                                      style: TextStyle(
                                          color: Colors.blueGrey.shade600,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 12)),
                                  HeightSpace(height: DPadding.half / 2),
                                  Text(
                                      "${response.vehicleType} (${response.transportType})",
                                      style: TextStyle(
                                          color: Colors.blueGrey.shade600,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('Transport Amount',
                                      style: TextStyle(
                                          color: Colors.blueGrey.shade600,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 12)),
                                  HeightSpace(height: DPadding.half / 2),
                                  Text("BDT ${response.transportAmount}",
                                      style: TextStyle(
                                          color: Colors.blueGrey.shade600,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ],
                          ),
                          HeightSpace(height: DPadding.full),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Note',
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
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [

                              TextButton.icon(
                                  onPressed: () => defaultDialog(
                                        title: "Are you sure approved this TA/DA?",
                                        okPress: () async {
                                          //await controller.approved(response.id);
                                          await controller.dHeadAndBossApproval("Accept", [response.id]);
                                          if(!context.mounted) return;
                                          Navigator.pop(context);
                                        },
                                        widget: const SizedBox(),
                                      ),
                                  style: TextButton.styleFrom(

                                      foregroundColor: Colors.green,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: DPadding.full),
                                      backgroundColor:
                                          Colors.green.withOpacity(0.2)),
                                  icon: const Icon(Icons.check, size: 18),
                                  label: const Text('Approve')),
                              TextButton.icon(
                                  onPressed: () => defaultDialog(
                                        title: "Are you sure Reject this request?",
                                        okPress: () async {
                                          //await controller.rejected(response.id);
                                          await controller.dHeadAndBossApproval("Reject", [response.id]);
                                          if(!context.mounted) return;
                                          Navigator.pop(context);
                                        },
                                        widget: const SizedBox(),
                                      ),
                                  style: TextButton.styleFrom(
                                      foregroundColor: DColors.highLight,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: DPadding.full),
                                      backgroundColor:
                                          DColors.highLight.withOpacity(0.2)),
                                  icon: const Icon(Icons.close, size: 18),
                                  label: const Text('Reject')),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )*/


        ),
      ),
    );
  }
}




/*
*
*
*
* \Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [

                  TextButton.icon(
                      onPressed: () => defaultDialog(
                        title: "Are you sure approved this TA/DA?",
                        okPress: () async {
                          //await controller.approved(response.id);
                          await controller.dHeadAndBossApproval("Accept", [2]);
                          if(!context.mounted) return;
                          Navigator.pop(context);
                        },
                        widget: const SizedBox(),
                      ),
                      style: TextButton.styleFrom(

                          foregroundColor: Colors.green,
                          padding: EdgeInsets.symmetric(
                              horizontal: DPadding.full),
                          backgroundColor:
                          Colors.green.withOpacity(0.2)),
                      icon: const Icon(Icons.check, size: 18),
                      label: const Text('Approve')),
                  TextButton.icon(
                      onPressed: () => defaultDialog(
                        title: "Are you sure Reject this request?",
                        okPress: () async {
                          //await controller.rejected(response.id);
                          await controller.dHeadAndBossApproval("Reject", [1]);
                          if(!context.mounted) return;
                          Navigator.pop(context);
                        },
                        widget: const SizedBox(),
                      ),
                      style: TextButton.styleFrom(
                          foregroundColor: DColors.highLight,
                          padding: EdgeInsets.symmetric(
                              horizontal: DPadding.full),
                          backgroundColor:
                          DColors.highLight.withOpacity(0.2)),
                      icon: const Icon(Icons.close, size: 18),
                      label: const Text('Reject')),
                ],
              ),

              ListView.builder(
                itemCount: controller.responses.length,
                itemBuilder: (context, index) {
                  TadaResponse response = controller.responses[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: DPadding.half, vertical: DPadding.half),
                    child: Card(
                      elevation: 0,
                      color: Colors.grey.shade200,
                      child: Padding(
                        padding: EdgeInsets.all(DPadding.half),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Image.network(
                                          response.photo!.toString(),
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.fill),
                                    ),
                                    const WidthSpace(),
                                    Text(
                                      response.fullName!.toString(),
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Text(response.transportDate,
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.blueGrey.shade600,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const HeightSpace(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('From',
                                        style: TextStyle(
                                            color: Colors.blueGrey.shade600,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 12)),
                                    HeightSpace(height: DPadding.half / 2),
                                    Text(response.destinationFrom,
                                        style: TextStyle(
                                            color: Colors.blueGrey.shade600,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text('To',
                                        style: TextStyle(
                                            color: Colors.blueGrey.shade600,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 12)),
                                    HeightSpace(height: DPadding.half / 2),
                                    Text(response.destinationTo,
                                        style: TextStyle(
                                            color: Colors.blueGrey.shade600,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                            ),
                            HeightSpace(height: DPadding.half+2),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Transport Type',
                                        style: TextStyle(
                                            color: Colors.blueGrey.shade600,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 12)),
                                    HeightSpace(height: DPadding.half / 2),
                                    Text(
                                        "${response.vehicleType} (${response.transportType})",
                                        style: TextStyle(
                                            color: Colors.blueGrey.shade600,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text('Transport Amount',
                                        style: TextStyle(
                                            color: Colors.blueGrey.shade600,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 12)),
                                    HeightSpace(height: DPadding.half / 2),
                                    Text("BDT ${response.transportAmount}",
                                        style: TextStyle(
                                            color: Colors.blueGrey.shade600,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                            ),
                            HeightSpace(height: DPadding.full),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Note',
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
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [

                                TextButton.icon(
                                    onPressed: () => defaultDialog(
                                      title: "Are you sure approved this TA/DA?",
                                      okPress: () async {
                                        //await controller.approved(response.id);
                                        await controller.dHeadAndBossApproval("Accept", [response.id]);
                                        if(!context.mounted) return;
                                        Navigator.pop(context);
                                      },
                                      widget: const SizedBox(),
                                    ),
                                    style: TextButton.styleFrom(

                                        foregroundColor: Colors.green,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: DPadding.full),
                                        backgroundColor:
                                        Colors.green.withOpacity(0.2)),
                                    icon: const Icon(Icons.check, size: 18),
                                    label: const Text('Approve')),
                                TextButton.icon(
                                    onPressed: () => defaultDialog(
                                      title: "Are you sure Reject this request?",
                                      okPress: () async {
                                        //await controller.rejected(response.id);
                                        await controller.dHeadAndBossApproval("Reject", [response.id]);
                                        if(!context.mounted) return;
                                        Navigator.pop(context);
                                      },
                                      widget: const SizedBox(),
                                    ),
                                    style: TextButton.styleFrom(
                                        foregroundColor: DColors.highLight,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: DPadding.full),
                                        backgroundColor:
                                        DColors.highLight.withOpacity(0.2)),
                                    icon: const Icon(Icons.close, size: 18),
                                    label: const Text('Reject')),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
            ],)*/
