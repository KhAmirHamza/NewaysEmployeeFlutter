import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neways3/src/features/contacts/presentation/ContactDetailsScreen.dart';
import 'package:neways3/src/utils/constants.dart';
import 'package:neways3/src/utils/functions.dart';

import '../../contacts/controllers/ContactController.dart';
import '../../contacts/models/employee_response_model.dart';
import '../ChatScreen.dart';
import '../controllers/ConvsCntlr.dart';

class GroupDetailsScreen extends StatefulWidget {
  String convsId;
  ConversationController convsController;
  EmployeeResponseModel currentEmployee;
  GroupDetailsScreen(this.convsId, this.convsController,
      this.currentEmployee, {super.key});

  @override
  State<GroupDetailsScreen> createState() => _GroupDetailsScreenState();
}

class _GroupDetailsScreenState extends State<GroupDetailsScreen> {

  refreshMainPage(){
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {

    int convsIndex = widget.convsController.conversations.indexWhere((element) => element.id == widget.convsId);

    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.white,
        elevation: 1,
        leading: BackButton(
          color: Colors.black,
          onPressed: () => {
          Navigator.of(context).pop()
        },
        ),
        backgroundColor: Colors.white,
        title: Container(
          margin: const EdgeInsets.only(bottom: 5),
          // child: Text( widget.convsController.conversations.firstWhere((element) => element.id==widget.convsId).title
          //     .toString(),

          child: const Text("Group Details",
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
        ),
      ),
      body: GetX<ConversationController>(
        builder: (controller){
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: ClipOval(
                        child: Image.network(widget.convsController.conversations[convsIndex].photo!, height: 70,width: 70, fit: BoxFit.fill,),
                      ),
                    )
                  ],
                ),
                if(widget.currentEmployee.employeeId=="72505" || widget.currentEmployee.employeeId == "71104")
                InkWell(
                  onTap: (){
                    showGroupEditingDialog(context, convsController, convsIndex, (){ setState(() {}); });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                        const Icon(Icons.mode_edit_outline_outlined,color: Colors.blue, size: 15,),
                        Container(
                          margin: const EdgeInsets.only(left: 5),
                          child: const Text("edit", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                        )
                      ],
                      )),
                ),
              ],
            ),
            const HeightSpace(height: 16,),
            Text( widget.convsController.conversations[convsIndex].title!,
                style: const TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
            ),
           const HeightSpace(height: 16,),
          const Row(children: [
            Padding(padding: EdgeInsets.fromLTRB(10,10,10,5), child: Text("Group Members", style: TextStyle(color: Colors.grey),),)
          ],),
          Expanded(
            child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: widget.convsController.conversations[convsIndex].participants!.length,
            itemBuilder: (context, index) {
            return EmployeeItem(widget.convsController, widget.currentEmployee, convsIndex,  index, refreshMainPage);
            }),
          )

          ],);
        }
      ),
    );
  }
}

class EmployeeItem extends StatefulWidget {
  ConversationController conversationController;
  EmployeeResponseModel currentEmployee;
  int convsIndex;
  int index;
  Function refreshMainPage;
  EmployeeItem(this.conversationController, this.currentEmployee, this.convsIndex, this.index, this.refreshMainPage,
      {Key? key})
      : super(key: key);

  @override
  State<EmployeeItem> createState() => _EmployeeItemState();
}



class _EmployeeItemState extends State<EmployeeItem> {
  @override
  Widget build(BuildContext context) {

    bool isOwnerOrAdmin(String employeeId){
      return (
          widget.conversationController.conversations[widget.convsIndex].owner!.employeeId == employeeId ||
              employeeId == "72505" ||
              employeeId == "71104" ||
          (
            widget.conversationController.conversations[widget.convsIndex].admins!=null &&
            widget.conversationController.conversations[widget.convsIndex].admins!.indexWhere((element) => element.employeeId==employeeId)!=-1
          )
      );
    }


    EmployeeResponseModel participant = widget.conversationController.conversations[widget.convsIndex].participants![widget.index];
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 3,
      margin: const EdgeInsets.fromLTRB(5, 8, 5, 0),
      borderOnForeground: true,
      shadowColor: Colors.grey,

      child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onLongPress: (){


            if(isOwnerOrAdmin(widget.currentEmployee.employeeId!) && !isOwnerOrAdmin(participant.employeeId!) ) {
              removeParticipant(
                  context,convsController,
                  widget.conversationController.conversations[widget.convsIndex].id!,
                  participant.employeeId!, widget.refreshMainPage);
            }
          },
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ContactDetailsScreen(employee: participant)));
            //debugPrint('Card tapped.');
            //print(widget.conversationController.conversations[widget.convsIndex].participants![widget.index].fullName);

            //todo...

            //select or remove contact
            //
            // if (groupEmployees.length == 0) {
            //   groupEmployees
            //       .add(widget.contactController.employees[widget.index]);
            //   //print("Now Added");
            //   widget.contactController.refresh();
            //   // widget.refreshFullPage();
            // } else {
            //   bool found = false;
            //   for (int i = 0; i < groupEmployees.length; i++) {
            //     if (groupEmployees[i].employeeId ==
            //         widget.contactController.employees[widget.index]
            //             .employeeId) {
            //       found = true;
            //       groupEmployees.removeAt(i);
            //       // print("Now Removed");
            //       widget.contactController.refresh();
            //       // widget.refreshFullPage();
            //       return;
            //     }
            //   }
            //   if (!found) {
            //     groupEmployees
            //         .add(widget.contactController.employees[widget.index]);
            //     //print("Now Added");
            //     widget.contactController.refresh();
            //     //widget.refreshFullPage();
            //   }
            // }
          },
          child: Container(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Container(
                //   margin: EdgeInsets.fromLTRB(20, 0, 15, 0),
                //   decoration: BoxDecoration(
                //     border: Border.all(color: Colors.grey),
                //     borderRadius: BorderRadius.circular(25),
                //   ),
                //   child: Container(
                //     padding: EdgeInsets.all(3),
                //     child: CircleAvatar(
                //       radius: 9,
                //       backgroundColor: Colors.white,
                //       backgroundImage: groupEmployees.any((element) =>
                //       element.employeeId ==
                //           widget.contactController.employees[widget.index]
                //               .employeeId)
                //           ? const AssetImage('assets/images/check_mark.png')
                //           : null,
                //       // backgroundImage: groupEmployees.contains(
                //       //         widget.contactController.employees[widget.index])
                //       //     ? AssetImage('assets/images/check_mark.png')
                //       //     : null,
                //     ),
                //   ),
                // ),
                ClipOval(
                  child: CachedNetworkImage(
                      imageUrl: (participant.photo!),
                      placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                      errorWidget: ((context, error, stackTrace) => Center(
                        child: Text(
                          "No Image",
                          style: TextStyle(
                              fontSize: 10, color: Colors.grey.shade400),
                        ),
                      )),
                      width: 48,
                      height: 48,
                      fit: BoxFit.fill),
                ),

                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            margin: const EdgeInsets.only(left: 15),
                            child: Text(participant.fullName!, style: const TextStyle(fontSize: 16),)),

                        widget.conversationController.conversations[widget.convsIndex].owner!.employeeId == participant.employeeId?
                          Text("Owner", style: TextStyle(color: Colors.green. shade700, fontWeight: FontWeight.bold),):
                            (   widget.conversationController.conversations[widget.convsIndex].admins!=null &&
                                widget.conversationController.conversations[widget.convsIndex].admins!.indexWhere((element) => element.employeeId==participant.employeeId)!=-1 )?
                              Text("Admins", style: TextStyle(color: Colors.green. shade700, fontWeight: FontWeight.bold),): Container()
                      ],
                    ),
                    const HeightSpace(height: 5,),
                      Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const WidthSpace(width: 15,),
                        Text(widget.conversationController.conversations[widget.convsIndex].participants![widget.index].designationName!,
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade800)),
                        const WidthSpace(width: 10,),
                        const Icon(Icons.label_important_outline, color: Colors.green, size: 14,),
                        const WidthSpace(width: 10,),
                      Text(widget.conversationController.conversations[widget.convsIndex].participants![widget.index].departmentName!,
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade800),),
                    ],)
                  ],),
                )
              ],
            ),
          )),
    );
  }
}


Future<void> removeParticipant(BuildContext context, ConversationController convsController, String convsId, String participantId, Function refreshMainPage) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Make Sure...'),
        content: const Text(
          'Do you want to remove participant from group?',
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('No', style: TextStyle(color: Colors.black),),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Remove', style: TextStyle(color: Colors.red),),
            onPressed: () {
              convsController.removeParticipant(convsId, participantId);
              Navigator.of(context).pop();
             // refreshMainPage();
            },
          ),
        ],
      );
    },
  );
}
void showCustomDialog(BuildContext context, String message) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext cxt) {
      // return Align(
      //   alignment: Alignment.center,
      //   child: Padding(
      //     padding: EdgeInsets.all(16),
      //     child: Material(
      //       color: Colors.green,
      //       shape: RoundedRectangleBorder(
      //           borderRadius: BorderRadius.circular(15)),
      //       child: Padding(
      //         padding: EdgeInsets.all(16),
      //         child: Column(
      //           mainAxisSize: MainAxisSize.min,
      //           children: [
      //             Row(
      //               children: [
      //                 InkWell(
      //                     onTap: () {
      //                       Navigator.of(context).pop();
      //                     },
      //                     child: Image.asset("assets/close.png")),
      //                 SizedBox(width: 16),
      //                 Expanded(
      //                   child: Text(
      //                     message,
      //                     style: TextStyle(
      //                       color: Colors.white,
      //                     ),
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
      //   ),
      // );
      return Align(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Group Title",
              style: TextStyle(color: Colors.black),
            ),
            const HeightSpace(),
            Container(
              decoration: BoxDecoration(
                color: DColors.white,
                borderRadius: BorderRadius.circular(DPadding.half),
              ),
              child: TextFormField(
            //    controller: titleTextEditingController,
               // focusNode: focusNode,
                //onTap: (){setState(() {});},
                //onTapOutside: (s){setState(() {});},
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.fromLTRB(5, 3, 3, 3),
                  border: const OutlineInputBorder(
                      borderSide: BorderSide.none
                  ),

                  hintStyle: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],),
      );

    },
  );
}

void showGroupEditingDialog(
    BuildContext context,
    ConversationController convsController,
    int convsIndex,
    Function() setState) {

  //showCustomDialog(context, "abc");

  showGeneralDialog(
    context: context,
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 650),
    pageBuilder: (_, __, ___) {
      FocusNode focusNode = FocusNode();
      TextEditingController titleTextEditingController = TextEditingController();
      titleTextEditingController.text = convsController.conversations[convsIndex].title!;

      String updatedImageUrl = "";

      return GetX<ConversationController>(
  builder: (controller){
  return Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16,16,16,25),
          child: Material(
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          InkWell(
                            onTap: (){
                              print("Image Clicked");
                              convsController.uploadImageAsMultipartLaravel((imageUrl, filename){
                                updatedImageUrl = imageUrl;
                                convsController.conversations[convsIndex].photo = imageUrl;
                                convsController.conversations.refresh();
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black12,
                                  ),
                                  borderRadius: const BorderRadius.all(Radius.circular(50))
                              ),
                              margin: const EdgeInsets.only(top: 10, bottom: 10),
                              child: ClipOval(
                                child: Image.network(convsController.conversations[convsIndex].photo!, height: 70,width: 70,),
                              ),
                            ),
                          ),
                          const Text(
                            "Group Photo",
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      )

                    ],
                  ),
                  const HeightSpace(height: 20,),
                  const Text(
                    "Group Title",
                    style: TextStyle(color: Colors.black),
                  ),
                  const HeightSpace(),
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: DColors.white,
                      borderRadius: BorderRadius.circular(DPadding.half),
                    ),
                    child: TextFormField(
                      controller: titleTextEditingController,
                      focusNode: focusNode,
                      //onTap: (){setState(() {});},
                      //onTapOutside: (s){setState(() {});},
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.fromLTRB(5, 3, 3, 3),
                        border: const OutlineInputBorder(
                          //  borderSide: BorderSide.none
                        ),

                        hintStyle: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),

                  InkWell(
                    onTap: (){
                    //  print("Update Clicked");

                      if(updatedImageUrl.length>1 || titleTextEditingController.text.length>1) {

                       // print("Image and title updated");
                        convsController.conversations[convsIndex].title = titleTextEditingController.text;
                        convsController.conversations.refresh();
                        convsController.updateConversation(
                            convsController.conversations[convsIndex].id!,
                            titleTextEditingController.text.isEmpty? convsController.conversations[convsIndex].title : titleTextEditingController.text,
                            updatedImageUrl.isEmpty?convsController.conversations[convsIndex].photo: updatedImageUrl
                        );
                        Navigator.pop(context);
                        }else {
                       // print("Image: ${updatedImageUrl}");
                       // print("Title: ${titleTextEditingController.text}");
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.green
                      ),
                      alignment: Alignment.center,
                      child: const Text("Update", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: DColors.white),),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
  });
    },
    transitionBuilder: (_, anim, __, child) {
      Tween<Offset> tween;
      if (anim.status == AnimationStatus.reverse) {
        tween = Tween(begin: const Offset(-1, 0), end: Offset.zero);
      } else {
        tween = Tween(begin: const Offset(1, 0), end: Offset.zero);
      }

      return SlideTransition(
        position: tween.animate(anim),
        child: FadeTransition(
          opacity: anim,
          child: child,
        ),
      );
    },
  );
}