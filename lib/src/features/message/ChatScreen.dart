// ignore_for_file: file_names, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:neways3/src/features/contacts/controllers/ContactController.dart';
import 'package:neways3/src/features/contacts/models/employee_response_model.dart';
import 'package:neways3/src/features/message/bloc/contact_list_page.dart';
import 'package:neways3/src/features/message/functions.dart';
import 'package:neways3/src/features/message/models/OnlineEmployee.dart';
import 'bloc/create_group.dart';
import 'bloc/group_chat_widget.dart';
import 'bloc/single_chat_page.dart';
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
   // print("notifyReactRemovedEvent called......................................................................");

    convsController.onReactRemoved(socket!, data);
  });
}

void setUpJoinListener(String currentEmployeeId) {
  //print("Current Employee Id is: ${convsController.currentEmployee!.employeeId!}");

  socket!.on("onJoin:$currentEmployeeId", (data) {
   // print('You have Joined now!');

    onlineEmployees.clear();
    for (int i = 0; i < data.length; i++) {
      Map<String, dynamic> jsonMap = data[i] as Map<String, dynamic>;
      OnlineEmployee newOnlineEmployee = OnlineEmployee.fromJson(jsonMap);
      onlineEmployees.add(newOnlineEmployee);
    }
  });

  socket!.on("notifyJoin", (data) {
    print("notifyJoin Called: ${jsonEncode(data).toString()}");
    var jsonMap = data as Map<String, dynamic>;
    //print(data);
   // print("Join an employee: ${jsonMap['employee_id']}");
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

void setUpLeaveListener(Function(OnlineEmployee onlineEmployee) setState) {
  //print("Current Employee Id is: ${convsController.currentEmployee!.employeeId!}");

  socket!.on("notifyLeave", (data) {
    print("notifyLeave Called: ${jsonEncode(data).toString()}");
    if(data==null) return;
    var jsonMap = data as Map<String, dynamic>;
    jsonMap['status'] = "0";
    OnlineEmployee newOnlineEmployee = OnlineEmployee.fromJson(jsonMap);

    setState(newOnlineEmployee);
  });

}

void setUpGroupMessagingRealTimeListeners(String convsType) {

 // print("setUpGroupMessagingRealTimeListeners called");
  String notifyMessageSendEvent = "notifyMessageSend?convsType=$convsType";
  socket!.on(notifyMessageSendEvent, (data) {
    convsController.onMessageSend(socket!, data);
  });
  setUpReactionRealTimeListeners(convsType);
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  int index = 0;
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
    super.dispose();
  }

  bool openMessage = false;

  refreshMainPage() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {


    TextEditingController searchContactController = TextEditingController();
    return GetX<ConversationController>(
        builder: (conversationController) {
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
                  padding: const EdgeInsets.all(10),
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
                    child: const Icon(
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
                    child: const Icon(
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
                        icon: const Icon(
                          Icons.add,
                          color: Colors.black,
                        ),
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem<int>(
                              value: 0,
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.qr_code_sharp,
                                    color: Colors.black,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 15),
                                    child: const Text("Scan QR Code"),
                                  )
                                ],
                              ),
                            ),
                            PopupMenuItem<int>(
                              value: 1,
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.groups_outlined,
                                    color: Colors.black,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 15),
                                    child: const Text("New Group"),
                                  )
                                ],
                              ),
                            ),
                            PopupMenuItem<int>(
                              value: 2,
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.chat_outlined,
                                    color: Colors.black,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 15),
                                    child: const Text("New Chat"),
                                  )
                                ],
                              ),
                            ),
                          ];
                        },
                        onSelected: (value) {
                          if (value == 0) {
                            // print("Scan QR Code menu is selected.");
                          } else if (value == 1) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CreateGroupWidget(
                                        contactController,
                                        convsController,
                                        convsController.currentEmployee!,
                                        widget.socket)));
                          } else if (value == 2) {
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

            body:
            //(convsController.currentEmployee == null || socket == null || convsController.conversations[index].messages==null)? null :
            Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(10, 5, 10, 0),
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
                        height: 35,
                        margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Material(
                          child: TextField(
                            focusNode: myFocusNode,
                            controller: searchContactController,
                            decoration: const InputDecoration(
                              hintText: "Search Conversation ...",
                              hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
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
                      margin: const EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.flash_on_outlined,
                                  color: Colors.blue, size: 17)),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.alternate_email_outlined,
                                color: Colors.grey,
                                size: 17,
                              )),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.star_border_outlined,
                                color: Colors.grey,
                                size: 17,
                              )),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.watch_later_outlined,
                                color: Colors.grey,
                                size: 17,
                              )),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.file_copy_outlined,
                                color: Colors.grey,
                                size: 17,
                              )),
                        ],
                      ),
                    ),
                    if(convsController.conversations.isNotEmpty)
                      Expanded( child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: conversationController.conversations.length,
                            itemBuilder: (context, index) {
                              return conversationController.conversations.isNotEmpty &&
                                  convsController
                                      .conversations[index].messages!.isNotEmpty
                                  ? ConversationItemWidget(
                                  convsController,
                                  contactController,
                                  convsController.conversations[index],
                                  convsController.currentEmployee!,
                                  socket!,
                                  convsController.conversations[index].id!)
                                  : null;
                            },
                          )
                          ),
                  ],
                )),
          );

        });

  }
}

class ConversationItemWidget extends StatefulWidget {
  final ConversationController convsController;
  final ContactController contactController;
  final Conversation conversation;
  final EmployeeResponseModel currentEmployee;
  final IO.Socket socket;
  final String convsId;

  const ConversationItemWidget(this.convsController, this.contactController,
      this.conversation, this.currentEmployee, this.socket, this.convsId,
      {super.key});

  @override
  State<ConversationItemWidget> createState() => _ConversationItemWidgetState();
}

class _ConversationItemWidgetState extends State<ConversationItemWidget> {
  @override
  Widget build(BuildContext context) {
    var otherUserActiveStatus = "Offline";
    EmployeeResponseModel? selectedEmployee;

    if (widget.conversation.type == "Single" && onlineEmployees.length > 1) {
      if (widget.conversation.participants![0].employeeId ==
          widget.currentEmployee.employeeId) {
        var otherEmployee = widget.conversation.participants![1];
        var onlineParticipantIndex = onlineEmployees.indexWhere((element) => element.employeeId==otherEmployee.employeeId);
        if(onlineParticipantIndex>-1 && (onlineEmployees[onlineParticipantIndex].status==null || onlineEmployees[onlineParticipantIndex].status=="1")){
          otherUserActiveStatus = "Online";
        }
      } else {
        var otherEmployee = widget.conversation.participants![0];
        var onlineParticipantIndex = onlineEmployees.indexWhere((element) => element.employeeId==otherEmployee.employeeId);
        if(onlineParticipantIndex>-1 && (onlineEmployees[onlineParticipantIndex].status==null || onlineEmployees[onlineParticipantIndex].status=="1")){
          otherUserActiveStatus = "Online";
        }
      }
      selectedEmployee =
      widget.conversation.participants![0].employeeId ==
          widget.currentEmployee.employeeId
          ? widget.conversation.participants![1]
          : widget.conversation.participants![0];
    }else if(widget.conversation.type == "Default"){

    } else {
      selectedEmployee =
      widget.conversation.participants![0].employeeId ==
          widget.currentEmployee.employeeId
          ? widget.conversation.participants![1]
          : widget.conversation.participants![0];
    }

    Message message =
        widget.conversation.messages![widget.conversation.messages!.length - 1];

    String lastMessage = "${message.sender!.fullName!.length > 15 ?
    (message.sender!.employeeId == widget.currentEmployee.employeeId? "You":
    message.sender!.fullName!.substring(0, message.sender!.fullName!.indexOf(" ")))

        : message.sender!.fullName}: ";
    if(message.attachments!.isNotEmpty){
      lastMessage = "[Photo]";
    }else{
      for(int i=0; i<message.texts!.length; i++){
        lastMessage+= message.texts![i].value!;
      }
    }


    message.texts!.map((e) => lastMessage+= e.value!);
    String? lastMessageTime = "...";

    if(message.texts!=null  && message.texts!.isNotEmpty){
      message.texts![0].value!.isEmpty
          ? "Photo"
          : buildStringFromTextItems(widget.conversation
          .messages![widget.conversation.messages!.length - 1].texts!);
      lastMessageTime = message.createdAt;
    }



    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: Card(
        elevation: 2,
        child: InkWell(
          onTap: () async {



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
                    SingleChatPage(
                            widget.convsController,
                            widget.currentEmployee,
                            selectedEmployee!,
                            widget.socket,
                            widget.convsId,
                            widget.contactController)));
          },
          child: Container(
            margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black12,
                      style: BorderStyle.solid,
                      width: 1.0,
                    ),
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: CircleAvatar(
                    radius: 22,
                    backgroundImage: (widget.conversation.type=="Group" || widget.conversation.type=="Default" )? NetworkImage(widget.conversation.photo!) : NetworkImage(selectedEmployee!.photo!),
                    backgroundColor: Colors.black12,
                  ),
                ),
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${widget.conversation.type == "Single" ? widget.conversation.participants![0].employeeId! == widget.currentEmployee.employeeId ? widget.conversation.participants![1].fullName : widget.conversation.participants![0].fullName : widget.conversation.title}",
                          maxLines: 1,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          child: Text( lastMessage.length>25?"${lastMessage.substring(0,25)}...":lastMessage,
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
                                  : FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            lastMessageTime!,
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ),
                        Visibility(
                          visible:
                          widget.conversation.type == "Group" ? false : true,
                          child: Container(
                            alignment: Alignment.bottomRight,
                            margin: const EdgeInsets.only(top: 14),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                    margin: const EdgeInsets.only(right: 5),
                                    child: Text(
                                      otherUserActiveStatus.toString(),
                                      style: TextStyle(
                                          color: otherUserActiveStatus != "Online"
                                              ? Colors.grey
                                              : Colors.green,
                                          fontSize: 12),
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
                    )
                  ],),
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
                Container(
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
                Container(
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.fromLTRB(5, 35, 5, 5),
                  child: const Text(
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
                                margin: const EdgeInsets.all(10),
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
                                      style: const TextStyle(fontSize: 10),
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
                    margin: const EdgeInsets.all(5),
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
}
