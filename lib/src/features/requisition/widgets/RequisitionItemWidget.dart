import 'package:flutter/material.dart';
import 'package:get/get.dart';
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



   // // List<Requisition> items = [];
   //  items.addAll(widget.controller.requisitions.where((element) =>  element.requisitionId == widget.requisition.requisitionId));
   //
   //
   //  refreshMainPage(String reqId,int dHeadStatus, int processStatus){
   //    print("Refresh Main Page called: reqId: $reqId, dHeadStatus: $dHeadStatus, processStatus: $processStatus");
   //    int index = items.indexWhere((element) => element.requisitionId == reqId);
   //
   //    setState(() {
   //      if(index>-1){
   //        print("Refresh Main Page called");
   //
   //        items[index].dheadApproval = dHeadStatus;
   //        items[index].processStatus = processStatus;
   //      }
   //    });
   //  }

    return InkWell(
      onTap: () {
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

            print("widget.requisition.dheadApproval: ${widget.requisition.dheadApproval}");

            return Container(
                margin: const EdgeInsets.fromLTRB(10, 50, 10, 50),
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                decoration: BoxDecoration(
                  color: DColors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Id",
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                            ),
                            const HeightSpace(height: 5,),
                            Text("${widget.requisition.id}", style: TextStyle(fontWeight: FontWeight.bold),),
                            const HeightSpace(height: 15),
                            Text(
                              "Requisition Id",
                              style: TextStyle(
                                  color: Colors.grey.shade600, fontSize: 12),
                            ),
                            const HeightSpace(height: 5,),
                            Text(
                              "${widget.requisition.requisitionId}",
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                            ),


                            const HeightSpace(height: 15),
                            Text(
                              "Request By",
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                            ),
                            const HeightSpace(height: 5,),
                            Text("${widget.requisition.employeeName}"
                                // " | ${widget.requisition.employeeId}"
                                , style: const TextStyle(fontWeight: FontWeight.bold)),


                            const HeightSpace(height: 15),
                            Text(
                              "Product Quantity",
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                            ),
                            const HeightSpace(height: 5,),
                            Text("${widget.requisition.totalProduct}", style: const TextStyle(fontWeight: FontWeight.bold),),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            //Text("Approval Status", style: TextStyle(color: Colors.grey.shade600),),
                            // const HeightSpace(),

                            Text("DHead Approval",
                                style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                            const HeightSpace(height: 5,),

                            widget.requisition.dheadApproval == 0
                                ? const Text(
                              //"Department Head: "
                                "Pending",
                                style: TextStyle(
                                    color: Colors.amber,
                                    fontWeight: FontWeight.bold))
                                : widget.requisition.dheadApproval == 1? const Text(
                              //"Department Head: "
                                "Approved",
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold)):
                            const Text(
                              //"Department Head: "
                                "Rejected",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold)),

                            const HeightSpace(height: 15),
                            Text(
                              "Process Status",
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                            ),
                            const HeightSpace(height: 5,),
                            Text("${widget.requisition.processStatus}", style: const TextStyle(fontWeight: FontWeight.bold)),

                            const HeightSpace(height: 15),
                            Text(
                              "Request Date",
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                            ),
                            const HeightSpace(height: 5,),
                            Text("${widget.requisition.requestDate}", style: const TextStyle(fontWeight: FontWeight.bold)),
                            const HeightSpace(height: 15),
                            Text("Expectation Date",
                                style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                            const HeightSpace(height: 5,),
                            Text("${widget.requisition.expectedDate}", style: const TextStyle(fontWeight: FontWeight.bold)),

                          ],
                        )
                      ],
                    ),
                    const HeightSpace(height: 15,),
                    Text(
                      "Products",
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                    ),
                    const HeightSpace(height: 5,),
                    //Text("${items.map((e) => e.productName!)}", style: const TextStyle(fontWeight: FontWeight.bold),),
                    RichText(
                      textAlign: TextAlign.center,
                      text:
                      TextSpan(
                          children: getProductsTextSpans(widget.controller, widget.requisition.requisitionId!)
                      ),),

                    if (widget.requisition.processStatus == 1)
                      const HeightSpace(height: 15),

                    if (widget.requisition.processStatus == 1)
                      const HeightSpace(height: 5,),
                    if (widget.requisition.processStatus == 1)
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        // InkWell(
                        //   onTap: () {},
                        //   child: const ClipOval(
                        //     clipBehavior: Clip.hardEdge,
                        //     child: Icon(
                        //       Icons.remove_red_eye,
                        //       color: Colors.green,
                        //     ),
                        //   ),
                        // ),
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              // int index = items.indexWhere((element) => element.requisitionId == widget.requisition.id.toString());
                              //
                              // setState(() {
                              //   if(index>-1){
                              //     print("Refresh Main Page called");
                              //
                              //     items[index].dheadApproval = 0;
                              //     items[index].processStatus = 1;
                              //   }
                              // });
                              //return;
                              await widget.controller
                                  .updateRequisitionApprovalStatus(
                                  widget.requisition.requisitionId.toString(),
                                  "accept");

                              if(!mounted) return;
                              Navigator.pop(context);

                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              margin: const EdgeInsets.only(right: 5),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,

                                children: [
                                  Icon(
                                    Icons.check,
                                    color: DColors.white,
                                  ),
                                  Text(
                                    "Accept",
                                    style: TextStyle(
                                        color: DColors.white,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              await widget.controller
                                  .updateRequisitionApprovalStatus(
                                  widget.requisition.requisitionId.toString(),
                                  "reject");
                              if(!mounted) return;
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              margin: const EdgeInsets.only(left: 5),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.check,
                                    color: DColors.white,
                                  ),
                                  Text(
                                    "Reject",
                                    style: TextStyle(
                                        color: DColors.white,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );


          },
          animationType: DialogTransitionType.size,
          axis: Axis.vertical,
          curve: Curves.fastOutSlowIn,
          duration: const Duration(seconds: 1),
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
                Text(
                  "${widget.requisition.requisitionId}",
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),

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
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                //Text("Approval Status", style: TextStyle(color: Colors.grey.shade600),),
                // const HeightSpace(),

                Text("${widget.requisition.requestDate}"),
                const HeightSpace(),

                widget.requisition.dheadApproval == 0
                    ? const Text(
                        //"Department Head: "
                        "Pending",
                        style: TextStyle(
                            color: Colors.amber, fontWeight: FontWeight.bold))
                    : widget.requisition.dheadApproval == 1? const Text(
                  //"Department Head: "
                    "Approved",
                    style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold)):
                const Text(
                  //"Department Head: "
                    "Rejected",
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold)),

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
              ],
            )
          ],
        ),
      ),
    );
  }
}

List<TextSpan> getProductsTextSpans(RequisitionController controller, String reqId) {
  List<Requisition> items = [];
  items.addAll(controller.requisitions.where((element) =>  element.requisitionId == reqId));

  List<TextSpan> spans = [];

  for (var element in items) {
    print("element.productName: ${element.productName}");

    spans.add(TextSpan( children:
    [
      WidgetSpan(alignment: PlaceholderAlignment.middle,  child: ClipOval(child: Image.network("http://erp.superhomebd.com/super_home/${element.productImage}", height: 20, width: 20,),)),
      TextSpan( text: " ${element.productName}     ", style: const TextStyle(color: Colors.black))
    ]
    ));

  }

  return spans;

}
