import 'package:async_button_builder/async_button_builder.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:neways3/src/features/contacts/controllers/ContactController.dart';
import 'package:neways3/src/features/contacts/models/employee_response_model.dart';
import 'package:neways3/src/features/main/MainPage.dart';
import 'package:neways3/src/features/message/ChatScreen.dart';
import 'package:neways3/src/features/message/bloc/group_details_screen.dart';
import 'package:neways3/src/features/message/models/Conversation.dart';
import 'package:neways3/src/features/message/utils/Constant.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import '../../../utils/constants.dart';
import '../../contacts/presentation/ContactDetailsScreen.dart';
import '../controllers/ConvsCntlr.dart';
import '../controllers/CustomTextEditingController.dart';
import '../controllers/MentionTextEditingController.dart';
import '../functions.dart';
import '../models/Mentionable.dart';
import '../models/Message.dart';
import '../models/MessageTextItem.dart';
import '../widgets/mentionable_text_field_widget.dart';
import '../widgets/typing_indicator.dart';

bool isChatting = false;
Message? replyMessage;

bool isHighlighted = false;
int highlightedIndex = 0;

class GroupChatWidget extends StatefulWidget {
  final ConversationController convsController;
  final EmployeeResponseModel currentEmployee, selectedEmployee;
  final String convsId;
  final dio = Dio();
  final IO.Socket socket;
  final ContactController contactController;

  GroupChatWidget(
      this.convsController,
      this.currentEmployee,
      this.selectedEmployee,
      this.socket,
      this.convsId,
      this.contactController,
      {super.key});

  @override
  State<GroupChatWidget> createState() => _GroupChatWidgetState();

  static void seenMessage(
    ConversationController convsController,
    String convsId,
    String convsType,
    String messageId,
    IO.Socket socket,
    String currentEmployeeId,
  ) {
    if (isChatting) {
      convsController.seenMessage(convsId, convsType, messageId, socket);
    }
  }
}

class _GroupChatWidgetState extends State<GroupChatWidget> {
  List<String> typingUsersId = <String>[];
  late FocusNode myFocusNode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isChatting = true;
    myFocusNode = FocusNode();
    convsController.getMessages(widget.convsId, 0, 50, 10);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    myFocusNode.dispose();
    String typingEvent = "typing"; //sending event name...
    if (typingUsersId.contains(widget.currentEmployee.employeeId)) {
      typingUsersId.remove(widget.currentEmployee.employeeId);
      var json = {
        "convsId": widget.convsId,
        "convsType": widget.convsController.conversations.firstWhere((element) => element.id==widget.convsId).type,
        "typingUsersId": typingUsersId
      };
      widget.socket.emit(typingEvent, json);
    }
    isChatting = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Message message = widget.convsController.conversations.firstWhere((element) => element.id==widget.convsId).messages!.last;
      if (!message.receivedBy!.contains(widget.currentEmployee.employeeId)) {
        widget
            .convsController
            .conversations[widget.convsController.conversations.indexWhere((element) => element.id == widget.convsId)]
            .messages![
        widget.convsController.conversations.firstWhere((element) => element.id==widget.convsId)
                    .messages!.length - 1]
            .receivedBy!
            .add(widget.currentEmployee.employeeId!);

        widget.convsController.receivedMessage(
            widget.convsId,
            widget.convsController.conversations.firstWhere((element) => element.id==widget.convsId).type!,
            message.id!,
            widget.socket);
      }

      if (!message.seenBy!.contains(widget.currentEmployee.employeeId)) {
        widget
            .convsController
            .conversations[widget.convsController.conversations.indexWhere((element) => element.id == widget.convsId)]
            .messages![widget.convsController.conversations.firstWhere((element) => element.id==widget.convsId)
                    .messages!.length - 1]
            .seenBy!
            .add(widget.currentEmployee.employeeId!);

        widget.convsController.seenMessage(
            widget.convsId,
            widget.convsController.conversations.firstWhere((element) => element.id==widget.convsId).type!,
            message.id!,
            widget.socket);

        widget.convsController.conversations.refresh();
      }

      String typingEvent = "typing?convsId=${widget.convsId}"; //typing event name...
        widget.socket.on(typingEvent, (data) {
        var jsonMap = data as Map<String, dynamic>;
        var result = jsonMap['typingUsersId'].toList();
        List<String> ids = <String>[];
        for (int i = 0; i < result.length; i++) {
          ids.add(result[i]);
        }
        typingUsersId = ids;
        setState(() {});
      });

      String notifyMessageReceivedEvent = "notifyMessageReceived?convsType=Group";
      widget.socket.on(notifyMessageReceivedEvent, (data) {
        widget.convsController.onMessageReceived(widget.socket, data);
      });

      String notifyMessageSeenEvent = "notifyMessageSeen?convsType=Group";
      widget.socket.on(notifyMessageSeenEvent, (data) {
        widget.convsController.onMessageSeen(widget.socket, data);
      });
    });

    return WillPopScope(
      onWillPop: () async {
        isChatting = false;
        widget.socket.clearListeners();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          shadowColor: Colors.white,
          elevation: 1,
          leading: BackButton(
            color: Colors.black,
            onPressed: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MainPage(widget.socket, 0)))
            },
          ),
          backgroundColor: Colors.white,
          title: Container(
            margin: const EdgeInsets.only(bottom: 5),
            child: Text( widget.convsController.conversations.firstWhere((element) => element.id==widget.convsId).title
                  .toString(),
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.call_outlined,
                color: Colors.black,
              ),
              tooltip: 'Call Now',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('This feature is coming soon!')));
              },
            ),
            // IconButton(
            //   icon: const Icon(
            //     Icons.more_horiz,
            //     color: Colors.black,
            //   ),
            //   tooltip: 'More',
            //   onPressed: () {
            //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            //         content: Text('This feature is coming soon!')));
            //   },
            // ),
            PopupMenuButton(
              // add icon, by default "3 dot" icon
              // icon: Icon(Icons.book)
                icon: const Icon(
                  Icons.more_horiz,
                  color: Colors.black,
                ),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem<int>(
                      value: 0,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.groups_outlined,
                            color: Colors.black,
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 15),
                            child: const Text("Group Details"),
                          )
                        ],
                      ),
                    ),
                    PopupMenuItem<int>(
                      value: 1,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.group_add_outlined,
                            color: Colors.black,
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 15),
                            child: const Text("Add New Member"),
                          )
                        ],
                      ),
                    ),
                    PopupMenuItem<int>(
                      value: 2,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.remove_circle_outline_sharp,
                            color: Colors.red,
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 15),
                            child: const Text("Leave Group", style: TextStyle(color: Colors.red),),
                          )
                        ],
                      ),
                    ),
                  ];
                },
                onSelected: (value) {
                  if (value == 0) {

                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GroupDetailsScreen(widget.convsId, widget.convsController, widget.currentEmployee)));
                  } else if (value == 1) {
                    //contactController.getAllEmployee();

                    addParticipantToGroupDialog(context, convsController, widget.currentEmployee, contactController, widget.convsId, myFocusNode);
                  } else if (value == 2) {
                   // print("Leave Group");
                    // Navigator.pushReplacement(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => ContactListPage(
                    //             contactController,
                    //             convsController,
                    //             convsController.currentEmployee!,
                    //             widget.socket)));
                  }
                })
          ],
        ),
        body: MessageListWidget(
            widget.convsController,
            widget.currentEmployee,
            widget.selectedEmployee,
            widget.socket,
            widget.convsId,
            typingUsersId,
            widget.contactController,
            myFocusNode),
      ),
    );
  }
}

class MessageListWidget extends StatefulWidget {
  final ConversationController convsController;
  final EmployeeResponseModel currentEmployee, selectedEmployee;
  final IO.Socket socket;
  final String convsId;
  final ContactController contactController;
  final FocusNode myFocusNode;
  final List<String> typingUsersId;
  final dio = Dio();

  MessageListWidget(
      this.convsController,
      this.currentEmployee,
      this.selectedEmployee,
      this.socket,
      this.convsId,
      this.typingUsersId,
      this.contactController,
      this.myFocusNode,
      {super.key});

  @override
  State<MessageListWidget> createState() => _MessageListWidgetState();
}

class _MessageListWidgetState extends State<MessageListWidget> {

  refreshRepliedMessage() {
    setState(() {});
  }

  refreshMainPage() {

    print("refreshMainPage called");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<String> ids = widget.typingUsersId;

    if (ids.contains(widget.currentEmployee.employeeId)) {
      ids.remove(widget.currentEmployee.employeeId);
    }


    final ItemScrollController itemScrollController = ItemScrollController();
    final ScrollOffsetController scrollOffsetController = ScrollOffsetController();
    final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
    final ScrollOffsetListener scrollOffsetListener = ScrollOffsetListener.create();

    var itemsLength = 10;
    bool scroolToTop = true;
    itemPositionsListener.itemPositions.addListener(() async {
      if(!scroolToTop && itemPositionsListener.itemPositions.value.last.index == (itemsLength - 1)){ //
        //print("Scroll to Top: ${itemPositionsListener.itemPositions.value.last.index}");
        scroolToTop = true;
        //Todo....
        await convsController.getMessages(widget.convsId, itemsLength, 5, 10);
        itemsLength +=5;

      }else if(itemPositionsListener.itemPositions.value.last.index != (itemsLength -1)){
        //print("Scroll not to Top: ${itemPositionsListener.itemPositions.value.last.index}");
        scroolToTop = false;
      }
    });

    void _scrollDown() {
      // _scrollController.animateTo(
      //   _scrollController.position.minScrollExtent,
      //   duration: Duration(seconds: 2),
      //   curve: Curves.fastOutSlowIn,
      // );

      itemScrollController.scrollTo(
          index: 0 ,
          duration: const Duration(seconds: 2),
          curve: Curves.easeInOutCubic);

    }



    void _scrollToMessage(index) {
      //print("_scrollToMessage called!: "+index.toString());
      setState(() {
        //highlightedIndex = index;
        isHighlighted = true;
      });
      // Future.delayed(const Duration(milliseconds: 10000), () {
      //   isHighlighted = false;
      //   setState(() {
      //
      //   });
      // });
      itemScrollController.scrollTo(
          index: index ,
          duration: const Duration(seconds: 2),
          curve: Curves.easeInOutCubic);
    }

    CustomTextEditingController customTextEditingController = CustomTextEditingController( widget.convsController, widget.convsId);


    return Column(
      children: <Widget>[
        Expanded(child: GetX<ConversationController>(
          builder: (controller) {
            var items = widget.convsController.conversations.firstWhere((element) => element.id==widget.convsId).messages;

            return ScrollablePositionedList.builder(
              physics: const BouncingScrollPhysics(),
              itemScrollController: itemScrollController,
              scrollOffsetController: scrollOffsetController,
              itemPositionsListener: itemPositionsListener,
              scrollOffsetListener: scrollOffsetListener,
              itemCount: items!.length,
              reverse: true,
              itemBuilder: (context, index) {
                final reversedIndex = items.length - 1 - index;
                final item = items[reversedIndex];

                bool hasSeen = false;
                if (item.seenBy!.contains(widget.selectedEmployee.employeeId)) {
                  hasSeen = true;
                }
                bool hasReceived = false;
                if (item.receivedBy!
                    .contains(widget.selectedEmployee.employeeId)) {
                  hasReceived = true;
                }

                //print("SeenByNow1: ${item.seenBy}");

                int position = getLastSendMessageIndex(
                    widget.currentEmployee.employeeId!, items);

                bool isLastSendMessage = reversedIndex == position;

                String createdAtDate =
                item.createdAt!.toString().substring(0, 10);

                bool hasMessagesAtSameDay = false;
                if (reversedIndex > 0) {
                  String createdAtPreviousDate =
                  items[reversedIndex - 1].createdAt!.substring(0, 10);
                  if (createdAtPreviousDate == createdAtDate) {
                    hasMessagesAtSameDay = true;
                  }
                }
                return Column(
                  children: [
                    Visibility(
                      visible: !hasMessagesAtSameDay,
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 50, 0, 10),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                              color: Colors.blueGrey[400],
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                            child: Text(
                              item.createdAt.toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    (convsController.conversations[convsController.conversations.indexWhere((element) => element.id==widget.convsId)]
                        .messages![reversedIndex].recall ==
                        "1" ||
                        widget.convsController.conversations.firstWhere((element) => element.id==widget.convsId).messages![reversedIndex].recall ==
                            1)
                        ? Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                      child: Text(
                        "${widget.convsController.conversations.firstWhere((element) => element.id==widget.convsId).messages![reversedIndex].sender!.fullName!} has recalled a message",
                        style: const TextStyle(
                            color: Colors.grey, fontSize: 12),
                      ),
                    )
                        :
                    ChatBubble(
                        messageIndex: reversedIndex,
                        convsId: widget.convsId,
                        isCurrentUser: item.sender!.employeeId ==
                            widget.currentEmployee.employeeId,
                        hasSeen: hasSeen,
                        hasReceived: hasReceived,
                        isLastSendMessage: isLastSendMessage,
                        convsController: widget.convsController,
                        socket: widget.socket,
                        currentEmployee: widget.currentEmployee,
                        refreshRepliedMessage: refreshRepliedMessage,
                        refreshMainPage: refreshMainPage,
                        contactController: widget.contactController,
                        selectedEmployee: widget.selectedEmployee,
                        myFocusNode: widget.myFocusNode,
                        scrollToMessage: _scrollToMessage,
                    ),
                  ],
                );
              },
            );

            // return ListView.builder(
            //   reverse: true,
            //   itemCount: items!.length,
            //   itemBuilder: (context, index) {
            //     final reversedIndex = items.length - 1 - index;
            //     final item = items[reversedIndex];
            //
            //     bool hasSeen = false;
            //     if (item.seenBy!.contains(widget.selectedEmployee.employeeId)) {
            //       hasSeen = true;
            //     }
            //     bool hasReceived = false;
            //     if (item.receivedBy!
            //         .contains(widget.selectedEmployee.employeeId)) {
            //       hasReceived = true;
            //     }
            //
            //     print("SeenByNow1: ${item.seenBy}");
            //
            //     int position = getLastSendMessageIndex(
            //         widget.currentEmployee.employeeId!, items);
            //
            //     bool isLastSendMessage = reversedIndex == position;
            //
            //     String createdAtDate =
            //         item.createdAt!.toString().substring(0, 10);
            //
            //     bool hasMessagesAtSameDay = false;
            //     if (reversedIndex > 0) {
            //       String createdAtPreviousDate =
            //           items[reversedIndex - 1].createdAt!.substring(0, 10);
            //       if (createdAtPreviousDate == createdAtDate)
            //         hasMessagesAtSameDay = true;
            //     }
            //     return Column(
            //       children: [
            //         Visibility(
            //           visible: !hasMessagesAtSameDay,
            //           child: Container(
            //             margin: EdgeInsets.fromLTRB(0, 50, 0, 10),
            //             child: DecoratedBox(
            //               decoration: BoxDecoration(
            //                   color: Colors.blueGrey[400],
            //                   borderRadius: BorderRadius.circular(15)),
            //               child: Padding(
            //                 padding: EdgeInsets.fromLTRB(10, 3, 10, 3),
            //                 child: Text(
            //                   item.createdAt.toString(),
            //                   style: TextStyle(color: Colors.white),
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ),
            //         ChatBubble(
            //             messageIndex: reversedIndex,
            //             convsIndex: widget.convsIndex,
            //             isCurrentUser: item.sender!.employeeId ==
            //                 widget.currentEmployee.employeeId,
            //             hasSeen: hasSeen,
            //             hasReceived: hasReceived,
            //             isLastSendMessage: isLastSendMessage,
            //             convsController: widget.convsController,
            //             socket: widget.socket,
            //             currentEmployee: widget.currentEmployee,
            //             refreshRepliedMessage: refreshRepliedMessage,
            //             refreshMainPage: refreshMainPage,
            //             contactController: widget.contactController,
            //             selectedEmployee: widget.selectedEmployee,
            //             myFocusNode: widget.myFocusNode,
            //             scrollToMessage: _scrollToMessage
            //         ),
            //       ],
            //     );
            //   },
            // );
          },
        )),
        TypingIndicator(
          showIndicator: ids.isNotEmpty,
          bubbleColor: Colors.black12,
          flashingCircleBrightColor: Colors.white,
          flashingCircleDarkColor: Colors.blueAccent,
        ),
        replyMessage == null
            ? Container()
            : Visibility(
                visible: replyMessage != null,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                  width: double.infinity,
                  child: DecoratedBox(

                      // chat bubble decoration
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  replyMessage!.sender!.fullName!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                          color: Colors.black87,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.topRight,
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                      onTap: () {
                                        replyMessage = null;
                                        refreshRepliedMessage();
                                      },
                                      child: const Icon(
                                        Icons.close,
                                        size: 20,
                                      )),
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                            child: (replyMessage!.attachments != null &&
                                    replyMessage!.attachments!.isNotEmpty)
                                ? Image.network(replyMessage!
                                    .attachments![0].url
                                    .toString())
                                : Text(
                                buildStringFromTextItems(replyMessage!.texts!),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                            color: Colors.black87,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400),
                                  ),
                          ),
                        ],
                      )),
                ),
              ),
        ChatMessageTypingField(
            widget.convsController,
            widget.currentEmployee,
            widget.selectedEmployee,
            widget.socket,
            widget.convsId,
            widget.typingUsersId,
            customTextEditingController,
            refreshRepliedMessage,
            _scrollDown),
      ],
    );
  }
}

int getLastSendMessageIndex(String currentUserId, List<Message> items) {
  int result = 0;
  for (var i = items.length - 1; i >= 0; i--) {
    if (items[i].sender!.employeeId == currentUserId) {
      result = i;
      break;
    }
  }
  return result;
}

class ChatBubble extends StatefulWidget {
  const ChatBubble(
      {Key? key,
      required this.messageIndex,
      required this.convsId,
      required this.isCurrentUser,
      required this.hasSeen,
      required this.hasReceived,
      required this.isLastSendMessage,
      required this.convsController,
      required this.socket,
      required this.currentEmployee,
      required this.refreshRepliedMessage,
      required this.refreshMainPage,
      required this.contactController,
      required this.selectedEmployee,
      required this.myFocusNode,
      required this.scrollToMessage,

      })
      : super(key: key);
  final int messageIndex;
  final String convsId;
  final bool isCurrentUser;
  final bool hasSeen;
  final bool hasReceived;
  final bool isLastSendMessage;
  final ConversationController convsController;
  final IO.Socket socket;
  final EmployeeResponseModel currentEmployee;
  final EmployeeResponseModel selectedEmployee;
  final ContactController contactController;

  final FocusNode myFocusNode;

  final Function() refreshRepliedMessage;
  final Function() refreshMainPage;
  final Function(int index) scrollToMessage;


  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  @override
  Widget build(BuildContext context) {
    final Conversation conversation = widget.convsController.conversations.firstWhere((element) => element.id==widget.convsId);


    Message message = conversation.messages![widget.messageIndex];
    var x, y;

    _onTapDown(TapDownDetails details) {
      x = details.globalPosition.dx;
      y = details.globalPosition.dy;
      // or user the local position method to get the offset
    }

    _onTapUp(TapUpDetails details) {
      x = details.globalPosition.dx;
      y = details.globalPosition.dy;
      // or user the local position method to get the offset
    }

    void _showPopUpMenuAtPosition(var x, var y, bool isCurrentUser) async {
      final RenderObject? overlay =
          Overlay.of(context).context.findRenderObject();

      final result = await showMenu(
          context: context,
          clipBehavior: Clip.hardEdge,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          color: Colors.transparent,
          position: RelativeRect.fromRect(
              Rect.fromLTWH(x, y - 20, 100, 100),
              Rect.fromLTWH(0, 0, overlay!.paintBounds.size.width,
                  overlay.paintBounds.size.height)),
          items: [
            PopupMenuItem(
              padding: const EdgeInsets.symmetric(vertical: 7),
              value: "fav",
              child: AnimatedContainer(
                width: 250,
                padding: const EdgeInsets.fromLTRB(5, 5, 5, 15),
                duration: const Duration(milliseconds: 1000),

                // Provide an optional curve to make the animation feel smoother.
                decoration: BoxDecoration(
                    // boxShadow: const [BoxShadow(color: Colors.grey)],
                    /*image: DecorationImage(
                    image: isCurrentUser
                        ? AssetImage('assets/chat_box_right.png')
                        : AssetImage('assets/chat_box_left.png'),
                    fit: BoxFit.fill,
                  ),*/
                    backgroundBlendMode: BlendMode.dstOut,
                    borderRadius: BorderRadius.circular(15),
                    color: Color(Colors.grey.value).withOpacity(.8)),
                curve: Curves.fastOutSlowIn,

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                          //  padding: EdgeInsets.all(2),
                          height: 40,
                          width: 40,
                          child: FloatingActionButton(
                              heroTag: 'btn1',
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              splashColor: Colors.blue,
                              elevation: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(25)),
                                // padding: EdgeInsets.all(2.5),
                                child: ClipOval(
                                  child: Image.network(
                                    'https://www.gifcen.com/wp-content/uploads/2022/05/thumbs-up-gif-7.gif',
                                    width: 30,
                                    height: 30,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                List<React> reacts = conversation.messages![widget.messageIndex]
                                    .reacts!;
                                // React r = reacts.firstWhere((it) => it.userId == widget.currentUser.id);
                                if (!reacts.any((item) =>
                                    item.sender!.employeeId ==
                                    widget.currentEmployee.employeeId)) {
                                  addReact(message, "like");
                                } else {
                                  removeReact(message, "like");
                                }
                                Navigator.pop(context);
                              }),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(5, 10, 0, 0),
                          //   padding: EdgeInsets.all(2),
                          height: 40,
                          width: 40,
                          child: FloatingActionButton(
                              heroTag: 'btn1',
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              splashColor: Colors.blueAccent,
                              elevation: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(25)),
                                child: ClipOval(
                                  child: Image.network(
                                    'https://cdn.pixabay.com/animation/2022/10/28/19/23/19-23-08-315_512.gif',
                                    fit: BoxFit.fitHeight,
                                    width: 30,
                                    height: 30,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                List<React> reacts = conversation.messages![widget.messageIndex]
                                    .reacts!;
                                // React r = reacts.firstWhere((it) => it.userId == widget.currentUser.id);
                                if (!reacts.any((item) =>
                                    item.sender!.employeeId ==
                                    widget.currentEmployee.employeeId)) {
                                  addReact(message, "Love");
                                } else {
                                  removeReact(message, "Love");
                                }
                                Navigator.pop(context);
                              }),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(5, 10, 0, 0),
                          height: 40,
                          width: 40,
                          child: FloatingActionButton(
                              heroTag: 'btn1',
                              tooltip: 'Secret Chat',
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              splashColor: Colors.blueAccent,
                              elevation: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(25)),
                                // padding: EdgeInsets.all(2.5),
                                child: ClipOval(
                                  child: Image.network(
                                    'https://gifdb.com/images/high/cute-finger-heart-hop7csjnvi37i29e.gif',
                                    width: 30,
                                    height: 30,
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                List<React> reacts = conversation.messages![widget.messageIndex]
                                    .reacts!;
                                // React r = reacts.firstWhere((it) => it.userId == widget.currentUser.id);
                                if (!reacts.any((item) =>
                                    item.sender!.employeeId ==
                                    widget.currentEmployee.employeeId)) {
                                  addReact(message, "Support");
                                } else {
                                  removeReact(message, "Support");
                                }
                                Navigator.pop(context);
                              }),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(5, 10, 0, 0),
                          height: 40,
                          width: 40,
                          child: FloatingActionButton(
                              heroTag: 'btn1',
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              splashColor: Colors.blueAccent,
                              elevation: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(25)),
                                // padding: EdgeInsets.all(2.5),
                                child: ClipOval(
                                  child: Image.network(
                                    'https://i.pinimg.com/originals/b8/fe/79/b8fe7956472296b40f3ce7a7e7d68108.gif',
                                    width: 30,
                                    height: 30,
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                List<React> reacts = conversation.messages![widget.messageIndex]
                                    .reacts!;
                                // React r = reacts.firstWhere((it) => it.userId == widget.currentUser.id);
                                if (!reacts.any((item) =>
                                    item.sender!.employeeId ==
                                    widget.currentEmployee.employeeId)) {
                                  addReact(message, "Hate");
                                } else {
                                  removeReact(message, "Hate");
                                }
                                Navigator.pop(context);
                              }),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 10, 5, 0),
                          height: 40,
                          width: 40,
                          child: FloatingActionButton(
                              heroTag: 'btn1',
                              tooltip: 'Secret Chat',
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              splashColor: Colors.blueAccent,
                              elevation: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(25)),
                                // padding: EdgeInsets.all(2.5),
                                child: ClipOval(
                                  child: Image.network(
                                    'https://media.tenor.com/l5_u4JytFLYAAAAC/wow-emoji.gif',
                                    width: 30,
                                    height: 30,
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                List<React> reacts = conversation.messages![widget.messageIndex]
                                    .reacts!;
                                // React r = reacts.firstWhere((it) => it.userId == widget.currentUser.id);
                                if (!reacts.any((item) =>
                                    item.sender!.employeeId ==
                                    widget.currentEmployee.employeeId)) {
                                  addReact(message, "Surprised");
                                } else {
                                  removeReact(message, "Surprised");
                                }
                                Navigator.pop(context);
                              }),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Expanded(
                              child: InkWell(
                            onTap: () {
                              replyMessage = message;
                              Navigator.pop(context);
                              widget.refreshRepliedMessage();
                            },
                            child: const Column(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.message_rounded,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                                Text("Reply",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white))
                              ],
                            ),
                          )),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);

                                // showMessageForwardDialog(
                                //     context,
                                //     widget.convsController,
                                //     widget.currentEmployee,
                                //     widget.selectedEmployee,
                                //     widget.socket,
                                //     widget.contactController,
                                //     message,
                                //     widget.convsIndex,
                                //     widget.refreshMainPage,
                                //     widget.myFocusNode);
                              },
                              child: const Column(
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.forward,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text("Forward",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white))
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                Navigator.pop(context);
                                await Clipboard.setData(
                                    ClipboardData(text: buildStringFromTextItems(message.texts!)));
                                if(!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        "'${buildStringFromTextItems(message.texts!)}' copied!")));
                              },
                              child: const Column(
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.copy,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text("Copy",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white))
                                ],
                              ),
                            ),
                          ),
                          (message.sender!.employeeId ==
                              widget.currentEmployee.employeeId &&
                              !widget.convsController.conversations.firstWhere((element) => element.id==widget.convsId).lockedMsgs!
                                  .any((element) => element == message.id!))
                              ?
                          //if currentEmployee is sender and message not locked
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                Navigator.pop(context);
                                widget.convsController
                                    .recallMessageUpdateConvs(
                                    widget.messageIndex,
                                    widget.convsId,
                                    widget.convsController.conversations.firstWhere((element) => element.id==widget.convsId).type!,
                                    message.id!,
                                    1,
                                    widget.socket);
                              },
                              child: const Column(
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.history,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text("Recall",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white))
                                ],
                              ),
                            ),
                          )
                              : Container(
                            width: 0,
                          ),
                          ( message.sender!.employeeId! == widget.currentEmployee.employeeId || widget.convsController.conversations.firstWhere((element) => element.id==widget.convsId).lockedMsgs!
                              .any((element) => element == message.id!))
                              ? Container(
                            width: 0,
                          )
                              : Expanded(
                            child: InkWell(
                              onTap: () async {
                                Navigator.pop(context);
                                widget.convsController
                                    .lockMessageUpdateConvs(
                                    widget.messageIndex,
                                    widget.convsId,
                                    widget.convsController.conversations.firstWhere((element) => element.id==widget.convsId).type!,
                                    message.id!,
                                    widget.socket);
                              },
                              child: const Column(
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.lock,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text("Lock",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white))
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
          ]);
      // perform action on selected menu item
      switch (result) {
        case 'fav':
          break;
        case 'close':
          {
            if (mounted) return;
            Navigator.pop(context);
          }
          break;
      }
    }

    int like = 0, love = 0, support = 0, surprised = 0, hate = 0;
    int reactCount = message.reacts!.length;

    for (int i = 0; i < reactCount; i++) {
      if (message.reacts![i].title!.toLowerCase() == 'like') {
        like++;
      } else if (message.reacts![i].title!.toLowerCase() == 'love') {
        love++;
      } else if (message.reacts![i].title!.toLowerCase() == 'support') {
        support++;
      } else if (message.reacts![i].title!.toLowerCase() == 'surprised') {
        surprised++;
      } else if (message.reacts![i].title!.toLowerCase() == 'hate') {
        hate++;
      }
    }


    // print("highlightedIndex");
    // print(highlightedIndex);
    // print("messageIndex");
    // print(widget.messageIndex);

    return GestureDetector(
        //onTapDown: (position) => {_getTapPosition(position)},
        onTapDown: (TapDownDetails details) => _onTapDown(details),
        onTapUp: (TapUpDetails details) => _onTapUp(details),
        onLongPress: () =>
            {_showPopUpMenuAtPosition(x, y, widget.isCurrentUser)},
        onDoubleTap: () =>
            {_showPopUpMenuAtPosition(x, y, widget.isCurrentUser)},
        child: Container(
          alignment: widget.isCurrentUser
              ? Alignment.centerRight
              : Alignment.centerLeft,
          padding: EdgeInsets.fromLTRB(widget.isCurrentUser ? 64.0 : 10.0, 4,
              widget.isCurrentUser ? 10.0 : 64.0, 4),
          child: Column(
            crossAxisAlignment: widget.isCurrentUser
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Container(
                alignment: widget.isCurrentUser
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                margin: const EdgeInsets.only(left: 37.5),
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Text(
                  widget.isCurrentUser
                      ? "You"
                      : message.sender!.fullName.toString(),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
              Visibility(
                visible: message.replyOf != null,
                child: message.replyOf == null
                    ? Container()
                    : Opacity(
                        opacity: .8,
                        child: InkWell(
                          onTap: (){
                            for(int i=0; i<widget.convsController.conversations.firstWhere((element) => element.id==widget.convsId).messages!.length; i++){
                              if(widget.convsController.conversations.firstWhere((element) => element.id==widget.convsId).messages![i].id==message.replyOf!.id){
                                highlightedIndex = i;
                                widget.scrollToMessage(widget.convsController.conversations.firstWhere((element) => element.id==widget.convsId).messages!.length-1-i);
                                return;
                              }
                            }
                          },
                          child: Container(
                            margin: widget.isCurrentUser
                                ? const EdgeInsets.fromLTRB(0, 5, 0, 0)
                                : const EdgeInsets.fromLTRB(45, 5, 0, 0),
                            padding: const EdgeInsets.fromLTRB(7, 7, 7, 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.grey[100],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  child: Text(
                                    "Replied ${message.replyOf!.sender!.fullName!.trim()}'s message",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                            color: Color(Colors.grey[600]!.value),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 2.5, 5, 15),
                                  child: (message.replyOf!.attachments != null &&
                                          message.replyOf!.attachments!.isNotEmpty)
                                      ? Image.network(message
                                          .replyOf!.attachments![0].url
                                          .toString())
                                      : Text(
                                          buildStringFromTextItems(message.replyOf!.texts!),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge! //.bodyText1!
                                              .copyWith(
                                                  color: Colors.grey[600],
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
              ),
              Transform.translate(
                offset: Offset(0, message.replyOf != null ? -15 : 0),
                child: IntrinsicWidth(
                  stepWidth: 0,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    // crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            widget.isCurrentUser ? 5 : 0, 0, 0, 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: widget.isCurrentUser ? 0 : 40,
                              width: widget.isCurrentUser ? 0 : 40,
                              child: GestureDetector(
                                onTap: () async {
                                  EmployeeResponseModel? sender = await contactController.getEmployee(employeeId: message.sender!.employeeId!);
                                  if (!mounted) return;
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ContactDetailsScreen(employee: sender!)));
                                },
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                      imageUrl: message.sender!.photo!,
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(),
                                      errorWidget: ((context, error,
                                              stackTrace) =>
                                          Center(
                                            child: Text(
                                              "No Image",
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.grey.shade400),
                                            ),
                                          )),
                                      width: 20,
                                      height: 20,
                                      fit: BoxFit.fill),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        // align the child within the container
                                        margin:
                                            const EdgeInsets.fromLTRB(5, 5, 0, 15),
                                        alignment: widget.isCurrentUser
                                            ? Alignment.centerRight
                                            : Alignment.centerLeft,
                                        child: Column(
                                          children: [
                                            DecoratedBox(
                                                // chat bubble decoration
                                                decoration: BoxDecoration(
                                                  color: widget.isCurrentUser
                                                      ? ChatColors.chatBubbleBackgroundSelf
                                                      : ChatColors.chatBubbleBackgroundParticipants,

                                                  borderRadius:
                                                      BorderRadius.circular(25),

                                                    border: isHighlighted && (highlightedIndex == widget.messageIndex)? Border.all(color: Colors.blueAccent, width: 2):null,
                                                ),
                                                child: Padding(
                                                  padding: (message
                                                                  .attachments !=
                                                              null &&
                                                          message.attachments!.isNotEmpty)
                                                      ? const EdgeInsets.all(0)
                                                      : const EdgeInsets.all(5),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding: (message
                                                                        .attachments !=
                                                                    null &&
                                                                message.attachments!.isNotEmpty)
                                                            ? const EdgeInsets.all(0)
                                                            : const EdgeInsets
                                                                    .fromLTRB(
                                                                5, 2.5, 5, 2.5),
                                                        child: (message.attachments !=
                                                                    null &&
                                                                message.attachments!.isNotEmpty)
                                                            ? Image.network(
                                                                message
                                                                    .attachments![
                                                                        0]
                                                                    .url
                                                                    .toString())
                                                            : Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        1.5),
                                                                child: getMessageWidget(
                                                                    message, conversation.participants!, widget.currentEmployee!),
                                                                // Text(
                                                                //   message.text
                                                                //       .toString(),
                                                                //   style: Theme.of(
                                                                //           context)
                                                                //       .textTheme
                                                                //       .bodyText1!
                                                                //       .copyWith(
                                                                //           color: widget.isCurrentUser
                                                                //               ? Colors
                                                                //                   .black87
                                                                //               : Colors
                                                                //                   .black87,
                                                                //           fontSize:
                                                                //               16,
                                                                //           fontWeight:
                                                                //               FontWeight.w400),
                                                                // ),
                                                              ),
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                          ],
                                        )),
/*
                                    Visibility(
                                      visible: widget.isLastSendMessage &&
                                          message.seenBy!.length > 1,
                                      child: Container(
                                        alignment: Alignment.bottomRight,
                                        margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                        child: Text(
                                          "Seen (${message.seenBy!.length})",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    )
*/
                                  ]),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                          bottom: 0,
                          right: 0,
                          child: Row(
                            children: [
                              Visibility(
                                visible: like > 0,
                                child: Container(
                                  margin: const EdgeInsets.only(right: 1),
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle),
                                  // padding: EdgeInsets.all(2.5),
                                  child: ClipOval(
                                    child: Image.network(
                                      'https://www.gifcen.com/wp-content/uploads/2022/05/thumbs-up-gif-7.gif',
                                      width: 20,
                                      height: 20,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: love > 0,
                                child: Container(
                                  margin: const EdgeInsets.only(right: 1),
                                  decoration:
                                      const BoxDecoration(shape: BoxShape.circle),
                                  // padding: EdgeInsets.all(2.5),
                                  child: ClipOval(
                                    child: Image.network(
                                      'https://cdn.pixabay.com/animation/2022/10/28/19/23/19-23-08-315_512.gif',
                                      width: 20,
                                      height: 20,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: surprised > 0,
                                child: Container(
                                  margin: const EdgeInsets.only(right: 1),
                                  decoration:
                                      const BoxDecoration(shape: BoxShape.circle),
                                  // padding: EdgeInsets.all(2.5),
                                  child: ClipOval(
                                    child: Image.network(
                                      'https://media.tenor.com/l5_u4JytFLYAAAAC/wow-emoji.gif',
                                      width: 20,
                                      height: 20,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: hate > 0,
                                child: Container(
                                  margin: const EdgeInsets.only(right: 1),
                                  decoration:
                                      const BoxDecoration(shape: BoxShape.circle),
                                  // padding: EdgeInsets.all(2.5),
                                  child: ClipOval(
                                    child: Image.network(
                                      'https://i.pinimg.com/originals/b8/fe/79/b8fe7956472296b40f3ce7a7e7d68108.gif',
                                      width: 20,
                                      height: 20,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: support > 0,
                                child: Container(
                                  margin: const EdgeInsets.only(right: 1),
                                  decoration:
                                      const BoxDecoration(shape: BoxShape.circle),
                                  // padding: EdgeInsets.all(2.5),
                                  child: ClipOval(
                                    child: Image.network(
                                      'https://gifdb.com/images/high/cute-finger-heart-hop7csjnvi37i29e.gif',
                                      width: 20,
                                      height: 20,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: reactCount > 0,
                                child: Container(
                                  margin: const EdgeInsets.only(right: 1),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  padding: const EdgeInsets.all(5),
                                  child: ClipOval(
                                    child: Text(
                                      reactCount.toString(),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ))
                    ],
                  ),
                ),
              ),
              // Visibility(
              //   visible: widget.isLastSendMessage,
              //   child: Container(
              //     alignment: Alignment.bottomRight,
              //     margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
              //     child: Text(widget.hasSeen
              //         ? "Seen"
              //         : widget.hasReceived
              //             ? "Received"
              //             : "Unseen"),
              //   ),
              // ),
            ],
          ),
        ));
  }

  void addReact(Message message, String reactTitle) {
    widget.convsController.addReactUpdateConvs(
        widget.messageIndex,
        widget.convsId,
        widget.convsController.conversations.firstWhere((element) => element.id==widget.convsId).type!,
        message.id!,
        reactTitle,
        widget.socket);
  }

  void removeReact(Message message, String reactTitle) {
    List<React> reacts = widget.convsController.conversations.firstWhere((element) => element.id==widget.convsId).messages![widget.messageIndex].reacts!;

    if (reacts
            .firstWhere((element) =>
                element.sender!.employeeId == widget.currentEmployee.employeeId)
            .title ==
        reactTitle) {
      widget.convsController.removeReactUpdateConvs(
          widget.messageIndex,
          widget.convsId,
          widget.convsController.conversations.firstWhere((element) => element.id==widget.convsId).type!,
          message.id!,
          reactTitle,
          widget.socket);
    } else {
      //todo...remove then add... react = update...
    }
  }
}

sendMessage(ConversationController convsController,
    EmployeeResponseModel currentEmployee,
    EmployeeResponseModel selectedEmployee,
    List<MessageTextItem> texts,
    List<Attachment> attachments,
    IO.Socket socket,
    String convsId,
    Function()? refreshRepliedMessage,
    BuildContext context) async {




  List<String> seenBy = <String>[];
  seenBy.add(currentEmployee.employeeId.toString());

  List<String> receivedBy = <String>[];
  receivedBy.add(currentEmployee.employeeId.toString());
  List<React> reacts = <React>[];

  ReplyOf? replyData;

  replyMessage != null
      ? {
          replyData = ReplyOf(
              id: replyMessage!.id,
              sender: replyMessage!.sender,
              recipients: replyMessage!.recipients!.isNotEmpty?replyMessage!.recipients! : null,
              texts: replyMessage!.texts,
              attachments: replyMessage!.attachments)
        }
      : {};

  List<EmployeeResponseModel> recipients = convsController.conversations.firstWhere((element) => element.id==convsId).participants!;
  recipients.removeWhere((element) => element.employeeId == currentEmployee.employeeId);

  Message message = Message(
      id: "",
      sender: currentEmployee,
      recipients: recipients,
      texts: texts,
      seenBy: seenBy,
      receivedBy: receivedBy,
      attachments: attachments,
      reacts: reacts,
      replyOf: replyData,
      recall: 0);

  await convsController.sendMessage(convsId,
      convsController.conversations.firstWhere((element) => element.id==convsId).type!,
      message);

  replyMessage = null;
  refreshRepliedMessage != null ? refreshRepliedMessage() : {};
}

class ChatMessageTypingField extends StatefulWidget {
  final ConversationController convsController;
  final EmployeeResponseModel currentEmployee, selectedEmployee;
  final IO.Socket socket;
  final String convsId;
  final List<String> typingUsersId;
  final CustomTextEditingController customTextEditingController;
  final Function() refreshRepliedMessage;
  final Function() _scrollDown;

  const ChatMessageTypingField(
      this.convsController,
      this.currentEmployee,
      this.selectedEmployee,
      this.socket,
      this.convsId,
      this.typingUsersId,
      this.customTextEditingController,
      this.refreshRepliedMessage,
      this._scrollDown,
      {Key? key})
      : super(key: key);

  @override
  State createState() => _ChatMessageTypingFieldState();
}

class _ChatMessageTypingFieldState extends State<ChatMessageTypingField> {
  //TextEditingController messageController = new TextEditingController();
  bool emojiShowing = false;

  @override
  Widget build(BuildContext context) {

    onTextChange(text) {
      if(text.isNotEmpty && text[text.length-1]=="@"){
        widget.customTextEditingController.searchMentionable = true;
        widget.customTextEditingController.onSearchMention();
      }else if(text.isNotEmpty && text.lastIndexOf("@")>-1){
        widget.customTextEditingController.searchMentionable = true;
        widget.customTextEditingController.onSearchMention();
      }else{
        convsController.matchMentionableBySearch.clear();
        convsController.selectedMentionsIndexList.clear();
      }

      String typingEvent = "typing"; //sending event name...

      if (text.isEmpty) {
        var json = {
          "convsId": widget.convsId,
          "convsType": widget.convsController.conversations.firstWhere((element) => element.id==widget.convsId).type,
          "typingUsersId": widget.typingUsersId
        };

        if (widget.typingUsersId.contains(
            widget.currentEmployee.employeeId)) {
          widget.typingUsersId.remove(
              widget.currentEmployee.employeeId);
          json = {
            "convsId": widget.convsId,
            "convsType": widget.convsController.conversations.firstWhere((element) => element.id==widget.convsId).type,
            "typingUsersId": widget.typingUsersId
          };

          widget.socket.emit(typingEvent, json);
        } else {
          widget.socket.emit(typingEvent, json);
        }
      } else {
        var json = {
          "convsId": widget.convsId,
          "convsType": widget.convsController.conversations.firstWhere((element) => element.id==widget.convsId).type,
          "typingUsersId": widget.typingUsersId
        };

        if (!widget.typingUsersId.contains(
            widget.currentEmployee.employeeId)) {
          widget.typingUsersId
              .add(widget.currentEmployee.employeeId!);

          json = {
            "convsId": widget.convsId,
            "convsType": widget.convsController.conversations.firstWhere((element) => element.id==widget.convsId).type,
            "typingUsersId": widget.typingUsersId
          };

          widget.socket.emit(typingEvent, json);
        } else {
          //widget.socket.emit(typingEvent, json);
        }
      }
      setState(() {});
    }






    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(5,15,5,10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(35.0),
                      boxShadow: const [
                        BoxShadow(
                            offset: Offset(0, 3),
                            blurRadius: 5,
                            color: Colors.grey)
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        IconButton(
                            icon: const Icon(
                              Icons.face,
                              color: Colors.blueAccent,
                            ),
                            onPressed: () async {
                              setState(() {
                                emojiShowing = !emojiShowing;
                              });
                            }),
                        Expanded(child: MentionableTextFieldWidget( widget.customTextEditingController, convsController,
                            onTextChange
                        )),
                        // Expanded(
                        //   //  child: MentionableTextFieldWidget( generateMentionableItems(widget.convsController.conversations.firstWhere((element) => element.id == widget.convsId)),
                        //     child: MentionableTextFieldWidget(
                        //         generateMentionsIncludingConst(
                        //             participants: widget.convsController.conversations.firstWhere(
                        //                     (element) => element.id == widget.convsId).participants!, asMentionable: true),
                        //         messageController, onTextChange, _mentionableUsers, onSelectMention)
                        // ),

                        // Expanded(
                        //   child: TextField(
                        //     maxLines: null,
                        //     keyboardType: TextInputType.multiline,
                        //     minLines: 1,
                        //     controller: messageController,
                        //     decoration: const InputDecoration(
                        //         hintText: "Type Something...",
                        //         hintStyle: TextStyle(color: Colors.blueAccent),
                        //         border: InputBorder.none),
                        //     onChanged: (text) {
                        //       String typingEvent =
                        //           "typing"; //sending event name...
                        //
                        //       if (text.isEmpty) {
                        //         var json = {
                        //           "convsId": widget.convsId,
                        //           "convsType": widget.convsController.conversations.firstWhere((element) => element.id==widget.convsId).type,
                        //           "typingUsersId": widget.typingUsersId
                        //         };
                        //
                        //         if (widget.typingUsersId.contains(
                        //             widget.currentEmployee.employeeId)) {
                        //           widget.typingUsersId.remove(
                        //               widget.currentEmployee.employeeId);
                        //           json = {
                        //             "convsId": widget.convsId,
                        //             "convsType": widget.convsController.conversations.firstWhere((element) => element.id==widget.convsId).type,
                        //             "typingUsersId": widget.typingUsersId
                        //           };
                        //
                        //           widget.socket.emit(typingEvent, json);
                        //         } else {
                        //           widget.socket.emit(typingEvent, json);
                        //         }
                        //       } else {
                        //         var json = {
                        //           "convsId": widget.convsId,
                        //           "convsType": widget.convsController.conversations.firstWhere((element) => element.id==widget.convsId).type,
                        //           "typingUsersId": widget.typingUsersId
                        //         };
                        //
                        //         if (!widget.typingUsersId.contains(
                        //             widget.currentEmployee.employeeId)) {
                        //           widget.typingUsersId
                        //               .add(widget.currentEmployee.employeeId!);
                        //
                        //           json = {
                        //             "convsId": widget.convsId,
                        //             "convsType": widget.convsController.conversations.firstWhere((element) => element.id==widget.convsId).type,
                        //             "typingUsersId": widget.typingUsersId
                        //           };
                        //
                        //           widget.socket.emit(typingEvent, json);
                        //         } else {
                        //           //widget.socket.emit(typingEvent, json);
                        //         }
                        //       }
                        //
                        //       setState(() {});
                        //     },
                        //   ),
                        // ),
                        IconButton(
                          icon:
                              const Icon(Icons.photo, color: Colors.blueAccent),
                          onPressed: () {
                            _openGalleryAndUploadImage(
                                widget.convsController,
                                widget.currentEmployee,
                                widget.selectedEmployee,
                                widget.customTextEditingController,
                                "",
                                widget.socket,
                                widget.convsId,
                                widget.refreshRepliedMessage);
                          },
                        ),
                        // IconButton(
                        //   icon: const Icon(Icons.attach_file,
                        //       color: Colors.blueAccent),
                        //   onPressed: () {},
                        // )
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 7),
                InkWell(
                  child: Container(
                    padding: const EdgeInsets.all(11.0),
                    decoration: const BoxDecoration(
                        color: Colors.blueAccent, shape: BoxShape.circle),
                    child: widget.customTextEditingController.text.isNotEmpty
                        ? const Icon(Icons.send, color: Colors.white)
                        : const Icon(Icons.keyboard_voice, color: Colors.white),
                  ),
                  onTap: () {

                    List<Attachment> attachments = <Attachment>[];
                    if (widget.customTextEditingController.text.isNotEmpty) {
                      //Send Text Message
                      sendMessage(
                          widget.convsController,
                          widget.currentEmployee,
                          widget.selectedEmployee,
                          widget.customTextEditingController.messageTextItems,
                          attachments,
                          widget.socket,
                          widget.convsId,
                          widget.refreshRepliedMessage,
                          context);
                      widget.customTextEditingController.text = "";
                      if (widget.typingUsersId
                          .contains(widget.currentEmployee.employeeId)) {
                        //notifying other user that current user is  not typing...

                        widget.typingUsersId
                            .remove(widget.currentEmployee.employeeId);
                        String typingEvent = "typing"; //sending event name...

                        var json = {
                          "convsId": widget.convsId,
                          "convsType": widget.convsController.conversations.firstWhere((element) => element.id==widget.convsId).type,
                          "typingUsersId": widget.typingUsersId
                        };
                        widget.socket.emit(typingEvent, json);
                      }
                    } else {
                      //todo...Send Voice Message...
                    }
                    widget._scrollDown();
                  },
                )
              ],
            ),
          ),
          Offstage(
            offstage: !emojiShowing,
            child: SizedBox(
                height: 250,
                child: EmojiPicker(
                  textEditingController: widget.customTextEditingController,
                  onEmojiSelected: (category, emoji) => {setState(() {})},
                  config: Config(
                    columns: 7,
                    // Issue: https://github.com/flutter/flutter/issues/28894
                    emojiSizeMax: 32 *
                        (foundation.defaultTargetPlatform == TargetPlatform.iOS
                            ? 1.30
                            : 1.0),

                    verticalSpacing: 0,
                    horizontalSpacing: 0,
                    gridPadding: EdgeInsets.zero,
                    initCategory: Category.RECENT,
                    bgColor: const Color(0xFFF2F2F2),
                    indicatorColor: Colors.blue,
                    iconColor: Colors.grey,
                    iconColorSelected: Colors.blue,
                    backspaceColor: Colors.blue,
                    skinToneDialogBgColor: Colors.white,
                    skinToneIndicatorColor: Colors.grey,
                    enableSkinTones: true,
                    //showRecentsTab: true,
                    recentsLimit: 28,
                    replaceEmojiOnLimitExceed: false,
                    noRecents: const Text(
                      'No Recents',
                      style: TextStyle(fontSize: 20, color: Colors.black26),
                      textAlign: TextAlign.center,
                    ),
                    loadingIndicator: const SizedBox.shrink(),
                    tabIndicatorAnimDuration: kTabScrollDuration,
                    categoryIcons: const CategoryIcons(),
                    buttonMode: ButtonMode.MATERIAL,
                    checkPlatformCompatibility: true,
                  ),
                )),
          ),
        ],
      ),
    );
  }

  void _openGalleryAndUploadImage(
      ConversationController convsController,
      EmployeeResponseModel currentEmployee,
      EmployeeResponseModel selectedEmployee,
      CustomTextEditingController customTextEditingController,
      imageUrl,
      IO.Socket socket,
      String convsId,
      Function() refreshRepliedMessage) async {

        convsController.uploadImageAsMultipartLaravel((url, filename) async {
          List<Attachment> attachments = <Attachment>[];
          if (url.length > 1) {
            attachments.add(Attachment(name: filename, type: "photo", url: url));
          }

          await sendMessage(
              convsController,
              currentEmployee,
              selectedEmployee,
              [MessageTextItem(type: 'text', value: customTextEditingController.text)],
              attachments,
              socket,
              convsId,
              refreshRepliedMessage,
              context);
        });
  }
}

void showMessageForwardDialog(
    BuildContext context,
    ConversationController convsController,
    EmployeeResponseModel currentEmployee,
    EmployeeResponseModel selectedEmployee,
    IO.Socket socket,
    ContactController contactController,
    Message message,
    int convsIndex,
    Function() setState,
    myFocusNode) {
  //contactController.getAllEmployee();

  showGeneralDialog(
    context: context,
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 650),
    pageBuilder: (_, __, ___) {
      return Center(
        child: Container(
          // height: 300,
          margin: const EdgeInsets.fromLTRB(10, 70, 10, 40),
          padding: const EdgeInsets.fromLTRB(5, 5, 5, 15),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              Container(
                alignment: Alignment.topCenter,
                margin: const EdgeInsets.fromLTRB(5, 35, 5, 5),
                child: const Text(
                  "Message Forward to",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              Container(
                height: 30,
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
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
                  child: GetBuilder<ContactController>(
                init: ContactController(),
                builder: (controller) {
                  return ListView.builder(

                    itemCount: controller.employees.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child: Row(
                            children: [
                              ClipOval(
                                child: CachedNetworkImage(
                                    imageUrl: contactController
                                        .employees[index].photo!,
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: ((context, error,
                                            stackTrace) =>
                                        Center(
                                          child: Text(
                                            "No Image",
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey.shade400),
                                          ),
                                        )),
                                    width: 48,
                                    height: 48,
                                    fit: BoxFit.fill),
                              ),
                              Container(
                                margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "${contactController.employees[index].fullName}",
                                        style: const TextStyle(
                                            fontSize: 15, color: Colors.black),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "${contactController.employees[index].email}",
                                        style: const TextStyle(
                                            fontSize: 10,
                                            color: Colors.black87),
                                      )
                                    ]),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: AsyncButtonBuilder(
                                    showError: false,
                                    showSuccess: true,
                                    child: const Text('Send'),
                                    onPressed: () async {
                                      await Future.delayed(
                                          const Duration(seconds: 1));

                                      Message messageToBeForward = Message(
                                          sender: currentEmployee,
                                          recipients: [
                                            controller.employees[index]
                                          ],
                                          texts: message.texts,
                                          seenBy: [currentEmployee.employeeId!],
                                          receivedBy: [
                                            currentEmployee.employeeId!
                                          ],
                                          attachments: message.attachments,
                                          recall: message.recall,
                                          replyOf: null,
                                          reacts: []);

                                      // ignore: use_build_context_synchronously
                                      forwardMessage(
                                          context,
                                          socket,
                                          contactController,
                                          convsController,
                                          currentEmployee,
                                          controller.employees[index],
                                          "${currentEmployee.fullName!}-${controller.employees[index].fullName!}",
                                          "Single",
                                          messageToBeForward,
                                          convsController
                                              .conversations[convsIndex].id!,
                                          convsController
                                              .conversations[convsIndex].type!);
                                      contactController.employees
                                          .removeAt(index);
                                      //contactController.employees.refresh();
                                      contactController.refresh();
                                      setState();
                                    },
                                    builder: (context, child, callback, _) {
                                      return TextButton(
                                        onPressed: callback,
                                        child: child,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              )),
            ],
          ),
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      Tween<Offset> tween;
      if (anim.status == AnimationStatus.reverse) {
        tween = Tween(begin: const Offset(0, 1), end: Offset.zero);
      } else {
        tween = Tween(begin: const Offset(0, -1), end: Offset.zero);
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

void forwardMessage(
    BuildContext context,
    IO.Socket socket,
    ContactController contactController,
    ConversationController convsController,
    EmployeeResponseModel currentEmployee,
    EmployeeResponseModel selectedEmployee,
    String title,
    String type,
    Message message,
    String convsId,
    String convsType) {
  String photo = "photo";
  List<EmployeeResponseModel> admins = <EmployeeResponseModel>[];

  convsController.sendFirstMessage(
      context,
      socket,
      contactController,
      convsController,
      selectedEmployee,
      null,
      title,
      message,
      convsType,
      photo,
      currentEmployee,
      admins);
}

void addParticipantToGroupDialog(
    BuildContext context,
    ConversationController convsController,
    EmployeeResponseModel currentEmployee,
    ContactController contactController,
    String convsId,
    myFocusNode) {

  Conversation? conversation =  convsController.conversations.firstWhere((element) => element.id==convsId);



  showGeneralDialog(
    context: context,
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 650),
    pageBuilder: (_, __, ___) {
      return Center(
        child: Container(
          // height: 300,
          margin: const EdgeInsets.fromLTRB(10, 70, 10, 40),
          padding: const EdgeInsets.fromLTRB(5, 5, 5, 15),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              Container(
                alignment: Alignment.topCenter,
                margin: const EdgeInsets.fromLTRB(5, 35, 5, 5),
                child: const Text(
                  "Select Participant",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              Container(
                height: 30,
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Material(
                  child: TextField(
                    focusNode: myFocusNode,
                    controller: contactController.searchController,
                    decoration: const InputDecoration(
                      hintText: "Search by Name",
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
                  child: GetBuilder<ContactController>(
                    init: ContactController(),
                    builder: (controller) {
                      return ListView.builder(
                        itemCount: controller.employees.length,
                        itemBuilder: (context, index) {
                          return (conversation.participants!=null &&
                              conversation.participants!.indexWhere((element) => element.employeeId == controller.employees[index].employeeId)!=-1
                          )?
                           Container()
                              :
                          Card(
                          child: Container(
                          margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child: Row(
                          children: [
                          ClipOval(
                          child: CachedNetworkImage(
                          imageUrl: contactController
                              .employees[index].photo!,
                          placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                          errorWidget: ((context, error,
                          stackTrace) =>
                          Center(
                          child: Text(
                          "No Image",
                          style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade400),
                          ),
                          )),
                          width: 48,
                          height: 48,
                          fit: BoxFit.fill),
                          ),
                          Container(
                          margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                          child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: <Widget>[
                          Text(
                          "${contactController.employees[index].fullName}",
                          style: const TextStyle(
                          fontSize: 15, color: Colors.black),
                          ),
                          const SizedBox(
                          height: 5,
                          ),
                          Text(
                          "${contactController.employees[index].email}",
                          style: const TextStyle(
                          fontSize: 10,
                          color: Colors.black87),
                          )
                          ]),
                          ),
                          Expanded(
                          child: Align(
                          alignment: Alignment.centerRight,
                          child: AsyncButtonBuilder(
                          showError: false,
                          showSuccess: true,
                          child: const Text('Add'),
                          onPressed: () async {
                          await Future.delayed(
                          const Duration(seconds: 1));
                          /* convsController
                                              .conversations[convsIndex]
                                              .participants!;

                                      recipients.removeWhere((element) => element.employeeId==currentEmployee.employeeId);
*/
                          convsController.addParticipant(convsId, controller.employees[index]); //Selected Employee
                          contactController.employees.removeAt(index);
                          contactController.refresh();
                          //  setState();
                          },
                          builder: (context, child, callback, _) {
                          return TextButton(
                          onPressed: callback,
                          child: child,
                          );
                          },
                          ),
                          ),
                          ),
                          ],
                          ),
                          ),
                          );
                        },
                      );
                    },
                  )),
            ],
          ),
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      Tween<Offset> tween;
      if (anim.status == AnimationStatus.reverse) {
        tween = Tween(begin: const Offset(0, 1), end: Offset.zero);
      } else {
        tween = Tween(begin: const Offset(0, -1), end: Offset.zero);
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







