import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:neways3/src/features/requisition/models/Requisition.dart';

import '../services/RequisitionService.dart';

class RequisitionController extends GetxController{

  List<Requisition> requisitions = [];
  final scrollController = ScrollController();

  int limit = 20;
  late bool isLoading = false;

  // @override
  // void onInit() async {
  //   super.onInit();
  //   scrollController.addListener(() async {
  //     if (scrollController.position.maxScrollExtent ==
  //         scrollController.offset) {
  //       limit = limit + 20;
  //       isLoading = true;
  //      // await getAllEmployee(size: limit);
  //
  //       //
  //     }
  //   });
  // }


  getAllAvailableRequisition(int branchId, int departmentId) async {
   // EasyLoading.show();
    await RequisitionService.getAllAvailableRequisition(branchId, departmentId, this);
    update();

    //print("requisition: "+requisitions.length.toString());
   // EasyLoading.dismiss();
   // return true;
  }


  updateRequisitionApprovalStatus(String requisition_id, String requisition_type) async {
    await RequisitionService.updateRequisitionApprovalStatus(requisition_id, requisition_type, (data){
     // print("Requisition Data Changed");

      int rIndex = requisitions.indexWhere((element) => element.requisitionId == requisition_id);
     // print("requisitions.length: ${requisitions.length}, requisition_id: $requisition_id, rIndex: $rIndex");
      for(int i=0; i<requisitions.length; i++){
        if(requisitions[i].requisitionId == requisition_id){
          requisitions[rIndex].processStatus =  2;
          requisitions[rIndex].dheadApproval = requisition_type=="accept"? 1:2;
        }
      }
      refresh();
      //update();
    });
  }



}