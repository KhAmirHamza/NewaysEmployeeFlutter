import 'package:flutter/material.dart';
import 'package:neways3/src/features/requisition/models/Requisition.dart';
import 'package:neways3/src/utils/constants.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import '../controllers/RequisitionController.dart';

class RequisitionItemWidget extends StatefulWidget {
  Requisition requisition;
  RequisitionController controller;
  RequisitionItemWidget(this.requisition, this.controller, {super.key});

  @override
  State<RequisitionItemWidget> createState() => _RequisitionItemWidgetState();
}

class _RequisitionItemWidgetState extends State<RequisitionItemWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        showAnimatedDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            /*return ClassicGeneralDialogWidget(
              titleText: 'Title',
              contentText: 'content',
              onPositiveClick: () {
                Navigator.of(context).pop();
              },
              onNegativeClick: () {
                Navigator.of(context).pop();
              },

            );*/

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(10, 50, 10, 50),
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                  decoration: BoxDecoration(
                    color: DColors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
              Text("Id", style: TextStyle(color: Colors.grey.shade600),),
              const HeightSpace(),
              Text("${widget.requisition.id}"),

                      const HeightSpace(height: 15),
                      Text("Requisition Id", style: TextStyle(color: Colors.grey.shade600, fontSize: 14),),
                      const HeightSpace(),
                      Text("${widget.requisition.requisitionId}", style: TextStyle(fontSize: 14, color: Colors.grey.shade600),),

                      const HeightSpace(height: 15),
                      Text("Total Product", style: TextStyle(color: Colors.grey.shade600),),
                      const HeightSpace(),
                      Text("${widget.requisition.totalProduct}"),

                      const HeightSpace(height: 15),
                      Text("Request Date", style: TextStyle(color: Colors.grey.shade600),),
                      const HeightSpace(),
              Text("${widget.requisition.requestDate}"),

                      const HeightSpace(height: 15),
                      Text("Expectation Date", style: TextStyle(color: Colors.grey.shade600)),
                      const HeightSpace(),
                       Text("${widget.requisition.expectedDate}"),
                    ],),


                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      //Text("Approval Status", style: TextStyle(color: Colors.grey.shade600),),
                      // const HeightSpace(),

                      Text("${widget.requisition.requestDate}"),
                      const HeightSpace(),

                      widget.requisition.dheadApproval==0? const Text(
                        //"Department Head: "
                          "Pending", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)):
                      const Text(
                        //"Department Head: "
                          "Approved", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),



                      const HeightSpace(height: 15),
              Text("Process Status", style: TextStyle(color: Colors.grey.shade600),),
              const HeightSpace(),
              Text("${widget.requisition.processStatus}"),
                      const HeightSpace(height: 15),
                      Text("Request By", style: TextStyle(color: Colors.grey.shade600),),
                       const HeightSpace(),
                       Text("${widget.requisition.employeeName}"
                          // " | ${widget.requisition.employeeId}"
                           ""),
              const HeightSpace(height: 15),
              if(widget.requisition.processStatus==0)
              Text("Options", style: TextStyle(color: Colors.grey.shade600),),

             if(widget.requisition.processStatus==0)
              const HeightSpace(),
              if(widget.requisition.processStatus==0)
              Row(children: [
                InkWell(
                onTap: (){

                },
                child: const ClipOval(
                  clipBehavior: Clip.hardEdge,
                  child: Icon(Icons.remove_red_eye, color: Colors.green,),
                ),
                ),
                InkWell(
                onTap: (){
                  widget.controller.updateRequisitionApprovalStatus(widget.requisition.id.toString(), "accept");
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child:const Row(children: [
                    Icon(Icons.check, color: DColors.white,),
                    Text("Accept", style: TextStyle(color: DColors.white, fontWeight: FontWeight.bold),)
                  ],),
                ),
                ),
                InkWell(
                onTap: (){
                  widget.controller.updateRequisitionApprovalStatus(widget.requisition.id.toString(), "reject");
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child:const Row(children: [
                    Icon(Icons.check, color: DColors.white,),
                    Text("Reject", style: TextStyle(color: DColors.white, fontWeight: FontWeight.bold),)
                  ],),
                ),
                ),

              ],),

                    ],)
                ],
                ),
                ),
              ],
            );
          },
          animationType: DialogTransitionType.size,
          axis: Axis.vertical,
          curve: Curves.fastOutSlowIn,
          duration: Duration(seconds: 1),
        );
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
              color: DColors.background,
              borderRadius: BorderRadius.circular(15),
          ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
/*              Text("Id", style: TextStyle(color: Colors.grey.shade600),),
              const HeightSpace(),
              Text("${widget.requisition.id}"),*/

             // const HeightSpace(height: 15),
              //Text("Requisition Id", style: TextStyle(color: Colors.grey.shade600, fontSize: 14),),
              //const HeightSpace(),
              Text("${widget.requisition.requisitionId}", style: TextStyle(fontSize: 14, color: Colors.grey.shade600),),

              //const HeightSpace(height: 15),
             // Text("Total Product", style: TextStyle(color: Colors.grey.shade600),),
             // const HeightSpace(),
             // Text("${widget.requisition.totalProduct}"),

             // const HeightSpace(height: 15),
             // Text("Request Date", style: TextStyle(color: Colors.grey.shade600),),
              /*const HeightSpace(),
              Text("${widget.requisition.requestDate}"),*/


                const HeightSpace(),
                Text("${widget.requisition.employeeName}"
                // " | ${widget.requisition.employeeId}"
                    ""),

             // const HeightSpace(height: 15),
             // Text("Expectation Date", style: TextStyle(color: Colors.grey.shade600)),
             // const HeightSpace(),
            //  Text("${widget.requisition.expectedDate}"),
            ],),


            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
              //Text("Approval Status", style: TextStyle(color: Colors.grey.shade600),),
             // const HeightSpace(),

                Text("${widget.requisition.requestDate}"),
                const HeightSpace(),

                widget.requisition.dheadApproval==0? const Text(
                //"Department Head: "
                "Pending", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)):
              const Text(
              //"Department Head: "
                  "Approved", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),



              /*const HeightSpace(height: 15),
              Text("Process Status", style: TextStyle(color: Colors.grey.shade600),),
              const HeightSpace(),
              Text("${widget.requisition.processStatus}"),
*/
              //const HeightSpace(height: 15),
             // Text("Request By", style: TextStyle(color: Colors.grey.shade600),),
             //  const HeightSpace(),
             //  Text("${widget.requisition.employeeName}"
             //     // " | ${widget.requisition.employeeId}"
             //      ""),
/*
              const HeightSpace(height: 15),
              Text("Options", style: TextStyle(color: Colors.grey.shade600),),
              const HeightSpace(),

              Row(children: [
                InkWell(
                  onTap: (){

                  },
                  child: const ClipOval(
                    clipBehavior: Clip.hardEdge,
                    child: Icon(Icons.remove_red_eye, color: Colors.green,),
                  ),
                ),
                InkWell(
                  onTap: (){
                    widget.controller.updateRequisitionApprovalStatus(widget.requisition.id.toString(), "accept");
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child:const Row(children: [
                      Icon(Icons.check, color: DColors.white,),
                      Text("Accept", style: TextStyle(color: DColors.white, fontWeight: FontWeight.bold),)
                    ],),
                  ),
                ),
                InkWell(
                  onTap: (){
                    widget.controller.updateRequisitionApprovalStatus(widget.requisition.id.toString(), "reject");
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child:const Row(children: [
                      Icon(Icons.check, color: DColors.white,),
                      Text("Reject", style: TextStyle(color: DColors.white, fontWeight: FontWeight.bold),)
                    ],),
                  ),
                ),

              ],),*/

            ],)
          ],
        ),
      ),
    );
  }
}
