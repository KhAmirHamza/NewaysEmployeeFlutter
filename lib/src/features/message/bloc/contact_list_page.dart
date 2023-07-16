import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:neways3/src/features/contacts/models/employee_response_model.dart';
import 'package:neways3/src/features/main/MainPage.dart';
import 'package:neways3/src/features/message/ChatScreen.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../contacts/controllers/ContactController.dart';
import '../controllers/ConvsCntlr.dart';
import '../models/Message.dart';
import 'create_group.dart';

class ContactListPage extends StatefulWidget {
  ContactController contactController;
  ConversationController convsController;
  EmployeeResponseModel currentEmployee;
  IO.Socket socket;
  ContactListPage(this.contactController, this.convsController,
      this.currentEmployee, this.socket,
      {super.key});

  @override
  State<ContactListPage> createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  late FocusNode myFocusNode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  TextEditingController searchContactController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ContactController>(
        init: ContactController(),
        builder: (contactController) {
          return Scaffold(
              appBar: AppBar(
                title: const Text(
                  "Select Contact",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                leading: BackButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    color: Colors.black),
              ),
              body: Column(children: <Widget>[
                InkWell(
                  onTap: () {
                    print("Create New Group Taped");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateGroupWidget(
                                widget.contactController,
                                widget.convsController,
                                widget.currentEmployee,
                                widget.socket)));
                  },
                  splashColor: Colors.pink,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                              'https://cdn1.iconfinder.com/data/icons/rcons-user-action/512/add_user_group-512.png',
                              scale: 2),
                          radius: 20,
                          backgroundColor: Colors.white,
                        ),
                        Container(
                            margin: EdgeInsets.fromLTRB(5, 10, 0, 10),
                            child: Text(
                              "Create new group",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )),
                      ],
                    ),
                  ),
                ),
                Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(5, 25, 0, 10),
                    child: Text(
                      "Neways Users",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    )),

                /*Expanded(
                    child: GetX<ContactController>(
                      builder: (controller) {
                        return ListView.builder(
                          itemCount: controller.employees.length,
                          itemBuilder: (context, index) {
                            return ContactWidget(
                                  widget.contactController,
                                  widget.convsController,
                                  widget.currentEmployee,
                                  widget.contactController.employees[index],
                                  widget.socket);
                          },
                        );
                      },
                    ),
                  ),*/
                Container(
                  height: 30,
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Material(
                    child: TextField(
                      focusNode: myFocusNode,
                      controller: contactController.searchController,
                      decoration: const InputDecoration(
                        hintText: "Search",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                        border: InputBorder.none,
                      ),
                      onChanged: (text) {
                        contactController.search(text);
                        //todo.... search user...
                      },
                    ),
                  ),
                ),
                Expanded(
                    child: ListView.builder(
                  itemCount: contactController.employees.length,
                  itemBuilder: (context, index) {
                    print(widget.contactController.employees[index].photo);

                    return ContactWidget(
                        widget.contactController,
                        widget.convsController,
                        widget.currentEmployee,
                        widget.contactController.employees[index],
                        widget.socket);
                  },
                ))
              ]));
        });
  }
}

class ContactWidget extends StatefulWidget {
  ConversationController convsController;
  EmployeeResponseModel currentEmployee, selectedEmployee;
  ContactController contactController;
  List<EmployeeResponseModel> employees = <EmployeeResponseModel>[];
  IO.Socket socket;

  ContactWidget(this.contactController, this.convsController,
      this.currentEmployee, this.selectedEmployee, this.socket,
      {super.key});

  @override
  State<ContactWidget> createState() => _ContactWidgetState();
}

class _ContactWidgetState extends State<ContactWidget> {
  @override
  Widget build(BuildContext context) {
    String title =
        "${widget.currentEmployee.fullName} - ${widget.selectedEmployee.fullName}";

    List<String> seenBy = <String>[];
    List<String> receivedBy = <String>[];
    seenBy.add(widget.currentEmployee.employeeId.toString());
    receivedBy.add(widget.currentEmployee.employeeId.toString());

    List<React> reacts = <React>[];

    Message message = Message(
        id: "Initial",
        sender: widget.currentEmployee,
        recipients: [widget.selectedEmployee],
        text: "Initial",
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

    widget.employees.add(widget.currentEmployee);
    widget.employees.add(widget.selectedEmployee);

    return Card(
      child: InkWell(
        onTap: () {
          String photo = "photo";
          List<EmployeeResponseModel> admins = <EmployeeResponseModel>[];

          widget.convsController.sendFirstMessage(
              context,
              widget.socket,
              widget.contactController,
              widget.convsController,
              widget.selectedEmployee,
              null,
              title,
              message,
              "Single",
              photo,
              widget.currentEmployee,
              admins);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      //HomePage(widget.userController, widget.currentUser, widget.socket, widget.convsController)
                      MainPage(widget.socket, 0)));
        },
        child: Container(
          margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
          child: Row(
            children: [
              ClipOval(
                child: CachedNetworkImage(
                    imageUrl: widget.selectedEmployee.photo!,
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
              Container(
                margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "${widget.selectedEmployee.fullName}",
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "${widget.selectedEmployee.email}",
                        style: TextStyle(fontSize: 10, color: Colors.black87),
                      )
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
