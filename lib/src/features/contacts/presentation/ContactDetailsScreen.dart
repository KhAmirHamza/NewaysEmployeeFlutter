// ignore_for_file: file_names, must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neways3/src/features/contacts/controllers/ContactController.dart';
import 'package:neways3/src/features/contacts/models/employee_response_model.dart';
import 'package:neways3/src/features/message/ChatScreen.dart';
import 'package:neways3/src/features/message/bloc/single_chat_page.dart';
import 'package:neways3/src/features/message/controllers/ConvsCntlr.dart';
import 'package:neways3/src/features/message/controllers/SocketController.dart';
import 'package:neways3/src/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../main/MainPage.dart';
import '../../message/models/Conversation.dart';
import '../../message/models/Message.dart';

class ContactDetailsScreen extends StatelessWidget {
  EmployeeResponseModel employee;
  ContactDetailsScreen({Key? key, required this.employee}) : super(key: key);
  final controller = Get.put(ContactController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: double.infinity,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: DPadding.full, vertical: DPadding.half),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeightSpace(height: DPadding.half),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(DPadding.half),
                                color: DColors.background,
                              ),
                              child: const Icon(Icons.arrow_back,
                                  color: DColors.primary),
                            ),
                          ),
                          const InkWell(
                            child: Icon(
                              Icons.more_horiz_rounded,
                              size: 26,
                              color: DColors.primary,
                            ),
                          )
                        ],
                      ),
                      HeightSpace(height: DPadding.full),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(DPadding.half),
                              child: CachedNetworkImage(
                                imageUrl: employee.photo!,
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: ((context, error, stackTrace) =>
                                    Center(
                                      child: Text(
                                        "No Image",
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey.shade400),
                                      ),
                                    )),
                                width: 65,
                                height: 65,
                                fit: BoxFit.fill,
                              )),
                          WidthSpace(width: DPadding.full),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(employee.fullName!,
                                    style: DTextStyle.textTitleStyle),
                                HeightSpace(height: DPadding.half / 2),
                                Text("🎉 ${employee.designationName}",
                                    style: DTextStyle.textSubTitleStyle),
                                const HeightSpace(height: 4),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: DPadding.full,
                                      vertical: DPadding.half / 2),
                                  decoration: BoxDecoration(
                                      color: employee.status! == 1
                                          ? Colors.green.withOpacity(0.2)
                                          : Colors.red.withOpacity(0.2),
                                      borderRadius:
                                          BorderRadius.circular(DPadding.full)),
                                  child: Text(
                                      (employee.status! == 1 || employee.status! == "1")
                                          ? "On Duty"
                                          : "Off Duty",
                                      style: TextStyle(
                                          color: employee.status! == 1
                                              ? Colors.green
                                              : Colors.red,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold)),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      HeightSpace(height: DPadding.full),
                      Divider(
                        thickness: DPadding.half,
                        color: Colors.grey.shade100,
                      ),
                      Text(
                        "Organization information",
                        style: DTextStyle.textTitleStyle3,
                      ),
                      HeightSpace(height: DPadding.full),
                      ContactListTile(
                        leading: "Name",
                        title: employee.fullName!,
                        trailing: false,
                        onPress: (() {}),
                      ),
                      Visibility(
                        visible: employee.departmentName != "Top Management ",
                        child: isDepHead
                            ? ContactListTile(
                                leading: "Personal Number",
                                title: employee.personalPhone!,
                                trailing: true,
                                onPress: (() async {
                                  final Uri phoneLaunchUri = Uri(
                                    scheme: 'tel',
                                    path: employee.personalPhone!,
                                  );

                                  await launchUrl(phoneLaunchUri);
                                }),
                              )
                            : const SizedBox(),
                      ),
                      Visibility(
                        visible: employee.status! == 1 &&
                            employee.departmentName != "Top Management ",
                        child: ContactListTile(
                          leading: "Company Number",
                          title: employee.companyPhone!,
                          trailing: true,
                          onPress: (() async {
                            final Uri phoneLaunchUri = Uri(
                              scheme: 'tel',
                              path: employee.companyPhone!,
                            );

                            await launchUrl(phoneLaunchUri);
                          }),
                        ),
                      ),
                      ContactListTile(
                        leading: "Email Address",
                        title: employee.email!,
                        trailing: true,
                        onPress: (() async {
                          final Uri emailLaunchUri = Uri(
                            scheme: 'mailto',
                            path: employee.email!,
                          );

                          await launchUrl(emailLaunchUri);
                        }),
                      ),
                      ContactListTile(
                        leading: "Department",
                        title: employee.departmentName!,
                        trailing: false,
                        onPress: (() {}),
                      ),
                      ContactListTile(
                        leading: "Designation",
                        title: employee.designationName!,
                        trailing: false,
                        onPress: (() {}),
                      ),
                      ContactListTile(
                        leading: "Location",
                        title: "Head Office",
                        trailing: false,
                        onPress: (() {}),
                      ),
                      ContactListTile(
                        leading: "Employee ID",
                        title: employee.employeeId!,
                        trailing: false,
                        onPress: (() {}),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: DPadding.full,
                left: DPadding.full,
                right: DPadding.full,
                child: Row(
                  mainAxisAlignment:
                      employee.departmentName != "Top Management "
                          ? MainAxisAlignment.spaceEvenly
                          : MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: (){

                        bool convsAvailable = false;
                        int convsIndex = 0;
                        for(int i=0; i<convsController.conversations.length; i++){
                          if(convsController.conversations[i].type=='Single' &&
                              convsController.conversations[i].participants!.any((element) => element.employeeId == employee.employeeId)){
                            convsAvailable = true;
                            convsIndex = i;
                            break;
                          }
                        }
                        if(convsAvailable){
                          // Open P to p chat page
                          print("Conversation Available");
                          print(employee.employeeId);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SingleChatPage(
                                      convsController,
                                      convsController.currentEmployee!,
                                      employee,
                                      socket!,
                                      convsController.conversations[convsIndex].id!,
                                      contactController)));
                        }else{
                          // start first time chat...
                          print("Conversation not Available");
                          print(employee.employeeId);


                          List<String> seenBy = <String>[];
                          List<String> receivedBy = <String>[];
                          seenBy.add(convsController.currentEmployee!.employeeId.toString());
                          receivedBy.add(convsController.currentEmployee!.employeeId.toString());

                          List<React> reacts = <React>[];
                          String photo = "photo";
                          List<EmployeeResponseModel> admins = <EmployeeResponseModel>[];


                          Message message = Message(
                              id: "Initial",
                              sender: convsController.currentEmployee,
                              recipients: [employee],
                              texts: [],
                              seenBy: seenBy,
                              receivedBy: receivedBy,
                              attachments: [
                                Attachment(
                                    type: "photo",
                                    url:
                                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTKTSNwcT2YrRQJKGVQHClGtQgp1_x8kLd0Ig&usqp=CAU")
                              ],
                              reacts: reacts,
                              recall: 0,
                              replyOf: null);

                          convsController.sendFirstMessage(context, socket!, contactController, convsController, employee, null,
                              employee.fullName!, message , "Single", photo, convsController.currentEmployee!, admins);


                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                  //HomePage(widget.userController, widget.currentUser, widget.socket, widget.convsController)
                                  MainPage(socket!, 0)));

                          // convsController.getMessages(convsController.conversations.last.id!, 0, 50, 10);
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => SingleChatPage(
                          //             convsController,
                          //             convsController.currentEmployee!,
                          //             employee,
                          //             socket!,
                          //             convsController.conversations.last.id!,
                          //             contactController)));
                        }
                      },
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(DPadding.half),
                            decoration: BoxDecoration(
                                color: DColors.primary,
                                borderRadius: BorderRadius.circular(50)),
                            child: const Icon(
                              Icons.message_rounded,
                              color: Colors.white,
                            ),
                          ),
                          const HeightSpace(),
                          const Text(
                            "Send message",
                            style: TextStyle(
                                color: DColors.primary,
                                fontSize: 13,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    Visibility(
                      visible: employee.departmentName != "Top Management ",
                      child: InkWell(
                        onTap: () async {
                          final Uri phoneLaunchUri = Uri(
                            scheme: 'tel',
                            path: employee.personalPhone!,
                          );

                          await launchUrl(phoneLaunchUri);
                        },
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(DPadding.half),
                              decoration: BoxDecoration(
                                  color: DColors.primary,
                                  borderRadius: BorderRadius.circular(50)),
                              child: const Icon(
                                Icons.call,
                                color: Colors.white,
                              ),
                            ),
                            const HeightSpace(),
                            const Text(
                              "Call",
                              style: TextStyle(
                                  color: DColors.primary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ContactListTile extends StatelessWidget {
  final String leading;
  final String title;
  bool trailing;
  VoidCallback onPress;
  ContactListTile({
    Key? key,
    required this.leading,
    required this.title,
    required this.onPress,
    this.trailing = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: DPadding.full),
      child: InkWell(
        onTap: onPress,
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                leading,
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: Colors.grey.shade700),
              ),
            ),
            Expanded(
              flex: 5,
              child: Text(
                title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.grey.shade800),
              ),
            ),
            Expanded(
              flex: 1,
              child: trailing
                  ? Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 18,
                      color: Colors.grey.shade600,
                    )
                  : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
