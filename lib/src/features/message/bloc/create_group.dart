import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:neways3/src/features/contacts/controllers/ContactController.dart';
import 'package:neways3/src/features/contacts/models/employee_response_model.dart';
import 'package:neways3/src/features/main/MainPage.dart';
import 'package:neways3/src/features/message/ChatScreen.dart';
import 'package:neways3/src/features/message/controllers/SocketController.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../controllers/ConvsCntlr.dart';
import '../models/Message.dart';

List<EmployeeResponseModel> groupEmployees = <EmployeeResponseModel>[];

class CreateGroupWidget extends StatefulWidget {
  ContactController contactController;
  ConversationController convsController;
  EmployeeResponseModel currentEmployee;
  IO.Socket socket;

  CreateGroupWidget(this.contactController, this.convsController,
      this.currentEmployee, this.socket,
      {Key? key})
      : super(key: key);

  @override
  State<CreateGroupWidget> createState() => _CreateGroupWidgetState();
}

class _CreateGroupWidgetState extends State<CreateGroupWidget> {
  // final searchController = Get.put(SearchController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  refreshFullPage() {
    print("refreshFullPage called");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //widget.contactController.getUsersDataExceptOne(widget.currentEmployee.fullName, widget.currentEmployee.email);
      widget.contactController.getAllEmployee(size: 20);
    });
    return WillPopScope(
      onWillPop: () async {
        groupEmployees.clear();
        //socket.clearListeners();
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => MainPage(socket!, 0)));
        return true;
      },
      child: GetBuilder<ContactController>(
          init: ContactController(),
          builder: (contactController) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                leading: BackButton(
                  color: Colors.black,
                  onPressed: () =>
                      Navigator.of(context, rootNavigator: true).pop(),
                ),
                title: Text(
                  "Create a Group Chat",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w900),
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      //method to show the search bar
                      showSearch(
                          context: context,
                          // delegate to customize the search bar
                          delegate: CustomSearchDelegate(
                              widget.contactController, refreshFullPage));
                    },
                    icon: const Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                  )
                ],
              ),
              body: GroupWidget(contactController, widget.convsController,
                  widget.currentEmployee, widget.socket, refreshFullPage),
            );
          }),
    );
  }
}

class GroupWidget extends StatefulWidget {
  ContactController contactController;
  Function() refreshFullPage;
  ConversationController convsController;
  EmployeeResponseModel currentEmployee;

  //List<User> users = <User>[];
  IO.Socket socket;

  GroupWidget(this.contactController, this.convsController,
      this.currentEmployee, this.socket, this.refreshFullPage,
      {Key? key})
      : super(key: key);

  @override
  State<GroupWidget> createState() => _GroupWidgetState();
}

class _GroupWidgetState extends State<GroupWidget>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final random = Random();

    // Generate a random color.
    var _color = Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1,
    );

    // Generate a random border radius.
    var _borderRadius = BorderRadius.circular(random.nextInt(100).toDouble());

    return Container(
      margin: EdgeInsets.fromLTRB(10, 7, 10, 10),
      child: Column(
        children: [
          MaterialButton(
              padding: EdgeInsets.only(left: 5),
              height: 50,
              onPressed: () {},
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 17.0,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    backgroundColor: Colors.blueAccent,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15),
                    child: Text(
                      "Friends",
                      style: TextStyle(fontSize: 17, color: Colors.black),
                    ),
                  )
                ],
              )),
          MaterialButton(
              padding: EdgeInsets.only(left: 5),
              height: 50,
              onPressed: () {},
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 17.0,
                    child: Icon(
                      Icons.contact_phone_sharp,
                      color: Colors.white,
                      size: 18,
                    ),
                    backgroundColor: Colors.cyan[700],
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15),
                    child: Text(
                      "Contacts",
                      style: TextStyle(fontSize: 17, color: Colors.black),
                    ),
                  )
                ],
              )),
          MaterialButton(
              padding: EdgeInsets.only(left: 5),
              height: 50,
              onPressed: () {},
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 17.0,
                    child: Icon(
                      Icons.group_rounded,
                      color: Colors.white,
                    ),
                    backgroundColor: Colors.green,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15),
                    child: Text(
                      "Select aGroup",
                      style: TextStyle(fontSize: 17, color: Colors.black),
                    ),
                  )
                ],
              )),
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.fromLTRB(5, 10, 0, 5),
            child: Text(
              "Select Contact",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: widget.contactController.employees.length,
                  itemBuilder: (context, index) {
                    return EmployeeItem(widget.contactController, index,
                        widget.refreshFullPage);
                  })),
          Card(
              margin: EdgeInsets.all(5),
              elevation: 2,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.white70, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 3,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      // Provide an optional curve to make the animation feel smoother.
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      //margin: EdgeInsets.fromLTRB(5,5,5,5),
                      height: groupEmployees.isEmpty ? 0 : 80,
                      curve: Curves.fastOutSlowIn,
                      padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
                              child: Text(
                                "Selected Contact: ( ${groupEmployees.length} )",
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: ListView.builder(
                              //physics: const NeverScrollableScrollPhysics(),
                              itemCount: groupEmployees.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                // return EmployeeItem(selecteUsers, index);
                                int animDuraton = 2000;
                                if (index > 0) animDuraton = 1000;

                                AnimationController _controller =
                                    AnimationController(
                                        vsync: this,
                                        duration: Duration(
                                            milliseconds: animDuraton));

                                return SelectedUserWidget(_controller, index);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.bottomRight,
                      //margin: EdgeInsets.all(5),
                      child: MaterialButton(
                        color: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22.0)),
                        clipBehavior: Clip.antiAlias,
                        elevation: 8,
                        onPressed: () {
                          //todo... goto next page

                          showCustomDialog(
                              context,
                              widget.convsController,
                              widget.contactController,
                              widget.currentEmployee,
                              widget.socket);
                        },
                        child:
                            Text("Next", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  )
                ],
              )),
        ],
      ),
    );
  }
}

class SelectedUserWidget extends StatelessWidget {
  AnimationController animationController;
  int index;
  SelectedUserWidget(this.animationController, this.index, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // _controller.forward().then((value) => _controller.dispose());
    Future.delayed(Duration(milliseconds: index * 300), () {
      animationController.forward().then((_) {
        // Animation finished, clean up the controller.
        animationController.dispose();

        // if (mounted) {
        //   setState(() {});
        // }
      });
    });

    return FadeTransition(
        opacity: animationController,
        child: Container(
          margin: EdgeInsets.fromLTRB(5, 10, 10, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(
                flex: 2,
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                      "https://cdn-icons-png.flaticon.com/512/2815/2815428.png"),
                  backgroundColor: Colors.transparent,
                ),
              ),
              Expanded(
                child: Text(
                  groupEmployees[index].fullName.toString(),
                  style: TextStyle(fontSize: 12),
                ),
              )
            ],
          ),
        ));
  }
}

class EmployeeItem extends StatefulWidget {
  ContactController contactController;
  Function() refreshFullPage;
  int index;
  EmployeeItem(this.contactController, this.index, this.refreshFullPage,
      {Key? key})
      : super(key: key);

  @override
  State<EmployeeItem> createState() => _EmployeeItemState();
}

class _EmployeeItemState extends State<EmployeeItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        margin: EdgeInsets.fromLTRB(5, 0, 5, 2),
        child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: () {
              debugPrint('Card tapped.');
              print(widget.contactController.employees[widget.index].fullName);

              //todo...

              //select or remove contact

              if (groupEmployees.length == 0) {
                groupEmployees
                    .add(widget.contactController.employees[widget.index]);
                print("Now Added");
                widget.contactController.refresh();
                // widget.refreshFullPage();
              } else {
                bool found = false;
                for (int i = 0; i < groupEmployees.length; i++) {
                  if (groupEmployees[i].employeeId ==
                      widget.contactController.employees[widget.index]
                          .employeeId) {
                    found = true;
                    groupEmployees.removeAt(i);
                    print("Now Removed");
                    widget.contactController.refresh();
                    // widget.refreshFullPage();
                    return;
                  }
                }
                if (!found) {
                  groupEmployees
                      .add(widget.contactController.employees[widget.index]);

                  print("Now Added");
                  widget.contactController.refresh();
                  //widget.refreshFullPage();
                }
              }
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 15, 0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(3),
                    child: CircleAvatar(
                      radius: 9,
                      backgroundColor: Colors.white,
                      backgroundImage: groupEmployees.any((element) =>
                              element.employeeId ==
                              widget.contactController.employees[widget.index]
                                  .employeeId)
                          ? const AssetImage('assets/images/check_mark.png')
                          : null,
                      // backgroundImage: groupEmployees.contains(
                      //         widget.contactController.employees[widget.index])
                      //     ? AssetImage('assets/images/check_mark.png')
                      //     : null,
                    ),
                  ),
                ),
                ClipOval(
                  child: CachedNetworkImage(
                      imageUrl: widget
                          .contactController.employees[widget.index].photo!,
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
                    margin: EdgeInsets.only(left: 15),
                    child: Text(widget
                        .contactController.employees[widget.index].fullName
                        .toString()))
              ],
            )),
      ),
    );
  }
}

void showCustomDialog(
    BuildContext context,
    ConversationController convsController,
    ContactController contactController,
    EmployeeResponseModel currentEmployee,
    IO.Socket socket) {
  print("Next Clicked: " + groupEmployees.length.toString());

  TextEditingController groupNameController = TextEditingController();

  showGeneralDialog(
    context: context,
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: Duration(milliseconds: 500),
    pageBuilder: (_, __, ___) {
      return Center(
        child: Container(
          height: 300,
          margin: EdgeInsets.symmetric(horizontal: 20),
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              Flexible(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25.0),
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0, 3),
                          blurRadius: 7,
                          color: Colors.blueGrey)
                    ],
                  ),
                  child: Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Material(
                      child: TextField(
                        controller: groupNameController,
                        decoration: const InputDecoration(
                          hintText: "Name of the group",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                        onChanged: (text) {
                          //todo.... search user...
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.fromLTRB(5, 35, 5, 5),
                child: Text(
                  "Selected Contact",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: ListView.builder(
                      itemCount: groupEmployees.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        // return EmployeeItem(selecteUsers, index);
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                          child: Container(
                            margin: EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const CircleAvatar(
                                  radius: 15,
                                  backgroundImage: NetworkImage(
                                      "https://cdn-icons-png.flaticon.com/512/2815/2815428.png"),
                                  backgroundColor: Colors.transparent,
                                ),
                                Text(
                                  groupEmployees[index].fullName.toString(),
                                  style: TextStyle(fontSize: 10),
                                )
                              ],
                            ),
                          ),
                        );
                      })),
              Expanded(
                child: Container(
                  alignment: Alignment.bottomRight,
                  margin: EdgeInsets.all(5),
                  child: MaterialButton(
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22.0)),
                    clipBehavior: Clip.antiAlias,
                    elevation: 8,
                    onPressed: () {
                      //todo... goto next page
                      print("Submit Clicked!");
                      List<String> seenBy = <String>[];
                      seenBy.add(currentEmployee.employeeId.toString());

                      List<String> receivedBy = <String>[];
                      receivedBy.add(currentEmployee.employeeId.toString());
                      List<React> reacts = <React>[];

                      Message message = Message(
                          id: "id should be generate",
                          sender: currentEmployee,
                          recipients: groupEmployees,
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
                      groupEmployees.add(currentEmployee);

                      String photo = "https://i.ibb.co/4sq8bwf/group.png";
                      List<EmployeeResponseModel> admins =
                          <EmployeeResponseModel>[];

                      convsController.sendFirstMessage(
                          context,
                          socket,
                          contactController,
                          convsController,
                          null,
                          groupEmployees,
                          groupNameController.text,
                          message,
                          "Group",
                          photo,
                          currentEmployee,
                          admins);

                      Navigator.of(_, rootNavigator: true).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  //HomePage(userController, currentUser, socket, convsController)
                                  MainPage(socket, 0)));
                    },
                    child:
                        Text("Submit", style: TextStyle(color: Colors.white)),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      Tween<Offset> tween;
      if (anim.status == AnimationStatus.reverse) {
        tween = Tween(begin: Offset(-1, 0), end: Offset.zero);
      } else {
        tween = Tween(begin: Offset(1, 0), end: Offset.zero);
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

createGroupConversation(
    BuildContext context,
    ConversationController convsController,
    String title,
    List<EmployeeResponseModel> employees,
    ContactController contactController,
    EmployeeResponseModel currentEmployee,
    List<Message> messages,
    IO.Socket socket) {
  String photo = "https://i.ibb.co/4sq8bwf/group.png";
  List<EmployeeResponseModel> admins = <EmployeeResponseModel>[];
  convsController.sendFirstMessage(
      context,
      socket,
      contactController,
      convsController,
      null,
      employees,
      title,
      messages[0],
      "Group",
      photo,
      currentEmployee,
      admins);
}

class CustomSearchDelegate extends SearchDelegate {
// Demo list to show querying
  ContactController contactController;
  Function() refreshFullPage;

  CustomSearchDelegate(this.contactController, this.refreshFullPage);

// first overwrite to
// clear the search text
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

// second overwrite to pop out of search menu
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

// third overwrite to show query result
  @override
  Widget buildResults(BuildContext context) {
    contactController.search(query);
    return GetBuilder<ContactController>(
      init: ContactController(),
      builder: (controller) {
        return ListView.builder(
          itemCount: contactController.employees.length,
          itemBuilder: (context, index) {
            return ListTile(
                title: EmployeeItem(controller, index, refreshFullPage));
          },
        );
      },
    );
  }

// last overwrite to show the
// querying process at the runtime
  @override
  Widget buildSuggestions(BuildContext context) {
    contactController.search(query);
    return GetBuilder<ContactController>(
      init: ContactController(),
      builder: (controller) {
        return ListView.builder(
          itemCount: contactController.employees.length,
          itemBuilder: (context, index) {
            return ListTile(
                title: EmployeeItem(controller, index, refreshFullPage));
          },
        );
      },
    );
  }
}
