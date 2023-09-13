import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neways3/src/features/contacts/controllers/ContactController.dart';
import 'package:neways3/src/features/contacts/models/employee_response_model.dart';
import 'package:neways3/src/features/main/MainPage.dart';
import 'package:neways3/src/features/message/controllers/SocketController.dart';
import 'package:neways3/src/utils/constants.dart';
import 'package:neways3/src/utils/functions.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../controllers/ConvsCntlr.dart';
import '../models/Message.dart';

List<EmployeeResponseModel> groupEmployees = <EmployeeResponseModel>[];

class CreateGroupWidget extends StatefulWidget {
  final ContactController contactController;
  final ConversationController convsController;
  final EmployeeResponseModel currentEmployee;
  final IO.Socket socket;

  const CreateGroupWidget(this.contactController, this.convsController,
      this.currentEmployee, this.socket,
      {Key? key})
      : super(key: key);

  @override
  State<CreateGroupWidget> createState() => _CreateGroupWidgetState();
}

class _CreateGroupWidgetState extends State<CreateGroupWidget> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    groupEmployees.clear();
    groupEmployees.add(widget.currentEmployee);
  }

  refreshFullPage() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.contactController.getAllEmployee(size: 20);
    });

    return WillPopScope(
      onWillPop: () async {
        groupEmployees.clear();
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
                title: const Text(
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
  final ContactController contactController;
  final Function() refreshFullPage;
  final ConversationController convsController;
  final EmployeeResponseModel currentEmployee;
  final IO.Socket socket;

  const GroupWidget(this.contactController, this.convsController,
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
      margin: const EdgeInsets.fromLTRB(10, 7, 10, 10),
      child: Column(
        children: [
          MaterialButton(
              padding: const EdgeInsets.only(left: 5),
              height: 50,
              onPressed: () {},
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 17.0,
                    backgroundColor: Colors.blueAccent,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    child: const Text(
                      "Friends",
                      style: TextStyle(fontSize: 17, color: Colors.black),
                    ),
                  )
                ],
              )),
          MaterialButton(
              padding: const EdgeInsets.only(left: 5),
              height: 50,
              onPressed: () {},
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 17.0,
                    backgroundColor: Colors.cyan[700],
                    child: const Icon(
                      Icons.contact_phone_sharp,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    child: const Text(
                      "Contacts",
                      style: TextStyle(fontSize: 17, color: Colors.black),
                    ),
                  )
                ],
              )),
          MaterialButton(
              padding: const EdgeInsets.only(left: 5),
              height: 50,
              onPressed: () {},
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 17.0,
                    backgroundColor: Colors.green,
                    child: Icon(
                      Icons.group_rounded,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    child: const Text(
                      "Select aGroup",
                      style: TextStyle(fontSize: 17, color: Colors.black),
                    ),
                  )
                ],
              )),
          Container(
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.fromLTRB(5, 10, 0, 5),
            child: const Text(
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
              margin: const EdgeInsets.all(5),
              elevation: 2,
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.white70, width: 1),
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
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              alignment: Alignment.topLeft,
                              margin: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                              child: Text(
                                "Selected Employees: ( ${groupEmployees.length} )",
                                style: const TextStyle(fontSize: 14, color: Colors.grey),
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

                                return SelectedEmployeeWidget(_controller, index);
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
                            const Text("Next", style: TextStyle(color: Colors.white)),
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

class SelectedEmployeeWidget extends StatelessWidget {
  final AnimationController animationController;
  final int index;
  const SelectedEmployeeWidget(this.animationController, this.index, {Key? key})
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
          margin: const EdgeInsets.fromLTRB(5, 10, 10, 0),
          width: 60,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(groupEmployees[index].photo!),
                  backgroundColor: Colors.transparent,
                ),
              ),
              Expanded(
                child: Text(
                  groupEmployees[index].fullName.toString(),

                  style: const TextStyle(fontSize: 12, overflow: TextOverflow.ellipsis),
                ),
              )
            ],
          ),
        ));
  }
}

class EmployeeItem extends StatefulWidget {
  final ContactController contactController;
  final Function() refreshFullPage;
  final int index;
  const EmployeeItem(this.contactController, this.index, this.refreshFullPage,
      {Key? key})
      : super(key: key);

  @override
  State<EmployeeItem> createState() => _EmployeeItemState();
}

class _EmployeeItemState extends State<EmployeeItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        margin: const EdgeInsets.fromLTRB(5, 0, 5, 2),
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
                //print("Now Added");
                widget.contactController.update();
                // widget.refreshFullPage();
              } else {
                bool found = false;
                for (int i = 0; i < groupEmployees.length; i++) {
                  if (groupEmployees[i].employeeId ==
                      widget.contactController.employees[widget.index]
                          .employeeId) {
                    found = true;
                    groupEmployees.removeAt(i);
                    widget.contactController.update();
                    // widget.refreshFullPage();
                    return;
                  }
                }
                if (!found) {
                  groupEmployees
                      .add(widget.contactController.employees[widget.index]);
                  widget.contactController.update();
                }
              }
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 15, 0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    child: CircleAvatar(
                      radius: 9,
                      backgroundColor: Colors.white,
                      backgroundImage: groupEmployees.any((element) =>
                              element.employeeId ==
                              widget.contactController.employees[widget.index]
                                  .employeeId)
                          ? const AssetImage('assets/images/check_mark.png')
                          : null,
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
                    margin: const EdgeInsets.only(left: 15),
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
  TextEditingController groupNameController = TextEditingController();

  showGeneralDialog(
    context: context,
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 500),
    pageBuilder: (_, __, ___) {
      return Center(
        child: Container(
          height: 300,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              Flexible(
                flex: 1,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25.0),
                    boxShadow: const [
                      BoxShadow(
                          offset: Offset(0, 3),
                          blurRadius: 7,
                          color: Colors.blueGrey)
                    ],
                  ),
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
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
                margin: const EdgeInsets.fromLTRB(5, 35, 5, 5),
                child: const Text(
                  "Selected Employees",
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
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                            width: 60,
                            margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundImage: NetworkImage(groupEmployees[index].photo!),
                                  backgroundColor: Colors.transparent,
                                ),
                                const HeightSpace(),
                                Text(
                                  groupEmployees[index].fullName.toString(),
                                  style: const TextStyle(fontSize: 10, overflow: TextOverflow.ellipsis),

                                )
                              ],
                            ),
                          ),
                        );
                      })),
              Expanded(
                child: Container(
                  alignment: Alignment.bottomRight,
                  margin: const EdgeInsets.all(5),
                  child: MaterialButton(
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22.0)),
                    clipBehavior: Clip.antiAlias,
                    elevation: 8,
                    onPressed: () {
                      //todo... goto next page

                      if(groupNameController.text.isEmpty){
                        showInSnackBar(context, "Enter Group Name...");
                        return;
                      }
                      List<String> seenBy = <String>[];
                      seenBy.add(currentEmployee.employeeId.toString());

                      List<String> receivedBy = <String>[];
                      receivedBy.add(currentEmployee.employeeId.toString());
                      List<React> reacts = <React>[];

                      Message message = Message(
                          id: "id should be generate",
                          sender: currentEmployee,
                          recipients: groupEmployees,
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
                        const Text("Submit", style: TextStyle(color: Colors.white)),
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
        icon: const Icon(Icons.clear),
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
      icon: const Icon(Icons.arrow_back),
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
