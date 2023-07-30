// ignore_for_file: file_names, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:neways3/src/features/contacts/controllers/ContactController.dart';
import 'package:neways3/src/features/contacts/models/employee_response_model.dart';
import 'package:neways3/src/features/contacts/presentation/AddContactScreen.dart';
import 'package:neways3/src/features/main/MainPage.dart';
import 'package:neways3/src/features/message/bloc/contact_list_page.dart';
import 'package:neways3/src/features/message/models/OnlineEmployee.dart';
import 'package:neways3/src/features/profile/controller/ProfileController.dart';
import 'package:neways3/src/features/profile/controller/ProfileDetailsController.dart';
import 'package:neways3/src/utils/constants.dart';

import '../profile/models/profile_response_model.dart';
import '../profile/services/profile_service.dart';
import 'bloc/create_group.dart';
import 'bloc/group_chat_widget.dart';
import 'bloc/p_to_p_chat_page.dart';
import 'controllers/ConvsCntlr.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

import 'controllers/SocketController.dart';
import 'models/Conversation.dart';
import 'models/Message.dart';

var selectedEmployees = <EmployeeResponseModel>[];
final convsController = Get.put(ConversationController());
final contactController = Get.put(ContactController());
List<OnlineEmployee> onlineEmployees = <OnlineEmployee>[];

class ChatScreen extends StatefulWidget {
  final Socket socket;

  const ChatScreen(this.socket, {Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

void setupAllSocketListeners() {
  setUpPersonToPersonMessagingRealTimeListeners();
  setUpGroupMessagingRealTimeListeners("Group");
  setUpGroupMessagingRealTimeListeners("Default");

  String notifyRecallMessageEvent = "notifyRecallMessage";
  socket!.on(notifyRecallMessageEvent, (data) {
    convsController.onRecallMessage(socket!, data);
  });

  String notifyLockMessageEvent = "notifyLockMessage";
  socket!.on(notifyLockMessageEvent, (data) {
    convsController.onLockMessage(socket!, data);
  });
}

void setUpPersonToPersonMessagingRealTimeListeners() {
  String notifyMessageSendEvent = "notifyMessageSend?convsType=Single";
  socket!.on(notifyMessageSendEvent, (data) {
    convsController.onMessageSend(socket!, data);
  });

  setUpReactionRealTimeListeners("Single");
}

void setUpReactionRealTimeListeners(String convsType) {
  String notifyNewReactAddedEvent = "notifyNewReactAdded?convsType=$convsType";
  socket!.on(notifyNewReactAddedEvent, (data) {
    convsController.onNewReactAdded(socket!, data);
  });

  String notifyReactRemovedEvent = "notifyReactRemoved?convsType=$convsType";
  socket!.on(notifyReactRemovedEvent, (data) {
    print(
        "notifyReactRemovedEvent called......................................................................");

    convsController.onReactRemoved(socket!, data);
  });
}

void setUpJoinAndLeaveListener(String currentEmployeeId) {
  print(
      "Current Employee Id is: ${convsController.currentEmployee!.employeeId!}");

  socket!.on("onJoin:$currentEmployeeId", (data) {
    print('You have Joined now!');
    onlineEmployees.clear();
    for (int i = 0; i < data.length; i++) {
      Map<String, dynamic> jsonMap = data[i] as Map<String, dynamic>;
      OnlineEmployee newOnlineEmployee = OnlineEmployee.fromJson(jsonMap);
      onlineEmployees.add(newOnlineEmployee);
    }
  });

  socket!.on("notifyJoin", (data) {
    print("notifyJoin called");
    var jsonMap = data as Map<String, dynamic>;
    //print(data);
    print("Join an employee: ${jsonMap['employee_id']}");
    jsonMap['status'] = "1";
    OnlineEmployee newOnlineEmployee = OnlineEmployee.fromJson(jsonMap);
    print(newOnlineEmployee.toJson());
    int onlineEmployeeIndex = onlineEmployees.indexWhere((element) => element.employeeId==newOnlineEmployee.employeeId);
    if(onlineEmployeeIndex > -1) {
      onlineEmployees.removeAt(onlineEmployeeIndex);
    }
    onlineEmployees.add(newOnlineEmployee);

    convsController.conversations.refresh();
  });
}

void setUpGroupMessagingRealTimeListeners(String convsType) {

  print("setUpGroupMessagingRealTimeListeners called");
  String notifyMessageSendEvent = "notifyMessageSend?convsType=$convsType";
  socket!.on(notifyMessageSendEvent, (data) {
    convsController.onMessageSend(socket!, data);
  });
  setUpReactionRealTimeListeners(convsType);
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  int index = 0;
 // final convsController = Get.put(ConversationController());
//  final contactController = Get.put(ContactController());
  late FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    myFocusNode.dispose();
    print("App Totally Closed!");
    super.dispose();
  }

  bool openMessage = false;

  refreshMainPage() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController searchContactController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        systemOverlayStyle: const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white, // Navigation bar
          statusBarColor: Colors.white, // Status bar
        ),
        leading: CircleAvatar(
          radius: 10.0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(10),
            child: Image.network(
                "https://cdn.iconscout.com/icon/free/png-256/free-apple-photos-493155.png"),
          ),
        ),
        shadowColor: Colors.transparent,
        toolbarHeight: 50,
        actions: <Widget>[
          FloatingActionButton(
              heroTag: 'btn1',
              tooltip: 'Secret Chat',
              backgroundColor: Colors.white,
              foregroundColor: Colors.white,
              splashColor: Colors.blueAccent,
              elevation: 0,
              child: Icon(
                Icons.mail_lock_outlined,
                color: Colors.black,
              ),
              onPressed: () {}),
          FloatingActionButton(
              heroTag: 'btn2',
              tooltip: ''
                  'Calender',
              backgroundColor: Colors.white,
              foregroundColor: Colors.white,
              splashColor: Colors.blueAccent,
              elevation: 0,
              child: Icon(
                Icons.calendar_month,
                color: Colors.black,
              ),
              onPressed: () {}),
          FloatingActionButton(
              heroTag: 'btn3',
              tooltip: 'Add',
              backgroundColor: Colors.white,
              foregroundColor: Colors.white,
              splashColor: Colors.blueAccent,
              elevation: 0,
              child: PopupMenuButton(
                  // add icon, by default "3 dot" icon
                  // icon: Icon(Icons.book)
                  icon: Icon(
                    Icons.add,
                    color: Colors.black,
                  ),
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem<int>(
                        value: 0,
                        child: Row(
                          children: [
                            Icon(
                              Icons.qr_code_sharp,
                              color: Colors.black,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 15),
                              child: Text("Scan QR Code"),
                            )
                          ],
                        ),
                      ),
                      PopupMenuItem<int>(
                        value: 1,
                        child: Row(
                          children: [
                            Icon(
                              Icons.message_outlined,
                              color: Colors.black,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 15),
                              child: Text("New Chat"),
                            )
                          ],
                        ),
                      ),
                      PopupMenuItem<int>(
                        value: 2,
                        child: Row(
                          children: [
                            Icon(
                              Icons.perm_contact_cal_outlined,
                              color: Colors.black,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 15),
                              child: Text("Add Contact"),
                            )
                          ],
                        ),
                      ),
                    ];
                  },
                  onSelected: (value) {
                    if (value == 0) {
                      print("Scan QR Code menu is selected.");
                    } else if (value == 1) {
                      print("New Chat menu is selected.");
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateGroupWidget(
                                  contactController,
                                  convsController,
                                  convsController.currentEmployee!,
                                  widget.socket)));
                    } else if (value == 2) {
                      print("Add Contact menu is selected.");

                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ContactListPage(
                                  contactController,
                                  convsController,
                                  convsController.currentEmployee!,
                                  widget.socket)));
                    }
                  }),
              onPressed: () {}),
        ],
      ),
      body: Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(10, 5, 10, 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25.0),
                  boxShadow: const [
                    BoxShadow(
                        offset: Offset(0, 3),
                        blurRadius: 25,
                        blurStyle: BlurStyle.inner,
                        color: Colors.blueGrey)
                  ],
                ),
                child: Container(
                  height: 30,
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Material(
                    child: TextField(
                      focusNode: myFocusNode,
                      controller: searchContactController,
                      decoration: const InputDecoration(
                        hintText: "Search",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                        border: InputBorder.none,
                      ),
                      onChanged: (text) {
                        //todo.... search user...
                      },
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.flash_on_outlined,
                            color: Colors.blue, size: 17)),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.alternate_email_outlined,
                          color: Colors.grey,
                          size: 17,
                        )),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.star_border_outlined,
                          color: Colors.grey,
                          size: 17,
                        )),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.watch_later_outlined,
                          color: Colors.grey,
                          size: 17,
                        )),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.file_copy_outlined,
                          color: Colors.grey,
                          size: 17,
                        )),
                  ],
                ),
              ),
              Expanded(child: GetX<ConversationController>(
                builder: (conversationController) {

                  return ListView.builder(
                    itemCount: conversationController.conversations.length,
                    itemBuilder: (context, index) {
                      print("Test1: Conversation Id: ${conversationController.conversations[index].id!} Conversation Type: ${conversationController.conversations[index].type!}");

                      return conversationController.conversations.length > 0 &&
                              convsController
                                      .conversations[index].messages!.length >
                                  0
                          ? ConversationItemWidget(
                              convsController,
                              contactController,
                              convsController.conversations[index],
                              convsController.currentEmployee!,
                              socket!,
                              convsController.conversations[index].id!)
                          : null;
                    },
                  );
                },
              )),
            ],
          )),
    );
  }
}

class ConversationItemWidget extends StatefulWidget {
  ConversationController convsController;
  ContactController contactController;
  Conversation conversation;
  EmployeeResponseModel currentEmployee;
  IO.Socket socket;
  String convsId;

  ConversationItemWidget(this.convsController, this.contactController,
      this.conversation, this.currentEmployee, this.socket, this.convsId,
      {super.key});

  @override
  State<ConversationItemWidget> createState() => _ConversationItemWidgetState();
}

class _ConversationItemWidgetState extends State<ConversationItemWidget> {
  @override
  Widget build(BuildContext context) {
    var otherUserActiveStatus = "Offline";
    print("Online Employee: ${onlineEmployees.length}");



    EmployeeResponseModel? selectedEmployee;

    if (widget.conversation.type == "Single" && onlineEmployees.length > 1) {
      if (widget.conversation.participants![0].employeeId ==
          widget.currentEmployee.employeeId) {
        print("Op:1");
        var otherEmployee = widget.conversation.participants![1];
        print("Test2: Conversation Id: "+widget.conversation.id!+" Conversation Type: "+widget.conversation.type!);
        print("Current Employee Id: "+widget.currentEmployee.employeeId!);
        print("Other Employee Id: "+otherEmployee.employeeId!);

        var onlineParticipantIndex = onlineEmployees.indexWhere((element) => element.employeeId==otherEmployee.employeeId);
        print("onlineParticipantIndex: " +onlineParticipantIndex.toString());

        if(onlineParticipantIndex>-1 && (onlineEmployees[onlineParticipantIndex].status==null || onlineEmployees[onlineParticipantIndex].status=="1")){
          otherUserActiveStatus = "Online";
        }

        // otherUserActiveStatus = onlineEmployees.any(
        //         (element) => (element.employeeId == otherEmployee.employeeId && (element.status == "1" || element.status == null))) //
        //     ? "Online"
        //     : "Offline";


      } else {
        print("Op:2");
        var otherEmployee = widget.conversation.participants![0];
        print("Test2.1: Conversation Id: "+widget.conversation.id!+" Conversation Type: "+widget.conversation.type!);
        print("Current Employee Id: "+widget.currentEmployee.employeeId!);

        print("All Online Employees: ");
        for(int i=0; i<onlineEmployees.length; i++){
          print(jsonEncode(onlineEmployees[i]));
        }

        var onlineParticipantIndex = onlineEmployees.indexWhere((element) => element.employeeId==otherEmployee.employeeId);
        print("onlineParticipantIndex: " +onlineParticipantIndex.toString());


        if(onlineParticipantIndex>-1 && (onlineEmployees[onlineParticipantIndex].status==null || onlineEmployees[onlineParticipantIndex].status=="1")){
          otherUserActiveStatus = "Online";
        }



        // otherUserActiveStatus = onlineEmployees.any(
        //         (element) => element.employeeId == otherEmployee.employeeId && (element.status == "1" || element.status == null))
        //     ? "Online"
        //     : "Offline";
      }
      selectedEmployee =
      widget.conversation.participants![0].employeeId ==
          widget.currentEmployee.employeeId
          ? widget.conversation.participants![1]
          : widget.conversation.participants![0];
    }else if(widget.conversation.type == "Default"){

    } else {
      print("Online employees: ${onlineEmployees.length}");
      selectedEmployee =
      widget.conversation.participants![0].employeeId ==
          widget.currentEmployee.employeeId
          ? widget.conversation.participants![1]
          : widget.conversation.participants![0];
    }

    Message message =
        widget.conversation.messages![widget.conversation.messages!.length - 1];

    String? lastMessage = message.text!.isEmpty
        ? "Photo"
        : widget.conversation
            .messages![widget.conversation.messages!.length - 1].text;

    String? lastMessageTime = message.createdAt;



    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        elevation: 2,
        child: InkWell(
          onTap: () {
            print(
                "widget.conversation.id:${widget.convsId}");

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => (widget.conversation.type == "Group" ||  widget.conversation.type == "Default")
                        ? GroupChatWidget(
                            widget.convsController,
                            widget.currentEmployee,
                            widget.currentEmployee, //Temporary replaced for Selected Employee
                            widget.socket,
                            widget.convsId,
                            widget.contactController)
                        :
                    pToP_ChatPage(
                            widget.convsController,
                            widget.currentEmployee,
                            selectedEmployee!,
                            widget.socket,
                            widget.convsId,
                            widget.contactController)));
          },
          child: Container(
            margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.blueAccent,
                      style: BorderStyle.solid,
                      width: 1.0,
                    ),
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: (widget.conversation.type=="Group" || widget.conversation.type=="Default" )? NetworkImage(widget.conversation.photo!) : NetworkImage(selectedEmployee!.photo!),
                    backgroundColor: Colors.black12,
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(15, 5, 0, 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "${widget.conversation.type == "Single" ? widget.conversation.participants![0].employeeId! == widget.currentEmployee.employeeId ? widget.conversation.participants![1].fullName : widget.conversation.participants![0].fullName : widget.conversation.title}",
                            maxLines: 1,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          alignment: Alignment.topLeft,
                          child: Text(
                            "${message.sender!.fullName!.length > 18 ? message.sender!.fullName!.substring(0, message.sender!.fullName!.indexOf(" ")) : message.sender!.fullName}: $lastMessage",
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 12,
                              color: message.seenBy!.contains(
                                      widget.currentEmployee.employeeId!)
                                  ? Colors.grey
                                  : Colors.black,
                              fontWeight: message.seenBy!.contains(
                                      widget.currentEmployee.employeeId!)
                                  ? FontWeight.normal
                                  : FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          lastMessageTime!,
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ),
                      Visibility(
                        visible:
                            widget.conversation.type == "Group" ? false : true,
                        child: Container(
                          alignment: Alignment.bottomRight,
                          margin: EdgeInsets.only(top: 17),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                  margin: EdgeInsets.only(right: 5),
                                  child: Text(
                                    otherUserActiveStatus.toString(),
                                    style: TextStyle(
                                        color: otherUserActiveStatus != "Online"
                                            ? Colors.grey
                                            : Colors.green,
                                        fontSize: 10),
                                  )),
                              SizedBox(
                                width: 10,
                                height: 10,
                                child: CircleAvatar(
                                    backgroundColor:
                                        otherUserActiveStatus != "Online"
                                            ? Colors.grey
                                            : Colors.green),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showCustomDialog(
      BuildContext context,
      ConversationController convsController,
      ContactController contactController,
      EmployeeResponseModel currentEmployee,
      List<Message> messages,
      IO.Socket socket) {
    print("Next Clicked: ${selectedEmployees.length}");

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
                Container(
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
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.fromLTRB(5, 35, 5, 5),
                  child: Text(
                    "Selected Contact",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
                Expanded(
                    child: ListView.builder(
                        itemCount: selectedEmployees.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          // return EmployeeItem(selecteUsers, index);
                          return Expanded(
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Container(
                                margin: EdgeInsets.all(10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const CircleAvatar(
                                      radius: 20,
                                      backgroundImage: NetworkImage(
                                          "https://cdn-icons-png.flaticon.com/512/2815/2815428.png"),
                                      backgroundColor: Colors.transparent,
                                    ),
                                    Text(
                                      selectedEmployees[index]
                                          .fullName
                                          .toString(),
                                      style: TextStyle(fontSize: 10),
                                    )
                                  ],
                                ),
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

                        messages.add(Message(
                            id: "id should be generate",
                            sender: currentEmployee,
                            recipients: selectedEmployees,
                            text: "Let's Chat...",
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
                            replyOf: null));

                        selectedEmployees.add(currentEmployee);
                        createGroupConversation(
                            context,
                            convsController,
                            groupNameController.text,
                            selectedEmployees,
                            contactController,
                            currentEmployee,
                            messages,
                            socket);
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
}
