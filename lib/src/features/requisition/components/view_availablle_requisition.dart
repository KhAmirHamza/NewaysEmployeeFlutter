import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neways3/src/features/requisition/controllers/RequisitionController.dart';
import 'package:neways3/src/features/requisition/widgets/RequisitionItemWidget.dart';

import '../../../utils/constants.dart';

class ViewAvailableRequisition extends StatefulWidget {

  RequisitionController requisitionController;
  int branchId, departmentId;
  ViewAvailableRequisition(this.requisitionController, this.branchId, this.departmentId, {super.key});

  @override
  State<ViewAvailableRequisition> createState() => _ViewAvailableRequisitionState();
}

class _ViewAvailableRequisitionState extends State<ViewAvailableRequisition> {


  @override
  Widget build(BuildContext context) {


    return Scaffold(
        backgroundColor: DColors.white,
        appBar: AppBar(
        leading: InkWell(
        onTap: () => Get.back(),
    child: const Icon(Icons.arrow_back_ios_new_rounded)),
    title: const Text("Requisition Approval"),
    centerTitle: true,
    elevation: 0,
    ),

      body: GetBuilder<RequisitionController>(
        init: widget.requisitionController,
        builder: (controller){

          print("Requisition Count: ${controller.requisitions.length}");

         // return Text("Requisition Count: ${controller.requisitions.length}");

          return ListView.builder(
              //shrinkWrap: true,
             // physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.all(DPadding.half),
             // controller: controller.scrollController,
              itemCount: controller.requisitions.length,
              itemBuilder: (context, index) {


                return
                  //Text(controller.requisitions[index].employeeId.toString());

                  RequisitionItemWidget(controller.requisitions[index], controller);
              });
        },
      ),
    );
  }
}



